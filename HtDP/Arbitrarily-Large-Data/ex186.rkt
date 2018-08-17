;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex186) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; List-of-numbers -> Boolean
; produces true if the numbers are sorted in descending order
(check-expect (sorted>? (cons 2 '())) #t)
(check-expect (sorted>? (cons 1 (cons 2 (cons 3 '())))) #f)
(check-expect (sorted>? (cons 3 (cons 2 (cons 1 '())))) #t)
(check-expect (sorted>? (cons 1 (cons 3 (cons 2 '())))) #f)

(define (sorted>? lon)
  (cond
    [(empty? (rest lon)) #t]
    [else
     (and (> (first lon) (first (rest lon)))
          (sorted>? (rest lon)))]))

; List-of-numbers -> List-of-numbers 
; rearranges l in descending order
(check-satisfied (sort> (list 3 2 1)) sorted>?)
(check-satisfied (sort> (list 1 2 3)) sorted>?)
(check-satisfied (sort> (list 12 20 -5)) sorted>?)
 
(define (sort> l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort> (rest l)))]))

; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers alon
(check-expect (insert 5 '()) (list 5))
(check-expect (insert 5 (list 6)) (list 6 5))
(check-expect (insert 5 (list 4)) (list 5 4))
(check-expect (insert 12 (list 20 -5)) (list 20 12 -5))

(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort>/bad l)
  (list 9 8 7 6 5 4 3 2 1 0))

;; (check-expect (sort>/bad (list 12 20 -5)) (list 20 12 -5))
;; The above test case shows sort>/bad is not a sorting function
;;
;; (check-satisfied (sort>/bad (list 12 20 -5)) sorted>?) 
;; check-satisfied cannnot be used to formulate a test case
;; that proves sort>/bad is not a sorting function because it always
;; returns true on the produced list (list 9 8 7 6 5 4 3 2 1 0),
;; which returns true when passed to sorted>?