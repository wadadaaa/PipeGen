(defun c:SEWERMENU ()
  (princ "\nSewer Design Plugin\n")
  (initget 1 "Generate Exit")
  (setq choice (getkword "\nSelect operation [Generate/Exit]: "))
  (cond
    ((= choice "Generate") (generate-sewer-system))
    ((= choice "Exit") (princ "\nExiting plugin."))
  )
  (princ)
)

(defun generate-sewer-system ()
  (setq manhole-list '())
  (setq pipe-list '())
  (princ "\nClick to place manholes. Right-click or press Enter to finish.")
  (while (setq pt (getpoint))
    (setq manhole (place-manhole pt))
    (setq manhole-list (cons manhole manhole-list))
    (if (> (length manhole-list) 1)
      (place-pipe (car (cdr manhole-list)) (car manhole-list))
    )
  )
  (if manhole-list
    (create-profile manhole-list pipe-list)
    (princ "\nNo manholes placed. Exiting.")
  )
)

(defun place-manhole (pt)
  (setq diameter (getreal "\nEnter manhole diameter (mm): "))
  (setq depth (getreal "\nEnter manhole depth (m): "))
  (setq invert (getreal "\nEnter invert level (m): "))
  
  ; Create a circle to represent the manhole
  (command "_.circle" pt (/ diameter 2000.0))
  
  ; Add text with manhole information
  (setq text_pt (list (+ (car pt) (/ diameter 2000.0)) (cadr pt)))
  (command "_.text" text_pt 0.2 0 (strcat "MH" (itoa (length manhole-list)) "\nD=" (rtos diameter 2 0) "mm\nH=" (rtos depth 2 2) "m\nIL=" (rtos invert 2 2) "m"))
  
  (list pt diameter depth invert)
)

(defun place-pipe (mh1 mh2)
  (setq start-pt (car mh1))
  (setq end-pt (car mh2))
  (setq length (distance start-pt end-pt))
  (setq diameter (getreal "\nEnter pipe diameter (mm): "))
  (setq slope (/ (- (nth 3 mh1) (nth 3 mh2)) length))
  
  ; Draw pipe
  (command "_.line" start-pt end-pt "")
  
  ; Add text with pipe information
  (setq mid-pt (list (/ (+ (car start-pt) (car end-pt)) 2) (/ (+ (cadr start-pt) (cadr end-pt)) 2)))
  (command "_.text" mid-pt 0.2 (angle start-pt end-pt) (strcat "L=" (rtos length 2 2) "m\nD=" (rtos diameter 2 0) "mm\nS=" (rtos (* slope 100) 2 2) "%"))
  
  (setq pipe-list (cons (list start-pt end-pt length diameter slope) pipe-list))
)

(defun create-profile (manholes pipes)
  (setq profile-start (getpoint "\nSpecify start point for profile: "))
  (setq scale-h (getreal "\nEnter horizontal scale (1:?): "))
  (setq scale-v (getreal "\nEnter vertical scale (1:?): "))
  
  (setq prev-x (car profile-start))
  (setq prev-y (cadr profile-start))
  (setq total-length 0)
  
  (foreach manhole manholes
    (setq mh-pt (car manhole))
    (setq mh-depth (caddr manhole))
    (setq mh-invert (cadddr manhole))
    
    (setq x (+ prev-x (/ total-length scale-h)))
    (setq y (+ prev-y (/ mh-invert scale-v)))
    
    ; Draw manhole
    (command "_.rectangle" (list x y) (list (+ x (/ 1 scale-h)) (+ y (/ mh-depth scale-v))))
    
    ; Draw ground level
    (command "_.line" (list x (+ y (/ mh-depth scale-v))) (list (+ x (/ 1 scale-h)) (+ y (/ mh-depth scale-v))) "")
    
    ; Add text
    (command "_.text" (list (+ x (/ 0.5 scale-h)) (+ y (/ mh-depth scale-v))) 0.2 0 (strcat "MH" (itoa (- (length manholes) (length manhole-list))) "\nIL=" (rtos mh-invert 2 2)))
    
    (if (/= manhole (car manholes))
      (progn
        ; Draw pipe
        (command "_.line" (list prev-x prev-y) (list x y) "")
        ; Add pipe info
        (setq pipe-info (car pipes))
        (command "_.text" (list (/ (+ prev-x x) 2) (/ (+ prev-y y) 2)) 0.2 (angle (list prev-x prev-y) (list x y)) 
                 (strcat "L=" (rtos (caddr pipe-info) 2 2) "m\nD=" (rtos (cadddr pipe-info) 2 0) "mm\nS=" (rtos (* (nth 4 pipe-info) 100) 2 2) "%"))
        (setq pipes (cdr pipes))
      )
    )
    
    (setq prev-x x)
    (setq prev-y y)
    (setq total-length (+ total-length (distance mh-pt (car (car manhole-list)))))
    (setq manhole-list (cdr manhole-list))
  )
)
