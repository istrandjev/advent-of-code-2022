(defparameter *char-map* (make-hash-table :test #'eq :size 26))

(let 
  (
	  (line (read-line))
	  (last 0)
	  (first -1)
  )
  (loop for c from (char-code #\a) to (char-code #\z)
    do (setf (gethash (code-char c) *char-map*) -55)
  )
  (loop for idx from 0 to (- (length line) 1)
	do (setf cur (aref line idx))
	do (setf cur_last (gethash cur *char-map*))
	do (if (>= cur_last (- idx 13)) (setf last (max last (+ 1 cur_last))))
    do (if (>= (- idx last) 13) (if (= first -1) (setf first idx)))
    do (setf (gethash cur *char-map*) idx)
  )
  (format t "The answer is: ~A~%" (+ first 1))
)

