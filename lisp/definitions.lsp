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

(#:define (render-reference r) r)

(#:define (li x)
  `(li ,x))

(#:define (render-suggestion s)
  (append
    `((h2 ,(ref s 'topic))
      (h3 "Possible References")
      ,(Cons 'ul (convert List (map
                                 (∘ li render-reference)
                                 (ref s 'references)))))
    (if (isempty (ref s 'see-also))
        '()
        `((h3 "Related Past Talks")
          ,(Cons 'ul (convert List (map
                                    (∘ li archive-link)
                                    (ref s 'see-also))))))))

(#:define (archive-link t)
  `(a ([href ,(string "/seminar/archive/" t)]) ,(ref (ref talkdict t) 'topic)))

(#:define (tag-link tag)
  `(a ([href ,(string "/seminar/tag/" tag)]) ,tag))
