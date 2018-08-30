;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex289) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define LOS1
  (list "Archilles" "Helena" "Hector" "Odisius" "Malena"))
(define LOS2
  (list "archer" "archimedes" "ares" "achmed"))

;; String [List-of String] -> Boolean
;; produces true if any of the strings on l are
;; equal to or an extension of s
(check-expect
 (find-name "Mesha" '()) #false)
(check-expect
 (find-name "Mesha" LOS1) #false)
(check-expect
 (find-name "Helena" LOS1) #true)

(define (find-name s l)
  (ormap
   (lambda (str)
     (and (<= (string-length s) (string-length str))
          (string=? s (substring str 0 (string-length s)))))
   l))


;; [List-of String] -> Boolean
;; produces true if all strings on l start with the letter "a"
(check-expect
 (all-startswith-a? LOS1) #f)
(check-expect
 (all-startswith-a? LOS2) #t)

(define (all-startswith-a? l)
  (andmap (lambda (s) (string=? "a" (substring s 0 1))) l))