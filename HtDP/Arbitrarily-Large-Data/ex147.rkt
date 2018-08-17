;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex147) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An NEList-of-Booleans is one of: 
; – (cons Boolean '())
; – (cons Boolean NEList-of-Booleans)
; interpretation non-empty lists of booleans

(define LOB1 (cons #t '()))
(define LOB2 (cons #f '()))
(define LOB3 (cons #f (cons #t (cons #f '()))))
(define LOB4 (cons #t (cons #t (cons #t '()))))
(define LOB5 (cons #f (cons #f (cons #f '()))))

;; List-of-boolean -> Boolean
;; produces true if all elements of ne-l is #true
(check-expect (all-true LOB1) #t)
(check-expect (all-true LOB2) #f)
(check-expect (all-true LOB3) #f)
(check-expect (all-true LOB4) #t)
(check-expect (all-true LOB5) #f)

(define (all-true ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else
     (and (first ne-l)
          (all-true (rest ne-l)))]))

;; List-of-boolean -> Boolean
;; produces true if one of the elements of ne-l is #true
(check-expect (one-true LOB1) #t)
(check-expect (one-true LOB2) #f)
(check-expect (one-true LOB3) #t)
(check-expect (one-true LOB4) #t)
(check-expect (one-true LOB5) #f)

(define (one-true ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else
     (or (first ne-l)
         (one-true (rest ne-l)))]))