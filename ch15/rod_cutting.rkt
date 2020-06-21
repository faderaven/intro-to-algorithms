#lang racket

(define price_table
  (vector 'nonuse 1 5 8 9 10 17 17 20 24 30))

(define (rod-cutting n price_table)
  (let ([prce (make-vector (+ n 1) -inf.0)]
        [rods (make-vector (+ n 1) 'uninit)])
    (letrec ([f (lambda (n init)
                  (cond
                    [(= 0 n) 0]
                    [(< -inf.0 (vector-ref prce n))
                     (vector-ref prce n)]
                    [else
                     (do ([i 1 (+ i 1)])
                       ((> i n))
                       (let* ([bean (f (- n i) i)]
                              [pod (+ bean (offer i))])
                         (max n i pod)))
                     (vector-ref prce n)]))]
             [offer (lambda (index)
                      (cond
                        [(> (+ index 1) (vector-length price_table))
                         (f index 1)]
                        [else
                         (vector-ref price_table index)]))]
             [max (lambda (n i pod)
                    (when (< (vector-ref prce n) pod)
                      (vector-set! prce n pod)
                      (vector-set! rods n i)))])
      (f n 1))
    (list prce rods)))

(define (cutting n)
  (let ([sum 0])
    (let f ([n n] [init 1])
      (cond
        [(= 0 n) (set! sum (+ sum 1))]
        [else
         (do ([i init (+ i 1)])
           ((> i n))
           (f (- n i) i))]))
    sum))

(define (range start end)
  (cond
    [(> start end) '()]
    [else (cons start (range (+ start 1) end))]))

(rod-cutting 17 price_table)
