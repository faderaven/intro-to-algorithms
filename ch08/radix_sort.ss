
(define 0?
  (lambda (n)
    (= 0 n)))

(define power
  (lambda (n times)
    (cond
      [(0? times) 1]
      [else (* n (power n (sub1 times)))])))

(define extract-b
  (lambda (n digit)
    (let ([p1 (power 10 digit)]
          [p2 (power 10 (sub1 digit))])
      (/ (- (modulo n p1) (modulo n p2))
         p2))))

(define extract
  (lambda (n digit)
    (cond
      [(< n 0)
       (assertion-violation 'extract "n must be positive integer")]
      [(< digit 1)
       (assertion-violation 'extract "digit at least 1")]
      [else (extract-b n digit)])))

(define counting-stable
  (lambda (v d)
    (let ([record (make-vector 10)]
          [out (make-vector (vector-length v))]
          [len (vector-length v)])
      (do ([i 0 (add1 i)])
        ((= i len))
        (let* ([n (extract (vector-ref v i) d)]
               [count (add1 (vector-ref record n))])
          (vector-set! record n count)))
      (do ([i 1 (add1 i)])
          ((= i (vector-length record)))
          (let ([record:i (vector-ref record i)]
                [record:i-1 (vector-ref record (sub1 i))])
            (vector-set! record i (+ record:i record:i-1))))
      (do ([i (sub1 len) (sub1 i)])
        ((< i 0))
        (let* ([n (extract (vector-ref v i) d)]
               [index (sub1 (vector-ref record n))])
          (vector-set! out index (vector-ref v i))
          (vector-set! record n index)))
      out)))

(define radix-sort
  (lambda (v digit)
    (do ([i 1 (add1 i)])
      ((> i digit))
      (set! v (counting-stable v i)))
    v))

;;--------------------------------------

(define mk-random-vector
  (lambda (n n_min n_max)
    (let ([v (make-vector n)])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (let ([bound (- n_max n_min)])
          (vector-set! v i
                       (+ n_min
                          (random bound)))))
      v)))

(define A (mk-random-vector 100 0 1000))
(display A) (newline)
(define B (radix-sort A 3))
(display B) (newline)
