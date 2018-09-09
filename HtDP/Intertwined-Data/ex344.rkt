;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex344) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; Dir -> [List-of Path]
;; produces a list of the paths of all files contained in d
(define (ls-R d)
  (local
    ((define root-dir (list (path->filename (dir-name d))))
     (define (ls-R d)
       (local ((define this.dirname (path->filename (dir-name d)))
               (define (subpaths d)
                 (foldr append '()
                        (map (λ (d)
                               (cons (list (path->filename (dir-name d)))
                                     (ls-R d)))
                             (dir-dirs d)))))
         
         (append
          (for/list ([file (dir-files d)]) (list this.dirname (file-name file)))
          (for/list ([path (subpaths d)]) (cons this.dirname path))))))
    
    (cons root-dir (ls-R d))))

;; Symbol String -> String
;; returns the file/dir name to which the given path points
(check-error  (path->filename "/home/racket"))
(check-expect (path->filename '/home/racket)          "racket")
(check-expect (path->filename '/longer/absolute/path) "path")

(define (path->filename s)
  (if (symbol? s)
      (last (string-split (symbol->string s) "/"))
      (error "path->filename: bad file path")))

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
(check-expect
 (find-all FIG-123 "TS")
 '(("TS")))
(check-expect
 (find-all FIG-123 "Docs")
 '(("TS" "Libs" "Docs")))

(define (find-all d f)
  (filter (λ (path) (string=? f (last path))) (ls-R d)))

