(defun c:PlaceManhole ( / pt diameter depth invert ground-level)
  ; Initialize counter if not exists
  (if (null *MH-Counter*) (setq *MH-Counter* 0))
  
  ; Initialize layer
  (command "._LAYER" "_M" "MANHOLES" "_C" "RED" "MANHOLES" "")
  (command "._LAYER" "_S" "MANHOLES" "")
  
  ; Main loop for continuous placement
  (princ "\nPlace manholes. Press ESC or Enter to finish.")
  
  ; Ask for default values first
  (initget 6)
  (setq diameter (getreal "\nDefault manhole diameter [mm] <1000>: "))
  (if (null diameter) (setq diameter 1000.0))
  
  (initget 6)
  (setq depth (getreal "\nDefault manhole depth [m] <3.0>: "))
  (if (null depth) (setq depth 3.0))
  
  ; Start placement loop
  (while (setq pt (getpoint "\nSelect manhole location: "))
    ; Increment counter
    (setq *MH-Counter* (1+ *MH-Counter*))
    
    ; Get ground level at this point
    (initget 1)
    (setq ground-level (getreal "\nGround level at this point [m]: "))
    
    ; Allow to override defaults for this specific manhole
    (initget 7) ; 7 = allow null and must be positive
    (setq this-diameter (getreal 
      (strcat "\nManhole diameter [mm] <" (rtos diameter 2 0) ">: ")))
    (if (null this-diameter) (setq this-diameter diameter))
    
    (initget 7)
    (setq this-depth (getreal 
      (strcat "\nManhole depth [m] <" (rtos depth 2 2) ">: ")))
    (if (null this-depth) (setq this-depth depth))
    
    ; Calculate invert level
    (setq invert (- ground-level this-depth))
    
    ; Draw manhole circle
    (command "._CIRCLE" pt (/ this-diameter 2000.0))
    
    ; Create text label
    (setq text-pt (list (+ (car pt) (* (/ this-diameter 1000.0) 0.75))
                        (+ (cadr pt) (* (/ this-diameter 1000.0) 0.75))))
    
    (command "._TEXT" "_J" "_L" text-pt 0.25 0
      (strcat "MH-" (rtos *MH-Counter* 2 0)
              "\nGL=" (rtos ground-level 2 2) "m"
              "\nD=" (rtos this-diameter 2 0) "mm"
              "\nH=" (rtos this-depth 2 2) "m"
              "\nIL=" (rtos invert 2 2) "m"))
    
    ; Group the circle and text
    (command "._GROUP" "_C" (entlast "._CIRCLE") (entlast) "")
    
    ; Print feedback
    (princ (strcat "\nManhole MH-" (rtos *MH-Counter* 2 0) " placed."))
  )
  
  (princ "\nManhole placement completed.")
  (princ)
)