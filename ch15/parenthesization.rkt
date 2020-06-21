#lang racket

(define factorial
  (lambda (n k)
    (cond
      [(= 1 k) n]
      [else
       (* n (factorial (- n 1) (- k 1)))])))
    
(define combination
  (lambda (n k)
    (if (= 0 k)
        1
        (/ (factorial n k)
           (factorial k k)))))

(define 2-pow
  (lambda (n)
    (cond
      [(= 0 n) 1]
      [else
       (* 2 (2-pow (- n 1)))])))

(define add-lat
  (lambda (lat)
    (cond
      [(eq? lat '()) 0]
      [else
       (+ (car lat) (add-lat (cdr lat)))])))

(define combine-case
  (lambda (origin replace)
    (+ (combination (- origin 2) (- replace 2))
       (* 2 (combination (- origin 2) (- replace 1))))))

(define get-last
  (lambda (lat)
    (cond
      [(eq? (cdr lat) '()) (car lat)]
      [else (get-last (cdr lat))])))

(define parentheses-help
  (lambda (n)
    (let ([one (2-pow (- n 2))]
          [more '()]
          [end (ceiling (/ n 2))])
      (set! more (cons one more))
      (do ([origin (- n 2) (- origin 1)]
           [replace 2 (+ replace 1)])
        ((= origin end))
        (set! more (cons (* (combine-case origin replace)
                            (2-pow (- origin 2)))
                         more)))
      (set! more (cons (* (combination end (- n end))
                          (get-last (parentheses end)))
                       more))
      (set! more (cons (add-lat more) more))
      (reverse more))))

(define parentheses
  (lambda (n)
    (cond
      [(= 2 n) '(1)]
      [(= 3 n) '(2)]
      [else
       (parentheses-help n)])))

(define parenth
  (lambda (n)
    (cond
      [(= 1 n) 1]
      [else
       (let ([sum 0])
         (do ([i 1 (+ i 1)])
           ((= i n) sum)
           (set! sum (+ sum
                        (* (parenth i) (parenth (- n i)))))))])))

(map parentheses '(2 3 4 5 6 7 8 9 10))
(map parenth '(2 3 4 5 6 7 8 9 10))