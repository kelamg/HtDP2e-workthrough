;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex173) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

; An LLS is one of: 
; – '()
; – (cons Los LLS)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
(define line2
  (cons "the"
        (cons "antelope"
              (cons "got"
                    (cons "a"
                          (cons "squishing!" '()))))))
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
(define lls2 (cons line0 (cons line1 (cons line2 '()))))

;; String -> File
;; consumes the name of a file n, reads and removes the articles
;; ("a", "an" and "the"), and writes the result out to a file
;; whose name is the result of concatenating "no-articles-" with n
;; (substring n 3) removes "IO" from path to "IO/ttt.txt"
;; no tests for IO function
(define (remove-articles-f n)
  (write-file (string-append "no-articles-" (substring n 3))
              (remove-articles (read-words/line n))))

;; LLS -> String
;; converts a list of lines into a string
;; and removes all occurences of "a", "an" and "the"
(check-expect (remove-articles lls0) "")
(check-expect (remove-articles lls1) "hello world \n\n")
(check-expect
 (remove-articles lls2) "hello world \n\nantelope got squishing! \n")
 
(define (remove-articles lls)
  (cond
    [(empty? lls) ""]
    [else (string-append (remove-article/articles (first lls))
                         "\n"
                         (remove-articles (rest lls)))]))

;; List-of-string -> String
;; converts a list of string into one String
(check-expect
 (remove-article/articles
  (cons "the"
        (cons "an"
              (cons "a"
                    (cons "lonely" '())))))
 "lonely ")

(define (remove-article/articles los)
  (cond
    [(empty? los) ""]
    [else
     (string-append (check-article (first los))
                    (remove-article/articles (rest los)))]))

;; String -> String
;; checks string for whether it is an article or not
;; returns an empty string if it is, same string if not
(check-expect (check-article "a") "")
(check-expect (check-article "an") "")
(check-expect (check-article "the") "")
(check-expect (check-article "lonely") "lonely ")

(define (check-article s)
  (if (or (string=? s "a")
          (string=? s "an")
          (string=? s "the"))
      ""
      (string-append s " ")))