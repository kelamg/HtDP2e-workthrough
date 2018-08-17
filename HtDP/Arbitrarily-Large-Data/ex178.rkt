;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex178) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))


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
 (make-editor (rev (explode "good")) (explode "day")))

(define (create-editor pre post)
  (make-editor (rev (explode pre)) (explode post)))

; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor 
(define (editor-render e) MT)
 
; Editor KeyEvent -> Editor
; deals with a key event, given some editor
(check-expect
 (editor-kh (create-editor "" "") "e")
 (create-editor "e" ""))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "e")
 (create-editor "cde" "fgh"))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "\b")
 (create-editor "c" "fgh"))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "left")
 (create-editor "c" "dfgh"))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "right")
 (create-editor "cdf" "gh"))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "up")
 (create-editor "cd" "fgh"))
(check-expect
 (editor-kh (create-editor "" "cdfgh") "left")
 (create-editor "" "cdfgh"))
(check-expect
 (editor-kh (create-editor "cdfgh" "") "right")
 (create-editor "cdfgh" ""))
(check-expect
 (editor-kh (create-editor "" "") "left")
 (create-editor "" ""))
(check-expect
 (editor-kh (create-editor "" "") "right")
 (create-editor "" ""))
(check-expect
 (editor-kh (create-editor "" "") "\b")
 (create-editor "" ""))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "\t")
 (create-editor "cd" "fgh"))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "\r")
 (create-editor "cd" "fgh"))

(define (editor-kh ed ke) ed)

; main : String -> Editor
; launches the editor given some initial string 
(define (main s)
   (big-bang (create-editor s "")
     [on-key editor-kh]
     [to-draw editor-render]))

;; editor-kh deals with "\t" and "\r" before strings of length one
;; because we want to ignore them while being concerned with every
;; other single length keystroke. If we deal with them after,
;; they would be processed together with keystrokes we are
;; concerned with (which we don't want to happen)