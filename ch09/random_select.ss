
(define divide
  (lambda (v l r)
    (let ([pivot (vector-ref v r)]
          [i (sub1 l)])
      (do ([j l (add1 j)])
        ((= j r))
        (when (< (vector-ref v j) pivot)
          (set! i (add1 i))
          (exchange v i j)))
      (exchange v (add1 i) r)
      (add1 i))))

(define random-divide
  (lambda (v l r)
    (mk-random-seed)
    (let* ([bound (add1 (- r l))]
           [p (+ l (random bound))])
      (exchange v p r)
      (divide v l r))))

(define random-select-b
  (lambda (index v left right)
    (let RS ([l left] [r right])
      (cond
        [(< l r)
         (let ([p (random-divide v l r)])
           (cond
             [(< index p)
              (RS l (sub1 p))]
             [(> index p)
              (RS (add1 p) r)]
             [else (vector-ref v index)]))]
        [else (vector-ref v index)]))))

(define random-select
  (lambda (index v left right)
    (cond
      [(< left 0)
       (assertion-violation 'random-select
                            "left index out of range in vector" left)]
      [(>= right (vector-length v))
       (assertion-violation 'random-select
                            "right index out of range in vector" right)]
      [(or (< index left)
           (> index right))
       (assertion-violation 'random-select
                            "select index out of range in arguments left and right"
                            index)]
      [else
       (random-select-b index v left right)])))

;;--------------------------------------

(define insertion-sort
  (lambda (v)
    (let ([n (vector-length v)])
      (when (> n 0)
        (do ([i 1 (add1 i)])
          ((= i n))
          (do ([p (sub1 i) (sub1 p)] [q i (sub1 q)])
            ((or (< p 0) (<= (vector-ref v p) (vector-ref v q))))
            (exchange v p q)))))))

(define exchange
  (lambda (v i j)
    (let ([temp (vector-ref v i)])
      (vector-set! v i (vector-ref v j))
      (vector-set! v j temp))))

(define mk-random-seed
  (lambda ()
    (random-seed (time-nanosecond (current-time)))))

(define mk-random-vector
  (lambda (n n_min n_max)
    (let ([v (make-vector n)])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (let ([bound (- n_max n_min)])
          (mk-random-seed)
          (vector-set! v i
                       (+ n_min (random bound)))))
      v)))

(define A (mk-random-vector 100 0 100))
(display A) (newline)
(define m (random-select 1 A 0 99))
(display m) (newline)
(insertion-sort A)
(display A) (newline)
