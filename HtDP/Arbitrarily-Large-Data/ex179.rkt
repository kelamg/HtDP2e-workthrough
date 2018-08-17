;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex179) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

(define (editor-kh ed k)
  (cond
    [(key=? k "left") (editor-lft ed)]
    [(key=? k "right") (editor-rgt ed)]
    [(key=? k "\b") (editor-del ed)]
    [(key=? k "\t") ed]
    [(key=? k "\r") ed]
    [(= (string-length k) 1) (editor-ins ed k)]
    [else ed]))

;; Editor 1String -> Editor
;; insert the 1String k between pre and post
(check-expect
  (editor-ins (make-editor '() '()) "e")
  (make-editor (cons "e" '()) '()))
(check-expect
  (editor-ins
    (make-editor (cons "d" '())
                 (cons "f" (cons "g" '()))) "e")
  (make-editor (cons "e" (cons "d" '()))
               (cons "f" (cons "g" '()))))

(define (editor-ins ed k)
  (make-editor (cons k (editor-pre ed))
               (editor-post ed)))

;; Editor -> Editor
;; handle "left" key event
(check-expect
 (editor-lft (make-editor '() '()))
 (make-editor '() '()))
(check-expect
 (editor-lft
  (make-editor
   (cons "m" (cons "u" (cons "s" '())))
   (cons "b" (cons "u" (cons "d" '())))))
 (make-editor
  (cons "u" (cons "s" '()))
  (cons "m" (cons "b" (cons "u" (cons "d" '()))))))

(define (editor-lft ed)
  (if (not (empty? (editor-pre ed)))
      (make-editor
       (rest (editor-pre ed))
       (cons (first (editor-pre ed)) (editor-post ed)))
      ed))

;; Editor -> Editor
;; moves the cursor position one 1String right, 
;; if possible
(check-expect
 (editor-rgt (make-editor '() '()))
 (make-editor '() '()))
(check-expect
 (editor-rgt
  (make-editor
   (cons "m" (cons "u" (cons "s" '())))
   (cons "b" (cons "u" (cons "d" '())))))
 (make-editor
  (cons "b" (cons "m" (cons "u" (cons "s" '()))))
  (cons "u" (cons "d" '()))))

(define (editor-rgt ed)
  (if (not (empty? (editor-post ed)))
      (make-editor
       (cons (first (editor-post ed)) (editor-pre ed))
       (rest (editor-post ed)))
      ed))
 
;; Editor -> Editor
;; deletes a 1String to the left of the cursor,
;; if possible
(check-expect
 (editor-del (make-editor '() '()))
 (make-editor '() '()))
(check-expect
 (editor-del
  (make-editor
   (cons "m" (cons "u" (cons "s" '())))
   (cons "b" (cons "u" (cons "d" '())))))
 (make-editor
  (cons "u" (cons "s" '()))
  (cons "b" (cons "u" (cons "d" '())))))

(define (editor-del ed)
  (if (not (empty? (editor-pre ed)))
      (make-editor (rest (editor-pre ed)) (editor-post ed))
      ed))

;; main : String -> Editor
;; launches the editor given some initial string 
(define (main s)
   (big-bang (create-editor s "")
     [on-key editor-kh]
     [to-draw editor-render]))

