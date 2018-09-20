;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex415) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define base #i10.0)

;; Number -> N
;; find the integer such that b overflows
(check-expect
 (= (expt base (sub1 (overflow-n base))) +inf.0) #false)
(check-expect
 (= (expt base (overflow-n base)) +inf.0) #true)

(define (overflow-n b)
  (local (; N -> N
          (define (find-overflow n)
            (if (= (expt b n) +inf.0)
                n
                (find-overflow (add1 n)))))
    (find-overflow 1)))
