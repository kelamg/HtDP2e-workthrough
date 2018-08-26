;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex262) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; An NMatrix is a [List-of [List-of N]]

;; N -> NMatrix
;; creates diagonal squares of 0s and 1s (identity matrix)
(check-expect
 (identityM 1)
 '((1)))
(check-expect
 (identityM 3)
 '((1 0 0)
   (0 1 0)
   (0 0 1)))
(check-expect
 (identityM 5)
 '((1 0 0 0 0)
   (0 1 0 0 0)
   (0 0 1 0 0)
   (0 0 0 1 0)
   (0 0 0 0 1)))

(define (identityM n)
  (local [;; N -> [List-of N]
          ;; produces a list of 0s with 1 at position k
          (define (build-row k)
            (append (make-list k 0)
                    '(1)
                    (make-list (- n k 1) 0)))]
    (build-list n build-row)))