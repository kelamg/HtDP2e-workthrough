;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex494) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Does the insertion sort> function from Auxiliary Functions that Recur need
;;     an accumulator? If so, why? If not, why not?

;; A - Yes it does. It is very similar to invert in that it also uses an auxiliary
;;     function (insert in this case) which recurses on the entire list as well.
