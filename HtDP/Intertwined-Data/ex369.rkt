;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex369) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; An [Or X Y] is one of:
;; - X
;; - Y

(define a0 '())
(define a1 '((initial "X")))
(define a2 '((from "seen-e") (to "seen-f")))

;; [List-of Attribute] Symbol -> [Or String false]
;; produces the associated string with sy if sy exists in la
;; produces #false otherwise
(check-expect (find-attr a0 'initial) #false)
(check-expect (find-attr a1 'from)    #false)
(check-expect (find-attr a1 'initial) "X")
(check-expect (find-attr a2 'from)    "seen-e")

(define (find-attr la sy)
  (local ((define found (assq sy la)))
    (if (false? found) #false (second found))))