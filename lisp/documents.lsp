(include "../pages/documents.md" #:markdown)

(#:each d documents
  (render-talk-brief (brief d)))
