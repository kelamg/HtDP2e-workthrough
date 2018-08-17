;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex145) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures

; NEList-of-temperatures -> Boolean
; produces true if the temperatures are sorted in descendiing order
(check-expect (sorted>? (cons 2 '())) #t)
(check-expect (sorted>? (cons 1 (cons 2 (cons 3 '())))) #f)
(check-expect (sorted>? (cons 3 (cons 2 (cons 1 '())))) #t)
(check-expect (sorted>? (cons 1 (cons 3 (cons 2 '())))) #f)

(define (sorted>? ne-l)
  (cond
    [(empty? (rest ne-l)) #t]
    [else
     (and (> (first ne-l) (first (rest ne-l)))
          (sorted>? (rest ne-l)))]))

 