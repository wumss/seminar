(h1 "Potential Topics")

(p "Here is a list of potential topics. "
   "You may also consider browsing topics by "
   (#:template link-to "tags" "tag")
   ". First-year students may wish to browse our list of "
   (#:template link-to "tag/first-year-friendly"
    "first-year-friendly topics")
   ". We have "
   (remark (string (length suggestions)))
   " potential topics for you to choose from, or you could create your own! "
   "Once you have found a topic, whether a suggested topic or one of "
   "your own choosing, please fill out the "
   (#:template link-to "submit-talk" "form")
   " to submit a talk proposal.")

(p "Remember these topics are meant as suggestions to spark ideas! "
   "Feel free to take any topic mentioned here and make it your own.")

(#:each s suggestions
  (render-suggestion s))
