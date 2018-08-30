;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex295) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; distances in terms of pixels 
(define WIDTH 300)
(define HEIGHT 300)
 
; N -> [List-of Posn]
; generates n random Posns in [0,WIDTH) by [0,HEIGHT)
(check-satisfied (random-posns 3)
                 (n-inside-playground? 3))
(check-satisfied (random-posns 6)
                 (n-inside-playground? 6))

(define (random-posns n)
  (build-list
    n
    (lambda (i)
      (make-posn (random WIDTH) (random HEIGHT)))))

;; N -> Boolean
;; produces true if length of l is within n and
;; all Posns in l are within a WIDTH by HEIGHT rectangle
(check-expect ((n-inside-playground? 3) '()) #false)
(check-expect
 ((n-inside-playground? 3) (list (make-posn 30 50))) #false)
(check-expect
 ((n-inside-playground? 3)
  (list (make-posn 300 50) (make-posn 50 100) (make-posn 10 5)))
 #false)
(check-expect
 ((n-inside-playground? 3)
  (list (make-posn 30 50) (make-posn 50 100) (make-posn 299 299)))
 #true)

(define (n-inside-playground? n)
  (λ (l)
    (and (= n (length l))
         (andmap (λ (p)
                   (and (> (posn-x p) 0)
                        (< (posn-x p) WIDTH)
                        (> (posn-y p) 0)
                        (< (posn-y p) HEIGHT)))
                 l))))

; N -> [List-of Posn]
; generates n random Posns in [0,WIDTH) by [0,HEIGHT)
(check-satisfied (random-posns/bad 3)
                 (n-inside-playground? 3))
(check-satisfied (random-posns 6)
                 (n-inside-playground? 6))

(define (random-posns/bad n)
  (build-list
    n
    (lambda (i)
      (make-posn 50 50))))
