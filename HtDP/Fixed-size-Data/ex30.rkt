;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex30) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define B-ATT 120)
(define B-PRICE 5.0)
(define B-ATT-CHANGE 15)
(define B-TCENT-CHANGE 0.1)
(define FIXED-COST 180)
(define VARIABLE-COST 0.04)
(define PRICE-SENSITIVITY (/ B-ATT-CHANGE
                          B-TCENT-CHANGE))

(define (attendees ticket-price)
  (- B-ATT (* (- ticket-price B-PRICE)
                       PRICE-SENSITIVITY)))
(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))
(define (cost ticket-price)
  (+ FIXED-COST (* VARIABLE-COST (attendees ticket-price))))
(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(profit 1)
(profit 2)
(profit 3)
(profit 4)
(profit 5)