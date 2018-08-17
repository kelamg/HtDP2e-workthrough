;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex81) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; more designing with structures

(define-struct time (hours minutes seconds))
;; A Time is a structure:
;;   (make-point Integer Interger Number)
;; interp. a point in time since midnight
;;         includes the number of hours, minutes and seconds
;;         since midnight

;; Time -> Number
;; produces the number of seconds that have passed since midnight
(check-expect (time->seconds (make-time 12 30 2))
              45002)

#;
(define (time->seconds t)
  (... (time-hours   t)
       (time-minutes t)
       (time-seconds t)))

(define (time->seconds t)
  (+ (* (time-hours t) 3600)
     (* (time-minutes t) 60)
     (* (time-seconds t)  1)))