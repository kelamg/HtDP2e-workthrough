;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex411) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define presence-schema
  `(("Present" ,boolean?) ("Description" ,string?)))
(define presence-content
  `((#true "presence") (#false "absence")))
(define presence-db
  (make-db presence-schema presence-content))

(define presence-content.v2
  `((#true "presence") (#true "here") (#false "absence") (#false "there")))
(define presence-db.v2
  (make-db presence-schema presence-content.v2))

;; DB DB -> DB
;; creates a database from db-1 by replacing the last cell
;; in each row with a translation which maps cells in db-2
(check-expect
 (map first (db-schema (join school-db presence-db)))
 `("Name" "Age" "Description"))
(check-expect
 (db-content (join school-db presence-db))
 `(("Alice" 35 "presence")
   ("Bob"   25 "absence")
   ("Carol" 30 "presence")
   ("Dave"  32 "absence")))
(check-expect
 (db-content (join school-db presence-db.v2))
 `(("Alice" 35 "presence")
   ("Alice" 35 "here")
   ("Bob"   25 "absence")
   ("Bob"   25 "there")
   ("Carol" 30 "presence")
   ("Carol" 30 "here")
   ("Dave"  32 "absence")
   ("Dave"  32 "there")))

(define (join db-1 db-2)
  (local ((define 1-schema  (db-schema  db-1))
          (define 1-content (db-content db-1))
          (define 2-schema  (db-schema  db-2))
          (define 2-content (db-content db-2))
          
          (define new-schema
            (append (drop-right 1-schema 1) (rest 2-schema)))

          ; Row Content -> Content
          (define (merge r l)
            (local ((define fn
                      (λ (row so-far)
                        (if (equal? (last r) (first row))
                            (cons (append (drop-right r 1) (rest row)) so-far)
                            so-far))))
              (foldr fn '() l)))
          
          (define new-content
            (local ((define fn
                      (λ (row so-far)
                        (local ((define conn (merge row 2-content)))
                          (if (empty? conn) so-far (append conn so-far))))))
              (foldr fn '() 1-content))))
    
    (make-db new-schema new-content)))
