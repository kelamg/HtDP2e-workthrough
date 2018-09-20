;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex412) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct inex [mantissa sign exponent])
; An Inex is a structure: 
;   (make-inex N99 S N99)
; An S is one of:
; – 1
; – -1
; An N99 is an N between 0 and 99 (inclusive)

; N Number N -> Inex
; makes an instance of Inex after checking the arguments
(define (create-inex m s e)
  (cond
    [(and (<= 0 m 99) (<= 0 e 99) (or (= s 1) (= s -1)))
     (make-inex m s e)]
    [else (error "bad values given")]))
 
; Inex -> Number
; converts an inex into its numeric equivalent 
(define (inex->number an-inex)
  (* (inex-mantissa an-inex)
     (expt
       10 (* (inex-sign an-inex) (inex-exponent an-inex)))))

;; Inex Inex -> [Or Inex error]
;; add two inexs whose exponents differ by 1
(check-expect 
 (inex+ (create-inex 1 1 0) (create-inex 2 1 0))
 (create-inex 3 1 0))
(check-expect
 (inex+ (create-inex 25 1 1) (create-inex 26 1 1))
 (create-inex 51 1 1))
(check-expect
 (inex+ (create-inex 55 1 0) (create-inex 55 1 0))
 (create-inex 11 1 1))
(check-expect
 (inex+ (create-inex 56 1 0) (create-inex 56 1 0))
 (create-inex 11 1 1))
(check-expect
 (inex+ (create-inex 1 1 0) (create-inex 1 1 1))
 (create-inex 11 1 0))
(check-expect
 (inex+ (create-inex 1 1 0) (create-inex 1 -1 1))
 (create-inex 11 -1 1))
(check-expect
 (inex+ (create-inex 9 1 90) (create-inex 9 1 89))
 (create-inex 99 1 89))
(check-error
 (inex+ (create-inex 99 1 99) (create-inex 99 1 99))
 "out of range")

(define (inex+ a b)
  (local ((define normed (normalize a b))
          (define inex-a (first normed))
          (define inex-b (second normed))
          (define sign (inex-sign inex-a))
          (define exp  (inex-exponent inex-a))
          (define ret (+ (inex-mantissa inex-a) (inex-mantissa inex-b))))
    
    (cond
      [(<= ret  99) (create-inex ret sign exp)]
      [(< exp 99) (create-inex (round (/ ret 10)) sign (add1 exp))]
      [else (error "out of range")])))

;; Inex -> N
;; produces the signed exponent of i
(check-expect (signed-exp (create-inex 2 1 2)) 2)
(check-expect (signed-exp (create-inex 2 -1 2)) -2)

(define (signed-exp i)
  (* (inex-sign i) (inex-exponent i)))

;; Inex Inex -> [List-of Inex Inex]
;; returns a list of equivalent inexs with equal exponents
(check-expect
 (normalize (create-inex 1 1 0) (create-inex 1 -1 1))
 (list (create-inex 10 -1 1) (create-inex 1 -1 1)))
(check-expect
 (normalize (create-inex 1 1 0) (create-inex 1 1 1))
 (list (create-inex 1 1 0) (create-inex 10 1 0)))
(check-expect
 (normalize (create-inex 9 1 90) (create-inex 9 1 89))
 (list (create-inex 90 1 89) (create-inex 9 1 89)))
(check-error
 (normalize (create-inex 9 1 90) (create-inex 9 1 88)))

(define (normalize a b)
  (local ((define a-exp (signed-exp a))
          (define b-exp (signed-exp b))
          (define exp-diff (abs (- a-exp b-exp)))

          ; Inex -> Inex
          (define (equiv i)
            (local ((define e (inex-exponent i))
                    (define exp (signed-exp i)))
              (create-inex (* (inex-mantissa i) 10)
                           (if (<= exp 0) -1 1)
                           (if (< (sub1 e) 0) (add1 e) (sub1 e))))))

    (cond
      [(= exp-diff 0)  (list a b)]
      [(> exp-diff 1)  (error "invalid exponents")]
      [(> a-exp b-exp) (list (equiv a) b)]
      [(< a-exp b-exp) (list a (equiv b))])))

