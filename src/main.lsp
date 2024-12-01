(defun c:PipeGen ()
  (alert "PipeGen Plugin Initialized!")
  (c:DrawPipe) ; Call DrawPipe function
)

(defun c:DrawPipe ()
  (print "Executing DrawPipe function...") ; Debugging output
  (command "LINE" "0,0" "10,10" "") ; Use coordinate strings instead of list
  (princ) ; Ensure clean command line return
)