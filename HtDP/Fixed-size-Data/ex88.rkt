;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex88) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; more  virtual pets

(require 2htdp/image)
(require 2htdp/universe)


(define-struct track (x hap))
;; A Track is a structure:
;;   (make-track Number Number[0, 100])
;; interp. keeps track of a cat's changing variables
;;         x is the x-coordinate of the cat on the screen
;;         hap is its happiness

(define-struct vcat (img track))
;; A VCat is a structure:
;;   (make-vcat Image Track)
;; interp. a virtual cat, including its image and
;;         information about its movement and happiness
