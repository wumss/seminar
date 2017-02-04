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
  (#:markdown (string "../" (abstractpath talk))))

(#:when (hassummary talk)
  (h2 "Summary")
  (#:markdown (string "../" (summarypath talk))))

(h2 "Tags")

(ul
  (#:each tag (tags talk)
    `((li ,(tag-link tag)))))
