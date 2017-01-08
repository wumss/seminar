;; TODO: we ought not to use ref so often, as it's brittle to changes in format
(h1 (#:var (ref document 'title)))

(p (#:var (ref (brief document) 'summary)))

(#:markdown (string "../document/" (ref document 'id)))

(h2 "Tags")

(ul
  ;; TODO: technically tags is for talks, not documents
  ;; make sure to update once talks get a non-JSON data structure
  (#:each tag (tags document)
    `((li ,(tag-link tag)))))
