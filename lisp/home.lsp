(include "../pages/home.md" #:markdown)

(remark
  (define (talk-row t)
    (append `((tr (td ,(title t))
                  (td ,(speaker t))
                  (td ,(location t))
                  (td ,(time-part (datetime t)))))
            (if (hasabstract t)
              `((tr (td ([colspan 4])
                        (include ,(string "../" (abstractpath t)) #:markdown))))
              '()))))

(h2 "Upcoming Talks")

(table
  (thead
    (tr (th "Topic") (th "Speaker") (th "Location") (th "Time")))
  (tbody
    (#:each d (unique (map (∘ Date datetime) talks))
     (if (≥ (Date d) ((. Dates today)))
       (let ([ts (filter (λ (t) (== (Date (datetime t)) d)) talks)])
         (append
           `((tr (th ([colspan 4]) "Talks on " ,(human d))))
           (convert List (flatten (map talk-row ts)))))
       '()))))

(h2 "Website Information")

(p "This website was last regenerated on "
   (remark (human ((. Dates today))))
   " by Htsx with Julia "
   (remark (string VERSION))
   ".")
