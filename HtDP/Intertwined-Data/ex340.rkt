;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex340) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require racket/list)
(require racket/string)

(require htdp/dir)
(require 2htdp/abstraction)

; A File is a structure: 
;   (make-file String N String)

; A Dir is a structure: 
;   (make-dir String [List-of Dir] [List-of File])

(define DIR       (create-dir "Test-Dir/"))
(define EMPTY-DIR (create-dir "Test-Dir/empty/"))

;; Dir -> [List-of String]
;; produces a list of the names of all
;; files and directories in dir
(check-expect
 (ls EMPTY-DIR) '())
(check-expect
 (ls DIR) '("empty" "next-dir" "a.txt" "b.cpp" "c.ppm"))

(define (ls dir)
  (append
   (for/list ([d (dir-dirs  dir)]) (path->filename (dir-name d)))
   (for/list ([f (dir-files dir)]) (file-name f))))

;; Symbol String -> String
;; returns the file/dir name to which the given path points
(check-error  (path->filename "/home/racket"))
(check-expect (path->filename '/home/racket)          "racket")
(check-expect (path->filename '/longer/absolute/path) "path")

(define (path->filename s)
  (if (symbol? s)
      (last (string-split (symbol->string s) "/"))
      (error "path->filename: bad file path")))
