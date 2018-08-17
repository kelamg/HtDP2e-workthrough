;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex68) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; flat representation

(define-struct ballf (x y deltax deltay))
;; interp. instead of:
;;         (make-ball (make-posn x y) (make-vel deltax delta y))
;;
;;         we could use a flat representation such as the struct
;;         definition above

(define a-ballf (make-ballf 30 40 -10 5))