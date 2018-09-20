;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex419) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define JANUS
  (list 31.0
        #i2e+34
        #i-1.2345678901235e+80
        2749.0
        -2939234.0
        #i-2e+33
        #i3.2e+270
        17.0
        #i-2.4e+270
        #i4.2344294738446e+170
        1.0
        #i-8e+269
        0.0
        99.0))

;; [List-of Number] -> Number
;; sums up all numbers in a list
(check-expect (sum '(2 4 6 8)) 20)

(define (sum l)
  (foldl + 0 l))


(sum JANUS)

(sum (reverse JANUS))

(sum (sort JANUS <))


(exact->inexact (sum (map inexact->exact JANUS)))
