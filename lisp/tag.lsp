;; setup
(#:execute
 (= related (relatedto tagmatrix tag))
 (= subtopics (subtags tagmatrix tag))
 (= uri (urinormalize (tagname tag))))

;; document
(h1 (#:var (ucfirst (tagname tag))))

(#:when (isfile (string "wiki/tag/" uri ".md"))
 (include (string "../wiki/tag/" uri ".md") #:markdown))

(p "There have been "
   (#:var
    (string
      (ItemList (filter (! isnothing)
                        (List
                          (ItemQuantity
                            (count iscompleted talks)
                            "completed talk")
                          (ItemQuantity
                            (count (! iscompleted) talks)
                            "scheduled talk")
                          (ItemQuantity
                            (length documents)
                            "document")
                          (ItemQuantity
                            (length suggestions)
                            "topic suggestion"))))))
   " tagged with " (b (#:var (tagname tag))) ".")

(#:when (> (length subtopics) 1)
 (p "There are many subfields of " (b (#:var (tagname tag)))
    ", including: ")
 (ul (#:each t subtopics
      `((li ,(tag-link t))))))

(#:when (! (isempty related))
  (h2 "Related Tags")
  (ul (#:each t related
        `((li ,(tag-link (ref t 1)))))))

(#:when (! (iszero (count iscompleted talks)))
 (h2 "Completed Talks")

 (#:each t (reverse (filter iscompleted talks))
  (render-talk-brief (brief t))))

(#:when (! (iszero (count (! iscompleted) talks)))
 (h2 "Scheduled Talks")

 (#:each t (filter (! iscompleted) talks)
  (render-talk-brief (brief t))))

(#:when (! (isempty documents))
 (h2 "Documents")

 (#:each t documents
  (render-talk-brief (brief t))))

(#:when (! (isempty suggestions))
 (h2 ([id "suggestions"]) "Talk Suggestions")

 (#:each s suggestions
  (render-suggestion s)))
