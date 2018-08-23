;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex243) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (f x) x)

(cons f '())

(f f)

(cons f (cons 10 (cons (f 10) '())))

;; ->
;;    (list function:f)
;;    function:f
;;    (list function:f 10 10)

;; These are treated similar to values in the sense that,
;; they are passed to functions the same way values are passed
;; to functions to be operated on (this can be seen in the outputs above)
;; However, they cannot be used in computations in the same way values are.