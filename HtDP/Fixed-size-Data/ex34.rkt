;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex34) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String -> 1String
; returns the first character from a non-empty string
; given:
;    "Datboi" for str
; expected:
;    "D"
(define (string-first str)
  (if (> (string-length str) 0)
      (string-ith str 0)
      "supplied an empty string"))

(string-first "Datboi")