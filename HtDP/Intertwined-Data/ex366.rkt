;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex366) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

; An Xexpr.v2 is (cons Symbol Xe-Body)

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; where Body is short for [List-of Xexpr.v2]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

(define x1 '(transition ((from "seen-e") (to "seen-f"))))
(define x2 '(ul (li (word) (word)) (li (word))))

(define a0 '((initial "X")))
 
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))

; Xexpr.v2 -> [List-of Attribute]
; retrieves the list of attributes of xe
(check-expect (xexpr-attr e0) '())
(check-expect (xexpr-attr e1) '((initial "X")))
(check-expect (xexpr-attr e2) '())
(check-expect (xexpr-attr e3) '())
(check-expect (xexpr-attr e4) '((initial "X")))

(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-x
                 (first optional-loa+content)))
         (if (list-of-attributes? loa-or-x)
             loa-or-x
             '()))])))

; [List-of Attribute] or Xexpr.v2 -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else
     (local ((define possible-attribute (first x)))
       (cons? possible-attribute))]))

;; Xexpr.v2 -> Symbol
;; extracts the tag of the element representation
(check-expect (xexpr-name e0) 'machine)
(check-expect (xexpr-name e1) 'machine)
(check-expect (xexpr-name e2) 'machine)
(check-expect (xexpr-name x1) 'transition)
(check-expect (xexpr-name x2) 'ul)

(define (xexpr-name xe)
  (first xe))

;; Xexpr.v2 -> Xe-Body
;; extracts the list of content elements
(check-expect (xexpr-content e0) '())
(check-expect (xexpr-content e1) '())
(check-expect (xexpr-content e2) '((action)))
(check-expect (xexpr-content e3) '((action)))
(check-expect (xexpr-content e4) '((action) (action)))
(check-expect (xexpr-content x2) '((li (word) (word)) (li (word))))

(define (xexpr-content xe)
  (match xe
    [(cons (? symbol?) (cons (? list-of-attributes?) body)) body]
    [(cons (? symbol?) body) body]))

