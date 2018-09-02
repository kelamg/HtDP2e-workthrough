;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex313) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


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

;; Explain why this function fails one of its tests.
;; What is the result of (blue-eyed-ancestor? A) no matter which A you choose?

;; The result is always #false no matter what tree is supplied.
;; This happens because the function traverses the tree right down to
;; a (make-no-parent) struct, which returns #false. It does not actually
;; check the parent structs for whether they have blue eyes or not.

; FT -> Boolean
; does an-ftree contain an ancestor child
; structure with "blue" in the eyes field
(check-expect (blue-eyed-ancestor? Eva) #false)
(check-expect (blue-eyed-ancestor? Gustav) #true)

(define (blue-eyed-ancestor? an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else
     (or (blue-eyed-child? (child-father an-ftree))
         (blue-eyed-child? (child-mother an-ftree)))]))
