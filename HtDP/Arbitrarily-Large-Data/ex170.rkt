;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex170) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct phone [area switch four])
; A Phone is a structure: 
;   (make-phone Three Three Four)
; A Three is a Number between 100 and 999. 
; A Four is a Number between 1000 and 9999.

;; List-of-phones -> List-of-phones
;; produces list with all occurences of area code 713
;; replaced with 281
(check-expect (replace '()) '())
(check-expect (replace
               (cons (make-phone 321 871 7283) '()))
              (cons (make-phone 321 871 7283) '()))
(check-expect (replace
               (cons (make-phone 321 713 7283)
                     (cons (make-phone 713 874 7132) '())))
              (cons (make-phone 321 713 7283)
                     (cons (make-phone 281 874 7132) '())))

(define (replace lop)
  (cond
    [(empty? lop) '()]
    [else
     (cons (replace/not (first lop) 281)
           (replace (rest lop)))]))

;; Phone Three -> Phone
;; replaces the area code of p with t if area code is 713
(check-expect (replace/not (make-phone 713 542 1839) 512)
              (make-phone 512 542 1839))
(check-expect (replace/not (make-phone 975 542 1839) 281)
              (make-phone 975 542 1839))

(define (replace/not p t)
  (if (= (phone-area p) 713)
      (make-phone t
                  (phone-switch p)
                  (phone-four p))
      p))
