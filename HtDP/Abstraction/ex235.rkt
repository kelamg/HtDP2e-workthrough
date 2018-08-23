;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex235) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; String Los -> Boolean
; determines whether l contains the string s
(define (contains? s l)
  (cond
    [(empty? l) #false]
    [else (or (string=? (first l) s)
              (contains? s (rest l)))]))

;; Los -> Boolean
;; search los for the string "atom"
(define (contains-atom? los)
  (contains? "atom" los))

;; Los -> Boolean
;; search los for the string "basic"
(define (contains-basic? los)
  (contains? "basic" los))

;; Los -> Boolean
;; search los for the string "zoo"
(define (contains-zoo? los)
  (contains? "zoo" los))
