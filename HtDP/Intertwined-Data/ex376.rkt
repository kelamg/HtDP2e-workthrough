;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex376) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; An Xexpr is (cons Symbol Xe-Body)

; An XWord is '(word ((text String)))

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; - XWord
;; where Body is short for [List-of Xexpr]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; An XItem.v2 is one of: 
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (list XWord)))
; – (cons 'li (cons XEnum.v2 '()))
; – (cons 'li (cons [List-of Attribute] (list XEnum.v2)))
; 
; An XEnum.v2 is one of:
; – (cons 'ul [List-of XItem.v2])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v2]))

(define i1 '(li (word ((text "I just came")))))
(define i2 '(li (word ((text "to say")))))
(define i3 '(li (word ((text "hello")))))

(define e1 `(ul ,i1))
(define e2 `(ul ,i1 ,i2))
(define e3 `(ul ,i1 ,i2 ,i3))
(define e4 `(ul ,i1 (ul ,i2 ,i3 ,i3)))


;; XEnum.v2 -> N
;; produces the number of "hello"s in xe
(check-expect (count-hellos e1) 0)
(check-expect (count-hellos e2) 0)
(check-expect (count-hellos e3) 1)
(check-expect (count-hellos e4) 2)

(define (count-hellos xe)
  (for/sum ([expr (xexpr-content xe)])
    (match expr
      [`(li (word ((text "hello")))) 1]
      [(cons 'ul rest) (count-hellos expr)]
      [else 0])))

;; Xexpr.v3 -> Xe-Body
;; extracts the list of content elements
(define (xexpr-content xe)
  (match xe
    [(cons (? symbol?) (cons (? list-of-attributes?) body)) body]
    [(cons (? symbol?) body) body]))

; [List-of Attribute] or Xexpr.v3 -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else
     (local ((define possible-attribute (first x)))
       (cons? possible-attribute))]))

;; Any -> Boolean
;; is a in XWord
(define (word? a)
  (match a
    [`(word ((text ,s))) #true]
    [else #false]))

;; XWord -> String
;; extracts the value xw
(define (word-text xw)
  (second (first (second xw))))
  