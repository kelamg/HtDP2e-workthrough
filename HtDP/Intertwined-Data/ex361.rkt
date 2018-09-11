;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex361) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

(define-struct fn-call (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

(define-struct const-def (name val))
;; A ConstantDefinition is a structure:
;;   (make-const-def Symbol Number)
;; interp. data representation for a constant definition

(define-struct fn-def (name param body))
;; A BSL-fun-def is a structure:
;;   (make-fn-def Symbol Symbol BSL-var-expr)
;; interp. a data representation of a function definition

; A BSL-fun-expr is one of: 
; – Number
; – Symbol 
; – (make-add BSL-fun-expr BSL-fun-expr)
; – (make-mul BSL-fun-expr BSL-fun-expr)
; - (make-fn-call Symbol BSL-fun-expr)

;; A NumRet is a Number

;; BSL-da-all is [List-of BSL-const-def BSL-fun-def]

(define const1 (make-const-def 'close-to-pi 3.14))
(define const2 (make-const-def 'height 10))
(define fa (make-fn-def 'area-of-circle 'r
                        (make-mul 'close-to-pi (make-mul 'r 'r))))
(define fv (make-fn-def 'volume-of-cylinder 'r
                        (make-mul 'height (make-fn-call 'area-of-circle 'r))))


(define f (make-fn-def 'f 'x (make-add 3 'x)))
(define g (make-fn-def 'g 'y (make-fn-call 'f (make-mul 2 'y))))
(define h (make-fn-def 'h 'v (make-add (make-fn-call 'f 'v) (make-fn-call 'g 'v))))

;; A BSL-fun-def* is [List-of BL-fun-def]
(define da-fgh (list f g h))

(define DA-ALL (append (list const1 const2 fa fv) da-fgh))


;; BSL-fun-expr BSL-da-all -> [Or NumRet error]
;; produces the value of ex, if all supplied constants,
;; and functions are defined in da
;; otherwise signals an error
(check-expect
 (eval-all 5 DA-ALL) 5)
(check-expect
 (eval-all (make-add 3 4) DA-ALL) 7)
(check-expect
 (eval-all (make-mul 3 4) DA-ALL) 12)
(check-expect
 (eval-all 'close-to-pi DA-ALL) 3.14)
(check-within
 (eval-all (make-mul 3 'close-to-pi) DA-ALL) #i9.42 0.01)
(check-expect
 (eval-all (make-fn-call 'g (make-add 1 1)) DA-ALL) 7)
(check-expect
 (eval-all (make-fn-call 'f (make-add 1 1)) DA-ALL) 5)
(check-expect
 (eval-all (make-fn-call 'h 10) DA-ALL) 36)
(check-within
 (eval-all (make-fn-call 'area-of-circle 1) DA-ALL) #i3.14 0.01)
(check-within
 (eval-all (make-fn-call 'volume-of-cylinder 1) DA-ALL)
 #i31.400000000000002 0.01)
(check-error (eval-all 'undefined DA-ALL))
(check-error (eval-all (make-fn-call 'i 3) DA-ALL))

(define (eval-all ex da)
  (match ex
    [(? number?) ex]
    [(? symbol?) (const-def-val (lookup-con-def da ex))]
    [(add   l r) (+  (eval-all l da) (eval-all r da))]
    [(mul   l r) (*  (eval-all l da) (eval-all r da))]
    [(fn-call n arg)
     (local ((define fn       (lookup-fn-def da n))
             (define arg-eval (eval-all arg da)))
       (eval-all (subst (fn-def-body fn) (fn-def-param fn) arg-eval) da))]))

;; BSL-da-all Symbol -> [Or BSL-const-def error]
;; produces the representation of a constant definition
;; whose name is x, is such a piece of data exists in da
;; otherwise signals an error
(check-expect (lookup-con-def DA-ALL 'close-to-pi) const1)
(check-error (lookup-con-def DA-ALL 'loc))

(define (lookup-con-def da x)
  (cond
    [(empty? da) (error "lookup-con-def: not defined")]
    [(and (const-def? (first da))
          (symbol=? x (const-def-name (first da)))) (first da)]
    [else (lookup-con-def (rest da) x)]))

;; BSL-da-all Symbol -> [Or BSL-fn-def error]
;; produces the representation of a function definition
;; whose name is f, is such a piece of data exists in da
;; otherwise signals an error
(check-expect (lookup-fn-def DA-ALL 'area-of-circle) fa)
(check-error (lookup-fn-def DA-ALL 'i))

(define (lookup-fn-def da x)
  (cond
    [(empty? da) (error "lookup-fn-def: not defined")]
    [(and (fn-def? (first da))
          (symbol=? x (fn-def-name (first da)))) (first da)]
    [else (lookup-fn-def (rest da) x)]))

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
