;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex437) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


; [List-of X] -> N
(check-expect
 (solve-length '()) 0)
(check-expect
 (solve-length '(1 3 4)) 3)
(check-expect
 (solve-length '(a b c d e)) 5)

(define (solve-length P)
  (cond
    [(empty? P) 0]
    [else (add1 (solve-length (rest P)))]))

; [List-of Number] -> [List-of Number]
(check-expect
 (solve-negate '()) '())
(check-expect
 (solve-negate '(1 3 -4 0))
 '(-1 -3 4 0))

(define (solve-negate P)
  (cond
    [(empty? P) '()]
    [else (cons (* -1 (first P))
                (solve-negate (rest P)))]))

; [List-of String] -> [List-of String]
(check-expect
 (solve-uppercase '()) '())
(check-expect
 (solve-uppercase '("he protec" "he attac"))
 '("HE PROTEC" "HE ATTAC"))

(define (solve-uppercase P)
  (cond
    [(empty? P) '()]
    [else (cons (string-upcase (first P))
                (solve-uppercase (rest P)))]))

;; Q - What do you conclude from these exercises?

;; A - The template that is used to solve problems requiring generative
;;     recursion can also be used to solve problems requiring
;;     structural recursion. I can thus conclude that structural
;;     recursion is a special form of generative recursion.
