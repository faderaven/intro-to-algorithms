
(library
 (random-lotto (1))
 (export bound bound! lotto)
 (import (chezscheme))
 
 (define make-ball
   (lambda (n)
     (letrec
         ([F (lambda (i lat)
               (cond
                 [(= 0 i) (cons 0 lat)]
                 [else
                  (F (sub1 i) (cons i lat))]))])
       (F (sub1 n) '()))))
 
 (define remove-ball
   (lambda (lat i co)
     (cond
       [(= 0 i) (co (car lat) (cdr lat))]
       [else
        (remove-ball
         (cdr lat) (sub1 i)
         (lambda (x y)
           (co x (cons (car lat) y))))])))
 
 (define help
   (lambda (a lat)
     (list a lat)))
 
 (define ball)
 (define ball!)

 (define lotto
   (let ([box '()]
         [min 0]
         [N 0])
     (set! ball
           (lambda () N))
     (set! ball!
           (case-lambda
             [(low up)
              (set! min low)
              (set! N (- up low))
              (set! box (make-ball N))]
             [(up)
              (ball! 0 up)]))
     (lambda ()
       (cond
         [(= 0 N)
          (error 'lotto
                 "the ball was exhausted, use bound! to reset.")]
         [else
          (random-seed (floor (/ (time-nanosecond (current-time)) 1000)))
          (let ([tag (remove-ball box (random N) help)])
            (set! box (cadr tag))
            (set! N (sub1 N))
            (+ min (car tag)))]))))

 (define bound ball)
 (define bound! ball!)
 )