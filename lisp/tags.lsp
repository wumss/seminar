(#:markdown "../pages/tags.md")

(ul
  (#:each tag tags
   `((li (a ([href ,(string "/seminar/tag/" tag)]) ,tag)))))
