
;; (define-record-type (type-name constructor predicate)
;;   (parent parent-type-name)
;;   (fields (mutable x get-x set-x!)
;;           (immutable y get-y))
;;   (nongenerative unique-id)
;;   (protocol
;;     (lambda (new)
;;       (lambda (fields-1 fields-2 ...)
;;       (new fields-1 fields-2 ...)))))
;; protocol clause receives a primitive constructor new as an argument, return a
;; final constructor c.

(define-record-type heap
  (nongenerative heap-1)
  (fields (mutable size) len v)
  (protocol
    (lambda (new)
      (lambda (size)
        (new size size
          (if (< size 3)
             (assertion-violation
               'heap-constructor "heap need length at least 2")
             (let ([V (make-vector (+ size 1))])
               (vector-set! V 0 'hold-empty)
               V)))))))

(define heap-ref
  (lambda (A i)
    (if (< i 1)
       "heap-ref: heap index start with 1"
       (vector-ref (heap-v A) i))))

(define heap-set!
  (lambda (A i value)
    (vector-set! (heap-v A) i value)))

(define heap-set-random!
  (lambda (A range)
    (do ([i 1 (+ i 1)])
        ((> i (heap-size A)))
      (heap-set! A i (random range)))))

(define heap-exchange
  (lambda (A i j)
    (if (and (<= i (heap-size A))
             (<= j (heap-size A)))
       (let ([tmp (heap-ref A i)])
         (heap-set! A i (heap-ref A j))
         (heap-set! A j tmp)
       "heap-exchange: index beyond boundary"))))

(define PARENT
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
    (let ([l (LEFT i)] [r (RIGHT i)] [largest i])
      (if (and (<= l (heap-size A))
               (> (heap-ref A l) (heap-ref A i)))
         (set! largest l))
      (if (and (<= r (heap-size A))
               (> (heap-ref A r) (heap-ref A largest)))
         (set! largest r))
      (if (> (heap-ref A largest) (heap-ref A i))
         (begin
            (heap-exchange A i largest)
            (heapify-max A largest))))))

(define heap-build-max
  (lambda (A)
    (do ([i (floor (/ (heap-size A) 2)) (- i 1)])
        ((< i 1))
      (heapify-max A i))))

(define heap-max?
  (lambda (A)
    (letrec ([max?
               (lambda (i)
                 (if (<= i (heap-size A))
                    (if (>= (vector-ref (heap-v A) (PARENT i))
                            (vector-ref (heap-v A) i))
                       (max? (+ i 1))
                       #f)
                    #t))])
      (max? 2))))

(define heap-sort
  (lambda (A)
    (heap-build-max A)
    (do ([size (heap-size A) (- size 1)])
        ((< size 2))
      (heap-exchange A 1 size)
      (heap-size-set! A (- size 1))
      (heapify-max A 1))))

(define A (make-heap 100))
(heap-set-random! A 1000)
(display (heap-v A))
(display "\n")
(heap-sort A)
(display (heap-v A))
