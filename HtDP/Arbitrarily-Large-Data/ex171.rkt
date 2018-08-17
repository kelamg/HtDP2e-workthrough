;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex171) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

; A List-of-numbers is one of: 
; – '()
; – (cons Number List-of-numbers)

;; A List-of-string is one of:
;; - '()
;; - (cons String List-of-string)
;; interp. a list of strings

(define LOL
  (cons " TTT"
        (cons ""
              (cons "  "
                    (cons ""
                          (cons "  Put up in a place" '()))))))
(define LOW
  (cons "TTT"
        (cons "Put"
              (cons "up"
                    (cons "in"
                          (cons "a"
                                (cons "place"
                                      (cons "where" '()))))))))

;; A List-of-list-of-string is one of:
;; - '()
;; - (cons List-of-string List-of-list-of-string)
;; interp. a list of list of strings

; An LLS is one of: 
; – '()
; – (cons Los LLS)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
 
; LLS -> List-of-numbers
; determines the number of words on each line 
 
(check-expect (words-on-line lls0) '())
(check-expect (words-on-line lls1) (cons 2 (cons 0 '())))
 
(define (words-on-line lls)
  (cond
    [(empty? lls) '()]
    [else (cons (length (first lls))
                (words-on-line (rest lls)))]))

; String -> List-of-numbers
; counts the words on each line in the given file
(define (file-statistic file-name)
  (words-on-line
    (read-words/line file-name)))
