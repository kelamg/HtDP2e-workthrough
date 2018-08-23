;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex253) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [Number -> Boolean]
(odd?    42)
(even?   42)
(number? 42)

; [Boolean String -> Boolean]
(define (? b s) #f)

(? #false "suh dude")

; [Number Number Number -> Number]
(max 1 3 7)
(min 1 3 7)

; [Number -> [List-of Number]]
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else
     (cons
      (sin n)
      (tab-sin (sub1 n)))]))

; [[List-of Number] -> Boolean]
(define (contains-1? l)
  (cond
    [(empty? l) #f]
    [else (or (= 1 (first l))
              (contains-1? (rest l)))]))