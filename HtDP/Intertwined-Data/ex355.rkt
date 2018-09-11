;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex355) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

;; A NumRet is a Number

; An AL (short for association list) is [List-of Association].
; An Association is a list of two items:
;   (cons Symbol (cons Number '()))

(define AL '((x 3) (y 5)))

(define ERROR "eval-variable: non-numeric expr")

;; BSL-var-expr AL -> [Or NumRet error]
;; produces a value for ex
;; if an undefined symbol in da is encountered,
;; throws an error
(check-expect
 (eval-var-lookup 42 AL) 42)
(check-expect
 (eval-var-lookup 'x AL) 3)
(check-expect
 (eval-var-lookup (make-add 'x 'y) AL) 8)
(check-error (eval-var-lookup 'z AL))
(check-error (eval-var-lookup (make-mul 'z 'x) AL))

(define (eval-var-lookup ex da)
  (match ex
    [(? number?) ex]
    [(? symbol?) (get-assoc-or-err ex da)]
    [(add   l r) (+ (eval-var-lookup l da) (eval-var-lookup r da))]
    [(mul   l r) (* (eval-var-lookup l da) (eval-var-lookup r da))]))

;; Symbol AL -> Number
;; produces the associated number in da if ex exists
(define (get-assoc-or-err ex da)
  (local ((define var (assq ex da)))
    (if (false? var) (error ERROR) (second var))))

