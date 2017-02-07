;; todo: will be held on if the talk has not yet been held
(p "This talk on "
   (#:var (title talk))
   " was held on "
   (#:var (human (datetime talk)))
   " in "
   (#:var (location talk))
   ". The speaker was "
   (#:var (speaker talk))
   ".")

(#:when (hasabstract talk)
  (h2 "Abstract")
  (include (string "../" (abstractpath talk)) #:markdown))

(#:when (hassummary talk)
  (h2 "Summary")
  (include (string "../" (summarypath talk)) #:markdown))

(h2 "Tags")

(ul
  (#:each tag (tags talk)
    `((li ,(tag-link tag)))))
