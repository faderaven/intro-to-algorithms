
(library
 (binary-tree (1))
 (export init-2tree-root
         2tree-left-set! 2tree-right-set!)
 (import (rnrs base) (rnrs records syntactic))

 (define-record-type node
   (nongenerative node-for-binary-tree)
   (fields (mutable obj)
           (mutable parent) (mutable left) (mutable right))
   (protocol
    (lambda (new)
      (lambda (obj)
        (new obj #f #f #f)))))

 (define init-2tree-root
   (lambda (s)
     (make-node s)))

 (define 2tree-left-set!
   (lambda (node s)
     (let ([left (make-node s)])
       (node-left-set! node left)
       (node-parent-set! left node))))

 (define 2tree-right-set!
   (lambda (node s)
     (let ([right (make-node s)])
       (node-right-set! node right)
       (node-parent-set! right node))))
 )