;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex139) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-numbers is one of: 
; – '()
; – (cons Number List-of-numbers)

(define LON1 '())
(define LON2 (cons 5 '()))
(define LON3 (cons -1 '()))
(define LON4 (cons 45 (cons -22 (cons 3 '()))))
(define LON5 (cons 45 (cons  22 (cons 3 '()))))

; Self-reference arrow from List-of-numbers on second one-of
; to top List-of-numbers

;; List-of-numbers -> Number
;; produces true if all numbers in lon are positive
;; hence checks whether lon is an element of List-of-amounts
(check-expect (pos? LON1) true)
(check-expect (pos? LON2) true)
(check-expect (pos? LON3) false)
(check-expect (pos? LON4) false)
(check-expect (pos? LON5) true)

(define (pos? lon)
  (cond
    [(empty? lon) #t]
    [else
     (and (positive? (first lon))
          (pos? (rest lon)))]))


;; List-of-numbers -> Number
;; produces the sum of lon of lon belongs to List-of-amounts,
;; produces an error otherwise
(check-expect (checked-sum LON1) 0)
(check-expect (checked-sum LON2) 5)
(check-error  (checked-sum LON3))
(check-error  (checked-sum LON4))
(check-expect (checked-sum LON5) 70)

(define (checked-sum lon)
  (cond
    [(empty? lon) 0]
    [(pos? lon) (+ (first lon)
                   (checked-sum (rest lon)))]
    [else
     (error "checked-sum: expected a List-of-amounts, given List-of-numbers")]))

;; If sum is passed an element of List-of-numbers containing negative numbers,
;; it produces the algebraic sum; if containing all positive numbers however,
;; it produces the addition total of all the numbers