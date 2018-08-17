;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex104) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; vehicles

;; A PlateNumber is a String of one of:
;;   - Natural
;;   - 1String
;; interp. ABC123DE represents a plate number

(define-struct vehicle (passenger# plate# consumption))
;; A Vehicle is a structure:
;;   (make-vehicle Natural PlateNumber Number)
;; interp. a vehicle has:
;;         passenger#,  the number of passengers it can carry
;;         plate#,      its license plate number
;;         consumption, its fuel consumption

(define auto  (make-vehicle 5  "ABE542LI" 50))
(define van   (make-vehicle 15 "CAN141DA" 45))
(define buses (make-vehicle 45 "BUS420ES" 40))
(define suv   (make-vehicle 7  "FRA738PT" 28))

#;
(define (fn-for-vehicle v)
  (... (vehicle-passenger#  v)
       (vehicle-plate#      v)
       (vehicle-consumption v)))
