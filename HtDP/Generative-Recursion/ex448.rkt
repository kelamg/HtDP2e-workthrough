;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex448) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - The find-root algorithm terminates for all (continuous) f, left,
;;     and right for which the assumption holds. Why? Formulate a
;;     termination argument.

;; A - As long as the assumption holds, the algorithm terminates because
;;     the interval size, a positive number, is halved on each iteration.
;;     As long as epsilon is positive, it will eventually reach a number
;;     close to epsilon.
