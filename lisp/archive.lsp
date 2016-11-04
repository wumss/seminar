(p "This talk on "
   (#:var topic)
   " was held on "
   (#:var (human date))
   " in "
   (#:var location)
   ". The speaker was "
   (#:var speaker)
   ".")

(#:when (defined? 'abstract)
  (h2 "Abstract")
  (#:markdown (string "../abstract/" abstract)))

(#:when (and (defined? 'summary) (!= summary (. Base summary)))
  (h2 "Summary")
  (#:markdown (string "../summary/" summary)))

(h2 "Tags")

(ul
  (#:each tag tags
    `((li ,(tag-link tag)))))
