;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex124) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define PRICE 5)
(define SALES-TAX (* 0.08 PRICE))
(define TOTAL (+ PRICE SALES-TAX))

(define PRICE 5)

(define SALES-TAX (* 0.08 PRICE))

(define SALES-TAX (* 0.08 5))

(define SALES-TAX 0.4)

(define TOTAL (+ PRICE SALES-TAX))

(define TOTAL (+ 5 0.4))

(define TOTAL 5.4)

;; ===================================

(define COLD-F 32)
(define COLD-C (fahrenheit->celsius COLD-F))
(define (fahrenheit->celsius f)
  (* 5/9 (- f 32)))

(define COLD-F 32)

(define COLD-C (fahrenheit->celsius COLD-F))

(define COLD-C (fahrenheit->celsius 32))

(define COLD-C (* 5/9 (- 32 32)))

(define COLD-C (* 5/9 0))

(define COLD-C 0)

;; No errors signaled

;; ===================================

(define LEFT -100)
(define RIGHT 100)
(define (f x) (+ (* 5 (expt x 2)) 10))
(define f@LEFT (f LEFT))
(define f@RIGHT (f RIGHT))

(define LEFT -100)

(define RIGHT 100)

(define (f x) (+ (* 5 (expt x 2)) 10))

(define f@LEFT (f LEFT))

(define f@LEFT (f -100))

(define f@LEFT (+ (* 5 (expt -100 2)) 10))

(define f@LEFT (+ (* 5 10000) 10))

(define f@LEFT (+ 50000 10))

(define f@LEFT 50010)

(define f@RIGHT (f RIGHT))

(define f@RIGHT (f 100))

(define f@RIGHT (+ (* 5 (expt 100 2)) 10))

(define f@RIGHT (+ (* 5 10000) 10))

(define f@RIGHT (+ 50000 10))

(define f@RIGHT 50010)

;; No errors signaled