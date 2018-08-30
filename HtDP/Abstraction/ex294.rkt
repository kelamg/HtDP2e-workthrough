;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex294) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; X [List-of X] -> [Maybe N]
; determine the index of the first occurrence
; of x in l, #false otherwise
(check-satisfied (index 1 '()) (is-index? 1 '()))
(check-satisfied (index 1 '(1 3 5)) (is-index? 1 '(1 3 5)))
(check-satisfied (index 5 '(1 3 7 2 5))
                 (is-index? 5 '(1 3 7 2 5)))

(define (index x l)
  (cond
    [(empty? l) #false]
    [else (if (equal? (first l) x)
              0
              (local ((define i (index x (rest l))))
                (if (boolean? i) i (+ i 1))))]))

; X [List-of X] -> Boolean
; is n the index of the first occurence of x in l
(check-expect ((is-index? 1 '()) 0)  #false)
(check-expect ((is-index? 1 '()) #f)  #true)
(check-expect ((is-index? 5 '(1 3 7 2 5)) 0) #false)
(check-expect ((is-index? 5 '(1 3 7 2 5)) 5) #false)
(check-expect ((is-index? 5 '(1 3 7 2 5)) 4)  #true)

(define (is-index? x l)
  (lambda (n)
    (cond
      [(false? n) (not (member? x l))]
      [(> n (sub1 (length l))) #false]
      [else (= x (list-ref l n))])))