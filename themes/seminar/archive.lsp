(#:define (human (:: d Date))
  ((. Dates format) d "E U d, YYYY"))
(#:define (human d) (human (Date d)))

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
  (#:markdown (string "../../abstract/" abstract)))

(#:when (and (defined? 'summary) (!= summary (. Base summary)))
  (h2 "Summary")
  (#:markdown (string "../../summary/" summary)))
