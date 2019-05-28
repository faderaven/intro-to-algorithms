(define ppi
  (case-lambda
    [(dot_pitch)
     (let* ([inpm 0.0393701] [w_in (* dot_pitch inpm)])
       (/ 1 w_in))]
    [(resolution size)
     (let* ([pow_w (* (car resolution) (car resolution))]
            [pow_h (* (cadr resolution) (cadr resolution))]
            [diagonal_pixels (sqrt (+ pow_w pow_h))])
       (/ diagonal_pixels size))]))
