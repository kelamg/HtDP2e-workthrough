;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex359) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; - (make-fn-call Symbol BSL-fun-expr)

(define-struct fn-call (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

(define-struct fn-def (name param body))
;; A BSL-fun-def is a structure:
;;   (make-fn-def Symbol Symbol BSL-var-expr)
;; interp. a data representation of a function definition

(define f (make-fn-def 'f 'x (make-add 3 'x)))
(define g (make-fn-def 'g 'y (make-fn-call 'f (make-mul 2 'y))))
(define h (make-fn-def 'h 'v (make-add (make-fn-call 'f 'v) (make-fn-call 'g 'v))))

;; A BSL-fun-def* is [List-of BL-fun-def]
(define da-fgh (list f g h))

;; A NumRet is a Number

(define UNDEF-FUN-ERROR "eval-function*: undefined function")
(define UNDEF-VAR-ERROR "eval-function*: undeclared variable")


;; BSL-fun-expr BSL-fun-def* -> [Or NumRet error]
;; produces the result of ex if any called functions exist in da
;; produces an error otherwise
(check-expect
 (eval-function* 5 da-fgh) 5)
(check-expect
 (eval-function* (make-add 10 (make-mul 2 4)) da-fgh) 18)
(check-expect
 (eval-function* (make-fn-call 'g (make-add 1 1)) da-fgh) 7)
(check-expect
 (eval-function* (make-fn-call 'f (make-add 1 1)) da-fgh) 5)
(check-expect
 (eval-function* (make-fn-call 'h 10) da-fgh) 36)
(check-error
 (eval-function* (make-fn-call 'k (make-add 1 1)) da-fgh))
(check-error
 (eval-function* (make-fn-call 'g (make-fn-call 'k 2)) da-fgh))
(check-error
 (eval-function* 'x da-fgh))

(define (eval-function* ex da)
  (local ((define (subst-def def x)
            (subst (fn-def-body def) (fn-def-param def) x)))
    
    (match ex
      [(? number?) ex]
      [(? symbol?) (error UNDEF-VAR-ERROR)]
      [(add   l r) (+  (eval-function* l da)
                       (eval-function* r da))]
      [(mul   l r) (*  (eval-function* l da)
                       (eval-function* r da))]
      [(fn-call n arg)
       (eval-function* (subst-def
                        (lookup-def da n) (eval-function* arg da))
                       da)])))

; BSL-fun-def* Symbol -> [Or BSL-fun-def error]
; retrieves the definition of f in da
; signals an error if there is none
(check-expect (lookup-def da-fgh 'g) g)

(define (lookup-def da f)
  (match da
    ['() (error UNDEF-FUN-ERROR)]
    [(cons def rest)
     (if (symbol=? f (fn-def-name def)) def (lookup-def rest f))]))

;; BSL-fun-expr Symbol Number -> BSL-fun-expr
;; produces a BSL-fun-expr like ex
;; with all occurences of x replaced by v
(check-expect
 (subst 'x 'x 5) 5)
(check-expect
 (subst (make-add 'x 3) 'x 5) (make-add 5 3))
(check-expect
 (subst (make-add (make-mul 'x 'x) (make-mul 'y 'y)) 'x 5)
 (make-add (make-mul 5 5) (make-mul 'y 'y)))
(check-expect
 (subst (make-fn-call 'f (make-add 'x 1)) 'x 5)
 (make-fn-call 'f (make-add 5 1)))

(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add   l r) (make-add (subst l x v) (subst r x v))]
    [(mul   l r) (make-mul (subst l x v) (subst r x v))]
    [(fn-call n arg) (make-fn-call n (subst arg x v))]))
