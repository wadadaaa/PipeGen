(defun c:TestCircle ()
  (setq pt '(0 0)) ; Set center point explicitly
  (setq radius 500) ; Set a large radius
  (princ (strcat "\nDrawing circle at: " (rtos (car pt) 2 2) ", " (rtos (cadr pt) 2 2) " with radius: " (rtos radius 2 2)))
  ; Explicitly create the circle
  (entmakex
    (list
      '(0 . "CIRCLE")          ; Specify the entity type as a circle
      (cons 10 pt)             ; Define the center point
      (cons 40 radius)         ; Define the radius
    )
  )
  (princ "\nCircle created successfully.\n")
  (princ)
)