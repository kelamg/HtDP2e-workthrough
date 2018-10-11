;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex509) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

(define FONT-SIZE 16)
(define FONT-COLOR "black")
 
; [List-of 1String] -> Image
; renders a string as an image for the editor 
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
 
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor [List-of 1String] [List-of 1String])
; interpretation if (make-editor p s) is the state of 
; an interactive editor, (reverse p) corresponds to
; the text to the left of the cursor and s to the
; text on the right


;; [List-of 1String] Number -> Editor
;; produces an editor with ed split into
;; a pre field:
;;   everything before x
;; and a post field:
;;   everything after x
;; where x is the x-coordinate of the mouse click
(define testcase "sometext")

(check-expect
 (split (explode testcase) 0)
 (make-editor '() (explode testcase)))
(check-expect
 (split
  (explode testcase) (image-width (text "somet" FONT-SIZE FONT-COLOR)))
 (make-editor (rev (explode "somet")) (explode "ext")))
(check-expect
 (split
  (explode testcase) (image-width (text testcase FONT-SIZE FONT-COLOR)))
 (make-editor (rev (explode "sometext")) '()))
(check-expect
 (split
  (explode testcase) (+ 1 (image-width (text testcase FONT-SIZE FONT-COLOR))))
 (make-editor (rev (explode "sometext")) '()))
(check-expect
 (split '() 100)
 (make-editor '() '()))

(define (split ed x)
  (local (; [List-of 1String] [List-of 1String] -> Editor
          ; accumulator pre is the prefixes of ed that have
          ; fit the given width so far
          (define (split/a pre post)
            (cond
              [(empty? post) (make-editor pre post)]
              [else
               (local ((define pre-width (image-width (editor-text pre)))
                       (define post-width
                         (image-width (editor-text (cons (first post) pre)))))
                 (cond
                   [(= x post-width)
                    (make-editor (cons (first post) pre) (rest post))]
                   [(<= pre-width x post-width) (make-editor pre post)]
                   [else (split/a (cons (first post) pre) (rest post))]))]))

          (define e (split/a '() ed)))

    (make-editor (editor-pre e) (editor-post e))))

;; main : String -> Editor
;; launches the editor given some initial string 
(define (main s)
   (big-bang (create-editor s "")
     [on-key editor-kh]
     [to-draw editor-render]
     [on-mouse editor-mouse-ctrl]))


;; Editor Number Number MouseEvent -> Editor
(define (editor-mouse-ctrl ed x y me)
  (split
   (append (reverse (editor-pre ed))
           (editor-post ed))
   x))

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
(check-expect
 (editor-render (create-editor "pre" "post"))
 (place-image/align
  (beside (text "pre" FONT-SIZE FONT-COLOR)
          CURSOR
          (text "post" FONT-SIZE FONT-COLOR))
  1 1
  "left" "top"
  MT))

(define (editor-render e)
  (place-image/align
    (beside (editor-text (rev (editor-pre e)))
            CURSOR
            (editor-text (editor-post e)))
    1 1
    "left" "top"
    MT))
 
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
