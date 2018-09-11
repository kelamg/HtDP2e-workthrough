;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex357) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

(define-struct fn-call (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; - (make-fn-call Symbol BSL-fun-expr)

; A BSL-var-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-var-expr BSL-var-expr)
; – (make-mul BSL-var-expr BSL-var-expr)

;; A BSL-expr is one of:
;; - Number
;; - (make-add BSL-expr BSL-expr)
;; - (make-mul BSL-expr BSL-expr)

;; A NumRet is a Number

(define UNDEF-FUN-ERROR "eval-definition1: undefined function")
(define UNDEF-VAR-ERROR "eval-definition1: undeclared variable")

(define EX1 (make-fn-call 'k (make-add 1 1)))
(define EX2 (make-mul 5 EX1))
(define EX3 (make-fn-call 'k (make-fn-call 'k (make-add 1 1))))
(define EX4 (make-mul (make-fn-call 'i 5) EX1))


;; BSL-fun-expr Symbol Symbol BSL-fun-expr -> [Or NumRet error]
;; determines the value of ex
;; produces an error if ex cannot be evaluated
(check-expect
 (eval-definition1 EX1 'k 'a (make-add 'a 'a)) 4)
(check-expect
 (eval-definition1 EX2 'k 'a (make-mul 'a 10)) 100)
(check-expect
 (eval-definition1 EX3 'k 'a (make-mul 'a 2)) 8)
(check-error
 (eval-definition1 EX4 'k 'a (make-add 'a 'a)))
(check-error
 (eval-definition1 'x 'k 'a (make-add 'a 'a)))
(check-error
 (eval-definition1 (make-fn-call 'x 5) 'k 'a (make-add 'a 'a)))


(define (eval-definition1 ex f x b)
  (match ex
    [(? number?) ex]
    [(? symbol?) (error UNDEF-VAR-ERROR)]
    [(add   l r) (+  (eval-definition1 l f x b)
                     (eval-definition1 r f x b))]
    [(mul   l r) (*  (eval-definition1 l f x b)
                     (eval-definition1 r f x b))]
    [(fn-call n arg)
     (if (not (symbol=? n f))
         (error UNDEF-FUN-ERROR)
         (eval-definition1
          (subst b x (eval-definition1 arg f x b))
          f x b))]))

;; BSL-var-expr Symbol Number -> BSL-var-expr
;; produces a BSL-var-expr like ex
;; with all occurences of x replaced by v
(check-expect
 (subst 'x 'x 5) 5)
(check-expect
 (subst (make-add 'x 3) 'x 5) (make-add 5 3))
(check-expect
 (subst (make-add (make-mul 'x 'x) (make-mul 'y 'y)) 'x 5)
 (make-add (make-mul 5 5) (make-mul 'y 'y)))

(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add   l r) (make-add (subst l x v) (subst r x v))]
    [(mul   l r) (make-mul (subst l x v) (subst r x v))]))
