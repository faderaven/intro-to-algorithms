
(define-record-type node
  (nongenerative node-for-unbounded-tree)
  (fields (mutable obj)
          (mutable parent) (mutable head_sub) (mutable right))
  (protocol
   (lambda (new)
     (lambda (obj)
       (new obj #f #f #f)))))

(define init-xtree-head
  (lambda (s)
    (make-node s)))

(define xtree-add
  (lambda (node s)
    (let ([sub (make-node s)])
      (cond
        [(eq? (node-head-sub node) #f)
         (node-head_sub-set! node sub)]
        [else
         (node-right-set! node sub)])
      (node-parent-set! sub node))))