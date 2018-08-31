;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex308) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct phone [area switch four])
;; A Phone is (make-phone N N N)

;; [List-of Phone] -> [List-of Phone]
;; susbtitutes the area code 713 with 281 in a list of phone records

(define input  (list (make-phone 713 664 9993)
                     (make-phone 123 782 8831)
                     (make-phone 910 235 1294)))
(define expect (list (make-phone 281 664 9993)
                     (make-phone 123 782 8831)
                     (make-phone 910 235 1294)))

(check-expect (replace input) expect)

(define (replace lop)
  (for/list ((p lop))
    (match p
      [(phone 713 s f) (make-phone 281 s f)]
      [(phone a   s f) (make-phone a   s f)])))