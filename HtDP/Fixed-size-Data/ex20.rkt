;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex20) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (string-insert str i)
  (if (> (string-length str) 0)
      (string-append (substring str 0 i) "_" (substring str i))
      "supplied an empty string"))

(define (string-delete str i)
  (if (> (string-length str) 0)
      (string-append (substring str 0 i) (substring str (+ i 1)))
      "supplied an empty string"))

(string-delete (string-insert "pythonbetter" 12) 12)
(string-delete "pythonbetter" 6)
(string-delete "" 12)