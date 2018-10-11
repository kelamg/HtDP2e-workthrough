;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex528) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)

(define MT (empty-scene 400 400))
(define A  (make-posn 200  50))
(define B  (make-posn  27 350))
(define C  (make-posn 373 350))

(define TRIVIAL  0.5)
(define CLR     'red)

; Image Posn Posn Posn -> Image
; draws a curve from a to c from the perspective of b

(define (draw-curve img a b c)
  (cond
    [(<= (distance a c) TRIVIAL) img]
    [else
     (local ((define mid-ab  (mid-point a b))
             (define mid-bc  (mid-point b c))
             (define mid-abc (mid-point mid-ab mid-bc))
             (define ab-line
               (scene+line img
                           (posn-x a) (posn-y a)
                           (posn-x a) (posn-y a)
                           CLR))
             (define bc-line
               (draw-curve ab-line a mid-ab mid-abc)))
       (draw-curve bc-line mid-abc mid-bc c))]))

; Posn Posn -> Number
; produces the eucledian distance between two Posns
(define (distance a b)
  (sqrt (+ (sqr (- (posn-y a) (posn-y b)))
           (sqr (- (posn-x a) (posn-x b))))))
 
; Posn Posn -> Posn 
; determines the midpoint between a and b
(define (mid-point a b)
  (make-posn (* 0.5 (+ (posn-x a) (posn-x b)))
             (* 0.5 (+ (posn-y a) (posn-y b)))))

; uncomment to draw curve
(draw-curve MT A B C)

