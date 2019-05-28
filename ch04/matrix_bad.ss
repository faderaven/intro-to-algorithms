

(define matrix-determinant
  (lambda (A)
    (let* ([n (matrix-row A)]
           [sn (- n 1)]
           [B (make-matrix sn sn)])
      (let f ([A A] [n n] [sn sn] [sign -1] [B B] [sum 0])
        (cond
          [(< n 2) #f]
          [(= n 2)
           (- (* (matrix-ref A 0 0) (matrix-ref A 1 1))
              (* (matrix-ref A 0 1) (matrix-ref A 1 0)))]
          [else
            (do ([x 0 (+ x 1)])
              ((= x n))
              (matrix-set! B 0 0 (- sn 1) (- x 1)
                (matrix-get-son A 1 0 sn (- x 1)))
              (matrix-set! B 0 x sn sn
                (matrix-get-son A 1 (+ x 1) sn sn))
              (set! sign (switch sign))
              (set! sum (+ sum (* (* (matrix-ref A 0 x) sign)
                                  (f B
                                     sn
                                     (- sn 1)
                                     -1
                                     (make-matrix (- sn 1) (- sn 1))
                                     0)))))
            sum])))))

(define switch
  (lambda (n)
    (* n -1)))

(define matrix-minor
  (lambda (A)
    (let* ([n (matrix-row A)] [M (make-matrix n n)]
           [B (make-matrix (- n 1) (- n 1))])
      (cond
        [(not (matrix-square? A))
         (display "not a square matrix\n")
         #f]
        [(<= n 2)
         (display "not have minors\n")
         #f]
        [else
         (matrix-print A)
         (do ([r 0 (+ r 1)])
           ((= r n))
           (do ([c 0 (+ c 1)])
             ((= c n))
             (matrix-set! B 0 0 (- r 1) (- c 1)
               (matrix-get-son A 0 0 (- r 1) (- c 1)))
             (matrix-set! B 0 c r (- n 2)
               (matrix-get-son A 0 (+ c 1) (- r 1) (- n 1)))
             (matrix-set! B r 0 (- n 2) (- c 1)
               (matrix-get-son A (+ r 1) 0 (- n 1) (- c 1)))
             (matrix-set! B r c (- n 2) (- n 2)
               (matrix-get-son A (+ r 1) (+ c 1) (- n 1) (- n 1)))
             (matrix-print B)
             (matrix-set! M r c
               (matrix-determinant B))))
         M]))))

(define matrix-inverse
  (lambda (A)
    (let* ([M (matrix-minor A)] [Co (matrix-cofactor M)]
           [T (matrix-transpose Co)] [de (/ 1 (matrix-determinant A))])
      (matrix-print M)
      (matrix-print Co)
      (do ([r 0 (+ r 1)])
        ((= r (matrix-row A)))
        (do ([c 0 (+ c 1)])
          ((= c (matrix-col A)))
          (matrix-set! T r c
            (* de (matrix-ref T r c)))))
      T)))

(define matrix-cofactor
  (lambda (A)
    (let ([B (make-matrix (matrix-row A) (matrix-col A))] [sign 1])
      (do ([r 0 (+ r 1)])
        ((= r (matrix-row A)))
        (do ([c 0 (+ c 1)])
          ((= c (matrix-col A)))
          (matrix-set! B r c
            (* sign (matrix-ref A r c)))
          (set! sign (switch sign))))
      B)))
