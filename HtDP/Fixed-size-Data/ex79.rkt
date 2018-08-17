;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex79) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; even more data universe

; A Color is one of: 
; — "white"
; — "yellow"
; — "orange"
; — "green"
; — "red"
; — "blue"
; — "black"

(define RED "red")
(define BLUE "blue")
(define ORANGE "orange")

;; ===================================

; H is a Number between 0 and 100.
; interpretation represents a happiness value

(define H1   0)
(define H2  50)
(define H3 100)

;; ===================================

(define-struct person [fstname lstname male?])
; A Person is a structure:
;   (make-person String String Boolean)

(define P1 (make-person "Mikel" "Iromaka" #true))
(define P2 (make-person "Sarah" "Iromaka" #false))

;; ===================================

(define-struct dog [owner name age happiness])
; A Dog is a structure:
;   (make-dog Person String PositiveInteger H)
; interp. a dog. A dog has:
;         an owner, a Person (make-person String String Boolean)
;         a name, an age and a happiness level, H, Number[0, 100]

(define D1 (make-dog P1 "Jerry" 2 100))
(define D2 (make-dog
            (make-person "Jonny" "Red" #true)
            "Rex"
            12
            45))

;; ====================================

; A Weapon is one of: 
; — #false
; — Posn
; interpretation #false means the missile hasn't 
; been fired yet; a Posn means it is in flight

(define W1 false)
(define W2 (make-posn 3 6))
