;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex271) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
  (local (; String -> Boolean
          ; produces true if str begins with s
          (define (starts-with? str)
            (and (<= (string-length s) (string-length str))
                 (string=?
                  s (substring str 0 (string-length s))))))
    (ormap starts-with? l)))


;; [List-of String] -> Boolean
;; produces true if all strings on l start with the letter "a"
(check-expect
 (all-startswith-a? LOS1) #f)
(check-expect
 (all-startswith-a? LOS2) #t)

(define (all-startswith-a? l)
  (local (; String -> Boolean
          ; produces true if s starts with "a"
          (define (startswith-a? s)
            (string=? "a" (substring s 0 1))))
    (andmap startswith-a? l)))

;; Should you use ormap or andmap to define a function that ensures
;; that no name on some list exceeds a given width?

;; andmap is returns true if all items in a given list
;; meet a condition, so it makes sense to use andmap.
;; That being said, you could use ormap with not to get the same
;; functionality. andmap is more straightforward though.