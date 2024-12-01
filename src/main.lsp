(defun c:PlaceManhole ( / pt diameter depth invert layer circle-id text-id mh-number)
  ; Initialize layer
  (setq layer "MANHOLES")
  (if (null (tblsearch "LAYER" layer))
    (command "._LAYER" "_M" layer "_C" "RED" layer "")
  )
  
  ; Initialize counter for manhole numbering
  (if (null MH-Counter) (setq MH-Counter 0))
  
  (while 
    (setq pt (getpoint "\nSelect point to place manhole: "))
    
    ; Increment manhole counter
    (setq MH-Counter (1+ MH-Counter))
    (setq mh-number (strcat "MH-" (rtos MH-Counter 2 0)))
    
    ; Get manhole parameters with default values and validation
    (initget 6) ; Make input required and positive
    (setq diameter (getreal 
      (strcat "\nEnter manhole diameter [mm] <1000>: ")))
    (if (null diameter) (setq diameter 1000.0))
    
    (initget 6)
    (setq depth (getreal 
      (strcat "\nEnter manhole depth [m] <3.0>: ")))
    (if (null depth) (setq depth 3.0))
    
    (initget 1)
    (setq invert (getreal 
      (strcat "\nEnter invert level [m]: ")))
    
    ; Set current layer
    (command "._LAYER" "_S" layer "")
    
    ; Create manhole circle
    (command "._CIRCLE" pt (/ diameter 2000.0))
    (setq circle-id (entlast))
    
    ; Create formatted text for manhole data
    (setq text-content 
      (strcat mh-number 
        "\nD=" (rtos diameter 2 0) "mm"
        "\nH=" (rtos depth 2 2) "m"
        "\nIL=" (rtos invert 2 2) "m"
      )
    )
    
    ; Calculate text position (offset from circle)
    (setq text-pt (list (+ (car pt) (* (/ diameter 1000.0) 0.75))
                        (+ (cadr pt) (* (/ diameter 1000.0) 0.75))))
    
    ; Add text annotation
    (command "._TEXT" "_J" "_L" text-pt 0.25 0 text-content)
    (setq text-id (entlast))
    
    ; Group circle and text together
    (command "._GROUP" "_C" circle-id text-id "")
    
    ; Add data to custom dictionary (for future use)
    (dictadd 
      (list 
        (cons "ID" mh-number)
        (cons "DIAMETER" diameter)
        (cons "DEPTH" depth)
        (cons "INVERT" invert)
        (cons "LOCATION" pt)
      )
    )
    
    ; Print feedback
    (princ (strcat "\nManhole " mh-number " placed at: "
                   (rtos (car pt) 2 2) ", "
                   (rtos (cadr pt) 2 2)))
  )
  (princ "\nManhole placement completed.\n")
  (princ)
)

; Helper function to add data to custom dictionary
(defun dictadd (data / dict)
  (setq dict (namedobject "MANHOLES_DATA"))
  (if (null dict)
    (progn
      (setq dict (dictcreat))
      (dictname "MANHOLES_DATA" dict)
    )
  )
  (dictadd dict (cdar data) (cdr data))
)