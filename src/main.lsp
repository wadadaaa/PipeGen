(defun c:createmanhole ( / pt1 counter lastpt)
  (setq *error* *error-handler*)
  (setq counter 0)
  (setq lastpt nil)
  
  ; Create layers if not exist
  (if (null (tblsearch "layer" "PIPE"))
      (command "_layer" "_m" "PIPE" "_c" "green" "PIPE" ""))
  (if (null (tblsearch "layer" "MANHOLE"))
      (command "_layer" "_m" "MANHOLE" "_c" "red" "MANHOLE" ""))
      
  (while 
    (setq pt1 (getpoint "\nSelect manhole location or ESC to exit: "))
    (setq counter (1+ counter))
    
    ; Draw manhole
    (command "_layer" "s" "MANHOLE" "")
    (command "_circle" pt1 50)
    (command "_circle" pt1 40)
    (command "_text" "j" "c" pt1 25 0 (rtos counter 2 0))
    
    (if lastpt
        (progn
          ; Draw pipe
          (command "_layer" "s" "PIPE" "")
          (setq ang (angle lastpt pt1))
          (setq pipe-len (distance lastpt pt1))
          (setq midpt (list (/ (+ (car pt1) (car lastpt)) 2) 
                           (/ (+ (cadr pt1) (cadr lastpt)) 2)))
          
          ; Draw pipe lines
          (command "_line" lastpt pt1 "")
          (setq p1 (polar lastpt (+ ang (/ pi 2)) 2))
          (setq p2 (polar pt1 (+ ang (/ pi 2)) 2))
          (command "_line" p1 p2 "")
          (setq p3 (polar lastpt (- ang (/ pi 2)) 2))
          (setq p4 (polar pt1 (- ang (/ pi 2)) 2))
          (command "_line" p3 p4 "")
          
          ; Calculate dynamic text placement
          (setq text-offset (if (< pipe-len 200) 20 50)) ; Adjust offset for shorter pipes
          (setq text-pt1 (polar midpt (/ pi 2) text-offset))
          (setq text-pt2 (polar midpt (/ pi 2) (* text-offset 1.5)))
          
          ; Add pipe labels with proper spacing
          (setq text-ang (if (and (> ang 0) (< ang pi)) 0 pi))
          (command "_text" "j" "c" text-pt2 12 text-ang "UPVC PIPE 300 Ø")
          (command "_text" "j" "c" text-pt1 12 text-ang "SLOPE: 1.0 %")
        )
    )
    
    (setq lastpt pt1)
  )
  
  (setq *error* nil)
  (princ)
)

(defun *error-handler* (msg)
  (if (/= msg "Function cancelled")
    (princ (strcat "\nError: " msg))
  )
  (setq *error* nil)
  (princ)
)
