;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname ex14) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(define (string-last str)
  (if (> (string-length str) 0)
      (string-ith str (- (string-length str) 1))
      "supplied an empty string"))

(string-last "I am programmer")