;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex140) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define LOB1 '())
(define LOB2 (cons #t '()))
(define LOB3 (cons #f '()))
(define LOB4 (cons #f (cons #t (cons #f '()))))
(define LOB5 (cons #t (cons #t (cons #t '()))))
(define LOB6 (cons #f (cons #f (cons #f '()))))

;; List-of-boolean -> Boolean
;; produces true if all elements of lob is #true
(check-expect (all-true LOB1) #t)
(check-expect (all-true LOB2) #t)
(check-expect (all-true LOB3) #f)
(check-expect (all-true LOB4) #f)
(check-expect (all-true LOB5) #t)

(define (all-true lob)
  (cond
    [(empty? lob) #true]
    [else
     (and (first lob)
          (all-true (rest lob)))]))

;; List-of-boolean -> Boolean
;; produces true if one of the elements of lob is #true
(check-expect (one-true LOB1) #f)
(check-expect (one-true LOB2) #t)
(check-expect (one-true LOB3) #f)
(check-expect (one-true LOB4) #t)
(check-expect (one-true LOB5) #t)
(check-expect (one-true LOB6) #f)

(define (one-true lob)
  (cond
    [(empty? lob) #false]
    [else
     (or (first lob)
         (one-true (rest lob)))]))