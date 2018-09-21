;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex427) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define THRESHOLD 5)

; [List-of Number] -> [List-of Number]
; produces a sorted version of alon
; assume the numbers are all distinct
; uses sort< if length of alon is below THRESHOLD
(check-expect
 (quick-sort< '()) '())
(check-expect
 (quick-sort< '(1)) '(1))
(check-expect
 (quick-sort< (list 11 8 14 7))
 '(7 8 11 14))
(check-expect
 (quick-sort< (list 11 9 2 18 12 14 4 1))
 (list 1 2 4 9 11 12 14 18))

(define (quick-sort< alon)
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [(< (length alon) THRESHOLD) (sort< alon)]
    [else (local ((define pivot (first alon)))
            (append (quick-sort< (smallers alon pivot))
                    (list pivot)
                    (quick-sort< (largers alon pivot))))]))
 
; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon larger than n
(define (largers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (> (first alon) n)
              (cons (first alon) (largers (rest alon) n))
              (largers (rest alon) n))]))
 
; [List-of Number] Number -> [List-of Number]
; produces all the numbers in alon smaller than n
(define (smallers alon n)
  (cond
    [(empty? alon) '()]
    [else (if (< (first alon) n)
              (cons (first alon) (smallers (rest alon) n))
              (smallers (rest alon) n))]))


; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(check-expect
 (sort< '()) '())
(check-expect
 (sort< '(4 0 8 10 3))
 '(0 3 4 8 10))

(define (sort< l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort< (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (<= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))


