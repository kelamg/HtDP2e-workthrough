;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex410) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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
(define team-content
  `(("Fred"  21 #false)
    ("Matt"  27 #false)
    ("Dave"  32 #false)
    ("Alice" 35 #true)))

(define school-db
  (make-db school-schema school-content))
(define team-db
  (make-db school-schema team-content))


;; DB DB -> DB
;; produces a new database with the same schema
;; and joint content of both
(check-expect
 (db-content (db-union school-db team-db))
 `(("Bob" 25 #false)
   ("Carol" 30 #true)
   ("Fred" 21 #false)
   ("Matt" 27 #false)
   ("Dave" 32 #false)
   ("Alice" 35 #true)))

(define (db-union db1 db2)
  (local ((define db1-content (db-content db1))
          (define db2-content (db-content db2))

          ; [List-of X] [List-of X] -> [List-of X]
          (define (union s1 s2)
            (cond
              [(empty? s1) s2]
              [(empty? s2) s1]
              [(member? (first s1) s2) (union (rest s1) s2)]
              [else (cons (first s1) (union (rest s1) s2))])))
    
    (make-db (db-schema db1) (union db1-content db2-content))))
          
