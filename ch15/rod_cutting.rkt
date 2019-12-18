#lang racket

(define cut-all
  (lambda (n)
    (let ([sum 0])
      (let f ([num n])
        (cond
          [(= 0 num) (set! sum (+ sum 1))]
          [else
           (do ([i 1 (+ i 1)])
             ((> i num))
             (f (- num i)))]))
      sum)))

(define cut-norepeat
  (lambda (n)
    (let ([sum 0])
      (let f ([num n] [iter 1])
        (cond
          [(= 0 num) (set! sum (+ sum 1))]
          [else
           (do ([i iter (+ i 1)])
             ((> i num))
             (f (- num i) i))]))
      sum)))


(define run-test
  (lambda (f lat)
    (cond
      [(eq? '() lat) '()]
      [else
       (cons (f (car lat)) (run-test f (cdr lat)))])))

(run-test cut-all '(2 3 4 5 6 7 8 9))
(run-test cut-norepeat '(2 3 4 5 6 7 8 9))

