;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex234) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; List-of-strings -> List-of-rankings
;; ranks a list from 1 to (length los)
(define (ranking los)
  (reverse (add-ranks (reverse los))))

;; List-of-strings -> List-of-strings
;; conses the rankings together with the elements
;; of the supplied list of string los
(define (add-ranks los)
  (cond
    [(empty? los) '()]
    [else (cons (list (length los) (first los))
                (add-ranks (rest los)))]))

;; List-of-rankings -> ...nested list...
;; produces a list representation of an HTML table from
;; a list of strings los
(define one-list
  '("Asia: Heat of the Moment"
    "U2: One"
    "The White Stripes: Seven Nation Army"))

(check-expect
 (make-ranking (ranking one-list))
 `(table ((border "1"))
         ,@(make-rows (ranking one-list))))

(define (make-ranking lor)
  `(table ((border "1"))
          ,@(make-rows lor)))

;; List-of-rankings -> ...nested list...
;; build table rows from lor
(check-expect
 (make-rows
  '((1 "The Weeknd: Starboy")
    (2 "Sweely: Around")
    (3 "Pan Pot: Sleepless (Stefan Bodzin remix)")))
  '((tr (td "1") (td "The Weeknd: Starboy"))
    (tr (td "2") (td "Sweely: Around"))
    (tr (td "3") (td "Pan Pot: Sleepless (Stefan Bodzin remix)"))))

(define (make-rows lor)
  (cond
    [(empty? lor) '()]
    [else
     (cons `(tr ,@(make-cells (first lor)))
                (make-rows (rest lor)))]))
 
; Number -> ... nested list ...
; creates a cell for an HTML table from a number 
(define (make-cell n)
  `(td ,(number->string n)))

;; List-of-rankings -> ...nested list...
;; builds individual table cells
(check-expect
 (make-cells `(1 "Kendrick Lamar: Love"))
 '((td "1") (td "Kendrick Lamar: Love")))

(define (make-cells lor)
  (cond
    [(empty? lor) '()]
    [else
     (cons (if (number? (first lor))
               `(td ,(number->string (first lor)))
               `(td ,(first lor)))
           (make-cells (rest lor)))]))