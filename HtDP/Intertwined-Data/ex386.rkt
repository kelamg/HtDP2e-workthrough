;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex386) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


(require 2htdp/abstraction)
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

; An Xexpr.v3 is one of:
;  – Symbol
;  – String
;  – Number
;  – (cons Symbol (cons Attribute*.v3 [List-of Xexpr.v3]))
;  – (cons Symbol [List-of Xexpr.v3])
; 
; An Attribute*.v3 is a [List-of Attribute.v3].
;   
; An Attribute.v3 is a list of two items:
;   (list Symbol String)


(define PREFIX "https://www.google.com/finance?q=")
(define SIZE 22) ; font size

; 2015tesla.html test
; via wayback machine
(define TEST-FILE (read-xexpr "./2015tesla.html"))
 
(define-struct data [price delta])
; A StockWorld is a structure: (make-data String String)


; String -> StockWorld
; retrieves the stock price of co and its change every 15s
(define (stock-alert co)
  (local ((define url (string-append PREFIX co))
          
          ; Any -> StockWorld
          ; "__w" denotes a dummy parameter
          ; essentially simulates a void parameter
          (define (retrieve-stock-data __w)
            (local ((define x (read-xexpr/web url)))
              (make-data (get x "price")
                         (get x "priceChange"))))
          
          ; StockWorld -> Image 
          (define (render-stock-data w)
            (local (; [StockWorld -> String] -> Image
                    (define (word sel col)
                      (text (sel w) SIZE col)))
              
              (overlay (beside (word data-price 'black)
                               (text "  " SIZE 'white)
                               (word data-delta 'red))
                       (rectangle 300 35 'solid 'white)))))
    
    (big-bang (retrieve-stock-data 'no-use)
      [on-tick retrieve-stock-data 15]
      [to-draw render-stock-data])))

; Xexpr.v3 String -> String
; retrieves the value of the "content" attribute 
; from a 'meta element that has attribute "itemprop"
; with value s
(check-expect
  (get '(meta ((content "+1") (itemprop "F"))) "F")
  "+1")
(check-error
 (get '(meta ((content "+1") (itemprop "F"))) "G"))

(define (get x s)
  (local ((define result (get-xexpr x s)))
    (if (string? result)
        result
        (error "not found"))))

;; Xexpr.v3 String -> [Maybe String]
;; searches xe for attr and produces its value
;; produces #false if not found
(check-expect
 (get-xexpr '(meta ((content "+1") (itemprop "F"))) "F") "+1")
(check-expect
 (get-xexpr
  '(html
    (head
     (meta ((content "no-rec") (user "white")))
     (meta ((content "biwidth") (itemprop "Q")))
     (meta ((content "hit") (itemprop "Y"))))
    (body (div "nothing"))) "Y")
 "hit")
(check-expect
 (get-xexpr '(meta ((content "+1") (itemprop "F"))) "G") #false)
(check-expect
 (get-xexpr '(link ((content "+1") (itemprop "F"))) "F") #false)
(check-expect
 (get-xexpr TEST-FILE "price") "303.70")

(define (get-xexpr xe s)
  (local ((define attrs (xexpr-attr xe))
          (define found (find-attr attrs 'itemprop))
          (define hit? (if (not (false? found)) (string=? found s) #false))

          ; [List-of Xexpr.v3] -> [Maybe String]
          (define (process-content content)
            (for/or ([x content])
              (local ((define ret (get-xexpr x s)))
                (if (false? ret) #false ret)))))
                  
    (match xe
      [(cons 'meta rest) (if hit? (find-attr attrs 'content) #false)]
      [(cons sym rest)   (process-content (xexpr-content xe))])))

;; [List-of Attribute] Symbol -> [Maybe String]
;; produces the associated string with sy if sy exists in la
;; produces #false otherwise
(define (find-attr la sy)
  (local ((define found (assq sy la)))
    (if (false? found) #false (second found))))

; [List-of Attribute] or Xexpr.v2 -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else
     (local ((define possible-attribute (first x)))
       (cons? possible-attribute))]))

;; Xexpr.v3 -> Xe-Body
;; extracts the list of content elements
(define (xexpr-content xe)
  (match xe
    [(cons (? symbol?) (cons (? list-of-attributes?) body)) body]
    [(cons (? symbol?) body) body]))

; Xexpr.v2 -> [List-of Attribute]
; retrieves the list of attributes of xe
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