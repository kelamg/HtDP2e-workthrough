;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex183) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(check-expect (cons "a" (list 0 #false))
              (cons "a" (cons 0 (cons #false '()))))

(check-expect (list (cons 1 (cons 13 '())))
              (cons (cons 1 (cons 13 '())) '()))

(check-expect (cons (list 1 (list 13 '())) '())
              (list (list 1 (list 13 '()))))

(check-expect (list '() '() (cons 1 '()))
              (list '() '() (list 1)))

(check-expect (cons "a" (cons (list 1) (list #false '())))
              (cons "a"
                    (cons (cons 1 '())
                          (cons #false (cons '() '())))))
