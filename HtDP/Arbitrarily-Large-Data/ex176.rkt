;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex176) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Matrix is one of: 
;  – (cons Row '())
;  – (cons Row Matrix)
; constraint all rows in matrix are of the same length
 
; A Row is one of: 
;  – '() 
;  – (cons Number Row)

(define wor1 (cons 11 (cons 21 '())))
(define wor2 (cons 12 (cons 22 '())))
(define tam1 (cons wor1 (cons wor2 '())))

(define row1 (cons 11 (cons 12 '())))
(define row2 (cons 21 (cons 22 '())))
(define mat1 (cons row1 (cons row2 '())))

(define row3a (cons 42 (cons 12 (cons 21 '()))))
(define row3b (cons 23 (cons  5 (cons 62 '()))))
(define row3c (cons  9 (cons 31 (cons 37 '()))))
(define mat2  (cons row3a (cons row3b (cons row3c '()))))

(define wor3a (cons 42 (cons 23 (cons  9 '()))))
(define wor3b (cons 12 (cons  5 (cons 31 '()))))
(define wor3c (cons 21 (cons 62 (cons 37 '()))))
(define tam2  (cons wor3a (cons wor3b (cons wor3c '())))) 

; Matrix -> Matrix
; transposes the given matrix along the diagonal
(check-expect (transpose mat1) tam1)
(check-expect (transpose mat2) tam2)
 
(define (transpose lln)
  (cond
    [(empty? (first lln)) '()]
    [else (cons (first* lln) (transpose (rest* lln)))]))

;; (empty? (first lln)) : This line exists because according to the data
;; definition, a matrix is a list of ONLY rows (of equal length),
;; which are themselves lists.
;; This means that a matrix can't be an empty list, but its rows can.

;; Matrix -> Row
;; produces the first column in lln as a Row
(check-expect (first* mat1) wor1)

(define (first* lln)
  (cond
    [(empty? lln) '()]
    [else (cons (first (first lln))
                (first* (rest lln)))]))

;; Matrix -> Matrix
;; removes the first column of the given matrix
(check-expect (rest* '()) '())
(check-expect
 (rest* mat1)
 (cons (cons 12 '())
       (cons (cons 22 '()) '())))

(define (rest* lln)
  (cond
    [(empty? lln) '()]
    [else (cons (rest (first lln))
                (rest* (rest lln)))]))

;; We cannot design this function with design recipes
;; because we do not (yet) have a recipe for list of lists
;; A Matrix is a list of lists