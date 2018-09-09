;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex351) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct add (left right))
(define-struct mul (left right))

; An Atom is one of: 
; – Number
; – String
; – Symbol

; An S-expr is one of: 
; – Atom
; – SL

; An SL is one of: 
; – '()
; – (cons S-expr SL)

;; A BSL-expr is one of:
;; - Number
;; - (make-add BSL-expr BSL-expr)
;; - (make-mul BSL-expr BSL-expr)

;; A NumRet is a Number


(define WRONG "parse: invalid S-expr")

;; S-expr -> [Or NumRet error]
;; if `parse` recognizes s as a BSL-expr,
;; it produces its value
;; otherwise, produces an error
(check-expect
 (interpreter-expr '(+ 3 5)) 8)
(check-expect
 (interpreter-expr '(* 3 5)) 15)
(check-error (interpreter-expr "fried chicken"))
(check-error (interpreter-expr '(+ 0 0 0)))

(define (interpreter-expr s)
  (eval-expression (parse s)))

;; BSL-expr -> NumRet
;; computes the value of bexpr
(check-expect (eval-expression 3) 3)
(check-expect
 (eval-expression (make-add 1 1)) 2)
(check-expect
 (eval-expression (make-mul 3 10)) 30)
(check-expect
 (eval-expression (make-add (make-mul 1 1) 10)) 11)

(define (eval-expression bexpr)
  (match bexpr
    [(? number?) bexpr]
    [(add   l r) (+ (eval-expression l) (eval-expression r))]
    [(mul   l r) (* (eval-expression l) (eval-expression r))]))

;; Any -> Boolean
;; produces true if x is of atomic
(check-expect (atom?   2)                #true)
(check-expect (atom? "a")                #true)
(check-expect (atom?  'x)                #true)
(check-expect (atom? (make-posn 40 50)) #false)

(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))

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
(check-error (parse "ooops"))
(check-error (parse 'ooops))
(check-error (parse '(+ 1)))
(check-error (parse '(/ (* 42 10) 10)))
(check-error (parse '(* 3 2 7)))

; S-expr -> BSL-expr
(define (parse s)
  (cond
    [(atom? s) (parse-atom s)]
    [else (parse-sl s)]))
 
; SL -> BSL-expr
(define (parse-sl s)
  (local ((define L (length s)))
    (cond
      [(< L 3) (error WRONG)]
      [(and (= L 3) (symbol? (first s)))
       (cond
         [(symbol=? (first s) '+)
          (make-add (parse (second s)) (parse (third s)))]
         [(symbol=? (first s) '*)
          (make-mul (parse (second s)) (parse (third s)))]
         [else (error WRONG)])]
      [else ((error WRONG)])))
 
; Atom -> BSL-expr 
(define (parse-atom s)
  (cond
    [(number? s) s]
    [(string? s) (error WRONG)]
    [(symbol? s) (error WRONG)]))
