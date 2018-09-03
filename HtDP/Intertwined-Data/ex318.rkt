;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex318) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; Any -> Boolean
;; produces true if x is of atomic
(check-expect (atom?   2)                #true)
(check-expect (atom? "a")                #true)
(check-expect (atom?  'x)                #true)
(check-expect (atom? (make-posn 40 50)) #false)

(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))


;; S-expr -> N
;; produces the depth of sexp
;; the depth of a list of of s-expressions is the
;; maximum depth of its items plus 1
(check-expect (depth '())     1)
(check-expect (depth "hello") 1)
(check-expect (depth '(hello world)) 2)
(check-expect (depth '((hello) world)) 3)
(check-expect (depth '(((hello world) world) !)) 4)

(define (depth sexp)
  (local
    (; SL -> N
     (define (depth-sl sl)
       (cond
         [(empty? sl) 0]
         [else (max (depth (first sl))
                    (depth-sl (rest sl)))]))

     ; S-expr -> N
     (define (depth sexp)
       (cond
         [(atom? sexp) 1]
         [else (add1 (depth-sl sexp))])))

  (depth sexp)))
