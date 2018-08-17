;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex141) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; List-of-string -> String
; concatenates all strings in l into one long string
 
(check-expect (cat '()) "")
(check-expect (cat (cons "a" (cons "b" '()))) "ab")
(check-expect
  (cat (cons "ab" (cons "cd" (cons "ef" '()))))
  "abcdef")

#;
(define (cat l)
  (cond
    [(empty? l) ""]
    [else (... (first l) ... (cat (rest l)) ...)]))

; l               (first l)    (rest l)    (cat (rest l))    (cat l)
;
; (cons "a"          "a"      (cons "b"         "b"            "ab"
;; (cons "b"                    '())
;;   '()))
;;
;; (cons             "ab"     (cons "cd"        "cdef"       "abcdef"
;;  "ab"                        (cons "ef"
;;  (cons "cd"                    '()))
;;    (cons "ef"
;;      '())))


;; The combination function to get the desired result is string-append

(define (cat l)
  (cond
    [(empty? l) ""]
    [else
     (string-append (first l)
                    (cat (rest l)))]))

;; evaluating (cat (cons "a" '()))

(cat (cons "a" '()))