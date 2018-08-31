;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex305) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

;; LOU is [List-of Number]
;; LOE is [List-of Number]

;; LOF is [List-of Number]
;; LOC is [List-of Number]

;; A Pair is [List-of Number]

(define RATE 1.06)
(define LOU1
  '(1.00 3.20 5.99 10.50))
(define LOF1
  '(-72 0 32.5 112.9))
(define LOP1
  (list (make-posn 43 89)
        (make-posn 12 14)
        (make-posn 80 50)))
  

;; LOU -> LOE
;; converts a list of US$ amounts to € amounts
(check-expect (convert-euro '()) '())
(check-expect (convert-euro LOU1)
              `(,(* 1.00  RATE)
                ,(* 3.20  RATE)
                ,(* 5.99  RATE)
                ,(* 10.50 RATE)))

(define (convert-euro l)
  (for/list ([item l])
    (* item RATE)))

;; LOF -> LOC
;; converts a list of fahrenheit measurements to celsius
(check-expect (convertFC '()) '())
(check-within (convertFC LOF1)
              '(-57.7 -17.7 0.27 44.94)
              0.1)

(define (convertFC l)
  (local (;; Number -> Number
          (define (fahrenheit->celsius n)
            (* 5/9 (- n 32))))
    (map fahrenheit->celsius l)))

;; [List-of Posn] -> [List-of Pair]
;; translates lop into a list of lists of pair of numbers
(check-expect (translate '()) '())
(check-expect (translate LOP1)
              '((43 89) (12 14) (80 50)))

(define (translate l)
  (local (;; Posn -> [List-of Number]
          (define (posn->pair p)
            (list (posn-x p) (posn-y p))))
    (map posn->pair l)))
