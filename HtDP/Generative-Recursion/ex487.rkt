;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex487) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Consider the functions f(n) = 2n and g(n) = 1000 n. Show that g
;;     belongs to O(f), which means that f is, abstractly speaking, more
;;     (or at least equally) expensive than g. If the input size is
;;     guaranteed to be between 3 and 12, which function is better?

;; A -
;;     since:
;;            g E O(f)
;;            g(n) <= c * f(n) for all n >= n0
;;     then:
;;            1000n <= c * 2^n  (a)
;;
;;            (1000n / 2^n) <= c
;;
;;            500n <= c
;;
;;            for n = 1:
;;                       500 * 1 <= c
;;
;;                       500 <= c
;;
;;            subbing any value for which 500 <= c holds into (a):
;;                       c = 500
;;
;;            thus:
;; 
;;                  1000n <= 500 * 2^n
;;
;;                  (1000n / 500) <= 2^n
;;
;;                  2n <= 2^n
;;
;;            for n = 1: 2 <= 2 holds
;;
;;     therefore:
;; 
;;                c = 500, n = 1
