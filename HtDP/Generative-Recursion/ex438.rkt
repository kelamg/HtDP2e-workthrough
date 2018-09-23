;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex438) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (gcd-structural n m)
  (local (; N -> N
          ; determines the gcd of n and m less than i
          (define (greatest-divisor-<= i)
            (cond
              [(= i 1) 1]
              [else
               (if (= (remainder n i) (remainder m i) 0)
                   i
                   (greatest-divisor-<= (- i 1)))])))
    (greatest-divisor-<= (min n m))))

;; Q - In your words: how does greatest-divisor-<= work? Use the design recipe to
;;     find the right words. Why does the locally defined greatest-divisor-<= recur
;;     on (min n m)?
;; A - It works by checking the remainder of both numbers when supplied a given
;;     number i and recurses until it reaches a number that divides both numbers
;;     evenly: the greatest factor of both numbers. It starts from (min n m), the
;;     smaller of the two numbers because the greatest factor will always be
;;     determined by the smaller number, since any number that is smaller than
;;     the larger number but larger than the smaller number, cannot be a factor
;;     of the smaller number.
;;     For example, for two numbers 4 and 16, 8 is a factor of 16 but not a factor
;;     of 4.