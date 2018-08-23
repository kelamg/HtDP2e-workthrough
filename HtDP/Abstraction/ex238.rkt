;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex238) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define long-inf
  (list 25 24 23 22 21 20 19 18 17 16 15 14 13
      12 11 10 9 8 7 6 5 4 3 2 1))

(define long-sup
  (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
      17 18 19 20 21 22 23 24 25))

; Nelon -> Number
; determines the smallest 
; number on l
(define (inf l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (min (first l) (inf (rest l)))]))

; Nelon -> Number
; determines the largest 
; number on l
(define (sup l)
  (cond
    [(empty? (rest l))
     (first l)]
    [else
     (max (first l) (sup (rest l)))]))

;; Nelon -> Number
;; searches the given list for "the one";
;; the number that satisfies the comparison function globally
(define (find-neo func l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (if (func (first l) (find-neo func (rest l)))
              (first l)
              (find-neo func (rest l)))]))

; Nelon -> Number
; determines the smallest number on l

; slow -> (check-expect (inf-1 long-inf) 1)

(define (inf-1 l)
  (find-neo < l))

; Nelon -> Number
; determines the smallest number on l

; slow -> (check-expect (sup-1 long-sup) 25)

(define (sup-1 l)
  (find-neo > l))

;; The functions are slow on the long lists because for each number
;; in the list, the entire rest of the list is traversed AGAIN to
;; determine whether that number is the globally optimum solution
;; using a comparison function that returns a boolean value.
;; The most obvious indicator of this is that there are
;; 2 recursive calls in their function bodies

;; Nelon -> Number
;; searches the given list for "the one";
;; the number that satisfies the comparison function globally
(define (find-neo.v2 func l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (func (first l) (find-neo.v2 func (rest l)))]))

; Nelon -> Number
; determines the smallest number on l
(check-expect (inf-2 long-inf) 1)

(define (inf-2 l)
  (find-neo.v2 < l))

; Nelon -> Number
; determines the smallest number on l
(check-expect (sup-2 long-sup) 25)

(define (sup-2 l)
  (find-neo.v2 max l))

;; These versions are faster because it utilises a function that
;; compares non-boolean values, and thus allowes the functions
;; to only be recursively called once 




