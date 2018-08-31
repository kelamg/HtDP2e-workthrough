;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex302) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; (define x (cons 1 x))

;; Q - Where is the shaded occurrence of x bound?
;; A - It is not bounded to any binding occurence; it is a free occurence.
;;
;; Q - What should be the value of the right-hand side according to our rules?
;; A - The value of the right hand side should be a bounded occurence from a
;;     binding occurence that has previously been defined, and of a name that
;;     isn't x, or at least after renaming x