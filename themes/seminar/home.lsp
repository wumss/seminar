(#:markdown "../../pages/home.md")

(h2 "Upcoming Talks")

(table
  (thead
    (tr (th "Topic") (th "Speaker") (th "Location") (th "Time")))
  (tbody
    (#:each d dates
     (if (< (Date d) ((. Dates today)))
       (let ([ts (filter (λ (t) (== (ref t 'date) d)) talks)])
         (convert List (map (λ (t)
                               `((tr (td ,(ref t 'topic))
                                     (td ,(ref t 'speaker))
                                     (td ,(ref t 'location))
                                     (td ,(ref t 'time)))))
                            ts)))
       '()))))
