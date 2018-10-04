;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex486) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - In the first subsection, we stated that the function f(n) = n2 + n
;;     belongs to the class O(n2). Determine the pair of numbers c and bigEnough
;;     that verify this claim.
;;
;; A -
;;     since:
;;            f E O(n^2)
;;            f(n) <= c * g(n) for all n >= n0
;;     then:
;;            n^2 + n <= c * n^2   (a)
;;
;;            (n^2 + n) / n^2 <= c
;;
;;            1 + (1 / n) <= c
;;
;;            for n = 1:
;;                       1 + (1 / 1) <= c
;;
;;                       2 <= c
;;
;;            subbing any value for which 2 <= c holds into (a):
;;                       c = 2
;;
;;            thus:
;; 
;;                  n^2 + n <= 2 * n^2
;;
;;                  n <= 2n^2 - n^2
;;
;;                  n <= n^2
;;
;;            for n = 1: 1 <= 1 holds
;;
;;     therefore:
;; 
;;                c = 2, n = 1
