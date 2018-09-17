;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex400) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Nucleobase is one of:
;; - 'a
;; - 'c
;; - 'g
;; - 't

;; [List-of Nucleobase] [List-of Nucleobase] -> Boolean
;; produces #true if s starts with ptn
(check-expect (DNAprefix '() '())      #true)
(check-expect (DNAprefix '(a) '())    #false)
(check-expect (DNAprefix '() '(a))     #true)
(check-expect (DNAprefix '(a c) '(a)) #false)
(check-expect (DNAprefix '(a c) '(a g c t))          #false)
(check-expect (DNAprefix '(a c g) '(a c g))           #true)
(check-expect (DNAprefix '(a c g) '(a c g t t g c a)) #true)

(define (DNAprefix ptn s)
  (cond
    [(empty? ptn) #true]
    [(empty? s)  #false]
    [else (and (symbol=? (first ptn) (first s))
               (DNAprefix (rest ptn) (rest s)))]))

;; [List-of Nucleobase] [List-of Nucleobase] -> [Or [Maybe Symbol] error]
;; produces the first item in s beyond ptn
;; produces an error if:
;;     the lists are identical (no symbol beyond the pattern)
;; produces if #false if:
;;     ptn does not match the beginning of the s
(check-expect (DNAdelta '(a) '())     #false)
(check-expect (DNAdelta '() '(a))         'a) 
(check-expect (DNAdelta '(a c) '(a))  #false)
(check-expect (DNAdelta '(a c) '(a g c t)) #false)
(check-error  (DNAdelta '(a c g) '(a c g)))
(check-expect (DNAdelta '(a c)   '(a c a t g))       'a)
(check-expect (DNAdelta '(a c g) '(a c g t t g c a)) 't)

(define (DNAdelta ptn s)
  (cond
    [(and (empty? ptn) (empty? s)) (error "identical")]
    [(and (empty? ptn) (cons? s)) (first s)]
    [(empty? s) #false]
    [(symbol=? (first ptn) (first s)) (DNAdelta (rest ptn) (rest s))]
    [else #false]))