
(library
 (link (1))
 (export make-link link-car link-cdr link-display)
 (import (rnrs base) (rnrs records syntactic) (rnrs io simple))

 (define sub1
   (lambda (n)
     (- n 1)))

 (define-record-type node
   (nongenerative node)
   (fields (mutable obj) (mutable next))
   (protocol
    (lambda (new)
      (lambda (obj)
        (new obj #f)))))

 (define nodal
   (lambda (l)
     (cond
       [(null? l) '()]
       [else
        (cons (make-node (car l))
              (nodal (cdr l)))])))

 (define make-link
   (lambda args
     (let* ([nodes (nodal args)]
            [head (car nodes)])
       (letrec ([f
                 (lambda (pre l)
                   (cond
                     [(null? l) head]
                     [else
                      (node-next-set! pre (car l))
                      (f (car l) (cdr l))]))])
         (f head (cdr nodes))))))

 (define link-ref
   (lambda (head index)
     (letrec ([f
               (lambda (head index)
                 (cond
                   [(zero? index) head]
                   [else
                    (f (node-next head) (sub1 index))]))])
       (node-obj (f head index)))))

 (define link-car
   (lambda (link)
     (node-obj link)))

 (define link-cdr
   (lambda (link)
     (node-next link)))

 (define link-display
   (lambda (link)
     (display "#(link [")
     (letrec ([f (lambda (l)
                   (cond
                     [(eq? (link-cdr l) #f)
                      (display (link-car l))
                      (display "])")]
                     [else
                      (display (link-car l)) (display " ")
                      (f (link-cdr l))]))])
       (f link))))
 )
