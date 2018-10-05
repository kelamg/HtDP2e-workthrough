;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex505) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; N[>=1] -> Boolean
; determines whether n is a prime number
(check-expect (is-prime? 1)  #false)
(check-expect (is-prime? 2)   #true)
(check-expect (is-prime? 3)   #true)
(check-expect (is-prime? 7)   #true)
(check-expect (is-prime? 10) #false)
(check-expect (is-prime? 11)  #true)

(define (is-prime? n)
  (local (; N -> Boolean
          ; accumulator a is a number between [2, n)
          ; n is prime if n0 is 1
          (define (is-prime?/a a)
            (cond
              [(= a 1) #true]
              [else (if (zero? (remainder n a))
                        #false
                        (is-prime?/a (sub1 a)))])))
    
    (cond
      [(= n 1) #false]
      [else (is-prime?/a (sub1 n))])))
