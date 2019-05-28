
(define-record-type matrix
  (fields coor v)   ;; coordinate list '(row . col)
  (nongenerative even-matrix)
  (protocol
    (lambda (new)
      (lambda (coor)
        (new coor
          (if (or (< (car coor) 0) (< (cdr coor) 0))
            (assertion-violation "matrix constructor"
              "matrix row and col at least 0")
            (make-vector (* (car coor) (cdr coor)))))))))


(define matrix-null?
  (lambda (A)
    (if (or (= 0 (car (matrix-coor A))) (= 0 (cdr (matrix-coor A))))
        #t
        #f)))


(define matrix-square?
  (lambda (A)
    (if (= (car (matrix-coor A)) (cdr (matrix-coor A)))
      #t
      #f)))


(define matrix-same-size?
  (lambda (A B)
    (if (and (= (car (matrix-coor A)) (car (matrix-coor B)))
             (= (cdr (matrix-coor A)) (cdr (matrix-coor B))))
        #t
        #f)))


(define matrix-compatible?
  (lambda (A B)
    (if (= (cdr (matrix-coor A)) (car (matrix-coor B)))
      #t
      #f)))


(define matrix-valid-coor?
  (lambda (A coor)
    (if (and (>= (car coor) 0)
             (>= (cdr coor) 0)
             (< (car coor) (car (matrix-coor A)))
             (< (cdr coor) (cdr (matrix-coor A))))
        #t
        #f)))


(define matrix-ref
  (lambda (A coor)
    (vector-ref (matrix-v A)
      (+ (* (car coor)
            (cdr (matrix-coor A)))
         (cdr coor)))))


(define matrix-set!
  (case-lambda
    [(A coor e)
     (vector-set! (matrix-v A)
       (+ (* (car coor)
             (cdr (matrix-coor A)))
          (cdr coor)) e)]
    [(A top bot B)
     (set-car! bot (min (car bot) (- (car (matrix-coor A)) 1)))
     (set-cdr! bot (min (cdr bot) (- (cdr (matrix-coor A)) 1)))
     (let ([row (min (+ (- (car bot) (car top)) 1)
                   (car (matrix-coor B)))]
           [col (min (+ (- (cdr bot) (cdr top)) 1)
                   (cdr (matrix-coor B)))])
       (let f ([m row] [r (car top)] [br 0])
         (when (> m 0)
           (let g ([n col] [c (cdr top)] [bc 0])
             (when (> n 0)
               (matrix-set! A (cons r c) (matrix-ref B (cons br bc)))
               (g (- n 1) (+ c 1) (+ bc 1))))
           (f (- m 1) (+ r 1) (+ br 1)))))]))


(define matrix-set-random!
  (lambda (A range)
    (do ([r 0 (+ r 1)])
      ((= r (car (matrix-coor A))))
      (do ([c 0 (+ c 1)])
        ((= c (cdr (matrix-coor A))))
        (matrix-set! A (cons r c)
          (random range))))))


(define matrix-set-list!
  (lambda (A l)
    (call/cc
      (lambda (k)
        (let ([row (car (matrix-coor A))]
              [col (cdr (matrix-coor A))])
          (do ([r 0 (+ r 1)])
            ((= r row))
            (do ([c 0 (+ c 1)])
              ((= c col))
              (matrix-set! A (cons r c) (car l))
              (set! l (cdr l))
              (if (null? l) (k)))))))))


(define matrix-print
  (lambda (A)
    (cond
      [(matrix-null? A)
       (display "matrix: null\n")]
      [else
       (let ([row (car (matrix-coor A))] [col (cdr (matrix-coor A))])
         (display "matrix:\n")
         (do ([r 0 (+ r 1)])
           ((= r row))
           (do ([c 0 (+ c 1)])
             ((= c col))
             (display " ")
             (display (matrix-ref A (cons r c))))
           (newline)))])))


(define matrix-son
  (lambda (A top bot)
    (let ([row (+ (- (car bot) (car top)) 1)]
          [col (+ (- (cdr bot) (cdr top)) 1)])
      (let ([B (make-matrix (cons row col))])
        (do ([r (car top) (+ r 1)] [br 0 (+ br 1)])
          ((= br row))
          (do ([c (cdr top) (+ c 1)] [bc 0 (+ bc 1)])
            ((= bc col))
            (matrix-set! B (cons br bc)
              (matrix-ref A (cons r c)))))
        B))))


(define matrix-get-son
  (lambda (A top bot)
    (cond
      [(matrix-valid-coor? A top)
       (let ([r_bot (min (car bot) (- (car (matrix-coor A)) 1))]
             [c_bot (min (cdr bot) (- (cdr (matrix-coor A)) 1))])
         (matrix-son A top (cons r_bot c_bot)))]
      [else
        (make-matrix (cons 0 0))])))


(define matrix-copy
  (lambda (A)
    (if (matrix-null? A)
        (make-matrix (cons 0 0))
        (let ([row (car (matrix-coor A))] [col (cdr (matrix-coor A))])
          (let ([B (make-matrix (cons row col))])
            (do ([r 0 (+ r 1)])
              ((= r row))
              (do ([c 0 (+ c 1)])
                ((= c col))
                (matrix-set! B (cons r c)
                  (matrix-ref A (cons r c)))))
            B)))))


(define matrix-scale
  (lambda (A s)
    (let ([row (car (matrix-coor A))] [col (cdr (matrix-coor A))])
      (let ([B (make-matrix (cons row col))])
        (do ([r 0 (+ r 1)])
          ((= r row))
          (do ([c 0 (+ c 1)])
            ((= c col))
            (matrix-set! B (cons r c)
              (* s (matrix-ref A (cons r c))))))
        B))))


(define matrix_+-
  (lambda (p A B)
    (let ([row (car (matrix-coor A))] [col (cdr (matrix-coor A))])
      (let ([C (make-matrix (cons row col))])
        (do ([r 0 (+ r 1)])
          ((= r row))
          (do ([c 0 (+ c 1)])
            ((= c col))
            (matrix-set! C (cons r c)
              (p (matrix-ref A (cons r c))
                 (matrix-ref B (cons r c))))))
        C))))


(define matrix-add/sub
  (lambda (p A B)
    (cond
      [(matrix-null? A) B]
      [(matrix-null? B) A]
      [(not (matrix-same-size? A B))
       (display "not same-size matrix cannot add/sub\n")]
      [else
       (matrix_+- p A B)])))


(define matrix-multiply
  (lambda (A B)
    (let ([row (car (matrix-coor A))] [col (cdr (matrix-coor B))]
          [same (cdr (matrix-coor A))] [sum 0])
      (let ([C (make-matrix (cons row col))])
        (do ([r 0 (+ r 1)])
          ((= r row))
          (do ([c 0 (+ c 1)])
            ((= c col))
            (do ([m 0 (+ m 1)])
              ((= m same))
              (set! sum (+ sum
                           (* (matrix-ref A (cons r m))
                              (matrix-ref B (cons m c))))))
            (matrix-set! C (cons r c) sum)
            (set! sum 0)))
        C))))


(define mid
  (lambda(n)
    (if (= 1 (mod n 2))
        (+ 1 (floor (/ n 2)))
        (/ n 2))))


(define matrix-multiply-recursive
  (lambda (A B)
    (let f ([A A] [B B])
      (let ([n (max (max (car (matrix-coor A)) (cdr (matrix-coor A)))
                    (max (car (matrix-coor B)) (cdr (matrix-coor B))))]
            [row (car (matrix-coor A))] [col (cdr (matrix-coor B))])
        (let ([C (make-matrix (cons row col))]
              [1_top (cons 0 0)]
              [1_bot (cons (- (mid n) 1) (- (mid n) 1))]
              [2_top (cons 0 (mid n))]
              [2_bot (cons (- (mid n) 1) (- n 1))]
              [3_top (cons (mid n) 0)]
              [3_bot (cons (- n 1) (- (mid n) 1))]
              [4_top (cons (mid n) (mid n))]
              [4_bot (cons (- n 1) (- n 1))])
          (cond
            [(matrix-null? C) C]
            [(= 1 n)
             (matrix-set! C 1_top
               (* (matrix-ref A 1_top) (matrix-ref B 1_top)))
             C]
            [else
             (matrix-set! C 1_top 1_bot
               (matrix-add/sub +
                 (f (matrix-get-son A 1_top 1_bot)
                    (matrix-get-son B 1_top 1_bot))
                 (f (matrix-get-son A 2_top 2_bot)
                    (matrix-get-son B 3_top 3_bot))))
             (when (matrix-valid-coor? C 2_top)
               (matrix-set! C 2_top 2_bot
                 (matrix-add/sub +
                   (f (matrix-get-son A 1_top 1_bot)
                      (matrix-get-son B 2_top 2_bot))
                   (f (matrix-get-son A 2_top 2_bot)
                      (matrix-get-son B 4_top 4_bot)))))
             (when (matrix-valid-coor? C 3_top)
               (matrix-set! C 3_top 3_bot
                 (matrix-add/sub +
                   (f (matrix-get-son A 3_top 3_bot)
                      (matrix-get-son B 1_top 1_bot))
                   (f (matrix-get-son A 4_top 4_bot)
                      (matrix-get-son B 3_top 3_bot)))))
             (when (matrix-valid-coor? C 4_top)
               (matrix-set! C 4_top 4_bot
                 (matrix-add/sub +
                   (f (matrix-get-son A 3_top 3_bot)
                      (matrix-get-son B 2_top 2_bot))
                   (f (matrix-get-son A 4_top 4_bot)
                      (matrix-get-son B 4_top 4_bot)))))
             C]))))))


(define matrix_+-_strassen
  (lambda (p A B)
    (let ([row (max (car (matrix-coor A)) (car (matrix-coor B)))]
          [col (max (cdr (matrix-coor A)) (cdr (matrix-coor B)))])
      (let ([C (make-matrix (cons row col))])
        (do ([r 0 (+ r 1)])
          ((= r row))
          (do ([c 0 (+ c 1)])
            ((= c col))
            (cond
              [(and (matrix-valid-coor? A (cons r c))
                    (matrix-valid-coor? B (cons r c)))
               (matrix-set! C (cons r c)
                 (p (matrix-ref A (cons r c))
                    (matrix-ref B (cons r c))))]
              [(matrix-valid-coor? A (cons r c))
               (matrix-set! C (cons r c)
                 (matrix-ref A (cons r c)))]
              [(matrix-valid-coor? B (cons r c))
               (matrix-set! C (cons r c)
                 (matrix-ref B (cons r c)))])))
        C))))


(define matrix-add/sub-strassen
  (lambda (p A B)
    (cond
      [(matrix-null? A)
       (if (eqv? - p)
           (matrix-scale B -1)
           (matrix-copy B))]
      [(matrix-null? B) (matrix-copy A)]
      [else
       (matrix_+-_strassen p A B)])))


(define matrix-multiply-strassen
  (lambda (A B)
    (let f ([A A] [B B])
      (let ([n (max (max (car (matrix-coor A)) (cdr (matrix-coor A)))
                    (max (car (matrix-coor B)) (cdr (matrix-coor B))))]
            [row (car (matrix-coor A))] [col (cdr (matrix-coor B))])
        (let ([C (make-matrix (cons row col))]
              [1_top (cons 0 0)]
              [1_bot (cons (- (mid n) 1) (- (mid n) 1))]
              [2_top (cons 0 (mid n))]
              [2_bot (cons (- (mid n) 1) (- n 1))]
              [3_top (cons (mid n) 0)]
              [3_bot (cons (- n 1) (- (mid n) 1))]
              [4_top (cons (mid n) (mid n))]
              [4_bot (cons (- n 1) (- n 1))])
          (cond
            [(matrix-null? C) C]
            [(= 1 n)
             (matrix-set! C 1_top
               (* (matrix-ref A 1_top) (matrix-ref B 1_top)))
             C]
            [else
             (let ([A1 (matrix-get-son A 1_top 1_bot)]
                   [A2 (matrix-get-son A 2_top 2_bot)]
                   [A3 (matrix-get-son A 3_top 3_bot)]
                   [A4 (matrix-get-son A 4_top 4_bot)]
                   [B1 (matrix-get-son B 1_top 1_bot)]
                   [B2 (matrix-get-son B 2_top 2_bot)]
                   [B3 (matrix-get-son B 3_top 3_bot)]
                   [B4 (matrix-get-son B 4_top 4_bot)])
               (let ([S1 (matrix-add/sub-strassen - B2 B4)]
                     [S2 (matrix-add/sub-strassen + A1 A2)]
                     [S3 (matrix-add/sub-strassen + A3 A4)]
                     [S4 (matrix-add/sub-strassen - B3 B1)]
                     [S5 (matrix-add/sub-strassen + A1 A4)]
                     [S6 (matrix-add/sub-strassen + B1 B4)]
                     [S7 (matrix-add/sub-strassen - A2 A4)]
                     [S8 (matrix-add/sub-strassen + B3 B4)]
                     [S9 (matrix-add/sub-strassen - A1 A3)]
                     [S10 (matrix-add/sub-strassen + B1 B2)])
                 (let ([P1 (f A1 S1)]
                       [P2 (f S2 B4)]
                       [P3 (f S3 B1)]
                       [P4 (f A4 S4)]
                       [P5 (f S5 S6)]
                       [P6 (f S7 S8)]
                       [P7 (f S9 S10)])
                   (matrix-set! C 1_top 1_bot
                     (matrix-add/sub-strassen +
                       (matrix-add/sub-strassen -
                         (matrix-add/sub-strassen + P5 P4) P2) P6))
                   (when (matrix-valid-coor? C 2_top)
                     (matrix-set! C 2_top 2_bot
                       (matrix-add/sub-strassen + P1 P2)))
                   (when (matrix-valid-coor? C 3_top)
                     (matrix-set! C 3_top 3_bot
                       (matrix-add/sub-strassen + P3 P4)))
                   (when (matrix-valid-coor? C 4_top)
                     (matrix-set! C 4_top 4_bot
                       (matrix-add/sub-strassen -
                         (matrix-add/sub-strassen -
                           (matrix-add/sub-strassen + P5 P1) P3) P7)))
                   C)))]))))))


(define A (make-matrix '(5 . 11)))
(define B (make-matrix '(11 . 4)))
(matrix-set-random! A 10)
(matrix-set-random! B 10)
(matrix-print A)
(matrix-print B)
(matrix-print (matrix-multiply A B))
(matrix-print (matrix-multiply-strassen A B))
