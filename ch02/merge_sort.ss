
(define RMIN #x-80000000)
(define RMAX #x7FFFFFFF)


(define make-random-numbers-file
  (lambda (filename n)
    (let ([p (open-file-output-port filename
               (file-options no-fail))]
          [v (make-bytevector 4 0)])
      (let f ([n n])
        (when (not (zero? n))
          (bytevector-s32-native-set! v 0
            (new-random RMIN RMAX))
          (put-bytevector p v)
          (f (- n 1))))
      (close-port p))))


(define new-random
  (lambda (rmin rmax)
    (+ (random (- rmax rmin)) rmin)))


(define look-random-numbers-file
  (lambda (filename pos n)
    (let ([p (open-file-input-port filename)])
      (set-port-position! p (* pos 4))
      (let f ([i n] [v (get-bytevector-n p 4)])
        (cond
          [(zero? i)
            (display 'current-position:)
            (display (+ pos n))]
          [(eof-object? v) (display 'it-is-end-of-file)]
          [else
            (display (bytevector-s32-native-ref v 0))
            (newline)
            (f (- i 1) (get-bytevector-n p 4))]))
      (close-port p))))


(define file-size
  (lambda (filename)
    (let ([count 0] [p (open-file-input-port filename)])
      (let f ([n 0] [u8 (get-u8 p)])
        (if (eof-object? u8)
          (set! count n)
          (f (+ n 1) (get-u8 p))))
      (close-port p)
      count)))


(define insertion-sort
  (lambda (v)
    (let f ([k 1])
      (cond
        [(= k (vector-length v)) v]
        [else
          (set! key (vector-ref v k))
          (do ([i (- k 1) (- i 1)])
            ((or (< i 0) (< (vector-ref v i) key))
               (vector-set! v (+ i 1) key))
            (vector-set! v (+ i 1) (vector-ref v i)))
          (f (+ k 1))]))))


(define vector-copy
  (lambda (v start n)
    (let ([v-copy (make-vector n 0)])
      (do ([i 0 (+ i 1)] [start start (+ start 1)] [n n (- n 1)])
        ((or (= (vector-length v) start) (zero? n)) v-copy)
        (vector-set! v-copy i (vector-ref v start))))))


(define merge-sort
  (lambda (v)
    (let f ([left 0] [right (- (vector-length v) 1)]
            [mid #f] [vl #f] [vr #f])

      (when (< left right)
        (set! mid (floor (/ (+ left right) 2)))

        (f left mid #f #f #f)
        (f (+ mid 1) right #f #f #f)

        (set! vl (vector-copy v left (+ (- mid left) 1)))
        (set! vr (vector-copy v (+ mid 1) (- right mid)))

        (do ([i 0] [j 0] [k left (+ k 1)])
          ((and (= (vector-length vl) i) (= (vector-length vr) j)))
          (cond
            [(= (vector-length vl) i)
               (vector-set! v k (vector-ref vr j))
               (set! j (+ j 1))]
            [(= (vector-length vr) j)
               (vector-set! v k (vector-ref vl i))
               (set! i (+ i 1))]
            [else
              (cond
                [(< (vector-ref vl i) (vector-ref vr j))
                  (vector-set! v k (vector-ref vl i))
                  (set! i (+ i 1))]
                [else
                  (vector-set! v k (vector-ref vr j))
                  (set! j (+ j 1))])]))))
    v))


(define quick-sort
  (lambda (v)
    (let f ([left 0] [right (- (vector-length v) 1)])
      (let ([mid (floor (/ (+ left right) 2))]
            [last left])
        (when (< left right)
          (vector-swap v left mid)
          (do ([i (+ left 1) (+ i 1)])
            ((> i right))
            (when (< (vector-ref v i) (vector-ref v left))
              (set! last (+ last 1))
              (vector-swap v i last)))
          (vector-swap v left last)
          (f left (- last 1))
          (f (+ last 1) right))))
    v))


(define vector-swap
  (lambda (v i j)
    (let ([tmp (vector-ref v i)])
      (vector-set! v i (vector-ref v j))
      (vector-set! v j tmp))))


(define sort-random-numbers-file
  (lambda (sort input-file output-file)

    (let ([ip (open-file-input-port input-file)]
          [op (open-file-output-port output-file
                (file-options no-fail))]
          [len (/ (file-size input-file) 4)]
          [bv32 (make-bytevector 4 0)])
      (set! v (make-vector len 0))

      ;; read random numbers
      (let f ([i 0] [bv32 (get-bytevector-n ip 4)])
        (when (not (eof-object? bv32))
          (vector-set! v i (bytevector-s32-native-ref bv32 0))
          (f (+ i 1) (get-bytevector-n ip 4))))
      (close-port ip)

      ;; sort random numbers
      (set! v (sort v))

      ;; write random numbers
      (let g ([i 0])
        (when (not (= i len))
          (bytevector-s32-native-set! bv32 0 (vector-ref v i))
          (put-bytevector op bv32)
          (g (+ i 1))))
      (close-port op))))


(define run-test
  (lambda ()
    (make-random-numbers-file "test" (* 1024 1024))
    (sort-random-numbers-file merge-sort "test" "out-test")
    (look-random-numbers-file "out-test" (* 512 1024) (* 512 1024))))
(run-test)
;; takes about 4 seconds
