;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex72) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; structure definitions

(define-struct phone# [area switch num])
;; Phone is a structure:
;;  (make-phone Integer[100, 999] Integer[100, 999] Integer[1000, 9999])
;; interp. a phone number, with:
;;         area makes up the area code
;;         switch is the phone exchange of the neighbourhood
;;         num is the phone with respect to the neighbourhood