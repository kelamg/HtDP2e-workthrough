;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex37) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String -> String/1String
; removes the first character from the given string
; given:
;    "bright" for str
; expected:
;    "right"
(define (string-rest str)
  (if (> (string-length str) 0)
      (string-append (substring str 1))
      "supplied an empty string"))

(string-rest "bright")