
(define quick-sort
  (lambda (divide)
    (lambda (v)
      (let ([q 0])
        (let f ([l 0] [r (sub1 (vector-length v))])
          (when (< l r)
            (set! q (divide v l r))
            (f l (sub1 q))
            (f (add1 q) r)))))))

(define divide
  (lambda (compare)
    (lambda (v l r)
      (let ([i (sub1 l)])
        (do ([j l (add1 j)])
          ((= j r))
          (when (compare (vector-ref v j) (vector-ref v r))
            (set! i (add1 i))
            (exchange v i j)))
        (exchange v (add1 i) r)
        (add1 i)))))

(define random-divide
  (lambda (compare)
    (lambda (v l r)
      (exchange v
                (+ l (random (add1 (- r l))))
                r)
      ((divide compare) v l r))))

(define exchange
  (lambda (v i j)
    (let ([temp (vector-ref v i)])
      (vector-set! v i (vector-ref v j))
      (vector-set! v j temp))))

(define quick-sort-ase (quick-sort (divide <=)))
(define quick-sort-dese (quick-sort (divide >=)))
(define random-quick-sort-ase (quick-sort (random-divide <=)))
(define random-quick-sort-dese (quick-sort (random-divide >=)))

;;-----------------------------------

(define mk-random-vector
  (lambda (n bound)
    (let ([v (make-vector n)])
      (do ([i 0 (add1 i)])
        ((= i (vector-length v)))
        (vector-set! v i (random bound)))
      v)))

(define A (mk-random-vector 100 1000))
(quick-sort-ase A)
(display A)
(newline)
(quick-sort-dese A)
(display A)
(newline)
(random-quick-sort-ase A)
(display A)
(newline)
(random-quick-sort-dese A)
(display A)
(newline)
