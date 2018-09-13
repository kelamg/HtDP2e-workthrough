;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex372) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)
(require 2htdp/image)

; An Xexpr is (cons Symbol Xe-Body)

; An XWord is '(word ((text String)))

;; An Xe-Body is one of:
;; - Body
;; - (cons [List-of Atrribute] Body)
;; - XWord
;; where Body is short for [List-of Xexpr]

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; An XEnum.v1 is one of: 
; – (cons 'ul [List-of XItem.v1])
; – (cons 'ul (cons Attributes [List-of XItem.v1]))
; An XItem.v1 is one of:
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons Attributes (cons XWord '())))

(define i1 '(li (word ((text "Python")))))
(define i2 '(li (word ((text "is")))))
(define i3 '(li (word ((text "great")))))

(define TEXT-COLOR 'black)
(define TEXT-SIZE      16)

(define SPACE  (square 5 'solid 'white))
(define BULLET (beside (circle 5 'solid TEXT-COLOR) SPACE))


; XItem.v1 -> Image 
; renders an item as a "word" prefixed by a bullet
(check-expect
 (render-item1 i1)
 (beside/align 'center BULLET (text "Python" TEXT-SIZE TEXT-COLOR)))
  
(define (render-item1 i)
  (local ((define content (xexpr-content i))
          (define element (first content))
          (define a-word (word-text element))
          (define item (text a-word TEXT-SIZE TEXT-COLOR)))
    (beside/align 'center BULLET item)))

;; > render-item1 takes XItem.v1, extracts the XWord from its content,
;; > converts the text in the XWord text attribute to an image,
;; > and renders it beside an image of a bullet point aligned at
;; the center

;; Xexpr.v2 -> Xe-Body
;; extracts the list of content elements
(define (xexpr-content xe)
  (match xe
    [(cons (? symbol?) (cons (? list-of-attributes?) body)) body]
    [(cons (? symbol?) body) body]))

; [List-of Attribute] or Xexpr.v2 -> Boolean
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

