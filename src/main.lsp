(defun c:DrawCircles ()
  (princ "\nClick to place circles. Press ESC or Enter to finish.")
  (while (setq pt (getpoint "\nSelect circle center: "))
    (command "CIRCLE" pt 5) ; Default radius is 5 units
  )
  (princ "\nCircle placement finished.\n")
  (princ) ; Clean exit
)