;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex64) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Manhattan distance

;; Position (posn) -> Natural
;; measures the manhattan distance of the given posn to the origin
(check-expect (manhattan-distance (make-posn 3 4))   7)
(check-expect (manhattan-distance (make-posn 14 6)) 20)

(define (manhattan-distance p)
  (+ (posn-x p) (posn-y p)))