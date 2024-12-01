(defun c:PlaceManhole ( / pt)
  ; Initialize counter if not exists
  (if (null *MH-Counter*) (setq *MH-Counter* 0))
  
  ; Create and set layer
  (if (null (tblsearch "LAYER" "MANHOLES"))
    (command "._LAYER" "M" "MANHOLES" "C" "1" "MANHOLES" "")
  )
  (command "._LAYER" "S" "MANHOLES" "")
  
  ; Default values
  (setq diameter 1000.0)  ; 1000mm
  (setq depth 3.0)        ; 3m
  
  (princ "\nClick to place manholes. Press Enter or ESC to finish.")
  
  ; Main loop - continue until user presses Enter or ESC
  (setq pt T)  ; Initialize pt to allow loop to start
  (while pt     ; Continue while pt has a value
    (setq pt (getpoint "\nSelect manhole location: "))
    (if pt      ; Only create manhole if point was selected
      (progn
        ; Increment counter
        (setq *MH-Counter* (1+ *MH-Counter*))
        
        ; Draw manhole circle
        (command "._CIRCLE" pt (/ diameter 2000.0))
        (setq circle-id (entlast))
        
        ; Create text label
        (setq text-pt (list (+ (car pt) 0.5) (+ (cadr pt) 0.5)))
        
        (command "._TEXT" "J" "L" text-pt 0.25 0
          (strcat "MH-" (rtos *MH-Counter* 2 0)
                  "\nD=" (rtos diameter 2 0) "mm"
                  "\nH=" (rtos depth 2 2) "m"))
        (setq text-id (entlast))
        
        ; Group the circle and text
        (command "._GROUP" "C" circle-id text-id "")
      )
    )
  )
  
  (princ)
)