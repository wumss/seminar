(#:markdown "../pages/home.md")

(#:define (talk-row t)
  (append `((tr (td ,(topic t))
                (td ,(speaker t))
                (td ,(location t))
                (td ,(String (time-part (ref t 'time))))))
          (if (hasabstract t)
            `((tr (td ([colspan 4])
                      (#:markdown
                       ,(string "../" (abstractpath t))))))
            '())))

(h2 "Upcoming Talks")

(table
  (thead
    (tr (th "Topic") (th "Speaker") (th "Location") (th "Time")))
  (tbody
    (#:each d (unique (map date talks))
     (if (≥ (Date d) ((. Dates today)))
       (let ([ts (filter (λ (t) (== (date t) d)) talks)])
         (append
           `((tr (th ([colspan 4]) "Talks on " ,(human d))))
           (convert List (flatten (map talk-row ts)))))
         '()))))

(h2 "Website Information")

(p "This website was last regenerated on "
   (#:var (human ((. Dates today))))
   " by Htsx with Julia "
   (#:var (string VERSION))
   ".")
