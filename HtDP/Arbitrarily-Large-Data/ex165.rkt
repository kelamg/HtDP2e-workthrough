;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex165) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; A ToyD is a String
;; interp. toy descriptions

;; List-of-toyd is one of:
;; - '()
;; - (cons String List-of-toyd
;; interp. a list of toy descriptions

(define LOT1 '())
(define LOT2 (cons "c3po" (cons "anakin" '())))
(define LOT3
  (cons "robot" (cons "solo" (cons "c3po" (cons "anakin" '())))))
(define LOT4
  (cons "robot" (cons "solo" (cons "c3po" (cons "robot" '())))))

;; List-of-toyd -> List-of-toyd
;; replaces all occurences of "robot" in lot to "r2d2"
(check-expect (subst-robot LOT1) LOT1)
(check-expect (subst-robot LOT2) LOT2)
(check-expect
 (subst-robot LOT3)
 (cons "r2d2" (cons "solo" (cons "c3po" (cons "anakin" '())))))
(check-expect
 (subst-robot LOT4)
 (cons "r2d2" (cons "solo" (cons "c3po" (cons "r2d2" '())))))

(define (subst-robot lot)
  (cond
    [(empty? lot) '()]
    [else
     (if (string=? (first lot) "robot")
         (cons "r2d2" (subst-robot (rest lot)))
         (cons (first lot) (subst-robot (rest lot))))]))

;; String String List-of-Strings -> List-of-Strings
;; produces a list of strings with old replaced with new in los
(check-expect (substitute "anakin" "obi-wan" LOT1) LOT1)
(check-expect
 (substitute "anakin" "obi-wan" LOT2)
 (cons "c3po" (cons "obi-wan" '())))
(check-expect
 (substitute "ugly" "jabba" LOT3)
 LOT3)
(check-expect
 (substitute "robot" "terminator" LOT4)
 (cons "terminator"
       (cons "solo"
             (cons "c3po"
                   (cons "terminator" '())))))

(define (substitute old new los)
  (cond
    [(empty? los) '()]
    [else
     (if (string=? (first los) old)
         (cons new (substitute old new (rest los)))
         (cons (first los) (substitute old new (rest los))))]))

