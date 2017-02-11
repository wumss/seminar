(#:define (human (:: d (. Dates TimeType)))
  ((. Dates format) d "E U d, YYYY"))

(#:define (time-part t)
  ((. Dates format) t "HH:MM"))

(#:define (nav-link url text)
 (if (== url currentpage)
   `(li ([class "current"]) (a ([href ,(string "/" url)]) ,text))
   `(li (a ([href ,(string "/" url)]) ,text))))

(#:define (render-talk-brief t)
  `((h3 (a ([href ,(string "/" (ref t 'url))]) ,(ref t 'title)))
    (p ,(ref t 'summary))))

(#:define (render-reference r)
  ((. StdLib rendermd) r))

(#:define (li x)
  `(li ,x))

(#:define (render-suggestion s)
  (append
    `((h3 ,(ref s 'topic)))
    (if (haskey s 'excerpt)
      `(,((. StdLib rendermd) (ref s 'excerpt)))
      '())
    (if (isempty (ref s 'references))
      '()
      `((p "Possible reference materials for this topic include")
        ,(cons 'ul (convert list (map (∘ li render-reference)
                                      (ref s 'references))))))
    (if (isempty (get s 'see-also '()))
      '()
      `((p "Past and scheduled talks on a related subject include")
        ,(cons 'ul (convert list (map (∘ li archive-link)
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
    `(,(cons 'p (render-inline-tags (ref s 'tags))))))

(#:define (interpolate item between)
  (if (isempty between) '()
    (cons (car between) (cons item (interpolate item (cdr between))))))

(#:define (render-inline-tags ts)
  (interpolate " " (convert list (map tag-link (sort ts)))))

(#:define (archive-link t)
 `(span
    (a ([href ,(string "/archive/" t)]) ,(title (ref talkdict t)))
    " by " ,(speaker (ref talkdict t))))

;; TODO: in the long term, we want to use tag objects instead of strings
;; everywhere.
(#:define (tag-link (:: tag-name String))
 (let ([uri (urinormalize tag-name)])
   `(a ([class ,(string "tag-link tag-" uri)]
        [href ,(string "/tag/" uri)]) ,tag-name)))

(#:define (tag-link (:: tag Tag))
 (tag-link (tagname tag)))

(#:define (link-to url text)
  `(a ([href ,(string "/" url)]) ,text))
