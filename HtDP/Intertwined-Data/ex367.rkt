;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex367) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) ...]
      [else (... (first optional-loa+content)
                 (xexpr-attr (rest optional-loa+content)))])))

;; Q - Add this self-reference to the template and then explain why the
;;     finished parsing function does not contain it.
;;
;; A - The design recipe uses a self-reference when processing lists
;;     usually by applying a function to each element of the list
;;     then combining the results using a function.
;;     The parsing function processes a representation of a structure
;;     instead of arbitrarily large data, thus it wouldn't be processed
;;     in the same way a list of data of would.