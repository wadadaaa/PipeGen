(defun c:PlaceManhole ()
  (princ "\nClick to place a manhole.")
  (while (setq pt (getpoint "\nSelect manhole location: "))
    (setq diameter (getreal "\nEnter manhole diameter (mm): "))
    (setq depth (getreal "\nEnter manhole depth (m): "))
    (setq invert (getreal "\nEnter invert level (m): "))
    
    ; Draw manhole circle
    (command "CIRCLE" pt (/ diameter 2000.0)) ; Diameter converted to radius in meters
    
    ; Add text annotations
    (setq text-pt (list (+ (car pt) (/ diameter 2000.0)) (cadr pt)))
    (command "TEXT" text-pt 0.2 0 (strcat "D=" (rtos diameter 2 0) "mm\nH=" (rtos depth 2 2) "m\nIL=" (rtos invert 2 2) "m"))
    
    (princ (strcat "\nManhole placed at: " (rtos (car pt) 2 2) ", " (rtos (cadr pt) 2 2)))
  )
  (princ "\nManhole placement finished.\n")
  (princ)
)