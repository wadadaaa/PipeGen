(defun c:PlaceManhole ( / pt label-offset text-pos1 text-pos2 text-pos3 text-pos4)
  ; Initialize counter if not exists
  (if (null *MH-Counter*) (setq *MH-Counter* 0))
  
  ; Create and set layer for manholes
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
    
    ; Draw manhole circle with a larger radius for better visibility
    (command "CIRCLE" pt 1.0) ; Radius set to 1.0 units for visibility
    (setq circle-id (entlast)) ; Store circle entity ID
    
    ; Fill the circle with a solid hatch for better visibility
    (setvar "HPASSOC" 1) ; Ensure the hatch is associative
    (command "HATCH" "SOLID" "P" "") ; Create a solid hatch for the last created circle
    
    ; Explicitly calculate text positions for consistent placement
    (setq text-pos1 (list (+ (car pt) label-offset) (+ (cadr pt) 0.6))) ; Line 1: Manhole number
    (setq text-pos2 (list (+ (car pt) label-offset) (+ (cadr pt) 0.3))) ; Line 2: Cover Level
    (setq text-pos3 (list (+ (car pt) label-offset) (+ (cadr pt) 0.0))) ; Line 3: Invert Level
    (setq text-pos4 (list (+ (car pt) label-offset) (- (cadr pt) 0.3))) ; Line 4: Manhole Type
    
    ; Line 1: Manhole number
    (command "TEXT" text-pos1 0.35 0 (strcat "MH-" (itoa *MH-Counter*)))
    (setq text-id1 (entlast)) ; Store text entity ID
    
    ; Line 2: Cover Level
    (command "TEXT" text-pos2 0.35 0 (strcat "C.L +" (rtos cover-level 2 2)))
    (setq text-id2 (entlast)) ; Store text entity ID
    
    ; Line 3: Invert Level
    (command "TEXT" text-pos3 0.35 0 (strcat "I.L " (rtos invert-level 2 2)))
    (setq text-id3 (entlast)) ; Store text entity ID
    
    ; Line 4: Manhole Type
    (command "TEXT" text-pos4 0.35 0 manhole-type)
    (setq text-id4 (entlast)) ; Store text entity ID
    
    ; Create selection set for grouping
    (setq ss (ssadd))
    (ssadd circle-id ss)
    (ssadd text-id1 ss)
    (ssadd text-id2 ss)
    (ssadd text-id3 ss)
    (ssadd text-id4 ss)
    
    ; Create group with auto-generated name
    (command "GROUP" "C" "" "" ss "")
    
    (princ (strcat "\nManhole MH-" (itoa *MH-Counter*) " placed."))
  )
  
  (princ)
)
