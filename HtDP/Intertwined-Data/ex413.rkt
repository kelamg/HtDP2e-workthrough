;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex413) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
;; multiply two inexs together
(check-expect
 (inex* (create-inex 2 1 4) (create-inex 8 1 10))
 (create-inex 16 1 14))
(check-expect
 (inex* (create-inex 20 1 1) (create-inex  5 1 4))
 (create-inex 10 1 6))
(check-expect
 (inex* (create-inex 6 -1 3) (create-inex 5 -1 2))
 (create-inex 30 -1 5))
(check-expect
 (inex* (create-inex 27 -1 1) (create-inex  7 1 4))
 (create-inex 19 1 4))
(check-error
 (inex* (create-inex 98 1 50) (create-inex 98 1 98))
 "out of range")
(check-error
 (inex* (create-inex 98 1 98) (create-inex 98 1 98))
 "out of range")

(define (inex* a b)
  (local ((define a-signed-exp (signed-exp a))
          (define b-signed-exp (signed-exp b))
          (define ret-mant (* (inex-mantissa a) (inex-mantissa b)))
          (define ret-exp  (+ a-signed-exp b-signed-exp))
          (define ret-sign
            (if (zero? ret-exp) 1 (/ ret-exp (abs ret-exp)))))
    
    (cond
      [(<= ret-mant 99)
       (create-inex ret-mant ret-sign (abs ret-exp))]
      [(< ret-exp   99)
       (create-inex (round (/ ret-mant 10)) ret-sign (add1 ret-exp))]
      [else (error "out of range")])))

;; Inex -> N
;; produces the signed exponent of i
(check-expect (signed-exp (create-inex 2 1 2)) 2)
(check-expect (signed-exp (create-inex 2 -1 2)) -2)

(define (signed-exp i)
  (* (inex-sign i) (inex-exponent i)))


