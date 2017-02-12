(include "../pages/documents.md" #:markdown)

(h2 "Documents")

(#:each d documents
  (render-document-brief (brief d)))

(h2 "Summarized Talks")

(#:each t (filter hassummary talks)
 (render-talk-brief t))
