#lang racket

; the number of compatible matrixes: n
; A1, A2, ... An
; a1*a2, a2*a3, ... an*a(n+1)

(struct Product ([row #:mutable]
                 [col #:mutable]
                 [sum #:mutable]
                 [prior #:mutable])
  #:transparent)

(define (matrix*chain-row chain index)
  (car (vector-ref chain index)))

(define (matrix*chain-col chain index)
  (cadr (vector-ref chain index)))

(define (make-shelf chain)
  (let* ([n (vector-length chain)]
         [shelf (make-vector n)])
    (do ([i 0 (+ i 1)]
         [j n (- j 1)])
      ((= i n))
      (vector-set! shelf i (make-vector j)))
    (let ([v1 (vector-ref shelf 0)])
      (do ([i 0 (+ i 1)])
        ((= i n))
        (vector-set! v1 i
                     (Product (matrix*chain-row chain i)
                              (matrix*chain-col chain i)
                              0
                              i))))
    shelf))

(define (shelf-ref shelf left right)
  (let* ([index (- right left)]
         [v1 (vector-ref shelf index)])
    (vector-ref v1 left)))

(define (shelf-set! shelf left right pduct)
  (let* ([index (- right left)]
         [v1 (vector-ref shelf index)])
    (vector-set! v1 left pduct)))

(define (shelf-empty? shelf left right)
  (let ([info (shelf-ref shelf left right)])
    (if (Product? info)
        #f
        #t)))

(define (mul pduct1 pduct2)
  (let ([row (Product-row pduct1)]
        [col (Product-col pduct2)]
        [sum1 (Product-sum pduct1)]
        [sum2 (Product-sum pduct2)]
        [prior1 (Product-prior pduct1)]
        [prior2 (Product-prior pduct2)])
    (Product row
             col
             (+ (* row (Product-col pduct1) col)
                sum1 sum2)
             (cons prior1 (cons prior2 '())))))

(define (find-min-multiply shelf)
  (let ([n (vector-length shelf)])
    (let paren ([left 0] [right (- n 1)])
      (cond
        [(not (shelf-empty? shelf left right))
         (shelf-ref shelf left right)]
        [else
         (let ([min (Product 0 0 +inf.0 -1)])
           (do ([i left (+ i 1)])
             ((= i right))
             (let ([tmp (mul (paren left i)
                             (paren (+ i 1) right))])
               (when (< (Product-sum tmp)
                        (Product-sum min))
                 (set! min tmp))))
           (shelf-set! shelf left right min)
           min)]))))

(define M-dim
  '#((5 4) (4 6) (6 3) (3 9) (9 8) (8 3) (3 11)))

(define shelf (make-shelf M-dim))

(find-min-multiply shelf)
shelf