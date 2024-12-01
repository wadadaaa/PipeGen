(defun c:PlaceCustomCircles ()
  (princ "\nClick to place custom circles. Press ESC or Enter to finish.")
  (while (setq pt (getpoint "\nSelect circle center: "))
    (command "CIRCLE" pt 50) ; Radius set to 50 units
  )
  (princ "\nCircle placement finished.\n")
  (princ) ; Clean exit
)

(defun c:TestCircle ()
  (setq pt '(0 0)) ; Set center point
  (setq radius 500) ; Set a large radius
  (princ (strcat "\nDrawing circle at: " (rtos (car pt) 2 2) ", " (rtos (cadr pt) 2 2) " with radius: " (rtos radius 2 2)))
  (command "CIRCLE" pt radius)
  (princ "\nCircle created.\n")
  (princ)
)