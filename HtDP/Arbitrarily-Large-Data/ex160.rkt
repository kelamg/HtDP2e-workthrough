;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex160) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; List-of-string String -> N
; determines how often s occurs in los
(check-expect (count '() 5) 0)
(check-expect (count (cons 5 (cons 3 '())) 5) 1)
(check-expect (count (cons 5 (cons 3 '())) 2) 0)
(check-expect (count
               (cons 10 (cons 33.4 (cons 4 (cons 10 '())))) 10)
              2)

(define (count los s)
  (cond
    [(empty? los) 0]
    [else
     (if (equal? (first los) s)
         (+ 1 (count (rest los) s))
         (count (rest los) s))]))

; Son
(define es '())
 
; Number Son -> Boolean
; is x in s
(define (in? x s)
  (member? x s))

; Number Son.L -> Son.L
; removes x from s 
(define s1.L
  (cons 1 (cons 1 '())))
 
(check-expect
  (set-.L 1 s1.L) es)
 
(define (set-.L x s)
  (remove-all x s))

; Number Son.R -> Son.R
; removes x from s
(define s1.R
  (cons 1 '()))
 
(check-expect
  (set-.R 1 s1.R) es)
 
(define (set-.R x s)
  (remove x s))

;; Number Son.L -> Son.L
;; adds a number x to a given Son.L
(check-expect
 (set+.L 1 s1.L) (cons 1 (cons 1 (cons 1 '()))))

(define (set+.L x s)
  (cons x s))

;; Number Son.R -> Son.R
;; adds a number x to a given Son.R
(check-expect
 (set+.R 1 s1.R) s1.R)
(check-expect
 (set+.R 2 s1.R) (cons 2 s1.R))

(define (set+.R x s)
  (if (member x s) s (cons x s)))