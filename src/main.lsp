(defun c:PlaceCustomCircles ()
  (princ "\nClick to place custom circles. Press ESC or Enter to finish.")
  (while (setq pt (getpoint "\nSelect circle center: "))
    (command "CIRCLE" pt 50) ; Radius set to 50 units
  )
  (princ "\nCircle placement finished.\n")
  (princ) ; Clean exit
)