
; (Red-Black-Tree-Operations
;  insert
;  delete
;  search
;  rank
;  order)

(define-record-type node
  (nongenerative node)
  (fields
   ;;(mutable data node.data node.data!)
   (immutable key node.key)
   (mutable color node.color node.color!)
   (mutable left node.left node.left!)
   (mutable right node.right node.right!)
   (mutable parent node.parent node.parent!))
  (protocol
   (lambda (new)
     (case-lambda
       [(key left right color parent)
        (new key left right color parent)]
       [(key)
        (new key 'red #f #f #f)]))))

(define-record-type RB-tree
  (nongenerative RB-tree)
  (fields (mutable root RB.root RB.root!))
  (protocol
   (lambda (new)
     (case-lambda
       [(x)
        (new x)]
       [()
        (new #f)]))))

(define walk-in
  (lambda (root x)
    (cond
      [(<= (node.key x) (node.key root))
       (if (eq? (node.left root) #f)
           (list root 'left)
           (walk-in (node.left root) x))]
      [else
       (if (eq? (node.right root) #f)
           (list root 'right)
           (walk-in (node.right root) x))])))

(define RB-tree-insert
  (lambda (T x)  ;; x is node type
    (cond
      [(eq? (RB.root T) #f)
       (node.color! x 'black)
       (RB.root! T x)]
      [else
       (let* ([ret (walk-in (RB.root T) x)]
              [parent (car ret)]
              [branch (cadr ret)])
         (cond
           [(eq? branch 'left)
            (node.left! parent x)
            (node.parent! x parent)]
           [else
            (node.right! parent x)
            (node.parent! x parent)]))
       (insert-fixup T x)])))

(define right-rotate
  (lambda (g)
    (let ([p (node.left g)]
          [s (node.right (node.left g))]
          [gp (node.parent g)])
      (when (and (node? gp) (node.left? g))
        (node.left! gp p)
        (node.right! gp p))
      (node.parent! p gp)
      (node.left! g s)
      (when (node? s)
        (node.parent! s g))
      (node.right! p g)
      (node.parent! g p))))

(define left-rotate
  (lambda (g)
    (let ([p (node.right g)]
          [s (node.left (node.right g))]
          [gp (node.parent g)])
      (when (and (node? gp) (node.left? g))
        (node.left! gp p)
        (node.right! gp p))
      (node.parent! p gp)
      (node.right! g s)
      (when (node? s)
        (node.parent! s g))
      (node.left! p g)
      (node.parent! g p))))

(define node.red?
  (lambda (x)
    (if (and (node? x)
             (eq? (node.color x) 'red))
        #t
        #f)))

(define node.black?
  (lambda (x)
    (if (and (node? x)
             (eq? (node.color x) 'black))
        #t
        #f)))

(define node.left?
  (lambda (x)
    (if (and (node? x)
             (eq? (node.left (node.parent x)) x))
        #t
        #f)))

(define node.right?
  (lambda (x)
    (if (and (node? x)
             (eq? (node.right (node.parent x)) x))
        #t
        #f)))

(define insert-fixup
  (lambda (T x)
    (let* ([p (node.parent x)]
           [g (if (eq? p #f)
                  #f
                  (node.parent p))])
      (cond
        [(eq? p #f)
         (RB.root! T x)
         (node.color! (RB.root T) 'black)]
        [(node.black? p)
         (when (eq? g #f)
           (RB.root! T p))
         (node.color! (RB.root T) 'black)]
        [else
         (cond
           [(node.left? p)
            (let ([k (node.right g)])
              (cond
                [(node.red? k)
                 (node.color! p 'black)
                 (node.color! g 'red)
                 (node.color! k 'black)
                 (insert-fixup T g)]
                [(node.right? x)
                 (left-rotate p)
                 (insert-fixup T p)]
                [else
                 (node.color! p 'black)
                 (node.color! g 'red)
                 (right-rotate g)
                 (insert-fixup T x)]))]
           [else
            (let ([k (node.left g)])
              (cond
                [(node.red? k)
                 (node.color! p 'black)
                 (node.color! g 'red)
                 (node.color! k 'black)
                 (insert-fixup T g)]
                [(node.left? x)
                 (right-rotate p)
                 (insert-fixup T p)]
                [else
                 (node.color! p 'black)
                 (node.color! g 'red)
                 (left-rotate g)
                 (insert-fixup T x)]))])]))))

(define RB-tree-search
  (lambda (root key)
    (cond
      [(eq? root #f)
       #f]
      [(< key (node.key root))
       (RB-tree-search (node.left root) key)]
      [(> key (node.key root))
       (RB-tree-search (node.right root) key)]
      [else
       root])))

(define tree-minimum
  (lambda (x)
    (cond
      [(eq? #f (node.left x))
       x]
      [else
       (tree-minimum (nede.left x))])))

(define transplant
  (lambda (x c)
    (let ([p (node.parent x)])
      (when (node? p)
        (if (eq? x (node.left p))
            (node.left! p c)
            (node.right! p c)))
      (when (node? c)
        (node.parent! c p))
      (if (eq? c (node.left x));;
          (node.left! x #f)    ;;
          (node.right! x #f))  ;; clean
      (node.parent! x #f))))   ;;

(define delete
  (lambda (T x)
    (let ([x-origin-color (node.color x)]
          [y #f])
      (cond
        [(eq? #f (node.left x))
         (set! y (node.right x))
         (transplant x y)]
        [(eq? #f (node.right x))
         (set! y (node.left x))
         (transplant x y)]
        [else
         (let ([z (tree-minimum (node.right x))])
           (cond
             [(eq? z (node.right x))
              (set! y z)]
             [else
              (set! x-origin-color (node.color z))
              (set! y (node.right z))
              (transplant z y)
              (node.right! z (node.right x))
              (node.parent! (node.right x) z)
              (node.right! x z)
              (node.parent! z x)])
           (node.left! z (node.left x))
           (node.parent! (node.left z) z)
           (node.left! x #f)  ;; clean
           (transplant x y))])
      (when (eq? 'black x-origin-color)
        (delete-fixup T y)))))

(define delete-fixup
  (lambda (T x)
    (cond
      [(or (eq? x (RB.root T))
           (node.red? x))
       (node.black! x)]
      [(node.left? x)
       (let* ([p (node.parent x)]
              [s (node.right p)]
              [nc (node.left s)]
              [nw (node.right s)])
         (when (node.red? s)
           (right-rotate p)
           (node.black! s)
           (node.red! p)
           (set! s (node.right (node.parent x))))
         (cond
           [(and (node.black? nc) (node.black? nw))
            (node.red! s)
            (delete-fixup T p)]
           [(node.black? nw)
            (node.red! s)
            (node.black! nc)
            (right-rotate s)
            (delete-fixup T x)]
           [else
            (node.color! s (node.color p))
            (node.black! p)
            (left-rotate p)]))])))


(define A (make-RB-tree))
(define n1 (make-node 1))
(define n2 (make-node 2))
(define n3 (make-node 3))
(define n4 (make-node 4))
(define n5 (make-node 5))
(define n6 (make-node 6))
(define n7 (make-node 7))
(RB-tree-insert A n5)
(RB-tree-insert A n3)
(RB-tree-insert A n4)
(RB-tree-insert A n7)
(RB-tree-insert A n1)