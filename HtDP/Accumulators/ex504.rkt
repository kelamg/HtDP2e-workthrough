;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex504) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [List-of N] -> N
;; produces the corresponding number from the list of digits l
(check-expect (to10 '()) 0)
(check-expect (to10 '(1 0 2)) 102)

(define (to10 l)
  (local (; [List-of N] N -> N
          ; accumulator a is the corresponding number
          ; of l so far
          (define (to10/a l0 a)
            (cond
              [(empty? l0) a]
              [else (to10/a (rest l0)
                            (+ (first l0) (* 10 a)))])))

    (to10/a l 0)))