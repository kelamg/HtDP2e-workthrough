;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex393) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
	
; A Son.R is one of: 
; – empty 
; – (cons Number Son.R)
; 
; Constraint If s is a Son.R, 
; no number occurs twice in s


;; Son.R Son.R -> Son.R
;; produces a new set that contains the elements of both
(check-expect (union '() '()) '())
(check-expect (union '() '(1)) '(1))
(check-expect (union '(1) '()) '(1))
(check-expect (union '(1 2) '(3)) '(1 2 3))
(check-expect (union '(1 2 3) '(3 4 1)) '(2 3 4 1))
(check-expect (union '(1 3 5) '(1 4 2 3)) '(5 1 4 2 3))

(define (union s1 s2)
  (cond
    [(empty? s1) s2]
    [(empty? s2) s1]
    [(member? (first s1) s2) (union (rest s1) s2)]
    [else (cons (first s1) (union (rest s1) s2))]))

;; Son.R Son.R -> Son.R
;; produces a new set that contains only the elements
;; that occur in both sets
(check-expect (intersect '() '()) '())
(check-expect (intersect '() '(1)) '())
(check-expect (intersect '(1) '()) '())
(check-expect (intersect '(1 2) '(3)) '())
(check-expect (intersect '(1 2 3) '(3 4 1)) '(1 3))
(check-expect (intersect '(1 3 5 2) '(1 4 2 3)) '(1 3 2))

(define (intersect s1 s2)
  (cond
    [(or (empty? s1) (empty? s2)) '()]
    [(not (member? (first s1) s2)) (intersect (rest s1) s2)]
    [else (cons (first s1) (intersect (rest s1) s2))]))
