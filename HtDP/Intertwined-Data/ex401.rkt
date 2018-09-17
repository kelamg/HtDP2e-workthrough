;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex401) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require racket/base)

; An S-expr (S-expression) is one of: 
; – Atom
; – [List-of S-expr]
; 
; An Atom is one of: 
; – Number
; – String
; – Symbol

; Any -> Boolean
; is x an atom
(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))


;; S-expr S-expr -> Boolean
;; produces #true if s1 and s2 are equal
(check-expect (sexp=? '() '())      #true)
(check-expect (sexp=? 2 3)         #false)
(check-expect (sexp=? 2 2)          #true)
(check-expect (sexp=? "aye" "yes") #false)
(check-expect (sexp=? "aye" 5)     #false)
(check-expect (sexp=? "aye" "aye")  #true)
(check-expect (sexp=? 'a 3)        #false)
(check-expect (sexp=? 'a "a")      #false)
(check-expect (sexp=? 'a '(2))     #false)
(check-expect (sexp=? '(2) 'a)     #false)
(check-expect (sexp=? 'a '(a d))  #false)
(check-expect (sexp=? 'a 'a)        #true)
(check-expect
 (sexp=? '(2 "b" c) '(2 "b" d))    #false)
(check-expect
 (sexp=? '(2 "b" c) '((2) "b" d))  #false)
(check-expect
 (sexp=? '(2 "b" c) '(2 "b"))      #false)
(check-expect
 (sexp=? '(2 "b" c) '(2 "b" c))     #true)
(check-expect
 (sexp=? '((2) "b" c) '((2) "b" c)) #true)
(check-expect
 (sexp=? '(1 (make-posn 2 3) a)
         '(1 (make-posn 2 2) a))   #false)
(check-expect
 (sexp=? '(1 (make-posn 2 3) a)
         '(1 (make-posn 2 3) a))    #true)

(define (sexp=? s1 s2)
  (cond
    [(and (empty? s1) (empty? s2))     #true]
    [(and (atom? s1) (atom? s2))       (eq? s1 s2)]
    [(and (and (cons? s1) (cons? s2))
          (= (length s1) (length s2))) (andmap sexp=? s1 s2)]
    [else #false]))
