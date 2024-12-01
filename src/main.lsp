(defun c:TestCircle ()
  (setq pt '(0 0)) ; Center point of the circle
  (setq radius 500) ; Radius of the circle
  (princ (strcat "\nDrawing circle at: " (rtos (car pt) 2 2) ", " (rtos (cadr pt) 2 2) " with radius: " (rtos radius 2 2)))
  
  ; Use entmakex to create the circle
  (entmakex
    (list
      '(0 . "CIRCLE")        ; Entity type: Circle
      (cons 10 pt)           ; Center point (group code 10)
      (cons 40 radius)       ; Radius (group code 40)
    )
  )
  
  (princ "\nCircle created successfully using entmakex.\n")
  (princ)
)