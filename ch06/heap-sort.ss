
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

(define RESERVED 63)

(define-record-type heap
  (nongenerative heap-for-sort)
  (fields (mutable capacity) (mutable tail) (mutable v))
  (protocol
    (lambda (new)
      (lambda (size)
        (new
          (+ size RESERVED)
          tail
          (if (< tail 1)
             (assertion-violation
               'heap-constructor "heap need length at least 1")
             ;; index at 0, not be used, index start at 1
             (let ([v (make-vector (+ tail RESERVED 1))])
               (vector-set! v 0 'hold-empty)
               v)))))))

(define heap-ref
  (lambda (A i)
    (if (< i 1)
       "heap-ref: heap tail start with 1"
       (vector-ref (heap-v A) i))))

(define heap-set!
  (lambda (A i value)
    (vector-set! (heap-v A) i value)))

(define heap-set-random!
  (lambda (A range)
    (do ([i 1 (+ i 1)])
        ((> i (heap-tail A)))
      (heap-set! A i (random range)))))

(define heap-append!
  (lambda (A key)
    (let ([next-pos (+ (heap-tail A) 1)])
      (if (<= next-pos capacity)
        (begin
          (heap-tail-set! next-pos)
          (heap-set! A next-pos key))
        (begin
          (let ([v (make-vector (+ capacity RESERVED 1))])
            (vector-copy (heap-v A) 0 (heap-tail A) v)
            (heap-v-set! A v))))
    (if (<= tail capacity)
      (begin
        (heap-tail-set! (+ heap-tail 1))
        (heap-set! A (heap-tail A) key))
      (begin
        ()))))

(define heap-exchange
  (lambda (A i j)
    (if (and (<= i (heap-tail A))
             (<= j (heap-tail A)))
       (let ([tmp (heap-ref A i)])
         (heap-set! A i (heap-ref A j))
         (heap-set! A j tmp)
       "heap-exchange: tail beyond boundary"))))

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
      (if (and (<= l (heap-tail A))
               (> (heap-ref A l) (heap-ref A i)))
         (set! largest l))
      (if (and (<= r (heap-tail A))
               (> (heap-ref A r) (heap-ref A largest)))
         (set! largest r))
      (if (> (heap-ref A largest) (heap-ref A i))
         (begin
            (heap-exchange A i largest)
            (heapify-max A largest))))))

(define heap-build-max
  (lambda (A)
    (do ([i (floor (/ (heap-tail A) 2)) (- i 1)])
        ((< i 1))
      (heapify-max A i))))

(define heap-max?
  (lambda (A)
    (letrec ([max?
               (lambda (i)
                 (if (<= i (heap-tail A))
                    (if (>= (vector-ref (heap-v A) (PARENT i))
                            (vector-ref (heap-v A) i))
                       (max? (+ i 1))
                       #f)
                    #t))])
      (max? 2))))

(define heap-maximum
  (lambda (A)
    (heap-ref A 1)))

(define heap-extract-max
  (lambda (A)
    (let ([largest (heap-ref A 1)])
      (heap-exchange A 1 tail)
      (heap-tail-set! A (-tail 1))
      (heapify-max A 1)
      largest)))

(define heap-sort
  (lambda (A)
    (heap-build-max A)
    (do ([tail (heap-tail A) (- tail 1)])
        ((< tail 2))
      (heap-exchange A 1 tail)
      (heap-tail-set! A (- tail 1))
      (heapify-max A 1))
    ;; restore heap-tail
    (heap-tail-set! A (heap-capacity A))))

(define A (make-heap 100))
(heap-set-random! A 1000)
(display (heap-v A))
(display "\n")
(heap-sort A)
(display (heap-v A))
