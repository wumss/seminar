(h1 (#:var title))

(p (#:var (ref (brief document) 'summary)))

(#:markdown (string "../document/" id))

(h2 "Tags")

(ul
  (#:each tag tags
    `((li ,(tag-link tag)))))
