;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex312) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


(define-struct no-parent [])
(define NP (make-no-parent))

(define-struct child [father mother name date eyes])
; An FT (short for family tree) is one of: 
; – NP
; – (make-child FT FT String N String)

; Oldest Generation:
(define Carl    (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))
 
; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva  (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))
 
; Youngest Generation: 
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))

; FT -> Boolean
; does an-ftree contain a child
; structure with "blue" in the eyes field
 
(check-expect (blue-eyed-child? Carl) #false)
(check-expect (blue-eyed-child? Gustav) #true)
 
(define (blue-eyed-child? an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else (or (string=? (child-eyes an-ftree) "blue")
              (blue-eyed-child? (child-father an-ftree))
              (blue-eyed-child? (child-mother an-ftree)))]))

;; FT -> [List-of String]
;; produces a list of all the eye colors in ft
(check-expect (eye-colors NP)     '())
(check-expect (eye-colors Carl)   '("green"))
(check-expect
 (eye-colors Adam)   '("hazel" "green" "green"))
(check-expect
 (eye-colors Gustav) '("brown" "pink" "blue" "green" "green"))

(define (eye-colors ft)
  (cond
    [(no-parent? ft) '()]
    [else (append (list (child-eyes ft))
                  (eye-colors (child-father ft))
                  (eye-colors (child-mother ft)))]))
