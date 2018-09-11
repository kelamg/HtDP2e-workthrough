;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex360) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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


;; BSL-da-all is [List-of BSL-const-def BSL-fun-def]

(define const1 (make-const-def 'age 12))
(define const2 (make-const-def 'height 175.5))
(define f (make-fn-def 'f 'x (make-add 3 'x)))
(define g (make-fn-def 'g 'y (make-fn-call 'f (make-mul 2 'y))))
(define h (make-fn-def 'h 'v (make-add (make-fn-call 'f 'v) (make-fn-call 'g 'v))))

(define DA-ALL (list const1 const2 f g h))


;; BSL-da-all Symbol -> [Or BSL-const-def error]
;; produces the representation of a constant definition
;; whose name is x, is such a piece of data exists in da
;; otherwise signals an error
(check-expect (lookup-con-def DA-ALL 'age) (make-const-def 'age 12))
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
(check-expect (lookup-fn-def DA-ALL 'h) h)
(check-error (lookup-fn-def DA-ALL 'i))

(define (lookup-fn-def da x)
  (cond
    [(empty? da) (error "lookup-fn-def: not defined")]
    [(and (fn-def? (first da))
          (symbol=? x (fn-def-name (first da)))) (first da)]
    [else (lookup-fn-def (rest da) x)]))

