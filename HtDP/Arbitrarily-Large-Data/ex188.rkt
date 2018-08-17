;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex188) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct email [from date message])
; An Email Message is a structure: 
;   (make-email String Number String)
; interpretation (make-email f d m) represents text m 
; sent by f, d seconds after the beginning of time 

(define E1
  (make-email "Freddie" 2017 "Come in on Monday."))
(define E2
  (make-email "Yaeji" 2004 "Can't wait for the Ri concert!"))
(define E3
  (make-email "Trev" 2013 "Oh boy"))

(define LOE1 (list E1 E2))
(define LOE2 (list E1 E3))
(define LOE3 (list E2 E3))
(define LOE4 (list E1 E2 E3))

#;
(define (fn-for-email e)
  (... (email-from e)
       (email-date e)
       (email-message e)))

;; List-of-email -> List-of-email
;; sorts loe by date in descending order
(check-expect (sort-emails> '()) '())
(check-expect (sort-emails> LOE1) (list E1 E2))
(check-expect (sort-emails> LOE2) (list E1 E3))
(check-expect (sort-emails> LOE3) (list E3 E2))
(check-expect (sort-emails> LOE4) (list E1 E3 E2))

(define (sort-emails> loe)
  (cond
    [(empty? loe) '()]
    [else
     (insert-email (first loe) (sort-emails> (rest loe)))]))

; Number List-of-email -> List-of-email
; inserts e into the sorted list of email, loe
(check-expect
 (insert-email E1 '()) (list E1))
(check-expect
 (insert-email E1 (list E2)) (list E1 E2))
(check-expect
 (insert-email E1 (list E3)) (list E1 E3))
(check-expect
 (insert-email E1 (list E3 E2)) (list E1 E3 E2))

(define (insert-email e loe)
  (cond
    [(empty? loe) (cons e '())]
    [else (if (e>? e (first loe))
              (cons e loe)
              (cons (first loe) (insert-email e (rest loe))))]))
    
;; EmailMessage EmailMessage -> Boolean
;; produces true if e1 >= e2
(check-expect (e>? E1 E2) #t)
(check-expect (e>? E2 E1) #f)
(check-expect (e>? E2 E2) #t)

(define (e>? e1 e2)
  (>= (email-date e1) (email-date e2)))

;; List-of-email -> List-of-email
;; sorts loe by name in descending order
(check-expect (sort-emails-by-name> '()) '())
(check-expect (sort-emails-by-name> LOE1) (list E2 E1))
(check-expect (sort-emails-by-name> LOE2) (list E3 E1))
(check-expect (sort-emails-by-name> LOE3) (list E2 E3))
(check-expect (sort-emails-by-name> LOE4) (list E2 E3 E1))

(define (sort-emails-by-name> loe)
  (cond
    [(empty? loe) '()]
    [else
     (insert-email-by-name (first loe)
                           (sort-emails-by-name> (rest loe)))]))

; Number List-of-email -> List-of-email
; inserts e into the sorted list of email, loe
(check-expect
 (insert-email-by-name E1 '()) (list E1))
(check-expect
 (insert-email-by-name E1 (list E2)) (list E2 E1))
(check-expect
 (insert-email-by-name E1 (list E3)) (list E3 E1))
(check-expect
 (insert-email-by-name E1 (list E2 E3)) (list E2 E3 E1))

(define (insert-email-by-name e loe)
  (cond
    [(empty? loe) (cons e '())]
    [else (if (en>? e (first loe))
              (cons e loe)
              (cons (first loe)
                    (insert-email-by-name e (rest loe))))]))

;; EmailMessage EmailMessage -> Boolean
;; produces true if e1 > e2
(check-expect (en>? E1 E2) #f)
(check-expect (en>? E2 E1) #t)

(define (en>? e1 e2)
  (string>? (email-from e1) (email-from e2)))
