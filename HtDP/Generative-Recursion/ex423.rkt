;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex423) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; String N -> [List-of String]
;; produces a list of string chunks of size n
(check-expect
 (partition "" 2) '())
(check-expect
 (partition "realslim" 2)
 '("re" "al" "sl" "im"))
(check-expect
 (partition "realslim" 4)
 '("real" "slim"))
(check-expect
 (partition "realslimshady" 2)
 '("re" "al" "sl" "im" "sh" "ad" "y"))

(define (partition s n)
  (local ((define this.len (min n (string-length s))))
    
    (cond
      [(zero? this.len) '()]
      [else
       (cons (substring s 0 this.len)
             (partition (substring s this.len) n))])))
