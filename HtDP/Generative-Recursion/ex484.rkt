;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex484) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Q - Hand-evaluate (infL (list 3 2 1 0)).

(define (infL l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (local ((define s (infL (rest l))))
            (if (< (first l) s) (first l) s))]))

(infL '(3 2 1 0))

(cond
  [(empty? (rest '(3 2 1 0))) (first '(3 2 1 0))]
  [else (local ((define s (infL (rest '(3 2 1 0)))))
          (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [(empty? '(2 1 0)) (first '(3 2 1 0))]
  [else (local ((define s (infL (rest '(3 2 1 0)))))
          (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [#false (first '(3 2 1 0))]
  [else (local ((define s (infL (rest '(3 2 1 0)))))
          (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else (local ((define s (infL (rest '(3 2 1 0)))))
          (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else (local ((define s (infL '(2 1 0))))
          (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [(empty? (rest '(2 1 0))) (first '(2 1 0))]
          [else (local ((define s (infL (rest '(2 1 0)))))
                  (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [(empty? '(1 0)) (first '(2 1 0))]
          [else (local ((define s (infL (rest '(2 1 0)))))
                  (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [#false (first '(2 1 0))]
          [else (local ((define s (infL (rest '(2 1 0)))))
                  (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else (local ((define s (infL (rest '(2 1 0)))))
                  (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else (local ((define s (infL '(1 0))))
                  (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [(empty? (rest '(1 0))) (first '(1 0))]
                  [else (local ((define s (infL (rest '(1 0)))))
                          (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [(empty? '(0)) (first '(1 0))]
                  [else (local ((define s (infL (rest '(1 0)))))
                          (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [#false (first '(1 0))]
                  [else (local ((define s (infL (rest '(1 0)))))
                          (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [else (local ((define s (infL (rest '(1 0)))))
                          (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [else (local ((define s (infL '(0))))
                          (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [else
                   (local
                     ((define s
                        (cond
                          [(empty? (rest '(0))) (first '(0))]
                          [else (local ((define s (infL (rest '(0)))))
                                  (if (< (first '(0)) s) (first '(0)) s))])))
                     (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [else
                   (local
                     ((define s
                        (cond
                          [(empty? '()) (first '(0))]
                          [else (local ((define s (infL (rest '(0)))))
                                  (if (< (first '(0)) s) (first '(0)) s))])))
                     (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (cond
                  [else
                   (local
                     ((define s
                        (cond
                          [#true (first '(0))]
                          [else (local ((define s (infL (rest '(0)))))
                                  (if (< (first '(0)) s) (first '(0)) s))])))
                     (if (< (first '(1 0)) s) (first '(1 0)) s))])))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (local
                  ((define s (first '(0))))
                  (if (< (first '(1 0)) s) (first '(1 0)) s))))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (local
                  ((define s 0))
                  (if (< (first '(1 0)) s) (first '(1 0)) s))))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (if (< (first '(1 0)) 0) (first '(1 0)) 0)))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (if (< 1 0) (first '(1 0)) 0)))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s
                (if #false (first '(1 0)) 0)))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (cond
          [else
           (local
             ((define s 0))
             (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))])))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (local
          ((define s 0))
          (if (< (first '(2 1 0)) s) (first '(2 1 0)) s))))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (if (< (first '(2 1 0)) 0) (first '(2 1 0)) 0)))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (if (< 2 0) (first '(2 1 0)) 0)))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s
        (if #false (first '(2 1 0)) 0)))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(cond
  [else
   (local
     ((define s 0))
     (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))])

(local
  ((define s 0))
  (if (< (first '(3 2 1 0)) s) (first '(3 2 1 0)) s))

(if (< (first '(3 2 1 0)) 0) (first '(3 2 1 0)) 0)

(if (< 3 0) (first '(3 2 1 0)) 0)

(if #false (first '(3 2 1 0)) 0)

0


;; Q - Then argue that infL uses on the “order of n steps” in the best
;;     and the worst case.

;; A - The best and worst case does not matter in this instance because
;;     the function definition requires that the entire list is traversed.
;;     Due to the local expression, the only recursive step, (infL (rest l))
;;     is carried out once and its result cached. As a result, it runs on the
;;     order of n where n is the size of the list.
;;     The uncached version (without a local expression) would run on the order
;;     of n squared because for each item in the list, the entire remaining list
;;     will be traversed again.
