;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex261) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct ir [name price])
; An IR is a structure:
;   (make-IR String Number)

; An Inventory is [List-of ir]

(define LIR1
  (list (make-ir "Jack Daniels" 3.21)
        (make-ir "Twinkies" 0.72)
        (make-ir "Game of Thrones Season 1" 7.99)
        (make-ir "Fly Swatter" 0.92)
        (make-ir "Rope" 3.98)
        (make-ir "Adderall" 5.50)
        (make-ir "Male Tears mug" 4.99)
        (make-ir "Amazon Gift Card" 10.00)
        (make-ir "Back scratcher" 0.99)
        (make-ir "Demon got me T-shirt" 1.00)))
        

; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(check-expect
 (extract1 LIR1)
 (list (make-ir "Twinkies" 0.72)
       (make-ir "Fly Swatter" 0.92)
       (make-ir "Back scratcher" 0.99)
       (make-ir "Demon got me T-shirt" 1.00)))

(define (extract1 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (cond
       [(<= (ir-price (first an-inv)) 1.0)
        (cons (first an-inv) (extract1 (rest an-inv)))]
       [else (extract1 (rest an-inv))])]))

; Inventory -> Inventory
; creates an Inventory from an-inv for all
; those items that cost less than a dollar
(check-expect
 (extract1.v2 LIR1)
 (list (make-ir "Twinkies" 0.72)
       (make-ir "Fly Swatter" 0.92)
       (make-ir "Back scratcher" 0.99)
       (make-ir "Demon got me T-shirt" 1.00)))

(define (extract1.v2 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else
     (local [(define extract-from-rest
                 (extract1.v2 (rest an-inv)))]
       (cond 
         [(<= (ir-price (first an-inv)) 1.0)
          (cons (first an-inv) extract-from-rest)]
         [else extract-from-rest]))]))

;; local does not offer any significant performance improval here at all.
;; This is so because (extract1.v2 (rest an-inv)) is only ever called once
;; on each recursive call to begin with (it is called in the first or second
;; clause of the nested cond expression), and thus using local offers
;; no significant benefit.
