;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex397) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct employee (name number rate))
;; An EmployeeRecord is a structure:
;;    (make-employee String N Number)
;; interp. an employee has a name, employee
;;         number and pay rate

(define-struct card [number hours])
; A TimeCard is a structure: 
;   (make-card N Number)
; interp. (make-work n h) combines the employee number 
;         with the number of hours h worked per week

(define-struct wage (name amount))
;; A WageRecord is a structure:
;;   (make-wage String Number)
;; interp. combines an employee's name with their week's wage

;; EmployeeRecord* is [List-of EmployeeRecord]
;; TimeCard* is [List-of TimeCard]
;; WageRecord* is [List-of WageRecord]

(define e1 (make-employee "Robby" 3485 11.95))
(define e2 (make-employee "Shady" 8273 12.95))
(define e3 (make-employee "Nyssa" 1283 10.80))
(define e4 (make-employee "47" 4700 15.10))

(define c1 (make-card (employee-number e1) 39))
(define c2 (make-card (employee-number e2) 45))
(define c3 (make-card (employee-number e3) 40))
(define c4 (make-card 9000 37))

(define w1 (make-wage (employee-name e1) (* 11.95 39)))
(define w2 (make-wage (employee-name e2) (* 12.95 45)))
(define w3 (make-wage (employee-name e3) (* 10.80 40)))

(define le1 (list e1 e2))
(define le2 (list e1 e2 e3))
(define le3 (list e1 e2 e4))

(define lc1 (list c1 c2))
(define lc2 (list c3 c1 c2))
(define lc3 (list c1 c4 c2))


;; EmployeeRecord* TimeCard* -> [Or WageRecord* error]
;; produces a list of wage records for each employee in le,
;; signals an error if an employee record cannot be found
;; for a time card or vice versa 
(check-expect (wages*.v3 '() '()) '())
(check-error  (wages*.v3 '() `(,c1)))
(check-error  (wages*.v3 `(,e1) '()))
(check-error  (wages*.v3 le2 lc1))
(check-expect (wages*.v3 le1 lc1) (list w1 w2))
(check-expect (wages*.v3 le2 lc2) (list w3 w1 w2))
(check-error  (wages*.v3 le2 lc3))
(check-error  (wages*.v3 le3 lc2))

(define (wages*.v3 le lt)
  (local (; [X -> Y] [List-of X] -> [List-of X]
          ; sorts a list of structured items using selector
          (define (sort-struct selector l)
            (sort l (λ (x y) (< (selector x) (selector y)))))

          (define sorted-le (sort-struct employee-number le))
          (define sorted-lt (sort-struct card-number lt))

          ; Number Number -> Number
          ; computes the weekly wage from pay-rate and hours
          (define (weekly-wage pay-rate hours) (* pay-rate hours))

          ; Employee TimeCard -> Wage
          (define (pay e t)
            (if (not (= (employee-number e) (card-number t)))
                (error "unmatched records")
                (make-wage (employee-name e)
                           (weekly-wage (employee-rate e) (card-hours t)))))

          ; EmployeeRecord* TimeCard* -> [Or WageRecord* error]
          (define (main le lt)
            (cond
              [(and (empty? le) (empty? lt)) '()]
              [(or  (empty? le) (empty? lt))
               (error "employee or time card not found")]
              [else
               (cons (pay (first le) (first lt))
                     (main (rest le) (rest lt)))])))
    
    (main sorted-le sorted-lt)))
