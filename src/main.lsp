(defun c:PlaceManholes ()
  (prompt "\nClick to place manholes. Press ESC to finish.")
  (while (setq pt (getpoint "\nSelect manhole location: "))
    (entmakex
      (list
        '(0 . "CIRCLE")          ; Entity type: Circle
        (cons 10 pt)             ; Center point
        (cons 40 1.0)            ; Radius (default: 1 unit)
      )
    )
    (command "TEXT" (list (+ (car pt) 1) (cadr pt)) "Manhole") ; Label the manhole
  )
  (princ "\nManhole placement finished.\n")
  (princ) ; Clean return to command line
)