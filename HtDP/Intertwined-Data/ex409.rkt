;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex409) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define school-content
  `(("Alice" 35 #true)
    ("Bob"   25 #false)
    ("Carol" 30 #true)
    ("Dave"  32 #false)))

(define school-db
  (make-db school-schema school-content))


;; DB [List-of Label] -> DB
;; produces a new projected db using labels
;; and in the order specified by labels
(check-expect
 (db-content (reorder school-db '("Age" "Present" "Name")))
 '((35 #true "Alice")
   (25 #false "Bob")
   (30 #true "Carol")
   (32 #false "Dave")))
(check-expect
 (db-content (reorder school-db '("Age" "Name")))
 '((35 "Alice")
   (25 "Bob")
   (30 "Carol")
   (32 "Dave")))
(check-expect
 (map first (db-schema (reorder school-db '("Age" "Present" "Name"))))
 '("Age" "Present" "Name"))

(define (reorder db labels)
  (local ((define schema  (db-schema  db))
          (define content (db-content db))
          (define schema-list (map first schema))

          ; Indices is a [List-of [Or N #false]]
          (define indices
            (map (λ (label) (index-of schema-list label)) labels))

          ; [List-of X] Indices -> [List-of X]
          (define (rebuild l ind)
            (foldr (λ (i rest)
                     (if (false? i) rest (cons (list-ref l i) rest)))
                   '()
                   ind)))
    
    (make-db (rebuild schema indices)
             (map (λ (row) (rebuild row indices)) content))))
