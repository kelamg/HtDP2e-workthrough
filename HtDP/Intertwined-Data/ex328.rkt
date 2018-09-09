;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex328) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

; S-expr Symbol Atom -> S-expr
; replaces all occurrences of old in sexp with new

(check-expect (substitute '() 'hello 'world) '())
(check-expect
 (substitute 'hello 'hello 'world) 'world)
(check-expect
 (substitute '(hello world) 'hello 'world) '(world world))
(check-expect
 (substitute '((hello) world) 'hello 'world) '((world) world))
(check-expect
 (substitute '(("hello") 'world) 'hello 'world)
 '(("hello") 'world))
(check-expect
 (substitute '(((hello world) world) !) 'hello 'world)
 '(((world world) world) !))
(check-expect
 (substitute '(((world) bye) bye) 'bye '42)
 '(((world) 42) 42))
 
(define (substitute sexp old new)
  (cond
    [(atom? sexp) (if (equal? sexp old) new sexp)]
    [else
     (map (λ (s) (substitute s old new)) sexp)]))

