;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex174) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

; 1String -> String
; converts the given 1String to a 3-letter numeric String
 
(check-expect (encode-letter "z") (code1 "z"))
(check-expect (encode-letter "\t")
              (string-append "00" (code1 "\t")))
(check-expect (encode-letter "a")
              (string-append "0" (code1 "a")))
 
(define (encode-letter s)
  (cond
    [(>= (string->int s) 100) (code1 s)]
    [(< (string->int s) 10)
     (string-append "00" (code1 s))]
    [(< (string->int s) 100)
     (string-append "0" (code1 s))]))
 
; 1String -> String
; converts the given 1String into a String
 
(check-expect (code1 "z") "122")
 
(define (code1 c)
  (number->string (string->int c)))

;; (encode-letter s) converts 1Strings to their corresponding ASCII codes
;; (code1 c) is a helper function that gets the integer representation
;;           of ASCII code of the letter 

; An LLS is one of: 
; – '()
; – (cons Los LLS)
; interpretation a list of lines, each is a list of Strings
 
(define line0 (cons "cat" (cons "nip" '())))
(define line1 '())
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))

;; String -> File
;; encodes a text file n numerically
;; each letter in a word in the file is encoded as a numeric
;; three-letter string
;; (substring n 3) removes "IO/" from file path
(define (encode-file n)
  (write-file (string-append "encoded-" (substring n 3))
              (encode-text (read-words/line n))))

;; LLS -> String
;; encodes lines of text numerically
(check-expect (encode-text lls0) "")
(check-expect (encode-text lls1)
              "099097116 110105112 \n\n")
 
(define (encode-text lls)
  (cond
    [(empty? lls) ""]
    [else (string-append (encode-line (first lls))
                         "\n"
                         (encode-text (rest lls)))]))

;; List-of-string -> String
;; encodes a line of text numerically
(check-expect
 (encode-line
  (cons "sword"
        (cons "art" '())))
 "115119111114100 097114116 ")

(define (encode-line los)
  (cond
    [(empty? los) ""]
    [else
     (string-append (encode-each (explode (first los)))
                    " "
                    (encode-line (rest los)))]))

;; List-of-1String -> String
;; encodes each 1String in lo1s
(check-expect (encode-each (explode "cat")) "099097116")

(define (encode-each lo1s)
  (cond
    [(empty? lo1s) ""]
    [else
     (string-append (encode-letter (first lo1s))
                    (encode-each (rest lo1s)))]))