(include "../pages/documents.md" #:markdown)

(#:each d documents
  (render-document-brief (brief d)))
