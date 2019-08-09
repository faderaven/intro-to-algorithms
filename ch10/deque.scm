
(library
 (deque (1))
 (export deque? make-deque
         deque-empty? deque-size deque-ref
         deque-push-head deque-push-tail deque-pop-head deque-pop-tail)
 (import (rnrs base) (rnrs records syntactic) (rnrs control))

 (define add1
   (lambda (n)
     (+ n 1)))

 (define sub1
   (lambda (n)
     (- n 1)))

 (define reserved 2)
 (define db_reserve (* reserved 2))

 (define-record-type deque
   (nongenerative deque-data-structrue)
   (fields (mutable capacity)
           (mutable head) (mutable tail)
           (mutable v))
   (protocol
    (lambda (new)
      (case-lambda
        [(n value)
         (cond
           [(< n 0)
            (assertion-violation
             'deque
             "invalid value to initialize deque" n)]
           [(= n 0)
            (let ([v (make-vector db_reserve)])
              (new db_reserve reserved (sub1 reserved) v))]
           [else
            (let* ([capacity (+ db_reserve n)]
                   [tail (sub1 (+ reserved n))]
                   [v (make-vector capacity)])
              (do ([i reserved (add1 i)])
                ((= i (add1 tail)))
                (vector-set! v i value))
              (new capacity reserved tail v))])]
        [(n)
         (make-deque n 0)]))))

 (define deque-empty?
   (lambda (dq)
     (> (deque-head dq) (deque-tail dq))))

 (define deque-size
   (lambda (dq)
     (add1 (- (deque-tail dq) (deque-tail dq)))))

 (define deque-ref
   (lambda (dq index)
     (let ([real-index (+ (deque-head dq) index)])
       (cond
         [(> real-index (deque-tail dq))
          (error 'deque-ref "index out of range in deque" index)]
         [else
          (vector-ref (deque-v dq) real-index)]))))

 (define deque-push-head-extend
   (lambda (dq value)
     (let* ([old-cap (deque-capacity dq)]
            [v (make-vector (+ reserved old-cap))])
       (vector-set! v (sub1 reserved) value)
       (vector-copy! (deque-v dq) 0 v reserved old-cap)
       (deque-v-set! dq v)
       (deque-capacity-set! dq (+ old-cap reserved)))))

 (define deque-push-tail-extend
   (lambda (dq value)
     (let* ([old-cap (deque-capacity dq)]
            [v (make-vector (+ reserved old-cap))])
       (vector-set! v old-cap value)
       (vector-copy! (deque-v dq) 0 v 0 old-cap)
       (deque-v-set! dq v)
       (deque-capacity-set! dq (+ old-cap reserved)))))

 (define vector-copy!
   (lambda (src src-start dst dst-start n)
     (let ([bound (+ src-start n)])
       (do ([i src-start (add1 i)]
            [j dst-start (add1 j)])
         ((= i  bound))
         (vector-set! dst j (vector-ref src i))))))

 (define deque-push-head
   (lambda (dq value)
     (cond
       [(> (deque-head dq) 0)
        (deque-head-set! dq (sub1 (deque-head dq)))
        (vector-set! (deque-v dq) (deque-head dq) value)]
       [else
        (deque-push-head-extend dq value)
        (deque-head-set! dq (sub1 reserved))
        (deque-tail-set! dq (+ reserved (deque-tail dq)))])))

 (define deque-push-tail
   (lambda (dq value)
     (cond
       [(< (deque-tail dq) (sub1 (deque-capacity dq)))
        (deque-tail-set! dq (add1 (deque-tail dq)))
        (vector-set! (deque-v dq) (deque-tail dq) value)]
       [else
        (deque-push-tail-extend dq value)
        (deque-tail-set! dq (add1 (deque-tail dq)))])))

 (define deque-pop-head
   (lambda (dq)
     (cond
       [(deque-empty? dq)
        (error 'deque-pop-head "empty deque")]
       [else
        (let* ([index (deque-head dq)]
               [head (vector-ref (deque-v dq) index)])
          (vector-set! (deque-v dq) index 0)
          (deque-head-set! dq (add1 index))
          head)])))

 (define deque-pop-tail
   (lambda (dq)
     (cond
       [(deque-empty? dq)
        (error 'deque-tail "empty deque")]
       [else
        (let* ([index (deque-tail dq)]
               [tail (vector-ref (deque-v dq) index)])
          (vector-set! (deque-v dq) index 0)
          (deque-tail-set! dq (sub1 index))
          tail)])))
 )
