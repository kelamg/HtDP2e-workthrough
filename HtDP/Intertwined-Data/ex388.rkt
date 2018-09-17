;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex388) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct employee (name ssn rate))
;; An Employee is a structure:
;;    (make-employee String N Number)
;; interp. an employee has a name, socia security
;;         number and pay rate

(define-struct work [name hours])
; A (piece of) Work is a structure: 
;   (make-work String Number)
; interp. (make-work n h) combines the name 
;         with the number of hours h

(define-struct paycheck (employee amount))
;; A Paycheck is a structure:
;;   (make-paycheck String Number)
;; interp. combines an employee's name with their week's wage

(define e1 (make-employee "Robby" 3485 11.95))
(define e2 (make-employee "Shady" 8273 12.95))
(define e3 (make-employee "Nyssa" 1283 10.80))

(define w1 (make-work (employee-name e1) 39))
(define w2 (make-work (employee-name e2) 45))
(define w3 (make-work (employee-name e3) 40))

(define p1 (make-paycheck (employee-name e1) (* 11.95 39)))
(define p2 (make-paycheck (employee-name e2) (* 12.95 45)))
(define p3 (make-paycheck (employee-name e3) (* 10.80 40)))

(define le1 (list e1 e2))
(define le2 (list e1 e2 e3))

(define lw1 (list w1 w2))
(define lw2 (list w3 w1 w2))

;; [List-of Employee] [List-of Work] -> [List-of Paycheck]
;; produces a list of paychecks for each employee in le,
;; and his/her weekly wage 
(check-expect (wages*.v2 '() '()) '())
(check-expect (wages*.v2 le1 lw1) (list p1 p2))
(check-expect (wages*.v2 le2 lw2) (list p1 p2 p3))
(check-error  (wages*.v2 le2 lw1))

(define (wages*.v2 le lw)
  (local (; Employee -> [Or Paycheck error]
          ; makes a paycheck for employee e
          (define (write-paycheck e)
            (local ((define name (employee-name e))
                    (define rate (employee-rate e))
                    (define found (find-hours e))
                    (define hours
                      (if (false? found) (error "employee not found") found)))
              (make-paycheck name (weekly-wage rate hours))))

          ; Emloyee -> [Maybe Number]
          ; finds employee e's hours in lw, else #false
          (define (find-hours e)
            (for/or ([w lw])
              (if (string=? (employee-name e) (work-name w)) (work-hours w) #f)))

          ; Number Number -> Number
          ; computes the weekly wage from pay-rate and hours
          (define (weekly-wage pay-rate hours) (* pay-rate hours)))
          
  (cond
    [(empty? le) '()]
    [else
     (cons (write-paycheck (first le))
           (wages*.v2 (rest le) lw))])))
