;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


; [List-of Number] [X X -> Boolean] -> [List-of Number]
; produces a sorted version of alon based on cmp
; assume the numbers are all distinct
(check-expect
 (quick-sort< '() <) '())
(check-expect
 (quick-sort< '(1) <) '(1))
(check-expect
 (quick-sort< (list 11 8 14 7) <)
 '(7 8 11 14))
(check-expect
 (quick-sort< (list 11 9 2 18 12 14 4 1) <)
 (list 1 2 4 9 11 12 14 18))
(check-expect
 (quick-sort< (list 1 1 11 1 9 2 18 1 12 14 4 1) <)
 (list 1 1 1 1 1 2 4 9 11 12 14 18))
(check-expect
 (quick-sort< (list 1 1 11 1 9 2 18 1 12 14 4 1) >)
 (reverse (list 1 1 1 1 1 2 4 9 11 12 14 18)))

(define (quick-sort< alon cmp)     
  (cond
    [(empty? alon) '()]
    [(empty? (rest alon)) alon]
    [else (local ((define pivot (first alon))
                  (define to-sort (rest alon))
                  (define left? (λ (n) (cmp n pivot)))
                  (define right? (λ (n) (not (cmp n pivot)))))
            
            (append (quick-sort< (filter left? to-sort) cmp)
                    (list pivot)
                    (quick-sort< (filter right? to-sort) cmp)))]))
