;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex29) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define base-attendees 120)
(define base-price 5.0)
(define base-attendance-change 15)
(define base-ten-cent-change 0.1)
(define fixed-cost 180)
(define variable-cost 1.50)

(define (attendees ticket-price)
  (- base-attendees (* (- ticket-price base-price)
                       (/ base-attendance-change
                          base-ten-cent-change))))

(define (cost ticket-price)
  (* variable-cost (attendees ticket-price)))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define (profit-3 ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(profit-3 3)
(profit-3 4)
(profit-3 5)

(define (profit-4 price)
  (- (* (+ 120
           (* (/ 15 0.1)
              (- 5.0 price)))
        price)
      (* 0.04
         (+ 120
            (* (/ 15 0.1)
               (- 5.0 price))))))

(profit-4 3)
(profit-4 4)
(profit-4 5)