(#:markdown "../pages/tags.md")

(ul
  (#:each tag tags
   `((li ,(tag-link tag)))))
