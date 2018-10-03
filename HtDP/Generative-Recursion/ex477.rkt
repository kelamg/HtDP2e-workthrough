;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex477) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items in w
; generative:  creates a list of all rearrangements of w with the
;              one item removed, then consing that item to every
;              rearrangement generated. Each new problem is one item
;              less than the previous, ultimately reducing the item list
;              down to empty. We combine all solutions with append.
; termination: each new generated problem is one less than the previous,
;              which means that for any given list, there will eventually
;              be a trivial problem (an empty list) for which the generative
;              step will terminate.
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else
      (foldr
       (λ (item others)
         (local ((define without-item
                   (arrangements (remove item w)))
                 (define add-item-to-front
                   (map (λ (a) (cons item a))
                        without-item)))
           (append add-item-to-front others)))
       '()
       w)]))

(define (all-words-from-rat? w)
  (and (member (explode "rat") w)
       (member (explode "art") w)
       (member (explode "tar") w)))
 
(check-satisfied (arrangements '("r" "a" "t"))
                 all-words-from-rat?)