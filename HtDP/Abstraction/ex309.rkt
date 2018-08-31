;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex309) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

;; [List-of [List-of String]] -> [List-of Number]
;; produces a list of the number of strings per item in lls

(define input  '(("I" "can" "see" "clearly" "now")
                 ("The" "rain" "has" "gone")
                 ("I" "can" "see" "all" "the" "obstacles")
                 ("In" "my" "way")))
(define expect '(5 4 6 3))

(check-expect (words-on-line input) expect)

(define (words-on-line lls)
  (match lls
    ['()        '()]
    [(cons s l) (cons (length s)
                      (words-on-line l))]))
