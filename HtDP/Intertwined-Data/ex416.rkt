;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex416) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define base #i10.0)

;; Number -> N
;; find the integer such that b underflows
(check-expect
 (= (expt base (add1 (underflow-n base))) #i0.0) #false)
(check-expect
 (= (expt base (underflow-n base)) #i0.0) #true)

(define (underflow-n b)
  (flow-n b sub1 #i0.0))


;; Number -> N
;; find the integer such that b overflows
(check-expect
 (= (expt base (sub1 (overflow-n base))) +inf.0) #false)
(check-expect
 (= (expt base (overflow-n base)) +inf.0) #true)

(define (overflow-n b)
  (flow-n b add1 +inf.0))

;; Number [N -> N] Number -> N
(define (flow-n b fn appr)
  (local
    (; N -> N
     (define (find-flow n)
       (if (= (expt b n) appr) n (find-flow (fn n)))))
    
    (find-flow 0)))