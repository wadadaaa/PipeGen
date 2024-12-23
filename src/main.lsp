(defun c:AddManhole ()
  ;; Prompt the user for a point
  (setq pt (getpoint "\nSelect location for manhole: "))
  ;; Check if the point is valid
  (if pt
    (progn
      ;; Draw a circle to represent the manhole
      (command "_.CIRCLE" pt "0.5") ;; Radius of 0.5 units (adjust as needed)
      ;; Add a unique tag to the manhole
      (setq manhole-tag (getstring "\nEnter manhole ID: "))
      (if manhole-tag
        (progn
          ;; Add the tag as text next to the manhole
          (setq text-location (polar pt 0.0 1.0)) ;; Offset text slightly to the right
          (command "_.TEXT" text-location "0.2" "0" manhole-tag)
        )
        (prompt "\nNo tag provided, skipping annotation.")
      )
    )
    (prompt "\nInvalid point, operation canceled.")
  )
  (princ)
)
