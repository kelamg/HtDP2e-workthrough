;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex73) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; posn-up-x

;; Posn Number -> Posn
;; produces a posn with n in the x field
(check-expect (posn-up-x (make-posn 3 4)     5) (make-posn   5  4))
(check-expect (posn-up-x (make-posn 42 93) 183) (make-posn 183 93))

(define (posn-up-x p n)
  (make-posn n (posn-y p)))