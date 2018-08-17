;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex67) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define SPEED 3)

(define-struct balld [location direction])

(make-balld 10 "up")

;; interp. a balld is a representation of a ball, with
;;         location, its distance from the top of the canvas
;;         direction, the current direction of movement of the ball


(define a-ball (make-balld 5 "down"))

(define another-ball (make-balld 120 "up"))