;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex133) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name

; List-of-names -> Boolean
; determines whether "Flatt" occurs on alon
(check-expect (contains-flatt? '()) #false)
(check-expect (contains-flatt? (cons "Find" '()))
              #false)
(check-expect (contains-flatt? (cons "Flatt" '()))
              #true)
(check-expect (contains-flatt?
               (cons "A" (cons "Flatt" (cons "C" '()))))
              #true)
(check-expect (contains-flatt?
               (cons "A" (cons "fsociety" (cons "T" '()))))
              #false)

#;
(define (contains-flatt? alon)
  (cond
    [(empty? alon) #false]
    [else
     (or (string=? (first alon) "Flatt")
         (contains-flatt? (rest alon)))]))

(define (contains-flatt? alon)
  (cond
    [(empty? alon) #false]
    [else
     (cond
      [(string=? (first alon) "Flatt") #true]
      [else (contains-flatt? (rest alon))])]))

;; This second function body gives the same results as the first because
;; the cond in the second clause is practically a re-formulation of the or
;; primitive as a function. It returns #true, or makes the recursive call
;; just like an or expression would.
;;
;; The first function body is better because it is quicker to write, and makes
;; use of a primitive rather than having to reinvent the wheel. Besides we get
;; the advantages of any performance tweaks the primitive has over the cond expr.