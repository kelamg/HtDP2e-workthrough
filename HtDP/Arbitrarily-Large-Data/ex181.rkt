;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex181) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(check-expect (cons "a" (cons "b" (cons "c" (cons "d" '()))))
              (list "a" "b" "c" "d"))

(check-expect (cons (cons 1 (cons 2 '())) '())
              (list (list 1 2)))

(check-expect (cons "a" (cons (cons 1 '()) (cons #false '())))
              (list "a" (list 1) #false))

(check-expect (cons (cons "a" (cons 2 '())) (cons "hello" '()))
              (list (list "a" 2) "hello"))

(check-expect (cons (cons 1 (cons 2 '()))
                    (cons (cons 2 '())
                          '()))
              (list (list 1 2)
                    (list 2)))