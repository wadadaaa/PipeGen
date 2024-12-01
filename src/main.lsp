; Global variables for settings
(setq *MANHOLE-LAYER* "MANHOLES")
(setq *PIPE-LAYER* "PIPES")
(setq *TEXT-HEIGHT* 0.25)
(setq *MH-DATA* nil)  ; Store manhole data

; Main function for placing manholes
(defun c:PlaceManhole ( / pt diameter depth invert layer circle-id text-id mh-number ground-level)
  ; Initialize layers
  (create-layers)
  
  ; Initialize counter
  (if (null MH-Counter) (setq MH-Counter 0))
  
  (while 
    (setq pt (getpoint "\nSelect point to place manhole: "))
    
    ; Get manhole parameters
    (setq MH-Counter (1+ MH-Counter))
    (setq mh-number (strcat "MH-" (rtos MH-Counter 2 0)))
    
    ; Get ground level at point
    (initget 1)
    (setq ground-level (getreal "\nEnter ground level [m]: "))
    
    ; Get manhole parameters with validation
    (initget 6)
    (setq diameter (getreal "\nEnter manhole diameter [mm] <1000>: "))
    (if (null diameter) (setq diameter 1000.0))
    
    (initget 6)
    (setq depth (getreal "\nEnter manhole depth [m] <3.0>: "))
    (if (null depth) (setq depth 3.0))
    
    ; Calculate invert level from ground level and depth
    (setq invert (- ground-level depth))
    
    ; Draw manhole
    (draw-manhole pt diameter depth ground-level invert mh-number)
    
    ; Store manhole data
    (setq *MH-DATA* 
      (append *MH-DATA*
        (list
          (list
            mh-number
            pt
            diameter
            depth
            ground-level
            invert
          )
        )
      )
    )
    
    ; Print feedback
    (princ (strcat "\nManhole " mh-number " placed at: "
                   (rtos (car pt) 2 2) ", "
                   (rtos (cadr pt) 2 2)))
  )
  (princ)
)

; Function to create pipes between manholes
(defun c:ConnectMH ( / mh1 mh2 p1 p2 dia slope)
  (setq mh1 (car (entsel "\nSelect first manhole: ")))
  (setq mh2 (car (entsel "\nSelect second manhole: ")))
  
  (if (and mh1 mh2)
    (progn
      (setq p1 (get-manhole-center mh1))
      (setq p2 (get-manhole-center mh2))
      
      ; Get pipe parameters
      (initget 6)
      (setq dia (getreal "\nEnter pipe diameter [mm] <300>: "))
      (if (null dia) (setq dia 300.0))
      
      (initget 6)
      (setq slope (getreal "\nEnter pipe slope [%] <1.0>: "))
      (if (null slope) (setq slope 1.0))
      
      ; Draw pipe
      (draw-pipe p1 p2 dia)
      
      ; Calculate and display slope arrow
      (draw-slope-arrow p1 p2 slope)
    )
  )
  (princ)
)

; Helper function to create layers
(defun create-layers ()
  (foreach layer (list *MANHOLE-LAYER* *PIPE-LAYER*)
    (if (null (tblsearch "LAYER" layer))
      (command "._LAYER" "_M" layer "_C" "RED" layer "")
    )
  )
)

; Helper function to draw manhole
(defun draw-manhole (pt dia depth gl il mh-num / circle-id text-id)
  (command "._LAYER" "_S" *MANHOLE-LAYER* "")
  
  ; Draw circle
  (command "._CIRCLE" pt (/ dia 2000.0))
  (setq circle-id (entlast))
  
  ; Create text annotation
  (setq text-content 
    (strcat mh-num 
      "\nGL=" (rtos gl 2 2) "m"
      "\nD=" (rtos dia 2 0) "mm"
      "\nH=" (rtos depth 2 2) "m"
      "\nIL=" (rtos il 2 2) "m"
    )
  )
  
  ; Calculate text position
  (setq text-pt (list (+ (car pt) (* (/ dia 1000.0) 0.75))
                      (+ (cadr pt) (* (/ dia 1000.0) 0.75))))
  
  ; Add text
  (command "._TEXT" "_J" "_L" text-pt *TEXT-HEIGHT* 0 text-content)
  (setq text-id (entlast))
  
  ; Group entities
  (command "._GROUP" "_C" circle-id text-id "")
)

; Helper function to draw pipe
(defun draw-pipe (p1 p2 dia / )
  (command "._LAYER" "_S" *PIPE-LAYER* "")
  (command "._LINE" p1 p2 "")
  
  ; Add pipe diameter text
  (setq mid-pt (list (/ (+ (car p1) (car p2)) 2.0)
                     (/ (+ (cadr p1) (cadr p2)) 2.0)))
  (command "._TEXT" "_J" "_C" mid-pt *TEXT-HEIGHT* 
           (angle p1 p2) (strcat "D=" (rtos dia 2 0) "mm"))
)

; Helper function to draw slope arrow
(defun draw-slope-arrow (p1 p2 slope / ang dist)
  (setq ang (angle p1 p2))
  (setq dist (distance p1 p2))
  
  ; Draw arrow
  (command "._LAYER" "_S" *PIPE-LAYER* "")
  (command "._INSERT" "ARROW" mid-pt *TEXT-HEIGHT* *TEXT-HEIGHT* ang)
  
  ; Add slope text
  (command "._TEXT" "_J" "_C" 
           (polar mid-pt (+ ang (/ pi 2)) (* *TEXT-HEIGHT* 2))
           *TEXT-HEIGHT* ang
           (strcat (rtos slope 2 1) "%"))
)

; Helper function to get manhole center point
(defun get-manhole-center (ent / ent-data)
  (setq ent-data (entget ent))
  (cdr (assoc 10 ent-data))
)