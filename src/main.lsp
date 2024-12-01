(defun c:PlaceManhole ( / pt)
  ; Initialize counter if not exists
  (if (null *MH-Counter*) (setq *MH-Counter* 0))
  
  ; Create and set layer
  (if (null (tblsearch "LAYER" "MANHOLES"))
    (command "LAYER" "M" "MANHOLES" "C" "1" "MANHOLES" "")
  )
  (command "LAYER" "S" "MANHOLES" "")
  
  ; Default values
  (setq cover-level 0.15)   ; Cover level in meters
  (setq invert-level -0.45) ; Invert level in meters
  (setq manhole-type "LIGHT DUTY")
  
  (princ "\nClick to place manholes. Press Enter or ESC to finish.")
  
  ; Main loop - continue until user presses Enter or ESC
  (while (setq pt (getpoint "\nSelect manhole location: "))
    ; Increment counter
    (setq *MH-Counter* (1+ *MH-Counter*))
    
    ; Draw manhole circle
    (command "CIRCLE" pt 0.5)
    (setq circle-id (entlast))
    
    ; Create text label
    (setq text-pt (list (+ (car pt) 0.75) (+ (cadr pt) 0.5)))
    
    (command "TEXT" "J" "L" text-pt 0.25 0
      (strcat "MH-" (rtos *MH-Counter* 2 0) "\n"
              "C.L +" (rtos cover-level 2 2) "\n"
              "I.L " (rtos invert-level 2 2) "\n"
              manhole-type))
    (setq text-id (entlast))
    
    ; Create selection set for grouping
    (setq ss (ssadd))
    (ssadd circle-id ss)
    (ssadd text-id ss)
    
    ; Create group with auto-generated name
    (command "GROUP" "C" "" "" ss "")
    
    (princ (strcat "\nManhole MH-" (rtos *MH-Counter* 2 0) " placed."))
  )
  
  (princ)
)