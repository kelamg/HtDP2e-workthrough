;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex138) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-amounts is one of: 
; – '()
; – (cons PositiveNumber List-of-amounts)

(define LOA1 '())
(define LOA2 (cons 3 '()))
(define LOA3 (cons 45 (cons 22 (cons 3 '()))))

; Self-reference arrow from List-of-amounts on second one of
; to top List-of-amounts

;; List-of-amounts -> Number
;; produces the sum of the amounts in loa
(check-expect (sum LOA1) 0)
(check-expect (sum LOA2) 3)
(check-expect (sum LOA3) 70)

(define (sum loa)
  (cond
    [(empty? loa) 0]
    [else
     (+ (first loa)
        (sum (rest loa)))]))