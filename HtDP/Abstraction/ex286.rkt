;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex286) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct ir (name desc aprice sprice))
;; An IR is a structure:
;;    (make-ir String String Number Number)
;; interp. specifies the name of an item,
;;         its description,
;;         its acquisition price,
;;         its sales price

(define IR1
  (make-ir "Male tears mug" "Feminist mug" 10 13.5))
(define IR2
  (make-ir "Box of twinkies" "Yum" 7.2 9.9))
(define IR3
  (make-ir "Mega pack of detergent pods" "Not for eating" 11.2 16))

;; [List-of IR] -> [List-of IR]
;; sort a lust of inventory records by the difference between
;; the two prices in each record (in descending order)
(check-expect
 (sort-inventory '()) '())
(check-expect
 (sort-inventory (list IR1 IR2 IR3))
 (list IR3 IR1 IR2))

(define (sort-inventory l)
  (local (; IR -> Number
          ; gets the profit in each IR
          (define (profit ir)
            (- (ir-sprice ir) (ir-aprice ir))))
    
    (sort l (lambda (a b) (> (profit a) (profit b))))))
