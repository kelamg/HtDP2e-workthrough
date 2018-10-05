;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex506) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [X -> Y] [List-of X] -> [List-of Y]
;; accumulator style version of map
(check-expect (acc-map add1 '()) '())
(check-expect (acc-map add1 '(0 2 4)) '(1 3 5))
(check-expect (acc-map string-upcase '("we" "want" "the" "funk"))
              '("WE" "WANT" "THE" "FUNK"))

(define (acc-map fn l)
  (local (; [List-of X] -> [List-of Y]
          ; accumulator a is the processed list from
          ; l to l0
          (define (acc-map/a l0 a)
            (cond
              [(empty? l0) (reverse a)]
              [else (acc-map/a (rest l0)
                               (cons (fn (first l0)) a))])))

    (acc-map/a l '())))
