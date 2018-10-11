;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex516) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define ERR-MSG "are you sure about that?")

; A Lam is one of: 
; – Symbol
; – Lexpr
; – Lapp

(define-struct lexpr (params body))
;; A LExpr is a structure:
;;   (make-lexpr Params Lam)
;; A Params is a [List-of Symbol]

(define-struct lapp  (func arg))
;; A LApp is a structure:
;;   (make-lapp Lam Lam)

(define ex1 (make-lexpr '(x) 'x))
(define ex2 (make-lexpr '(x) 'y))
(define ex3 (make-lexpr '(y) (make-lexpr '(x) 'y)))

; Lam -> Lam 
; replaces all symbols s in le with '*undeclared
; if they do not occur within the body of a λ 
; expression whose parameter is s
(check-expect
 (undeclareds ex1) (make-lexpr '(x) '*declared:x))
(check-expect
 (undeclareds ex2) (make-lexpr '(x) '*undeclared:y))
(check-expect
 (undeclareds ex3) (make-lexpr '(y) (make-lexpr '(x) '*declared:y)))

(define (undeclareds le0)
  (local (; String Symbol -> Symbol
          (define (declare str sy)
            (string->symbol
             (string-append str ":" (symbol->string sy))))
          
          ; Lam [List-of Symbol] -> Lam
          ; accumulator declareds is a list of all λ 
          ; parameters on the path from le0 to le
          (define (undeclareds/a le declareds)
            (cond
              [(symbol? le)
               (if (member? le declareds)
                   (declare "*declared" le)
                   (declare "*undeclared" le))]
              [(lexpr? le)
               (local ((define para (lexpr-params le))
                       (define body (lexpr-body   le))
                       (define newd (append para declareds)))
                 (make-lexpr para (undeclareds/a body newd)))]
              [(lapp? le)
               (local ((define fun (lapp-func le))
                       (define arg (lapp-arg  le)))
                 (make-lapp (undeclareds/a fun declareds)
                            (undeclareds/a arg declareds)))])))
    (undeclareds/a le0 '())))
