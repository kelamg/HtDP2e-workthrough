;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex172) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

; An LLS is one of: 
; – '()
; – (cons Los LLS)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
(define line2
  (cons "I"
        (cons "had"
              (cons "something"
                    (cons "for"
                          (cons "this!" '()))))))
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
(define lls2 (cons line0 (cons line1 (cons line2 '()))))
 
;; LLS -> String
;; converts a list of lines into a string
;; the strings are separated by blank spaces (" ");
;; the lines are separated by a newline ("\n")
(check-expect (collapse lls0) "")
(check-expect (collapse lls1) "hello world \n\n")
(check-expect
 (collapse lls2) "hello world \n\nI had something for this! \n")
 
(define (collapse lls)
  (cond
    [(empty? lls) ""]
    [else (string-append (collapse-words (first lls))
                         "\n"
                         (collapse (rest lls)))]))

;; List-of-string -> String
;; converts a list of string into one String
(check-expect
 (collapse-words
  (cons "I"
        (cons "got"
              (cons "choons"
                    (cons "for"
                          (cons "your"
                                (cons "headtop..." '())))))))
 "I got choons for your headtop... ")

(define (collapse-words los)
  (cond
    [(empty? los) ""]
    [else
     (string-append (first los)
                    " "
                    (collapse-words (rest los)))]))
                        