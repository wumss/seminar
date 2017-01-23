(h1 "Tag " (#:var tag))

(p "There have been "
   (#:var (string (ItemList (List
                              (ItemQuantity
                                (count iscompleted talks)
                                "completed talks")
                              (ItemQuantity
                                (count (! iscompleted) talks)
                                "scheduled talks")))))
   " tagged with " (b (#:var tag)) ".")

(#:when (! (isempty related))
  (h2 "Related Tags")
  (ul (#:each t related
        `((li ,(tag-link (ref t 1)))))))

(h2 "Completed Talks")

(#:each t (reverse (filter iscompleted talks))
  (render-talk-brief (brief t)))

(h2 "Scheduled Talks")

(#:each t (filter (! iscompleted) talks)
  (render-talk-brief (brief t)))

(h2 "Documents")

(#:each t documents
  (render-talk-brief (brief t)))

(h2 ([id "suggestions"]) "Talk Suggestions")

(#:each s suggestions
  (render-suggestion s))
