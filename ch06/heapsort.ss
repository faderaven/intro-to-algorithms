
(define vector-exchange
  (lambda (V i j)
    (let ([tmp (vector-ref V i)])
      (vector-set! V i (vector-ref V j))
      (vector-set! V j tmp))))

(define heap?
  (lambda (V)
    (if (< (vector-length V) 2)
       #f
       #t)))

(define heap-max?
  (lambda (A)
    ))

(define parent
  (lambda (i)
    (floor (/ i 2))))

(define LEFT
  (lambda (i)
    (* i 2)))

(define RIGHT
  (lambda (i)
    (+ 1 (* i 2))))

(define heapify-max
  (lambda (A i)
    (let ([l (LEFT i)] [r (RIGHT i)] [largest i]
          [size (vector-length A)])
      (if (and (> (vector-ref A l) (vector-ref A i))
               (< l size))
         (set! largest l))
      (if (and (> (vector-ref A r) (vector-ref A largest))
               (< r size))
         (set! largest r))
      (if (> (vector-ref A largest) (vector-ref A i))
         (begin
            (vector-exchange V i largest)
            (max-heapify A largest))))))
