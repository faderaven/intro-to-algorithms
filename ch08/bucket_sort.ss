
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

(define bucket-sort
  (lambda (v)
    (let* ([n (vector-length v)]
           [B (make-vector n '())])

      (do ([i 0 (add1 i)])
        ((= i n))
        (let* ([element (vector-ref v i)]
               [index (exact (floor (* n element)))]
               [lst (vector-ref B index)])
          (vector-set! B index (cons element lst))))

      (do ([i 0 (add1 i)])
        ((= i n))
        (vector-set! B i
                     (list->vector (vector-ref B i))))

      (do ([i 0 (add1 i)])
        ((= i n))
        (insertion-sort (vector-ref B i)))

      (let ([k 0])
        (do ([i 0 (add1 i)])
          ((= i n))
          (let* ([son (vector-ref B i)]
                 [son-len (vector-length son)])
            (do ([j 0 (add1 j)])
              ((= j son-len))
              (vector-set! v k (vector-ref son j))
              (set! k (add1 k)))))))))

;;--------------------------------------

(define set-random-seed
  (lambda ()
    (random-seed (time-nanosecond (current-time)))))

(define mk-random-vector
  (lambda (n n_min n_max)
    (let ([v (make-vector n)])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (let ([bound (- n_max n_min)])
          (set-random-seed)
          (vector-set! v i
                       (+ n_min
                          (random bound)))))
      v)))

(define A (mk-random-vector 100 0 1.0))
(display A) (newline)
(bucket-sort A)
(display A) (newline)
