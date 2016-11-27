(h1 "Potential Topics")

(p "Here is a list of potential topics. "
   "You may also consider browsing topics by "
   (#:template link-to "tags" "tag")
   ". First-year students may wish to browse our list of "
   (#:template link-to "tag/first-year-friendly"
    "first-year-friendly topics")
   ". Once you have found a topic, whether a suggested topic or one of "
   "your own choosing, please fill out the "
   (#:template link-to "submit-talk" "form")
   " to submit a talk proposal.")

(#:each s suggestions
  (render-suggestion s))
