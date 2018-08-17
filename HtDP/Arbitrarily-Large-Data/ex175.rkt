;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex175) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

(define-struct wct (letters words lines))
;; A WC (word count) is a structure:
;;   (make-wc N N N)
;; interp. a file's word count

;; String -> WC
;; produces a word count for the passed in filename f
;; excludes spaces as read-words/line omits spaces
(check-expect
 (wc "IO/ttt.txt") (make-wct 148 33 21))

(define (wc f)
  (count* (read-words/line f)))

;; An LLS is one of: 
;; – '()
;; – (cons Los LLS)
;; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "A" (cons "Quote" '())))
(define line1 '())
(define line2
  (cons "hardwork"
        (cons "beats"
              (cons "talent"
                    (cons "when"
                          (cons "talent"
                                (cons "doesn't"
                                      (cons "work"
                                            (cons "hard" '())))))))))
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
(define lls2 (cons line1 (cons line2 '())))
(define lls3 (cons line0 (cons line1 (cons line2 '()))))

;; String -> WC
;; produces a word count for the number of lines, letters and words in file f
(check-expect (count* lls0) (make-wct 0 0 0))
(check-expect (count* lls1) (make-wct 6 2 2))
(check-expect (count* lls2) (make-wct 44 8 2))
(check-expect (count* lls3) (make-wct 50 10 3))

(define (count* lls)
  (make-wct (count-letters lls)
            (count-words   lls)
            (count-lines   lls)))

;; LLS -> N
;; produces the number of letters in lls
(check-expect (count-letters lls0) 0)
(check-expect (count-letters lls1) 6)
(check-expect (count-letters lls2) 44)
(check-expect (count-letters lls3) 50)

(define (count-letters lls)
  (cond
    [(empty? lls) 0]
    [else
     (+ (count-letters-in-word (first lls))
        (count-letters (rest lls)))]))

;; List-of-string -> N
;; counts the number of letters in each word
(check-expect
 (count-letters-in-word (cons "Not" (cons "Ruby" '())))
 7)

(define (count-letters-in-word los)
  (cond
    [(empty? los) 0]
    [else
     (+ (string-length (first los))
        (count-letters-in-word (rest los)))]))

;; LLS -> N
;; produces the number of words in lls
(check-expect (count-words lls0) 0)
(check-expect (count-words lls1) 2)
(check-expect (count-words lls2) 8)
(check-expect (count-words lls3) 10)

(define (count-words lls)
  (cond
    [(empty? lls) 0]
    [else
     (+ (length (first lls))
        (count-words (rest lls)))]))

;; LLS -> N
;; produces the number of lines in lls
(check-expect (count-lines lls0) 0)
(check-expect (count-lines lls1) 2)
(check-expect (count-lines lls2) 2)
(check-expect (count-lines lls3) 3)

(define (count-lines lls)
  (cond
    [(empty? lls) 0]
    [else (+ 1 (count-lines (rest lls)))]))