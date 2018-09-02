;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex315) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/abstraction)

(define-struct no-parent [])
(define NP (make-no-parent))

(define-struct child [father mother name date eyes])
; An FT (short for family tree) is one of: 
; – NP
; – (make-child FT FT String N String)

; Oldest Generation:
(define Carl    (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))
 
; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva  (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))
 
; Youngest Generation: 
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))

; An FF is [List-of FF]
; interpretation a family forest represents several
; families (say, a town) and their ancestor trees

(define ff1 (list Carl Bettina))
(define ff2 (list Fred Eva))
(define ff3 (list Fred Eva Carl))

; FT -> Boolean
; does an-ftree contain a child
; structure with "blue" in the eyes field
 
(check-expect (blue-eyed-child? Carl) #false)
(check-expect (blue-eyed-child? Gustav) #true)

(define (blue-eyed-child? an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else (or (string=? (child-eyes an-ftree) "blue")
              (blue-eyed-child? (child-father an-ftree))
              (blue-eyed-child? (child-mother an-ftree)))]))

;; FT -> N
;; produces the number of of child structs in the tree
(check-expect (count-persons NP)     0)
(check-expect (count-persons Carl)   1)
(check-expect (count-persons Adam)   3)
(check-expect (count-persons Gustav) 5)

(define (count-persons ft)
  (match ft
    [(no-parent)    0]
    [(child f m n d e)
     (+ 1
        (count-persons (child-father ft))
        (count-persons (child-mother ft)))]))

;; FF N -> Number
;; produces the average age of all child structs in ff
(check-expect (average-age ff1 2018)    92)
(check-expect (average-age ff2 2018) 72.25)
(check-expect (average-age ff3 2018)  76.2)

(define (average-age ff d)
  (local (; FT -> [List-of FT]
          (define (extract ft)
            (cond
              [(no-parent? ft) '()]
              [else
               (append (list ft)
                       (extract (child-father ft))
                       (extract (child-mother ft)))]))

          ; FF -> [List-of FT]
          (define all-trees
            (foldr append '() (map extract ff)))

          ; [List-of FT] -> [List-of N]
          (define (ages loft)
            (for/list ([child loft])
              (- d (child-date child)))))
    
    (/ (foldr + 0 (ages all-trees))
       (length all-trees))))
