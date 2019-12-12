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
          [(do ([i 1 (+ i 1)])
             ((> i (- n k)) sum)
             (set! sum (+ sum ((cut-k-all (- k 1)) (- n i)))))])))))

(define rod-all
  (lambda (n)
    (cond
      [(or (not (exact? n)) (< n 1))
       (error "exact: n > 1")]
      [else
       (let ([sum 2]) ;; partition-n and no-cut
         (do ([i 1 (+ i 1)])
           ((= i (- n 1)) sum)
           (set! sum (+ sum ((cut-k-all i) n)))))])))

((cut-k-all 14) 15)
(rod-all 25)