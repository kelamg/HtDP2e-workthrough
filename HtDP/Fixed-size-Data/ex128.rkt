;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex128) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(check-member-of "green" "red" "yellow" "grey")   ; 1
(check-within (make-posn #i1.0 #i1.1)
              (make-posn #i0.9 #i1.2)  0.01)      ; 2
(check-range #i0.9 #i0.6 #i0.8)                   ; 3
(check-random (make-posn (random 3) (random 9)) 
              (make-posn (random 9) (random 3)))  ; 4
(check-satisfied 4 odd?)                          ; 5


;; All tests failed

;; 1 fails because "green" is not a member of "red" "yellow" and "grey"

;; 2 fails because the result is not within epsilon, 0.01

;; 3 fails because #i0.9 does not satisfy #i0.6 <= #i0.9 <= #i0.8

;; 4 fails because the interchanged orders of constructor definition
;; causes a difference in expected outcome

;; 5 fails because 4 does not return #t when supplied as an argument to odd?