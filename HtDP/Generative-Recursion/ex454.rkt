;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex454) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; N [List-of X] -> [List-of [List-of X]]
;; groups lx into a list of n lists, each of length n
(check-expect
 (create-matrix 2 '()) '())
(check-expect
 (create-matrix 2 '(1 2 3 4))
 '((1 2)
   (3 4)))
(check-expect
 (create-matrix 3 (build-list 9 (λ (n) (integer->char (+ n 65)))))
 '((#\A #\B #\C)
   (#\D #\E #\F)
   (#\G #\H #\I)))

(define (create-matrix n lx)
  (cond
    [(empty? lx) '()]
    [else (cons (take lx n)
                (create-matrix n (drop lx n)))]))

;; [List-of X] N -> [List-of X]
;; returns the first n items in l
(check-expect (take '() 2) '())
(check-expect (take '(1 2 3) 2) '(1 2))

(define (take l n)
  (cond
    [(empty? l) '()]
    [(zero?  n) '()]
    [else (cons (first l)
                (take (rest l) (sub1 n)))]))

;; [List-of X] N -> [List-of X]
;; drops the first n items in l and returns the rest
(check-expect (drop '() 2) '())
(check-expect (drop '(1 2 3) 2) '(3))

(define (drop l n)
  (cond
    [(empty? l) '()]
    [(zero?  n) l]
    [else (drop (rest l) (sub1 n))]))

