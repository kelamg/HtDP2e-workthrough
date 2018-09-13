;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex375) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Why are you confident that your change works?
;; A - All the tests passed after making changes so I am confident
;;     that it works
;;
;; Q - Which version do you prefer?
;; A - I prefer wrapping bulletize around the branch because branching
;;     evaluates to only one statement, leaving the same result as wrapping
;;     around once in each clause.
;;     Both ways seem to lead to the same result, with one alternative
;;     requiring a bit more typing.


(require 2htdp/abstraction)
(require 2htdp/image)

; An XItem.v3 is one of: 
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (cons XWord '())))
; – (cons 'li (cons XEnum.v3 '()))
; – (cons 'li (cons [List-of Attribute] (cons XEnum.v3 '())))
; 
; An XEnum.v3 is one of:
; – (cons 'ul [List-of XItem.v3])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v3]))

(define i1 '(li (word ((text "Python")))))
(define i2 '(li (word ((text "is")))))
(define i3 '(li (word ((text "great")))))
(define i4 `(li (ul ,i1)))

(define e1 `(ul ,i1))
(define e2 `(ul ,i1 ,i2 ,i3))
(define e3 `(ul ,i2 (li ,e1)))

(define SIZE 12) ; font size 
(define COLOR "black") ; font color 
(define BT ; a graphical constant 
  (beside (circle 1 'solid 'black) (text " " SIZE COLOR)))

; for tests
(define i1-rendered (text "Python" SIZE COLOR))
(define i2-rendered (text "is" SIZE COLOR))
(define i3-rendered (text "great" SIZE COLOR))
 
; Image -> Image
; marks item with bullet
(check-expect
 (bulletize i1-rendered)
 (beside/align 'center BT i1-rendered))

(define (bulletize item)
  (beside/align 'center BT item))

; for tests
(define e1-rendered
  (above/align 'left (bulletize i1-rendered) empty-image))
(define e2-rendered
  (above/align 'left (bulletize i1-rendered)
               (above/align 'left (bulletize i2-rendered)
                            (above/align 'left (bulletize i3-rendered)
                                         empty-image))))
(define e3-rendered
  (above/align 'left
               (bulletize i2-rendered)
               (bulletize e1-rendered)))
 
; XEnum.v3 -> Image
; renders an XEnum.v3 as an image
(check-expect (render-enum e1) e1-rendered)
(check-expect (render-enum e2) e2-rendered)
(check-expect (render-enum e3) e3-rendered)

(define (render-enum xe)
  (foldr (λ (item so-far)
           (above/align 'left (render-item item) so-far))
         empty-image
         (xexpr-content xe)))

; XItem.v3 -> Image
; renders one XItem.v3 as an image
(check-expect (render-item i1) (bulletize i1-rendered))
(check-expect (render-item i4) (bulletize (render-enum e1)))

(define (render-item an-item)
  (local ((define content (first (xexpr-content an-item))))
    (if (word? content)
        (bulletize (text (word-text content) SIZE 'black))
        (bulletize (render-enum content)))))


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