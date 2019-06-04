
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

(define RESERVED 3)

(define-record-type heap
  (nongenerative heap-for-sort)
  (fields (mutable capacity) (mutable tail) (mutable v))
  (protocol
    (lambda (new)
      (lambda (size)
        (set! size (+ size 1))
        (new
          (+ size RESERVED)
          (- size 1)
          (if (< size 1)
             (assertion-violation
               'heap-constructor "heap need length at least 1")
             ;; index 0 not be used, index start at 1
             (let ([v (make-vector (+ size RESERVED))])
               (vector-set! v 0 'hold-empty)
               v)))))))

(define heap-ref
  (lambda (A i)
    (if (< i 1)
       (display "heap-ref: heap index start with 1")
       (vector-ref (heap-v A) i))))

(define heap-set!
  (lambda (A i value)
    (vector-set! (heap-v A) i value)))

(define heap-set-random!
  (lambda (A range)
    (do ([i 1 (+ i 1)])
        ((> i (heap-tail A)))
      (heap-set! A i (random range)))))

;; source: v1
;; source start index: i
;; destination: v2
;; destination start index: j
;; copy amount: n
(define vector-copy
  (lambda (v1 i v2 j n)
    (cond
      [(> (+ i n) (vector-length v1))
       (display "vector-copy: copy amount beyond source length\n")]
      [(> (+ j n) (vector-length v2))
       (display "vector-copy: copy amount beyond destinatin length\n")]
      [else
       (do ([i i (+ i 1)] [j j (+ j 1)] [c 0 (+ c 1)])
           ((= c n))
         (vector-set! v2 j (vector-ref v1 i)))])))

(define heap-append!
  (lambda (A value)
    (let ([next-tail (+ (heap-tail A) 1)]
          [capacity (heap-capacity A)])
      (if (= next-tail capacity)
        (let ([v (make-vector (+ capacity RESERVED))])
          (vector-copy (heap-v A) 0 v 0 capacity)
          (heap-capacity-set! A (vector-length v))
          (heap-v-set! A v)))
      (heap-tail-set! A next-tail)
      (heap-set! A next-tail value))))

(define heap-exchange!
  (lambda (A i j)
    (if (and (<= i (heap-tail A))
             (<= j (heap-tail A)))
       (let ([tmp (heap-ref A i)])
         (heap-set! A i (heap-ref A j))
         (heap-set! A j tmp))
       (display "heap-exchange!: index beyond boundary\n"))))

(define parent
  (lambda (i)
    (floor (/ i 2))))

(define left
  (lambda (i)
    (* i 2)))

(define right
  (lambda (i)
    (+ 1 (* i 2))))

(define heapify-max
  (lambda (A i)
    (let ([l (left i)] [r (right i)] [largest i])
      (if (and (<= l (heap-tail A))
               (> (heap-ref A l) (heap-ref A i)))
         (set! largest l))
      (if (and (<= r (heap-tail A))
               (> (heap-ref A r) (heap-ref A largest)))
         (set! largest r))
      (if (> (heap-ref A largest) (heap-ref A i))
         (begin
            (heap-exchange! A i largest)
            (heapify-max A largest))))))

(define heap-build-max!
  (lambda (A)
    (do ([i (floor (/ (heap-tail A) 2)) (- i 1)])
        ((< i 1))
      (heapify-max A i))))

(define heap-max?
  (lambda (A)
    (let f ([index 2])
      (if (<= i (heap-tail A))
        (if (>= (heap-ref A (parent index))
                (heap-ref A index))
          (f (+ index 1))
          #f)
        #t))))

(define heap-maximum
  (lambda (A)
    (heap-ref A 1)))

(define heap-max-extract
  (lambda (A)
    (let ([largest (heap-ref A 1)])
      (heap-exchange! A 1 tail)
      (heap-tail-set! A (- tail 1))
      (heapify-max A 1)
      largest)))

(define heap-max-insert!
  (lambda (A value)
    (heap-append! A value)
    (let ([tail (heap-tail A)])
      (do ([i tail (parent i)]
           [p (parent tail) (parent p)])
          ((or (< p 1)
               (> (heap-ref A p) (heap-ref A i))))
        (heap-exchange! A p i)))))

(define heap-sort
  (lambda (A)
    (heap-build-max! A)
    (let ([tail (heap-tail A)])
      (do ([tail tail (- tail 1)])
          ((< tail 2))
        (heap-exchange! A 1 tail)
        (heap-tail-set! A (- tail 1))
        (heapify-max A 1))
      ;; restore heap-tail
      (heap-tail-set! A tail))))

(define A (make-heap 3))
(heap-set-random! A 15)
(heap-build-max! A)
(display A)
(newline)
(heap-max-insert! A 9)
(display A)
(newline)
(heap-max-insert! A 3)
(display A)
(newline)
(heap-max-insert! A 15)
(display A)
(newline)
