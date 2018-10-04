;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex488) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Compare f(n) = n log(n) and g(n) = n^2. Does f belong to O(g) or g to O(f)?

;; A - The limit as (n log(n) / n^2) approaches 0 is:
;;
;;                  log(n)      1/n      1
;;                  ------  =   ---  =  ---
;;                     n         n       n
;;
;;     which means that n^2 grows faster.
;;
;;     Consequently, n log(n) will grow slower when n is big enough,
;;     which makes f belong to O(g).
