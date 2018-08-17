;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex134) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-string is one of: 
; – '()
; – (cons String List-of-string)
; interpretation a list of strings

; List-of-string -> Boolean
; determines whether s is in los
(check-expect (contains? "Flatt" '()) #false)
(check-expect (contains? "Elliot" (cons "Darlene" '()))
              #false)
(check-expect (contains? "Whiterose" (cons "Whiterose" '()))
              #true)
(check-expect (contains?
               "Elliot"
               (cons "Darlene"
                     (cons "Tyrell"
                           (cons "Elliot" '()))))
              #true)
(check-expect (contains?
               "Elliot"
               (cons "Darlene"
                     (cons "fsociety"
                           (cons "Whiterose" '()))))
              #false)


(define (contains? s los)
  (cond
    [(empty? los) #false]
    [else
     (or (string=? (first los) s)
         (contains? s (rest los)))]))