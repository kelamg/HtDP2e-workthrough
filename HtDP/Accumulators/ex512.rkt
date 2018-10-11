;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex512) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define ERR-MSG "are you sure about that?")

; A Lam is one of: 
; – Symbol
; – (list 'λ (list Symbol) Lam)
; – (list Lam Lam)

(define ex1 '(λ (x) x))
(define ex2 '(λ (x) y))
(define ex3 '(λ (y) (λ (x) y)))
(define ex4 '((λ (x) (x x)) (λ (x) (x x))))
(define ex5 'x)
(define ex6 '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w)))

;; Lam -> Boolean
;; is lam a variable?
(check-expect (is-var? ex1) #false)
(check-expect (is-var? ex4) #false)
(check-expect (is-var? ex5)  #true)

(define (is-var? lam)
  (symbol? lam))

;; Lam -> Boolean
;; is lam a λ?
(check-expect (is-λ? ex1)  #true)
(check-expect (is-λ? ex4) #false)
(check-expect (is-λ? ex5) #false)

(define (is-λ? lam)
  (and (cons? lam) (eq? (first lam) 'λ)))

;; Lam -> Boolean
;; is lam a function application?
(check-expect (is-app? ex1) #false)
(check-expect (is-app? ex4)  #true)
(check-expect (is-app? ex5) #false)
(check-expect (is-app? ex6)  #true)

(define (is-app? lam)
  (and (cons? lam) (not (eq? (first lam) 'λ))))

;; Lam -> [List-of Symbol]
;; extracts the parameter from a λ expression
(check-expect (λ-para ex1) '(x))
(check-expect (λ-para '(λ (x y) x)) '(x y))
(check-error  (λ-para ex4) ERR-MSG)

(define (λ-para lam)
  (if (is-λ? lam) (second lam) (error ERR-MSG)))

;; Lam -> Lam
;; extracts the body from a λ expression
(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex3) '(λ (x) y))
(check-error  (λ-body ex4) ERR-MSG)

(define (λ-body lam)
  (if (is-λ? lam) (third lam) (error ERR-MSG)))

;; Lam -> Lam
;; extracts the function from an application
(check-error  (app-fun ex1))
(check-expect (app-fun ex4) '(λ (x) (x x)))
(check-expect (app-fun ex6) '((λ (y) (λ (x) y)) (λ (z) z)))

(define (app-fun lam)
  (if (is-app? lam) (first lam) (error ERR-MSG)))

;; Lam -> Lam
;; extracts the argument from an application
(check-error  (app-arg ex1))
(check-expect (app-arg ex4) '(λ (x) (x x)))
(check-expect (app-arg ex6) '(λ (w) w))

(define (app-arg lam)
  (if (is-app? lam) (second lam) (error ERR-MSG)))

;; Lam -> [List-of Symbol]
;; extracts the list of all the symbols used as parameters
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '())
(check-expect (declareds ex6) '(y x z w))

(define (declareds lam)
  (cond
    [(is-var? lam) '()]
    [(is-λ?   lam) (append (λ-para lam) (declareds (λ-body lam)))]
    [else (append (declareds (app-fun lam)) (declareds (app-arg lam)))]))
