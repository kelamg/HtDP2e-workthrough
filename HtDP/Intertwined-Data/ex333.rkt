;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex333) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct dir [name content])
; A Dir.v2 is a structure: 
;   (make-dir String LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

;; figure 123
(define DIR
  (make-dir "TS" (list (make-dir "Text" '("part1" "part2" "part3"))
                       "read!"
                       (make-dir "Libs" (list (make-dir "Code" '("hang" "draw"))
                                              (make-dir "Docs" '("read!")))))))

;; Dir.v2 -> N
;; produces the number of files contained in dir
(check-expect
 (how-many (make-dir "root" '())) 0)
(check-expect (how-many DIR) 7)

(define (how-many dir)
  (foldr (λ (d dirs)
           (+ (match d
                [(? dir?) (how-many d)]
                [(? string?) 1])
              dirs))
         0
         (dir-content dir)))