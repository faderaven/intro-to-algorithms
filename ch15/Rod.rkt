#lang racket

; (rod-all n)
; (rod-no-repeat n)

(define cut-1-a
  (lambda (n)
    (let ([sum 0])
      (do ([i 1 (+ i 1)])
        ((> i (- n 1)) sum)
        (set! sum (+ sum 1))))))

(define cut-2-a
  (lambda (n)
    (let ([sum 0])
      (do ([i 1 (+ i 1)])
        ((> i (- n 2)) sum)
        (set! sum (+ sum (cut-1-a (- n i))))))))

(define cut-3-a
  (lambda (n)
    (let ([sum 0])
      (do ([i 1 (+ i 1)])
        ((> i (- n 3)) sum)
        (set! sum (+ sum (cut-2-a (- n i))))))))

(define cut-k-all
  (lambda (k)
    (lambda (n)
      (let ([sum 0])
        (cond
          [(= 1 k) (- n 1)]
          [else
           (do ([i 1 (+ i 1)])
             ((> i (- n k)) sum)
             (set! sum (+ sum ((cut-k-all (- k 1)) (- n i)))))])))))

(define rod-all
  (lambda (n)
    (cond
      [(or (not (exact? n)) (<= n 1))
       (error "n: exact, n > 1")]
      [else
       (let ([sum 2]) ;; partition-n and no-cut
         (do ([i 1 (+ i 1)])
           ((= i (- n 1)) sum)
           (set! sum (+ sum ((cut-k-all i) n)))))])))

(define cut-k-norepeat
  (lambda (k)
    (lambda (n)
      (let ([sum 0])
        (cond
          [(= 1 k) (floor (/ n 2))]
          [else
           (do ([i 1 (+ i 1)])
             ((> i (floor (/ n (+ k 1)))) sum)
             (set! sum (+ sum ((cut-k-norepeat (- k 1)) (- n i)))))])))))

(define rod-no-repeat
  (lambda (n)
    (cond
      [(or (not (exact? n)) (<= n 1))
       (error "n: exact, n > 1")]
      [else
       (let ([sum 2]) ;; partition-n and no-cut
         (do ([i 1 (+ i 1)])
           ((= i (- n 1)) sum)
           (set! sum (+ sum ((cut-k-norepeat i) n)))))])))

((cut-k-all 2) 10)
((cut-k-norepeat 2) 10)

(define test
  (lambda (f up)
    (let g ([ls '()] [up up])
      (cond
        [(= 1 up) ls]
        [else
         (g (cons (f up) ls) (- up 1))]))))

(test rod-all 15)
(test rod-no-repeat 15)

