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

(#:define (render-reference r)
  ((. StdLib rendermd) r))

(#:define (li x)
  `(li ,x))

(#:define (render-suggestion s)
  (append
    `((h3 ,(ref s 'topic)))
    (if (isempty (ref s 'references))
      '()
      `((h4 "Possible References")
        ,(Cons 'ul (convert List (map (∘ li render-reference)
                                      (ref s 'references))))))
    (if (isempty (ref s 'see-also))
      '()
      `((h4 "Related Past Talks")
        ,(Cons 'ul (convert List (map (∘ li archive-link)
                                      (ref s 'see-also))))))
    (if (haskey s 'excerpt)
      `(,((. StdLib rendermd) (ref s 'excerpt)))
      '())
    `((p "Quick links: "
         (a ([href ,(string "https://www.google.ca/search?q="
                            (ref s 'topic))])
            "Google search") ", "
         (a ([href ,(string "http://search.arxiv.org:8081/?query="
                            (ref s 'topic))])
            "arXiv.org search") ", "
         (a ([href ,(string "/seminar/potential-topics/#request")])
            "propose to present a talk")))))


(#:define (archive-link t)
  `(a ([href ,(string "/seminar/archive/" t)]) ,(ref (ref talkdict t) 'topic)))

(#:define (tag-link tag)
  `(a ([href ,(string "/seminar/tag/" tag)]) ,tag))

(#:define (link-to url text)
  `(a ([href ,(string "/seminar/" url)]) ,text))
