;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex455) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define EPS 0.0001)

(define (f1 x) 5)

(define (f2 x) (* 5 x))

(define (f3 x) (+ (* 5 (sqr x)) (* 6 x) 5))

;; [Number -> Number] Number -> Number
;; slope function
(check-within (slope f1 2) 0  EPS)
(check-within (slope f2 2) 5  EPS)
(check-within (slope f3 2) 26 EPS)

(define (slope f r1)
  (* (/ 1 (* 2 EPS))
     (- (f (+ r1 EPS))
        (f (- r1 EPS)))))
