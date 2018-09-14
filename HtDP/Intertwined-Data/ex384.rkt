;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex384) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
