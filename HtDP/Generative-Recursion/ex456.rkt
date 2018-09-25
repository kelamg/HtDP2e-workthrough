;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex456) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define EPS 0.0001)

(define (f1 x) 5)

(define (f2 x) (* 5 x))

(define (f3 x) (+ (* 5 (sqr x)) 5))

; Number -> Number
(define (poly x) (* (- x 2) (- x 4)))

;; [Number -> Number] Number -> Number
;; slope of f at r1
(check-within (slope f1 2) 0  EPS)
(check-within (slope f2 2) 5  EPS)
(check-within (slope f3 2) 20 EPS)

(define (slope f r1)
  (* (/ 1 (* 2 EPS))
     (- (f (+ r1 EPS))
        (f (- r1 EPS)))))

;; [Number -> Number] Number -> Number
;; get the root of the tangent of f at r1
(check-error  (root-of-tangent f1 2))
(check-error  (root-of-tangent poly 3))
(check-within (root-of-tangent f2 2) 0    EPS)
(check-within (root-of-tangent f3 2) 0.75 EPS)

(define (root-of-tangent f r1)
  (- r1
     (/ (f r1)
        (slope f r1))))
