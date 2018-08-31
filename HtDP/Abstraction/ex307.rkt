;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex307) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define LOS1
  (list "Archilles" "Helena" "Hector" "Odisius" "Malena"))
(define LOS2
  (list "archer" "archimedes" "ares" "achmed"))

;; String [List-of String] -> String or #false
;; produces the first string on l if any of the strings on l are
;; equal to or an extension of s
(check-expect
 (find-name "Mesha" '()) #false)
(check-expect
 (find-name "Mesha" LOS1) #false)
(check-expect
 (find-name "Helena" LOS1) "Helena")
(check-expect
 (find-name "Helen" LOS1) "Helena")

(define (find-name s l)
  (for/or ([i l])
    (local (; String String -> Boolean
            (define (match? s1 s2)
              (for/and ([j i] [k s])
                (string=? j k))))
      (if (match? i s) i #false))))

;; N [List-of String] -> Boolean
;; produces true if all strings on l do not exceed length n
(check-expect
 (all-below-n?  3 LOS1) #f)
(check-expect
 (all-below-n? 11 LOS2) #t)

(define (all-below-n? n l)
  (for/and ([s l])
    (< (string-length s) n)))
