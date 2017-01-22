(#:markdown "../pages/faq.md")

(h2 "Did we answer your question?")
(p "If not, please ask us!")

(form ([action "https://formspree.io/atiwary@uwaterloo.ca"]
       [method "post"])
      (label "How can we contact you? (Email address): "
             (input ([name "_replyto"]
                     [type "text"]
                     [placeholder "example@uwaterloo.ca"])))
      (label "What question do you have?"
             (textarea ([name "question"]
                        [rows 8]
                        [cols 50])))
      (button ([type "submit"]) "Ask")
      (input ([type "hidden"]
              [name "_cc"]
              [value "fengyang.wang.0@gmail.com"]))
      (input ([type "hidden"]
              [name "_next"]
              [value "//uwseminars.com/thanks"])))
