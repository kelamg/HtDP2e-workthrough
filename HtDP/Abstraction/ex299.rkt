;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex299) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;; A Set is a function: [N -> Boolean]
;; interp. a function that produces #true
;; iff (if and only if) ed belongs to the set
;; tested by remainder division
(check-expect (tens 25)         #f)
(check-expect (tens 20)         #t)
(check-expect (odd-numbers 6)   #f)
(check-expect (odd-numbers 3)   #t)

(define (mk-set div rem)
  (λ (ed)
    (= (modulo ed div) rem)))

;; A FiniteSet is a function: [N -> Boolean]
;; interp. a function that produces #true
;; iff (if and only if) ed belongs to a finite set
(check-expect ((mk-finset '(1 3 5)) 2) #f)
(check-expect ((mk-finset '(1 3 5)) 3) #t)

(define (mk-finset set)
  (λ (ed)
    (member? ed set)))

;; Constants 
(define even-numbers (mk-set 2 0))
(define odd-numbers  (mk-set 2 1))
(define tens         (mk-set 10 0))
(define less-than-5  (mk-finset '(0 1 2 3 4 5)))

;; N Set -> Set
;; produces a new set with elem added
(check-expect ((add-element 5 tens) 2) #f)
(check-expect ((add-element 5 tens) 5) #t)
(check-expect ((add-element 10 less-than-5) 10) #t)

(define (add-element elem set)
  (λ (ed)
    (or (= ed elem)
        (set ed))))

;; Set Set -> Set
;; makes a new set with elements of s1 and s2 combined
(check-expect ((union even-numbers tens) 20) #t)
(check-expect ((union even-numbers tens)  6) #t)
(check-expect ((union even-numbers tens) 15) #f)
(check-expect ((union less-than-5  odd-numbers)  7) #t)
(check-expect ((union less-than-5  odd-numbers)  2) #t)
(check-expect ((union less-than-5  odd-numbers)  8) #f)

(define (union s1 s2)
  (λ (ed)
    (or (s1 ed)
        (s2 ed))))

;; Set Set -> Set
;; collects all elements common to two sets
(check-expect ((intersect even-numbers tens) 20) #t)
(check-expect ((intersect even-numbers tens)  6) #f)
(check-expect ((intersect even-numbers tens) 15) #f)
(check-expect ((intersect less-than-5  odd-numbers)  7) #f)
(check-expect ((intersect less-than-5  odd-numbers)  2) #f)
(check-expect ((intersect less-than-5  odd-numbers)  3) #t)

(define (intersect s1 s2)
  (λ (ed)
    (and (s1 ed)
         (s2 ed))))
