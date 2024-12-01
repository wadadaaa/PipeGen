(defun c:PlaceCustomCircles ()
  (princ "\nClick to place custom circles. Press ESC or Enter to finish.")
  (while (setq pt (getpoint "\nSelect circle center: "))
    (command "CIRCLE" pt 50) ; Radius set to 50 units
  )
  (princ "\nCircle placement finished.\n")
  (princ) ; Clean exit
)

(defun c:TestCircle ()
  (command "CIRCLE" '(0 0) 500) ; Draw a circle at (0, 0) with a radius of 500 units
  (princ "\nA large test circle has been drawn at (0,0).\n")
  (princ)
)