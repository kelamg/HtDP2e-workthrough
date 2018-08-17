;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex187) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct gp [name score])
; A GamePlayer is a structure: 
;    (make-gp String Number)
; interpretation (make-gp p s) represents player p who 
; scored a maximum of s points

(define GP1 (make-gp "Freddie" 5200))
(define GP2 (make-gp "legend27" 9001))
(define GP3 (make-gp "Velma" 1255))

(define LOGP1 (list GP1 GP2))
(define LOGP2 (list GP1 GP3))
(define LOGP3 (list GP2 GP3))
(define LOGP4 (list GP1 GP2 GP3))

#;
(define (fn-for-gp p)
  (... (gp-name p)
       (gp-score p)))

;; List-of-gp -> List-of-gp
;; sorts logp by score in descending order
(check-expect (sort-players> '()) '())
(check-expect (sort-players> LOGP1) (list GP2 GP1))
(check-expect (sort-players> LOGP2) (list GP1 GP3))
(check-expect (sort-players> LOGP3) (list GP2 GP3))
(check-expect (sort-players> LOGP4) (list GP2 GP1 GP3))

(define (sort-players> logp)
  (cond
    [(empty? logp) '()]
    [else
     (insert-player (first logp) (sort-players> (rest logp)))]))

; Number List-of-gp -> List-of-gp
; inserts gp into the sorted list of gp, logp
(check-expect
 (insert-player GP1 '()) (list GP1))
(check-expect
 (insert-player GP1 (list GP2)) (list GP2 GP1))
(check-expect
 (insert-player GP1 (list GP3)) (list GP1 GP3))
(check-expect
 (insert-player GP1 (list GP2 GP3)) (list GP2 GP1 GP3))

(define (insert-player gp logp)
  (cond
    [(empty? logp) (cons gp '())]
    [else (if (gp>? gp (first logp))
              (cons gp logp)
              (cons (first logp) (insert-player gp (rest logp))))]))
    
;; GamePlayer GamePlayer -> Boolean
;; produces true if gp1 >= gp2
(check-expect (gp>? GP1 GP2) #f)
(check-expect (gp>? GP2 GP1) #t)
(check-expect (gp>? GP2 GP2) #t)

(define (gp>? gp1 gp2)
  (>= (gp-score gp1) (gp-score gp2)))


