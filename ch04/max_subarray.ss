
(define transform-array
  (lambda (v)
    (let* ([len (vector-length v)] [trans (make-vector (- len 1) 0)])
      (cond
        [(< len 2)
           (assertion-violation 'transform-array "length at least 2")]
        [else
          (do ([i 0 (+ i 1)])
            ((= i (- len 1)) trans)
            (vector-set! trans i
              (- (vector-ref v (+ i 1)) (vector-ref v i))))]))))


(define find-max-crossing-subarray
  (lambda (v left mid right)
    (let ([start mid] [end (+ mid 1)]
          [sum-left (vector-ref v mid)]
          [sum-right (vector-ref v (+ mid 1))])
      (do ([i mid (- i 1)] [sum 0])
        ((< i left))
        (set! sum (+ sum (vector-ref v i)))
        (when (> sum sum-left)
          (set! sum-left sum)
          (set! start i)))
      (do ([j (+ mid 1) (+ j 1)] [sum 0])
        ((> j right))
        (set! sum (+ sum (vector-ref v j)))
        (when (> sum sum-right)
          (set! sum-right sum)
          (set! end j)))
        (list start end (+ sum-left sum-right)))))


(define find-max-subarray
  (lambda (v)
    (let f ([left 0] [right (- (vector-length v) 1)])
      (let ([mid (floor (/ (+ left right) 2))]
            [max-left #f] [max-right #f] [max-crossing #f])
        (cond
          [(= left right) (list left right (vector-ref v left))]
          [else
            (set! max-left (f left mid))
            (set! max-right (f (+ mid 1) right))
            (set! max-crossing
              (find-max-crossing-subarray v left mid right))
            ;(display max-left) (newline)
            ;(display max-right) (newline)
            ;(display max-crossing) (newline)
            (cond
              [(and (>= (caddr max-left) (caddr max-right))
                    (>= (caddr max-left) (caddr max-crossing)))
               max-left]
              [(and (>= (caddr max-right) (caddr max-left))
                    (>= (caddr max-right) (caddr max-crossing)))
               max-right]
              [else max-crossing])])))))


(define find-max-subarray-linear
  (lambda (v)
    (let ([low 0] [high 0] [sum (vector-ref v 0)])
      (do ([i 0 (+ i 1)] [tmp-sum 0])
        ((= i (vector-length v)))
        (set! tmp-sum
          (max (+ tmp-sum (vector-ref v i))
                          (vector-ref v i)))
        (when (= (vector-ref v i) tmp-sum)
          (set! low i))
        (when (> tmp-sum sum)
          (set! sum tmp-sum)
          (set! high i)))
      (when (> low high)
        (set! low high))
      (list low high sum))))


(define char-list->number
  (lambda (ls)
    (string->number
      (list->string
        (reverse ls)))))

(define read-string-data
  (lambda (filename)
    (let ([p (open-file-input-port filename
               (file-options no-create) (buffer-mode block)
               (make-transcoder (utf-8-codec) (eol-style lf)))]
          [word '()] [data '()])
      (do ([c (get-char p) (get-char p)])
        ((port-eof? p))
        (cond
          [(and (char-whitespace? c) (not (null? word)))
             (set! data (cons (char-list->number word) data))
             (set! word '())]
          [(not (char-whitespace? c))
            (set! word (cons c word))]))
      (close-port p)
      (when (not (null? word))
        (set! data (cons (char-list->number word) data)))
      (find-max-subarray-linear (list->vector (reverse data))))))
