(#:markdown "../../pages/home.md")

(h2 "Upcoming Talks")

(table
  (thead
    (tr (th "Topic") (th "Speaker") (th "Location") (th "Time")))
  (tbody
    (#:each t upcoming
     `((tr (td ,(ref t 'topic))
           (td ,(ref t 'speaker))
           (td ,(ref t 'location))
           (td ,(ref t 'time)))))))
