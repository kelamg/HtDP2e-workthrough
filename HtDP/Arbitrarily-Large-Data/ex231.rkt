;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex231) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(check-expect
 '(1 "a" 2 #false 3 "c")
 (list 1 "a" 2 #false 3 "c"))

(check-expect
 '()
 (list))

(check-expect
 '(("alan" 1000)
   ("barb" 2000)
   ("carl" 1500))
 (cons (cons "alan" (cons 1000 '()))
       (cons (cons "barb" (cons 2000 '()))
             (cons (cons "carl" (cons 1500 '()))
                   '()))))
