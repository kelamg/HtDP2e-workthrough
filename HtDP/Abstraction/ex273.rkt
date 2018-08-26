;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex273) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [X Y] [X -> Y] [List-of X] -> [List-of Y]
;; produces a new list with fn applied to all items of l
(check-expect
 (fold-map add1 '(3 5 7)) '(4 6 8))

(define (fold-map fn l)
  (local (; X X -> Y
          ; applies fn both arguments
          (define (combine x xn)
            (cons (fn x) xn)))
    (foldr combine '() l)))
