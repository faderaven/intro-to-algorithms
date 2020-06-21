#lang racket

(struct node
  (coll
   [l #:mutable]
   [r #:mutable])
  #:transparent)

(define frequency (vector 2 3 4 11 35 36 37 36 65))
(define character (vector 'a 'b 'c 'd 'e 'f 'g 'h 's))

(define (collect frequency character)
  (let ([ls '()]
        [len (vector-length frequency)])
    (do ([i (- len 1) (- i 1)])
      ((> 0 i))
      (let* ([coll (cons (vector-ref frequency i)
                         (vector-ref character i))]
             [leaf (node coll #f #f)])
        (set! ls (cons leaf ls))))
    ls))

(define (huffman ls)
  (cond
    [(eq? '() (cdr ls))
     (car ls)]
    [else
     (let* ([x (car ls)]
            [y (cadr ls)]
            [x.f (car (node-coll x))]
            [y.f (car (node-coll y))]
            [w (node (list (+ x.f y.f)) x y)]
            [ls (replume w ls)])
       (huffman ls))]))

(define (replume w ls)
  (let f ([ls (cddr ls)])
    (cond
      [(eq? '() ls) (cons w ls)]
      [else
       (let ([w.f (car (node-coll w))]
             [a (car ls)]
             [a.f (car (node-coll (car ls)))])
         (cond
           [(<= w.f a.f)
            (cons w (cons a ls))]
           [else
            (cons (car ls) (f (cdr ls)))]))])))

(huffman (collect frequency character))