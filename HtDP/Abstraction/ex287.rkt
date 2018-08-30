;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex287) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define LIR     (list IR1 IR2 IR3))
(define LOS1
  (list "Chris" "Jennifer" "George" "Robert" "Scott" "Jesus Christ"))
(define LOS2
  (list "Logan" "Chris" "Jesus Christ" "Paul" "Satan" "Scott"))


;; Number [List-of IR] -> [List-of IR]
;; produces a list of all IRs whose sales price is below ua
(check-expect
 (eliminate-expensive 10 '()) '())
(check-expect
 (eliminate-expensive 10 LIR)
 (list IR2))

(define (eliminate-expensive ua l)
  (filter (lambda (ir) (< (ir-sprice ir) ua)) l))

;; String [List-of IR] -> [List-of IR]
;; produces a list of all IRs that do not use the name ty
(check-expect
 (recall "Box of twinkies" LIR)
 (list IR1 IR3))
(check-expect
 (recall "Supercalifragilisticexpialidocious" LIR)
 LIR)

(define (recall s l)
  (filter (lambda (ir) (not (string=? s (ir-name ir)))) l))

;; [List-of String] [List-of String] -> [List-of String]
;; selects the strings on lb that are also on la
(check-expect
 (selection LOS1 '()) '())
(check-expect
 (selection '() LOS1) '())
(check-expect
 (selection LOS1 LOS2)
 (list "Chris" "Jesus Christ" "Scott"))

(define (selection la lb)
  (filter (lambda (s) (member? s la)) lb))
          