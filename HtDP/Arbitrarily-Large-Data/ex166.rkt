;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex166) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct work [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work String Number Number)
; interpretation (make-work n r h) combines the name 
; with the pay rate r and the number of hours h

; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees

(define-struct paycheck (employee amount))
;; A Paycheck is a structure:
;;   (make-paycheck String Number)
;; interp. combines an employee's name with their week's wage

;; Lop (short for list of paychecks) is one of:
;; - '()
;; - (cons Paycheck Lop)
;; interp. an instance of lop represents a number of employees
;; and the amounts paid to them for hours worked

(define LOW1 '())
(define LOW2 (cons (make-work "Robby" 11.95 39) '()))
(define LOW3 (cons (make-work "Matthew" 12.95 45)
                   (cons (make-work "Robby" 11.95 39) '())))
(define LOW4
  (cons (make-work "Jerry" 10.80 50)
        (cons (make-work "Nyssa" 13.50 40)
              (cons (make-work "Justin" 12.50 60) '()))))
(define LOW5
  (cons (make-work "Bruce" 12 101)
        (cons (make-work "Hommer" 10.20 30) '())))

; Low -> List-of-numbers
; computes the weekly wages for the given records
(check-expect (wage*.v2 LOW1) '())
(check-expect (wage*.v2 LOW2)
              (cons (* 11.95 39) '()))
(check-expect (wage*.v2 LOW3)
              (cons (* 12.95 45)
                    (cons (* 11.95 39) '())))
(check-expect (wage*.v2 LOW4)
              (cons (* 10.80 50)
                    (cons (* 13.50 40)
                          (cons (* 12.50 60) '()))))
(check-expect (wage*.v2 LOW5)
              (cons (* 12 101)
                    (cons (* 10.20 30) '())))

(define (wage*.v2 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low) (cons (wage.v2 (first an-low))
                          (wage*.v2 (rest an-low)))]))

; Work -> Number
; computes the wage for the given work record w
(define (wage.v2 w)
  (* (work-rate w) (work-hours w)))

;; Low -> Lop
;; computes the weekly paychecks for the given record
(check-expect (wage*.v3 LOW1) '())
(check-expect (wage*.v3 LOW2)
              (cons (make-paycheck "Robby" (* 11.95 39)) '()))
(check-expect (wage*.v3 LOW3)
              (cons (make-paycheck "Matthew" (* 12.95 45))
                    (cons (make-paycheck "Robby" (* 11.95 39)) '())))
(check-expect (wage*.v3 LOW4)
              (cons (make-paycheck "Jerry" (* 10.80 50))
                    (cons (make-paycheck "Nyssa" (* 13.50 40))
                          (cons (make-paycheck "Justin" (* 12.50 60)) '()))))
(check-expect (wage*.v3 LOW5)
              (cons (make-paycheck "Bruce" (* 12 101))
                    (cons (make-paycheck "Hommer" (* 10.20 30)) '())))

(define (wage*.v3 low)
  (cond
    [(empty? low) '()]
    [else
     (cons (make-paycheck (work-employee (first low))
                          (wage.v3 (first low)))
           (wage*.v3 (rest low)))]))

; Work -> Number
; computes the wage for the given work record w
(define (wage.v3 w)
  (* (work-rate w) (work-hours w)))


(define-struct employee (name number))
;; An Employee is a structure:
;;    (make-employee String Natural)
;; interp. (make-employee s n) is an employee with name s
;;         and employee number n

(define-struct ework [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work Employee Number Number)
; interpretation (make-work n r h) combines the employee 
; with the pay rate r and the number of hours h

; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees

(define-struct epaycheck (employee amount))
;; A Paycheck is a structure:
;;   (make-paycheck Employee Number)
;; interp. combines an employee with his/her week's wage

;; Lop (short for list of paychecks) is one of:
;; - '()
;; - (cons Paycheck Lop)
;; interp. an instance of lop represents a number of employees
;; and the amounts paid to them for hours worked

(define E1 (make-employee "Robby" 40))
(define E2 (make-employee "Matthew" 12))
(define E3 (make-employee "Jerry" 5))
(define E4 (make-employee "Nyssa" 98))
(define E5 (make-employee "Justin" 55))
(define E6 (make-employee "Bruce" 73))
(define E7 (make-employee "Hommer" 26))

(define LOWE1 '())
(define LOWE2 (cons (make-ework E1 11.95 39) '()))
(define LOWE3 (cons (make-ework E2 12.95 45)
                   (cons (make-ework E1 11.95 39) '())))
(define LOWE4
  (cons (make-ework E3 10.80 50)
        (cons (make-ework E4 13.50 40)
              (cons (make-ework E5 12.50 60) '()))))
(define LOWE5
  (cons (make-ework E6 12 101)
        (cons (make-ework E7 10.20 30) '())))

; Work -> Number
; computes the wage for the given work record w
(define (wage.v4 we)
  (* (ework-rate we) (ework-hours we)))

;; Low -> Lop
;; computes the weekly paychecks for the given record
(check-expect (wage*.v4 LOWE1) '())
(check-expect (wage*.v4 LOWE2)
              (cons (make-epaycheck E1 (* 11.95 39)) '()))
(check-expect (wage*.v4 LOWE3)
              (cons (make-epaycheck E2 (* 12.95 45))
                    (cons (make-epaycheck E1 (* 11.95 39)) '())))
(check-expect (wage*.v4 LOWE4)
              (cons (make-epaycheck E3 (* 10.80 50))
                    (cons (make-epaycheck E4 (* 13.50 40))
                          (cons (make-epaycheck E5 (* 12.50 60)) '()))))
(check-expect (wage*.v4 LOWE5)
              (cons (make-epaycheck E6 (* 12 101))
                    (cons (make-epaycheck E7 (* 10.20 30)) '())))

(define (wage*.v4 lowe)
  (cond
    [(empty? lowe) '()]
    [else
     (cons (make-epaycheck
            (ework-employee (first lowe))
            (wage.v4 (first lowe)))
           (wage*.v4 (rest lowe)))]))