(cl:in-package #:viewpoints)

;;; viewpoint-sequence

(defmethod viewpoint-sequences ((v viewpoint) sequences)
  (mapcar #'(lambda (s) (viewpoint-sequence v s)) sequences))

(defmethod viewpoint-sequence ((v viewpoint) (m amuse:monody))
  (viewpoint-sequence v (coerce m 'list)))

(defmethod viewpoint-sequence ((v viewpoint) (event-list list))
  (labels ((events->viewpoint (events sequence)
             (if (null events) sequence
                 (let ((element (viewpoint-element v events)))
                   (if (undefined-p element)
                       (events->viewpoint (butlast events) sequence)
                       (events->viewpoint (butlast events)
                                          (cons element sequence)))))))
    (events->viewpoint event-list '())))

;;; viewpoint-element 

(defmethod viewpoint-element ((v viewpoint) (m amuse:monody))
  (viewpoint-element v (coerce m 'list)))

(defmethod viewpoint-element ((v viewpoint) (event-list list))
  (funcall (type-of v) event-list))

(defmethod viewpoint-element ((th threaded) (event-list list))
  (funcall (type-of th) event-list))

(defmethod viewpoint-element ((l linked) (event-list list))
  (let ((viewpoints (viewpoint-links l)))
    (mapcar #'(lambda (a) (funcall (type-of a) event-list))
            viewpoints)))

;;; Viewpoint methods 

(defmethod viewpoint-alphabet ((v viewpoint)) (%viewpoint-alphabet v))

(defmethod (setf viewpoint-alphabet) (alphabet (v viewpoint))
  (setf (%viewpoint-alphabet v) alphabet))

(defmethod viewpoint-typeset ((v viewpoint)) (%viewpoint-typeset v))

(defmethod viewpoint-links ((v viewpoint)) v)
(defmethod viewpoint-links ((l linked)) (%viewpoint-links l))
(defmethod viewpoint-links ((th threaded)) th)

(defmethod basic-p ((v viewpoint)) (typep v 'basic))
(defmethod derived-p ((v viewpoint)) (typep v 'derived))
(defmethod test-p ((v viewpoint)) (typep v 'test))
(defmethod linked-p ((v viewpoint)) (typep v 'linked))
(defmethod threaded-p ((v viewpoint)) (typep v 'threaded))

(defmethod viewpoint-name ((v viewpoint))
  (let* ((links (viewpoint-links v))
         (types (mapcar #'(lambda (l)
                            (string-downcase (symbol-name (type-of l))))
                        (if (atom links) (list links) links)))
         (name ""))
    (dolist (type (stable-sort types #'string<) name)
      (setf name 
            (concatenate 'string name (if (string= name "") "" "-") type)))))

(defmethod viewpoint-type ((v viewpoint))
  "Returns the type of a viewpoint <v>."
  (let ((viewpoints (viewpoint-links v)))
    (if (atom viewpoints)
        (type-of viewpoints)
        (mapcar #'type-of viewpoints))))

(defmethod viewpoint-equal ((v1 viewpoint) (v2 viewpoint))
  (equal (viewpoint-type v1) (viewpoint-type v2)))

(defmethod viewpoint-equal ((l1 linked) (l2 linked))
  (let ((type1 (viewpoint-type l1))
        (type2 (viewpoint-type l2)))
    (= (length type1) (length type2)
       (length (union type1 type2 :test #'equal)))))

(defmethod in-typeset-p ((b basic) (v viewpoint))
  (find (viewpoint-type b) (viewpoint-typeset v)))

(defmethod viewpoint-element-equal ((b basic) (v viewpoint) element1 element2)
  (when (in-typeset-p b v) (equal element1 element2)))

(defmethod viewpoint-element-equal ((b basic) (l linked) element1 element2)
  (when (in-typeset-p b l)
    (let ((elements-equal t)
          (links (viewpoint-links l)))
      (mapc #'(lambda (v e1 e2)
                (when (and (in-typeset-p b v) (not (equal e1 e2)))
                  (setf elements-equal nil)))
            links element1 element2)
      elements-equal)))

;;; Inverse viewpoint methods

(defmethod basic-sequence ((v viewpoint) (b basic) element-list event-list)
  (let ((element-list-rev (reverse element-list))
        (bs '()))
    (dotimes (i (length element-list) bs)
      (let ((el (nth i element-list-rev)))
        (unless (undefined-p el)
          (push (basic-element v b el (butlast event-list i)) bs))))))

(defmethod basic-sequence ((from basic) (to basic) element-list event-list)
  (declare (ignore from to event-list))
  element-list)
 
(defmethod basic-element ((from basic) (to basic) element event-list)
  (declare (ignore from to event-list))
  (list element))
 
(defmethod basic-element ((v viewpoint) (b basic) element event-list)
  (declare (ignore b))
  (unless (undefined-p element)
    (let ((inverse-function (inverse-viewpoint-function v)))
      (when inverse-function 
        (funcall inverse-function element event-list)))))

(defmethod basic-element ((l linked) (b basic) element event-list)
  (reduce #'(lambda (&rest x) 
              (when x (intersection (car x) (cadr x))))
          (mapcan #'(lambda (v e)
                      (when (in-typeset-p b v)
                        (let ((be (basic-element v b e event-list)))
                          (and be (list be)))))
                  (viewpoint-links l) element)))

(defmethod inverse-viewpoint-function ((v viewpoint))
  (find-symbol (concatenate 'string (symbol-name (type-of v)) "*")
               'viewpoints))

(defmethod inverse-viewpoint-function-defined-p ((v viewpoint))
  (if (inverse-viewpoint-function v) t nil))

(defmethod inverse-viewpoint-function-defined-p ((l linked))
  (every #'(lambda (x) (not (null x))) 
         (mapcar #'inverse-viewpoint-function-defined-p 
                 (viewpoint-links l))))