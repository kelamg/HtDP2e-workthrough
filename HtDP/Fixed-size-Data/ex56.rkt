;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex56) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(check-expect (end? "resting") #f)
(check-expect (end? 10) #f)
(check-expect (end? 1) #t)
(define (end? x)
  (if (number? x)
      (= x 1)
      #false))

(define (main2 s)
  (big-bang s
    [on-tick fly 0.05]
    [to-draw show]
    [on-key launch]
    [stop-when end?]))

(define (show x) empty-image)

(define (launch x ke) x)

(define (fly x) x)