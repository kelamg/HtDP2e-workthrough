;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex164) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-$amounts is one of:
;; - '()
;; - (cons Number List-of-$amounts)
;; interp. a list of amounts (in $)

;; List-of-€amounts is one of:
;; - '()
;; - (cons Number List-of-€amounts)
;; interp. a list of amounts (in €)

(define LOA1 '())
(define LOA2 (cons 10 (cons 45.5 '())))
(define LOA3
  (cons 112 (cons 34.2 (cons 127.5 (cons 93 '())))))

#;
(define (fn-for-loa loa)
  (cond
    [(empty? loa) ...]
    [else
     (... (first loa)
          (fn-for-loa (rest loa)))]))

(define RATE 1.14)

;; List-of-$amount -> List-of-€amount
;; convert a list of amounts (in $) to a list of amounts (in €)
(check-expect (convert-euro LOA1) '())
(check-within
 (convert-euro LOA2)
 (cons 11.4 (cons 51.87 '()))
 0.01)
(check-within
 (convert-euro LOA3)
 (cons 127.68 (cons 38.988 (cons 145.35 (cons 106.02 '()))))
 0.01)

(define (convert-euro loa)
  (cond
    [(empty? loa) '()]
    [else
     (cons (* (first loa) RATE)
           (convert-euro (rest loa)))]))

;; List-of-$amount Number -> List-of-€amount
;; convert a list of amounts (in $) to a list of amounts (in €)
;; using the supplied rate n
(check-expect (convert-euro* LOA1 RATE) '())
(check-within
 (convert-euro* LOA2 1.50)
 (cons 15 (cons 68.25 '()))
 0.01)
(check-within
 (convert-euro* LOA3 0.78)
 (cons 87.36 (cons 26.67 (cons 99.45 (cons 72.54 '()))))
 0.01)

(define (convert-euro* loa n)
  (cond
    [(empty? loa) '()]
    [else
     (cons (* (first loa) n)
           (convert-euro* (rest loa) n))]))

