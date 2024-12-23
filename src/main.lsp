(defun c:AddManhole ()
  ;; Prompt the user for a point
  (setq pt (getpoint "\nSelect location for manhole: "))
  ;; Check if the point is valid
  (if pt
    (progn
      ;; Draw a larger circle to represent the manhole
      (command "_.CIRCLE" pt "1.0") ;; Radius of 1.0 units for better visibility
      
      ;; Add a hatch to fill the circle
      (command "_.HATCH" "P" "SOLID" "") ;; Use solid fill
      
      ;; Prompt for manhole tag
      (setq manhole-tag (getstring "\nEnter manhole ID: "))
      (if manhole-tag
        (progn
          ;; Add the tag as larger text near the manhole
          (setq text-location (polar pt 0.0 1.5)) ;; Offset text further for better visibility
          (command "_.TEXT" text-location "0.5" "0" manhole-tag) ;; Larger text size
        )
        (prompt "\nNo tag provided, skipping annotation.")
      )
    )
    (prompt "\nInvalid point, operation canceled.")
  )
  (princ)
)
