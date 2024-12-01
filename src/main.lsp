(defun c:PlaceManholes ()
  (princ "\nSewer Design Plugin: Place Manholes")
  (setq manhole-list '())
  (princ "\nClick to place manholes. Right-click or press Enter to finish.")
  (while (setq pt (getpoint "\nSelect manhole location: "))
    (setq diameter (getreal "\nEnter manhole diameter (mm): "))
    (setq depth (getreal "\nEnter manhole depth (m): "))
    (setq invert (getreal "\nEnter invert level (m): "))
    
    ; Draw manhole as a circle
    (command "_.circle" pt (/ diameter 2000.0))
    
    ; Add manhole label
    (setq text-pt (list (+ (car pt) (/ diameter 2000.0)) (cadr pt)))
    (command "_.text" text-pt 0.2 0 (strcat "MH" (itoa (1+ (length manhole-list))) "\nD=" (rtos diameter 2 0) "mm\nH=" (rtos depth 2 2) "m\nIL=" (rtos invert 2 2) "m"))
    
    ; Save manhole data
    (setq manhole-list (cons (list pt diameter depth invert) manhole-list))
  )
  (if (not manhole-list)
    (princ "\nNo manholes placed. Exiting.")
    (princ "\nManhole placement completed.")
  )
  (princ)
)