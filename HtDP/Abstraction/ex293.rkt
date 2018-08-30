;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex293) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; X [List-of X] -> [Maybe [List-of X]]
; returns the first sublist of l that starts
; with x, #false otherwise
(check-satisfied (find 5 '()) (found? 5 '()))
(check-satisfied (find 5 '(2 4 5 6 9))
                 (found? 5 '(2 4 5 6 9)))

(define (find x l)
  (cond
    [(empty? l) #false]
    [else
     (if (equal? (first l) x) l (find x (rest l)))]))

;; X [List-of X] -> [ [List-of X] -> Boolean ]
;; does lx (if not false) contain exactly the rest of l starting from x
(check-expect ((found? 2 '()) '(2 1)) #false)
(check-expect ((found? 2 '()) #false)  #true)
(check-expect ((found? 2 '(1 4 2 5 8)) '(4 2 5 8)) #false)
(check-expect ((found? 2 '(1 4 2 5 8)) '(2 5 8)) #true)

(define (found? x l)
  (lambda (lx)
    (cond
      [(false? lx) (not (member? x l))]
      [(< (length l) (length lx)) #false]
      [else
       (local (; [List-of X] -> String
               (define (char-list ls)
                 (map number->string ls))

               ; l and lx converted to strings
               (define lstr
                 (implode (char-list l)))
               (define lxstr
                 (implode (char-list lx))))
         
         (string=? lxstr
                   (substring lstr (sub1 (length lx)))))])))