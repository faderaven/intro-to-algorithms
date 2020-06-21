
(import (random-lotto))

(define UNDF 'undefine)

(define-record-type
  (node node node?)
  (nongenerative node)
  (fields [mutable keys n.keys n.keys!]
          [mutable keysum n.keysum n.keysum!]
          [mutable downs n.downs n.downs!]
          [mutable layer n.layer n.layer!])
  (protocol
   (lambda (new)
     (case-lambda
       [(key down1 down2)
        (new (cons key '()) 1 (list down1 down2) 0)]
       [()
        (new '() 0 (list UNDF) 0)]))))


;; return void
(define node-insert
  (case-lambda

    [(n@ key down)
     (letrec
         ;; ks: keys, ds: downs, co: collection
         ([F (lambda (ks ds co)
               (cond
                 [(or (null? ks) (< key (car ks)))
                  (co (cons key ks)
                      (cons (car ds) (cons down (cdr ds))))]
                 [(= key (car ks))
                  (error 'node-insert
                         (format "key ~a already exists" key))]
                 [else
                  (F (cdr ks) (cdr ds)
                     (lambda (x y)
                       (co (cons (car ks) x)
                           (cons (car ds) y))))]))]
          [G (lambda (keys downs)
               (n.keys! n@ keys)
               (n.downs! n@ downs)
               (n.keysum! n@ (add1 (n.keysum n@))))])
       (F (n.keys n@) (n.downs n@) G))]

    [(n@ key)
     (node-insert n@ key UNDF)]))


(define-record-type
  (Btree Btree Btree?)
  (nongenerative Btree)
  (fields [mutable root B.root B.root!]
          [immutable lower B.lower]
          [immutable upper B.upper]
          [immutable height B.height])
  (protocol
   (lambda (new)
     (case-lambda
       [(n@ lower height)
        (new n@ lower (* 2 lower) height)]
       [(lower height)
        (new (node) lower (* 2 lower) height)]))))


;; return '(node index)
;; the node where the key is located, the index of the key in the node
;; if not exist, return 'nonexist
(define Btree-search
  (lambda (B key)
    (letrec
        ([S (lambda (n@)
              (F (n.keys n@) (n.downs n@) 0))]
         [F (lambda (ks ds i)
              (cond
                [(or (null? ks) (< key (car ks)))
                 (if (eq? UNDF (car ds))
                     'nonexist
                     (S (car ds)))]
                [(= key (car ks))
                 (list n@ i)]
                [else
                 (F (cdr ks) (cdr ds) (add1 i))]))])
      (S (B.root B)))))


;; if keysum of the node more than upper, return #t
;; else, return #f
(define Btree-upper?
  (lambda (B n@)
    (if (> (n.keysum n@) (B.upper B))
        #t
        #f)))


(define Btree-split
  (lambda (B n@s)
    (let ([n@ (car n@s)])

      (when (Btree-upper? B n@)
        (let* ([brk (floor (/ (n.keysum n@) 2))]
               [tail (list-tail (n.keys n@) brk)]
               [down (node)])
          
          (n.keys! down (cdr tail))
          (n.downs! down (list-tail (n.downs n@) (add1 brk)))
          (n.keysum! down (- (n.keysum n@) brk 1))
          (n.layer! down (n.layer n@))

          (n.keys! n@ (list-head (n.keys n@) brk))
          (n.downs! n@ (list-head (n.downs n@) (add1 brk)))
          (n.keysum! n@ brk)

          (cond
            [(null? (cdr n@s))
             (let ([root (node (car tail) n@ down)])
               (B.root! B root)
               (n.layer! root (add1 (n.layer n@))))]
            [else
             (node-insert (cadr n@s) (car tail) down)
             (Btree-split B (cdr n@s))]))))))


(define Btree-full?
  (lambda (B n@s)
    (if (null? n@s)
        #f
        (let ([n@ (car n@s)])
          (cond
            [(< (n.keysum n@) (B.upper B))
             #f]
            [(and (= (n.layer n@) (B.height B))
                  (= (n.keysum n@) (B.upper B)))
             #t]
            [else
             (Btree-full? B (cdr n@s))])))))


(define Btree-insert
  (lambda (B key)
    (let ([n@s '()])
      (letrec
          ([S (lambda (n@)
                (set! n@s (cons n@ n@s))
                (F (n.keys n@) (n.downs n@)))]
           [F (lambda (ks ds)
                (cond
                  [(or (null? ks) (< key (car ks)))
                   (cond
                     [(and (eq? UNDF (car ds))
                           (Btree-full? B n@s))
                      (error 'Btree-insert
                             "the current path is full, " key)]
                     [(eq? UNDF (car ds))
                      (node-insert (car n@s) key)
                      (Btree-split B n@s)]
                     [else
                      (S (car ds))])]
                  [(= key (car ks))
                   (error 'Btree-insert
                          (format "key ~a already exists" key))]
                  [else
                   (F (cdr ks) (cdr ds))]))])
        (S (B.root B))))))


(define list-replace
  (lambda (li i a)
    (letrec
        ([F (lambda (Li I)
              (cond
                [(null? Li)
                 (error 'list-replace
                        (format "index ~a out of range for list ~a" i li))]
                [(= 0 I)
                 (cons a (cdr Li))]
                [else
                 (cons (car Li) (F (cdr Li) (sub1 I)))]))])
      (F li i))))


(define list-remove
  (lambda (li i)
    (letrec
        ([F (lambda (Li I)
              (cond
                [(null? Li)
                 (error 'list-remove
                        (format "index ~a out of range for list ~a" i li))]
                [(= 0 I) (cdr Li)]
                [else
                 (cons (car Li) (F (cdr Li) (sub1 I)))]))])
      (F li i))))


(define list-connect
  (lambda (l1 l2)
    (letrec
        ([F (lambda (l)
              (cond
                [(null? l) l2]
                [else
                 (cons (car l) (F (cdr l)))]))])
      (F l1))))


(define merge-pre
  (lambda (n@ i)
    (let ([key (list-ref (n.keys n@) (sub1 i))]
          [pre (list-ref (n.downs n@) (sub1 i))]
          [mid (list-ref (n.downs n@) i)])
      
      (n.keys! n@ (list-remove (n.keys n@) (sub1 i)))
      (n.downs! n@ (list-remove (n.downs n@) i))
      (n.keysum! n@ (sub1 (n.keysum n@)))
      
      (n.keys! pre (list-connect (n.keys pre)
                                 (cons key (n.keys mid))))
      (n.downs! pre (list-connect (n.downs pre) (n.downs mid)))
      (n.keysum! pre (+ (n.keysum pre) 1 (n.keysum mid))))))


(define merge-nex
  (lambda (n@ i)
    (let ([key (list-ref (n.keys n@) i)]
          [mid (list-ref (n.downs n@) i)]
          [nex (list-ref (n.downs n@) (add1 i))])

      (n.keys! n@ (list-remove (n.keys n@) i))
      (n.downs! n@ (list-remove (n.downs n@) i))
      (n.keysum! n@ (sub1 (n.keysum n@)))

      (n.keys! nex (list-connect (n.keys mid)
                                 (cons key (n.keys nex))))
      (n.downs! nex (list-connect (n.downs mid) (n.downs nex)))
      (n.keysum! nex (+ (n.keysum mid) 1 (n.keysum nex))))))



(define pre-share
  (lambda (n@ i)
    (let* ([key (list-ref (n.keys n@) (sub1 i))]
           [pre (list-ref (n.downs n@) (sub1 i))]
           [mid (list-ref (n.downs n@) i)]
           [brk (floor (/ (n.keysum pre) 2))]
           [tail (list-tail (n.keys pre) brk)])

      (n.keys! n@ (list-replace (n.keys n@) (sub1 i) (car tail)))

      (n.keys! mid (list-connect (cdr tail) (list key)))
      (n.downs! mid (list-connect (list-tail (n.downs pre) (add1 brk))
                                  (n.downs mid)))
      (n.keysum! mid (- (n.keysum pre) brk))

      (n.keys! pre (list-head (n.keys pre) brk))
      (n.downs! pre (list-head (n.downs pre) (add1 brk)))
      (n.keysum! pre brk))))


(define nex-share
  (lambda (n@ i)
    (let* ([key (list-ref (n.keys n@) i)]
           [mid (list-ref (n.downs n@) i)]
           [nex (list-ref (n.downs n@) (add1 i))]
           [brk (floor (/ (n.keysum nex) 2))]
           [tail (list-tail (n.keys nex) brk)])

      (n.keys! n@ (list-replace (n.keys n@) i (car tail)))

      (n.keys! mid (list-connect (list key)
                                 (list-head (n.keys nex) brk)))
      (n.downs! mid (list-connect (n.downs mid)
                                  (list-head (n.downs nex) (add1 brk))))
      (n.keysum! mid (add1 brk))

      (n.keys! nex (cdr tail))
      (n.downs! nex (list-tail (n.downs nex) (add1 brk)))
      (n.keysum! nex (- (n.keysum nex) (n.keysum mid))))))


(define compact
  (lambda (B n@s inx)
    (when (not (null? n@s))
      (let ([n@ (car n@s)]
            [i  (car inx)]
            [pre.keysum 0]
            [mid.keysum (n.keysum (list-ref (n.downs (car n@s)) (car inx)))]
            [nex.keysum 0])
        (when (> i 0)
          (set! pre.keysum (n.keysum (list-ref (n.downs n@) (sub1 i)))))
        (when (< i (n.keysum n@))
          (set! nex.keysum (n.keysum (list-ref (n.downs n@) (add1 i)))))

        (cond
          [(and (not (= 0 pre.keysum))
                (<= pre.keysum nex.keysum)
                (<= (+ pre.keysum 1 mid.keysum) (B.lower B)))
           (merge-pre n@ i)
           (compact B (cdr n@s) (cdr inx))]
          [(and (not (= 0 nex.keysum))
                (< nex.keysum pre.keysum)
                (<= (+ mid.keysum 1 nex.keysum) (B.lower B)))
           (merge-nex n@ i)
           (compact B (cdr n@s) (cdr inx))]
          [(= 0 mid.keysum)
           (if (>= pre.keysum nex.keysum)
               (begin
                 (pre-share n@ i))
               (begin
                 (nex-share n@ i)))])))))


(define Btree-delete
  (lambda (B key)
    (let ([n@s '()] [inx '()])
      (letrec
          ([R (lambda (n@)
                (letrec
                    ([F (lambda (ks ds i)
                          (cond
                            [(or (null? ks) (< key (car ks)))
                             (if (eq? UNDF (car ds))
                                 (error 'Btree-delete
                                        (format "key ~a doesn't exist" key))
                                 (begin
                                   (set! n@s (cons n@ n@s))
                                   (set! inx (cons i  inx))
                                   (R (car ds))))]
                            [(= key (car ks))
                             (if (eq? UNDF (car ds))
                                 (begin
                                   (n.keys! n@ (list-remove (n.keys n@) i))
                                   (n.downs! n@ (cdr (n.downs n@)))
                                   (n.keysum! n@ (sub1 (n.keysum n@))))
                                 (begin
                                   (set! n@s (cons n@ n@s))
                                   (set! inx (cons (add1 i) inx))
                                   (n.keys! n@
                                            (list-replace (n.keys n@)
                                                          i (G (cadr ds))))))
                             (compact B n@s inx)
                             (let ([root (B.root B)])
                               (when (and (= 0 (n.keysum root))
                                          (node? (car (n.downs root))))
                                 (B.root! (car (n.downs root)))))]
                            [else
                             (F (cdr ks) (cdr ds) (add1 i))]))])
                  (F (n.keys n@) (n.downs n@) 0)))]
           [G (lambda (n@)
                (let ([ks (n.keys n@)]
                      [ds (n.downs n@)])
                  (cond
                    [(eq? UNDF (car ds))
                     (let ([x (car ks)])
                       (n.keys! n@ (cdr ks))
                       (n.downs! n@ (cdr ds))
                       (n.keysum! n@ (sub1 (n.keysum n@)))
                       x)]
                    [else
                     (set! n@s (cons n@ n@s))
                     (set! inx (cons 0  inx))
                     (G (car ds))])))])
        (R (B.root B))))))


(define Btree-print
  (lambda (B)
    (letrec
        ([P (lambda (n@ tier)
              (G tier)
              (printf "~a ~a ~a\n" (n.keys n@) (n.layer n@) (n.keysum n@))
              (F (n.downs n@) tier))]
         [F (lambda (ds tier)
              (cond
                [(or (null? ds) (eq? UNDF (car ds)))
                 (void)]
                [else
                 (P (car ds) (add1 tier))
                 (F (cdr ds) tier)]))]
         [G (lambda (tier)
              (cond
                [(= 0 tier)
                 (void)]
                [else
                 (printf "  ")
                 (G (sub1 tier))]))])
      (P (B.root B) 0))))


(define A (Btree (node) 3 2))
(bound! 100)

(define insert
  (case-lambda
    [(key)
     (Btree-insert A key)
     (Btree-print A)]
    [()
     (Btree-insert A (lotto))
     (Btree-print A)]))

(define delete
  (lambda (key)
    (Btree-delete A key)
    (Btree-print A)))

(define init
  (lambda (n)
    (when (> n 0)
      (insert)
      (init (sub1 n)))))