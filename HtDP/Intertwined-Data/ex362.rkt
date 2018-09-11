;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex362) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

;; DATA DEFINITIONS

(define-struct add       (left right))
(define-struct mul       (left right))

(define-struct fn-call   (name arg))
;; A FunctionCall is a structure:
;;   (make-fn-call Symbol BSL-fun-expr)
;; interp. data representation for a function
;;         called with only one argument, arg

(define-struct const-def (name val))
;; A ConstantDefinition is a structure:
;;   (make-const-def Symbol Number)
;; interp. data representation for a constant definition

(define-struct fn-def    (name param body))
;; A BSL-fun-def is a structure:
;;   (make-fn-def Symbol Symbol BSL-var-expr)
;; interp. a data representation of a function definition

; An Atom is one of: 
; – Number
; – String
; – Symbol

; An S-expr is one of: 
; – Atom
; – SL

;; An SL is [List-of S-expr]

;; A NumRet is a Number

;; END DATA DEFINITIONS

;; CONSTANT DEFINITIONS

; constant definitions
(define d1 '(define close-to-pi 3.14))
(define d2 '(define height        10))

; function definitions
(define d3 '(define (area-of-circle r) (* close-to-pi (* r r))))
(define d4 '(define (volume-of-cylinder r) (* height (area-of-circle r))))
(define d5 '(define (f x) (+ 3 x)))
(define d6 '(define (g y) (f (* 2 y))))
(define d7 '(define (h v) (+ (f v) (g v))))

;; An Sl is a [List-of BSL-const-def BSL-fun-def]
(define SL (list d1 d2 d3 d4 d5 d6 d7))

;; error messages
(define INVALID-DEF-ERROR "sorry was that.. was that a definition?")
(define UNDEF-FUNC-ERROR  "function not defined")
(define UNDEF-CONST-ERROR "constant not defined")
(define UNPARSEABLE-ERROR "expression is unparseable")
(define UNSPT-TYPE-ERROR  "unsupported functionality (I'm lazy, sorry)")

;; END CONSTANT DEFINTIONS


;; S-expr Sl -> [Or NumRet error]
;; parses input appropriately to BSL data representation,
;; then evaluates to obtain a value
;; produces an error if a value cannnot be obtained
(check-expect
 (interpreter 5 SL) 5)
(check-expect
 (interpreter 'close-to-pi SL) 3.14)
(check-expect
 (interpreter '(+ 4 close-to-pi) SL) 7.14)
(check-expect
 (interpreter '(f (+ 1 1)) SL) 5)
(check-expect
 (interpreter '(g (+ 1 1)) SL) 7)
(check-expect
 (interpreter '(h 10) SL) 36)
(check-within
 (interpreter '(area-of-circle 1) SL) #i3.14 0.01)
(check-within
 (interpreter '(volume-of-cylinder 1) SL) #i31.400000000000002 0.01)
(check-error (interpreter 'ooops SL))
(check-error (interpreter '(i 5) SL))

(define (interpreter s sl)
  (local ((define parsed-expr (parse s))
          (define parsed-defns (map parse sl)))
    
    (eval-all parsed-expr parsed-defns)))


;; S-expr -> BSL-expr
;; produces a BSL-expr from s
;; iff s is the result of quoting a BSL expression
;; that has a BSL-expr representative
(check-expect
 (parse 42) 42)
(check-expect
 (parse '(* 6 7)) (make-mul 6 7))
(check-expect
 (parse '(+ 2 (* 4 10))) (make-add 2 (make-mul 4 10)))
(check-expect
 (parse d1) (make-const-def 'close-to-pi 3.14))
(check-expect
 (parse d5) (make-fn-def 'f 'x (make-add 3 'x)))
(check-error (parse "ooops"))
(check-error (parse '(/ (* 42 10) 10)))
(check-error (parse '(* 3 2 7)))

; S-expr -> [Or BSL-expr error]
(define (parse s)
  (local
    (; Atom -> BSL-expr 
     (define (parse-atom s)
       (cond
         [(number? s) s]
         [(string? s) (error "parse: " UNSPT-TYPE-ERROR)]
         [(symbol? s) s]))

     ; SL -> BSL-expr
     (define (parse-sl s)
       (match s
         [(list '+ arg0 arg1) (make-add (parse arg0) (parse arg1))]
         [(list '* arg0 arg1) (make-mul (parse arg0) (parse arg1))]
         [(cons 'define expr) (parse-define expr)]
         [(list (? symbol?) arg) (make-fn-call (first s) (parse arg))]
         [else (error "parse-sl: " UNPARSEABLE-ERROR)])))
     
    (cond
      [(atom? s) (parse-atom s)]
      [else      (parse-sl s)])))


;; SL -> BSL-expr
;; parse sl to be defined, rather than evaluated
;; produces an error if unparseable
(check-expect
 (parse-define '(height 10))
 (make-const-def 'height 10))
(check-expect
 (parse-define '((h v) (+ (f v) (g v))))
 (make-fn-def 'h 'v (make-add (make-fn-call 'f 'v) (make-fn-call 'g 'v))))
(check-error (parse-define '(a 1 (+ 2 3))))

(define (parse-define sl)
  (match sl
    [(list (list f-name f-arg) f-body)
     (make-fn-def f-name f-arg (parse f-body))]
    [(list const-name const-val)
     (make-const-def const-name const-val)]
    [else (error "parse-define: " INVALID-DEF-ERROR)]))

;; BSL-fun-expr BSL-da-all -> [Or NumRet error]
;; produces the value of ex, if all supplied constants,
;; and functions are defined in da
;; otherwise signals an error
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

;; BSL-fun-expr Symbol Number -> BSL-fun-expr
;; produces a BSL-fun-expr like ex
;; with all occurences of x replaced by v
(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add   l r) (make-add (subst l x v) (subst r x v))]
    [(mul   l r) (make-mul (subst l x v) (subst r x v))]
    [(fn-call n arg) (make-fn-call n (subst arg x v))]))

;; BSL-da-all Symbol -> [Or BSL-const-def error]
;; produces the representation of a constant definition
;; whose name is x, is such a piece of data exists in da
;; otherwise signals an error
(define (lookup-con-def da x)
  (cond
    [(empty? da) (error "lookup-con-def: " UNDEF-FUNC-ERROR)]
    [(and (const-def? (first da))
          (symbol=? x (const-def-name (first da)))) (first da)]
    [else (lookup-con-def (rest da) x)]))

;; BSL-da-all Symbol -> [Or BSL-fn-def error]
;; produces the representation of a function definition
;; whose name is f, is such a piece of data exists in da
;; otherwise signals an error
(define (lookup-fn-def da x)
  (cond
    [(empty? da) (error "lookup-fn-def: " UNDEF-CONST-ERROR)]
    [(and (fn-def? (first da))
          (symbol=? x (fn-def-name (first da)))) (first da)]
    [else (lookup-fn-def (rest da) x)]))

;; Any -> Boolean
;; produces true if x is of atomic
(check-expect (atom?   2)                #true)
(check-expect (atom? "a")                #true)
(check-expect (atom?  'x)                #true)
(check-expect (atom? (make-posn 40 50)) #false)

(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))
