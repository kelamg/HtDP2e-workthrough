;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex343) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define DIR1
  (make-dir 'TS '() '()))
(define DIR2
  (make-dir
   'Root
   (list (make-dir 'next '() (list (make-file "b.txt" 2 ""))))
   (list (make-file "a.txt" 6 ""))))
(define DIR3
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


;; Symbol String -> String
;; returns the file/dir name to which the given path points
(check-error  (path->filename "/home/racket"))
(check-expect (path->filename '/home/racket)          "racket")
(check-expect (path->filename '/longer/absolute/path) "path")

(define (path->filename s)
  (if (symbol? s)
      (last (string-split (symbol->string s) "/"))
      (error "path->filename: bad file path")))

;; Dir -> [List-of String]
;; produces a list of the names of all
;; files and directories in dir
(define (ls dir)
  (append
   (for/list ([d (dir-dirs  dir)]) (path->filename (dir-name d)))
   (for/list ([f (dir-files dir)]) (file-name f))))


;; Dir -> [List-of Path]
;; produces a list of paths to all files (and directories) contained in d
(check-expect
 (ls-R DIR1) '(("TS")))
(check-expect
 (ls-R DIR2)
 '(("Root")
   ("Root" "a.txt")
   ("Root" "next")
   ("Root" "next" "b.txt")))
(check-expect
 (ls-R DIR3)
 '(("TS")
   ("TS" "read!")
   ("TS" "Text")
   ("TS" "Text" "part1")
   ("TS" "Text" "part2")
   ("TS" "Text" "part3")
   ("TS" "Libs")
   ("TS" "Libs" "Code")
   ("TS" "Libs" "Code" "hang")
   ("TS" "Libs" "Code" "draw")
   ("TS" "Libs" "Docs")
   ("TS" "Libs" "Docs" "read!")))


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

    