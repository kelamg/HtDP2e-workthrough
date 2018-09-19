;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex404) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; [X Y -> Boolean] [List-of X] [List-of Y] -> Boolean
;; produces #true if f returns true for all corresponding values of both lists
(check-expect (andmap2 = '(1 3 5) '(2 3 5)) #false)
(check-expect (andmap2 = '(1 3 5) '(1 3 5))  #true)

(define (andmap2 f la lb)
  (cond
    [(empty? la) #true]
    [else (and (f (first la) (first lb))
               (andmap2 f (rest la) (rest lb)))]))