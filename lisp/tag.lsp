(h1 "Tag " (#:var tag))

(p "There have been " (#:var (string (length done)))
   " completed talks and " (#:var (string (length scheduled)))
   " scheduled talks tagged with " (b (#:var tag)) ".")

(#:when (! (isempty related))
  (h2 "Related Tags")
  (ul (#:each t related
        `((li ,(tag-link (ref t 1)))))))

(h2 "Completed Talks")

(#:each t (reverse done)
  (render-talk-brief (brief t)))

(h2 "Scheduled Talks")

(#:each t scheduled
  (render-talk-brief (brief t)))

(h2 "Documents")

(#:each t documents
  (render-talk-brief (brief t)))

(h2 ([id "suggestions"]) "Talk Suggestions")

(#:each s suggestions
  (render-suggestion s))
