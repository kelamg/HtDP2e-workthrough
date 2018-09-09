;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex341) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require htdp/dir)
(require 2htdp/abstraction)

; A File is a structure: 
;   (make-file String N String)

; A Dir is a structure: 
;   (make-dir String [List-of Dir] [List-of File])

(define DIR       (create-dir "Test-Dir/"))
(define EMPTY-DIR (create-dir "Test-Dir/empty/"))

;; Dir -> N
;; produces the total size of all the files in dir
(check-expect (du EMPTY-DIR) 0)
(check-expect (du       DIR) (+ 44 84 1539 1 1 1))

(define (du dir)
  (+
   (for/sum ([d (dir-dirs  dir)]) (add1 (du d)))
   (for/sum ([f (dir-files dir)]) (file-size f))))