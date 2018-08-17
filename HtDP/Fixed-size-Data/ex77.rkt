;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex77) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; more data universe

(define-struct time (hours minutes seconds))
;; A Time is a structure:
;;   (make-point Integer Interger Number)
;; interp. a point in time since midnight
;;         includes the number of hours, minutes and seconds
;;         since midnight


