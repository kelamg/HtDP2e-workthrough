;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex177) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S)

; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

; Lo1s -> Lo1s 
; produces a reverse version of the given list 
 
(check-expect
  (rev (cons "a" (cons "b" (cons "c" '()))))
  (cons "c" (cons "b" (cons "a" '()))))
 
(define (rev l)
  (cond
    [(empty? l) '()]
    [else
     (append-to-end (rev (rest l)) (first l))]))

;; List-of-strings String -> List-of-strings
;; appends s to end of los
(check-expect
 (append-to-end '() "a") (cons "a" '()))
(check-expect
 (append-to-end (cons "a" (cons "b" '())) "c")
 (cons "a" (cons "b" (cons "c" '()))))

(define (append-to-end los s)
  (cond
    [(empty? los) (cons s '())]
    [else
     (cons (first los) (append-to-end (rest los) s))]))

;; String String -> Editor
;; produces an editor using pre and post
(check-expect
 (create-editor "" "") (make-editor '() '()))
(check-expect
 (create-editor "good" "day")
 (make-editor (explode "good") (explode "day")))

(define (create-editor pre post)
  (make-editor (explode pre) (explode post)))