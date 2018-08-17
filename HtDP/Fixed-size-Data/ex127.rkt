;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex127) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct ball [x y speed-x speed-y])

(number? (make-ball 1 2 3 4)) ; 1

(ball-speed-y (make-ball (+ 1 2) (+ 3 3) 2 3)) ; 2

(ball-y (make-ball (+ 1 2) (+ 3 3) 2 3)) ; 3

(ball-x (make-posn 1 2)) ; 4

(ball-speed-y 5) ; 5


;; 1 is #false

;; 2 is 3

;; 3 is 6

;; 4 is error

;; 5 is error