;; TODO: This definition is defined in Julia too; ideally we would like not to
;; repeat code.
(#:define (human (:: d Date))
  ((. Dates format) d "E U d, YYYY"))

(#:define (time-part t)
  (String (collect (take t 5))))

(#:define (nav-link url text)
  `(li (a ([href ,(string "/" url)]) ,text)))

(#:define (render-talk-brief t)
  `((h2 (a ([href ,(string "/" (ref t 'url))]) ,(ref t 'title)))
    (p ,(ref t 'summary))))

(#:define (render-reference r)
  ((. StdLib rendermd) r))

(#:define (li x)
  `(li ,x))

(#:define (render-suggestion s)
  (append
    (if (haskey s 'excerpt)
      `(,((. StdLib rendermd) (ref s 'excerpt)))
      '())
    (if (isempty (ref s 'references))
      '()
      `((p "Possible reference materials for this topic include")
        ,(Cons 'ul (convert List (map (∘ li render-reference)
                                      (ref s 'references))))))
    (if (isempty (get s 'see-also '()))
      '()
      `((p "Past and scheduled talks on a related subject include")
        ,(Cons 'ul (convert List (map (∘ li archive-link)
                                      (ref s 'see-also))))))
    `((p "Quick links: "
         (a ([href ,(string "https://www.google.ca/search?q="
                            (ref s 'topic))])
            "Google search") ", "
         (a ([href ,(string "http://search.arxiv.org:8081/?query="
                            (ref s 'topic))])
            "arXiv.org search") ", "
         (a ([href ,(string "/submit-talk")])
            "propose to present a talk")))
    `((h3 ,(ref s 'topic))
      ,(Cons 'p (render-inline-tags (ref s 'tags))))))

(#:define (interpolate item between)
  (if (isempty between) '()
    (Cons (car between) (Cons item (interpolate item (cdr between))))))

(#:define (render-inline-tags ts)
  (interpolate " " (convert List (map tag-link (sort ts)))))

(#:define (archive-link t)
  `(a ([href ,(string "/archive/" t)]) ,(ref (ref talkdict t) 'topic)))

(#:define (tag-link tag)
  `(a ([class ,(string "tag-link tag-" tag)]
       [href ,(string "/tag/" tag)]) ,tag))

(#:define (link-to url text)
  `(a ([href ,(string "/" url)]) ,text))
