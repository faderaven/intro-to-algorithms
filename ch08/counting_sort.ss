
(define counting-sort
  (lambda (v n-max)
    (let ([out (make-vector (vector-length v))]
          [record (make-vector (add1 n-max))])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (let* ([v:i (vector-ref v i)]
               [count (add1 (vector-ref record v:i))])
          (vector-set! record v:i count)))
      (do ([i 1 (add1 i)])
        ((= i (vector-length record)))
        (let ([record:i (vector-ref record i)]
              [record:i-1 (vector-ref record (sub1 i))])
          (vector-set! record i
                       (+ record:i record:i-1))))
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (let* ([v:i (vector-ref v i)]
               [index (sub1 (vector-ref record v:i))])
          (vector-set! out index v:i)
          (vector-set! record v:i index)))
      out)))

;;--------------------------------------

(define mk-random-vector
  (lambda (n bound)
    (let ([v (make-vector n)])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (vector-set! v i (random bound)))
      v)))

(define count 100)
(define n-max 99)

(define A (mk-random-vector count (add1 n-max)))
(display A)
(newline)
(define B (counting-sort A n-max))
(display B)
(newline)
