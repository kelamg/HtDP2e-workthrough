;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex113) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; formulate predicates

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game

;; Any -> Boolean
;; is s a member of SIGS?
(define (is-sigs? s)
  (cond
    [(or (aim? s)
         (fired? s)) #t]
    [else #f]))

;; ==================================================

; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point

;; Any -> Boolean
;; is c a Coordinate?
(define (is-coordinate? c)
  (cond
    [(number? c) #t]
    [(posn? c)   #t]
    [else #f]))

;; ===================================================

(define-struct track (x hap))
;; A Track is a structure:
;;   (make-track Number Number[0, 100])
;; interp. keeps track of a vanimal's changing variables
;;         x is the x-coordinate of the vanimal on the screen
;;         hap is its happiness

(define-struct vcat (img track))
;; A VCat is a structure:
;;   (make-vcat Image Track)
;; interp. a virtual cat, including its image and
;;         information about its movement and happiness

(define-struct vcham (color img track))
;; A VCham is a structure:
;;   (make-vcham Color Image Track)
;; interp. a virtual chameleon, including its color, image and
;;         information about its movement and happiness

; A VAnimal is either
; – a VCat
; – a VCham

;; Any -> Boolean
;; is va a VAnimal?
(define (is-vanimal? va)
  (cond
    [(or (vcat? va)
         (vcham? va)) #t]
    [else #f]))
