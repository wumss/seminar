(#:markdown "../pages/tags.md")

(ul
  (#:each tag alltags
   `((li ,(tag-link tag)))))
