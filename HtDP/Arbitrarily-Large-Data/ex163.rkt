;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex163) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-fahrenheit is one of:
;; - '()
;; - (cons Number List-of-fahrenheit)
;; interp. a list of fahrenheit measurements

(define LOF1 '())
(define LOF2 (cons 56 (cons 89 '())))
(define LOF3
  (cons 92 (cons 34.2 (cons 127 (cons 93.7 '())))))

#;
(define (fn-for-lof lof)
  (cond
    [(empty? lof) ...]
    [else
     (... (first lof)
          (fn-for-lof (rest lof)))]))

;; List-of-celsius is one of:
;; - '()
;; - (cons Number List-of-celsius)
;; interp. a list of celsius measurements

(define LOC1 '())
(define LOC2 (cons 13.33 (cons 31.67 '())))
(define LOC3
  (cons 33.33 (cons 1.22 (cons 52.78 (cons 34.28 '())))))


;; List-of-fahrenheit -> List-of-celsius
;; convert a list of fahrenheit measurements to celsius measurements
(check-expect (convertFC LOF1) LOC1)
(check-within (convertFC LOF2) LOC2 0.01)
(check-within (convertFC LOF3) LOC3 0.01)

(define (convertFC lof)
  (cond
    [(empty? lof) '()]
    [else
     (cons (* (- (first lof) 32) 5/9)
           (convertFC (rest lof)))]))

