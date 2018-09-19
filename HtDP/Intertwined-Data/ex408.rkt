;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex408) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require racket/list)

(define-struct db [schema content])
; A DB is a structure:
;   (make-db Schema Content)
 
; A Schema is a [List-of Spec]
; A Spec is a [List Label Predicate]
; A Label is a String
; A Predicate is a [Any -> Boolean]
 
; A (piece of) Content is a [List-of Row]
; A Row is a [List-of Cell]
; A Cell is Any
; constraint cells do not contain functions 
 
; integrity constraint In (make-db sch con), 
; for every row in con,
; (I1) its length is the same as sch's, and
; (I2) its ith Cell satisfies the ith Predicate in sch


(define school-schema
  `(("Name" ,string?) ("Age" ,integer?) ("Present" ,boolean?)))

(define projected-schema
  `(("Name" ,string?) ("Present" ,boolean?)))

(define school-content
  `(("Alice" 35 #true)
    ("Bob"   25 #false)
    ("Carol" 30 #true)
    ("Dave"  32 #false)))

(define projected-content
  `(("Alice" #true)
    ("Bob"   #false)
    ("Carol" #true)
    ("Dave"  #false)))

(define school-db
  (make-db school-schema school-content))

(define projected-db
  (make-db projected-schema projected-content))

;; DB [List-of Label] [Row -> Boolean] -> Content
;; produces a list of rows that satisfy p?
(define 30-and-above? (λ (r) (>= (second r) 30)))
(define end-in-e? (λ (r) (string=? (last (explode (first r))) "e")))
(define present? (λ (r) (not (false? (last r)))))

(check-expect
 (select school-db '("Name" "Age") 30-and-above?)
 '(("Alice" 35) ("Carol" 30) ("Dave" 32)))
(check-expect
 (select school-db '("Name" "Present") 30-and-above?)
 '(("Alice" #true) ("Carol" #true) ("Dave" #false)))
(check-expect
 (select school-db '("Name") end-in-e?)
 '(("Alice") ("Dave")))
(check-expect
 (select school-db '("Name" "Age") present?)
 '(("Alice" 35) ("Carol" 30)))

(define (select db labels p?)
  (db-content
   (project (make-db (db-schema db) (filter p? (db-content db))) labels)))


; DB [List-of Label] -> DB
; retains a column from db if its label is in labels
(check-expect
  (db-content (project school-db '("Name" "Present")))
  projected-content)

(define (project db labels)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
 
          ; Spec -> Boolean
          ; does this column belong to the new schema
          (define (keep? c)
            (member? (first c) labels))
 
          ; Row -> Row 
          ; retains those columns whose name is in labels
          (define (row-project row)
            (foldr (lambda (cell m c) (if m (cons cell c) c))
                   '()
                   row
                   mask))
          (define mask (map keep? schema)))
    
    (make-db (filter keep? schema)
             (map row-project content))))

