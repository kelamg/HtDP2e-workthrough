;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex526) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define CENTER (make-posn 200 200))
(define RADIUS 200) ; the radius in pixels 
 
; Number -> Posn
; determines the point on the circle with CENTER 
; and RADIUS whose angle is 
 
; examples
; what are the x and y coordinates of the desired 
; point, when given: 120/360, 240/360, 360/360
(check-within
 (distance (circle-pt 120/360) CENTER) 200 0.0001)
(check-within
 (distance (circle-pt 240/360) CENTER) 200 0.0001)
(check-within
 (distance (circle-pt 360/360) CENTER) 200 0.0001)

(define (circle-pt factor)
  (local ((define angle (* factor (* 2 pi))))
    (make-posn (+ (posn-x CENTER) (* RADIUS (cos angle)))
               (+ (posn-y CENTER) (* RADIUS (sin angle))))))

; Posn Posn -> Number
; produces the eucledian distance between two Posns
(define (distance a b)
  (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
           (sqr (- (posn-x a) (posn-x b))))))