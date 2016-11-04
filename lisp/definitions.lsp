(#:define (human (:: d Date))
  ((. Dates format) d "E U d, YYYY"))
(#:define (human d) (human (Date d)))

(#:define (time-part t)
  (String (collect (take t (Int 5)))))

(#:define (nav-link url text)
  `(li (a ([href ,(string "/seminar/" url)]) ,text)))

(#:define (render-talk-brief t)
  `((h2 (a ([href ,(ref t 'url)]) ,(ref t 'title)))
    (p ,(ref t 'summary))))

(#:define (tag-link tag)
  `(a ([href ,(string "/seminar/tag/" tag)]) ,tag))
