(#:markdown "../pages/documents.md")

(#:each d documents
  (render-talk-brief (brief d)))
