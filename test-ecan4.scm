(use-modules (opencog)
             (opencog nlp relex2logic)
             (opencog attention)
             (opencog openpsi)
             (opencog eva-behavior)
             (opencog ghost)
             (rnrs sorting))

; --------------------
; Parse the rules

(ghost-parse-file "/home/misgana/Desktop/ECAN/toy-ecan.ghost")
(ghost-parse-file "/home/misgana/Desktop/ECAN/toy-goaldirected.ghost")
; --------------------
; Get the rules

; how
(define r1 (filter psi-rule? (cog-get-trunk (List (Word "Rule") (Word "A")))))

; how are
(define r2 (filter psi-rule? (cog-get-trunk (List (Word "Rule") (Word "B")))))

; how are you
(define r3 (filter psi-rule? (cog-get-trunk (List (Word "Rule") (Word "C")))))
(define r3 (filter psi-rule? (cog-get-trunk (Word "Human"))))
; how are you Sophia
;(define r4 (filter psi-rule? (cog-get-trunk (List (Word "Rule") (Word "D")))))
(define r4 (filter psi-rule? (cog-get-trunk (Word "fine"))))

; humanoid robot
(define r5 (filter psi-rule? (cog-get-trunk (Word "humanoid"))))

; --------------------
; Stimulate the words

(define (nlp-stimulate-word STR)
  (define word (Word STR))
  (define stimulus 100)

  (display (format #f "\n===== Stimulating ~a with stimulus ~a\n" word stimulus))
  (cog-stimulate word stimulus)
)

(define (stimulate-the-words)'()
  ;(nlp-stimulate-word "how")
  ;(nlp-stimulate-word "are")
  ;(nlp-stimulate-word "you")
)

(stimulate-the-words)

; --------------------
; Utility

(define (get-top-sti-rules NUM)
  ; Get only the ImplicationLink
  (define impl
    (filter
      (lambda (x) (equal? 'ImplicationLink (cog-type x)))
      (cog-af)
    )
  )

  ; Get the top n rules
  (if (<= (length impl) NUM)
    impl
    (list-tail
      (list-sort
        (lambda (x y)
          (< (cog-av-sti x) (cog-av-sti y)))
        impl
      )
      (- (length impl) NUM)
    )
  )
)

; --------------------
; Check the result

(define (show-result)
  (define (print . data)
    (define fp (open-file "ecan.csv" "a"))
    (display
      (format #f "~a, ~a, ~a, ~a, ~a\n"
        (list-ref data 0)
        (list-ref data 1)
        (list-ref data 2)
        (list-ref data 3)
        (list-ref data 4)
      )
      fp
    )
    (close-port fp)
  )

  (call-with-new-thread
    (print "R1" "R2" "R3" "R4" "R5") 
    (while #t
      (display (get-top-sti-rules 1))
      (newline)
      (print
        (cog-av-sti (car r1))
        (cog-av-sti (car r2))
        (cog-av-sti (car r3))
        (cog-av-sti (car r4))
        (cog-av-sti (car r5))
      )
      (usleep 500000)
    )
  )
)

(show-result)

; To plot the graph
; gnuplot -e "plot 'ecan.csv' using 1 with lines, 'ecan.csv' using 2 with lines, 'ecan.csv' using 3 with lines, 'ecan.csv' using 4 with lines; pause -1"
