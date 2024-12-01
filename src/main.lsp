(defun c:PipeGen ()
  (alert "PipeGen Plugin Initialized!")
  (c:DrawPipe) ; Call DrawPipe function
)

(defun c:DrawPipe ()
  (command "LINE" (list 0 0) (list 10 10) "")
)