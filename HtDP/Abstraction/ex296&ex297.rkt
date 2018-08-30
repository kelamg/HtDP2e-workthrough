;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex296) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Shape is a function: 
;   [Posn -> Boolean]
; interpretation if s is a shape and p a Posn, (s p) 
; produces #true if p is in s, #false otherwise

; Shape Posn -> Boolean
(check-expect (inside? (mk-point 3 4) (make-posn 3 4))
              #true)
(check-expect (inside? (mk-point 3 4) (make-posn 3 0))
              #false)

(define (inside? s p)
  (s p))

; Number Number -> Shape
; represents a point at (x,y)
(define (mk-point x y)
  (lambda (p)
    (and (= (posn-x p) x) (= (posn-y p) y))))

; Number Number Number -> Shape 
; creates a representation for a circle of radius r
;   located at (center-x, center-y)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 0)) #true)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn 0 9)) #false)
(check-expect
  (inside? (mk-circle 3 4 5) (make-posn -1 3)) #true)

(define (mk-circle center-x center-y r)
  ; [Posn -> Boolean]
  (lambda (p)
    (<= (distance-between center-x center-y p) r)))

;; Number Number Posn -> Number
;; calculate the euclidean distance between point (cx, cy) and p
(check-expect (distance-between 3 4 (make-posn 0 0)) 5)
(check-expect (distance-between 12 35 (make-posn 0 0)) 37)

(define (distance-between cx cy p)
  (sqrt (+ (sqr (- cx (posn-x p)))
           (sqr (- cy (posn-y p))))))
