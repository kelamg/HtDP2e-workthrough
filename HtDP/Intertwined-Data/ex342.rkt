;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex342) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require htdp/dir)
(require 2htdp/abstraction)

(require racket/list)
(require racket/string)


; A Path is [List-of String].
; interpretation directions into a directory tree

; A File is a structure:
;   (make-file String N String)

; A Dir is a structure:
;   (make-dir String [List-of Dir] [List-of File])

(define DIR (create-dir "Test-Dir/"))

;; figure 123
(define FIG-123
  (make-dir
   'TS
   (list
    (make-dir 'Text '() (list (make-file "part1" 99 "")
                               (make-file "part2" 52 "")
                               (make-file "part3" 17 "")))
    (make-dir 'Libs
              (list (make-dir 'Code '() (list (make-file "hang" 8 "")
                                               (make-file "draw" 2 "")))
                    (make-dir 'Docs '() (list (make-file "read!" 19 ""))))
              '()))
   (list (make-file "read!" 10 ""))))

;; Dir String -> Boolean
;; produces true if s is contained in dir
(check-expect (find? DIR "fn.py") #false)
(check-expect (find? DIR "b.cpp")  #true)
(check-expect (find? DIR "f.md")   #true)

(define (find? dir s)
  (or (ormap (λ (f) (string=? s (file-name f))) (dir-files dir))
      (ormap (λ (d) (find? d s)) (dir-dirs dir))))

;; Symbol String -> String
;; returns the file/dir name to which the given path points
(check-error  (path->filename "/home/racket"))
(check-expect (path->filename '/home/racket)          "racket")
(check-expect (path->filename '/longer/absolute/path) "path")

(define (path->filename s)
  (if (symbol? s)
      (last (string-split (symbol->string s) "/"))
      (error "path->filename: bad file path")))


;; Dir String -> Path or #false
;; produces a path to file f if it exists in d,
;; else produces #false
(check-expect
 (find DIR "stdio.h") #false)
(check-expect
 (find DIR "a.txt") '("Test-Dir" "a.txt"))
(check-expect
 (find DIR "d.c") '("Test-Dir" "next-dir" "d.c"))
(check-expect
 (find DIR "f.md") '("Test-Dir" "next-dir" "deep-dir" "f.md"))

(define (find d f)
  (local
    ((define this.dirname (path->filename (dir-name d)))
     (define found?
       (ormap (λ (file)
                (string=? f (file-name file))) (dir-files d))))
    
    (if found?
        (list this.dirname f)
        (for/or ([dir (dir-dirs d)])
          (local
            ((define subdirs (find dir f)))
            
            (if (false? subdirs)
                #false
                (cons this.dirname subdirs)))))))


;; Dir String -> [List-of Path]
;; produces all paths to f if it exists in d,
;; else produces #false
(check-expect
 (find-all DIR "stdio.h") '())
(check-expect
 (find-all DIR "d.c") '(("Test-Dir" "next-dir" "d.c")))
(check-expect
 (find-all DIR "a.txt")
 '(("Test-Dir" "a.txt")
   ("Test-Dir" "next-dir" "deep-dir" "a.txt")))
(check-expect
 (find-all FIG-123 "read!")
 '(("TS" "read!")
   ("TS" "Libs" "Docs" "read!")))

(define (find-all d f)
  (local
    ((define this.dirname (path->filename (dir-name d)))
     (define found?
       (ormap (λ (file)
                (string=? f (file-name file))) (dir-files d)))

     ; [List-of Dir] -> [List-of Path]
     (define subpaths
       (for*/list ([dir  (dir-dirs d)]
                   [path (find-all dir f)])
         (cons this.dirname path))))

    (if (not found?)
        subpaths
        (cons (list this.dirname f) subpaths))))

