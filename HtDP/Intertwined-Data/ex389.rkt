;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex389) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct phone-record [name number])
; A PhoneRecord is a structure:
;   (make-phone-record String String)

;; Names is [List-of String]

;; PhoneNumbers is [List-of String]

;; Names PhoneNumbers -> [List-of PhoneRecord]
;; combines both lists into a list of phone records
(check-expect
 (zip '() '()) '())
(check-expect
 (zip '("Shady" "Dre" "Kim") '("032-384-3744" "823-824-1287" "238-492-0853"))
 (list (make-phone-record "Shady" "032-384-3744")
       (make-phone-record "Dre" "823-824-1287")
       (make-phone-record "Kim" "238-492-0853")))

(define (zip lon lopn)
  (cond
    [(empty? lon) '()]
    [else (cons (make-phone-record (first lon) (first lopn))
                (zip (rest lon) (rest lopn)))]))
