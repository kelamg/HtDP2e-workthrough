;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex354) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

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

; An AL (short for association list) is [List-of Association].
; An Association is a list of two items:
;   (cons Symbol (cons Number '()))

(define AL '((x 3) (y 5)))


;; BSL-var-expr -> [Or NumRet error]
;; produces a value for ex
;; if ex passes numeric?
;; produces an error otherwise
(check-expect
 (eval-variable 42) 42)
(check-expect
 (eval-variable (make-add 10 32)) 42)
(check-expect
 (eval-variable (make-mul 10 42)) 420)
(check-error (eval-variable 'x))
(check-error (eval-variable (make-add 'x 32)))

(define (eval-variable ex)
  (match ex
    [(? not-numeric?) (error "eval-variable: non-numeric expr")]
    [(? number?) ex]
    [(add   l r) (+ (eval-variable l) (eval-variable r))]
    [(mul   l r) (* (eval-variable l) (eval-variable r))]))

;; BSL-var-expr AL -> [Or NumRet error]
;; produces a value for ex
;; if numeric? passes after applying `subst` to all assocs in da 
;; produces an error otherwise
(check-expect
 (eval-variable* 42 AL) 42)
(check-expect
 (eval-variable* 'x AL) 3)
(check-expect
 (eval-variable* (make-add 'x 'y) AL) 8)
(check-error (eval-variable* 'z AL))
(check-error (eval-variable* (make-mul 'z 'x) AL))

(define (eval-variable* ex da)
  (eval-variable
   (foldl (λ (assoc expr)
            (subst expr (first assoc) (second assoc)))
          ex
          da)))

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

;; BSL-var-expr -> Boolean
;; produces #true if ex is also a BSL-expr
(check-expect
 (numeric? 'x) #false)
(check-expect
 (numeric? (make-add 'x 3)) #false)
(check-expect
 (numeric? (make-add 10 32)) #true)
(check-expect
 (numeric? (make-mul 10 32)) #true)

(define (numeric? ex)
  (match ex
    [(? number?) #true]
    [(add   l r) (andmap numeric? (list l r))]
    [(mul   l r) (andmap numeric? (list l r))]
    [else #false]))

(define (not-numeric? ex) (not (numeric? ex)))
      