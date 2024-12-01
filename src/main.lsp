(defun c:PlaceManhole ( / pt label-offset)
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
  (setq label-offset 0.75)  ; Distance from circle to text
  
  (princ "\nClick to place manholes. Press Enter or ESC to finish.")
  
  ; Main loop - continue until user presses Enter or ESC
  (while (setq pt (getpoint "\nSelect manhole location: "))
    ; Increment counter
    (setq *MH-Counter* (1+ *MH-Counter*))
    
    ; Draw manhole circle
    (command "CIRCLE" pt 0.5)
    (setq circle-id (entlast))
    
    ; Line 1: Manhole number
    (command "TEXT" 
            (list (+ (car pt) label-offset) (+ (cadr pt) 0.6)) 
            0.25 0 
            (strcat "MH-" (rtos *MH-Counter* 2 0)))
    (setq text-id1 (entlast))
    
    ; Line 2: Cover Level
    (command "TEXT" 
            (list (+ (car pt) label-offset) (+ (cadr pt) 0.3)) 
            0.25 0 
            (strcat "C.L +" (rtos cover-level 2 2)))
    (setq text-id2 (entlast))
    
    ; Line 3: Invert Level
    (command "TEXT" 
            (list (+ (car pt) label-offset) (+ (cadr pt) 0.0)) 
            0.25 0 
            (strcat "I.L " (rtos invert-level 2 2)))
    (setq text-id3 (entlast))
    
    ; Line 4: Manhole Type
    (command "TEXT" 
            (list (+ (car pt) label-offset) (- (cadr pt) 0.3)) 
            0.25 0 
            manhole-type)
    (setq text-id4 (entlast))
    
    ; Create selection set for grouping
    (setq ss (ssadd))
    (ssadd circle-id ss)
    (ssadd text-id1 ss)
    (ssadd text-id2 ss)
    (ssadd text-id3 ss)
    (ssadd text-id4 ss)
    
    ; Create group with auto-generated name
    (command "GROUP" "C" "" "" ss "")
    
    (princ (strcat "\nManhole MH-" (rtos *MH-Counter* 2 0) " placed."))
  )
  
  (princ)
)