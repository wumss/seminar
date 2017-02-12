(include "../pages/archived-talks.md" #:markdown)

(#:each t (reverse talks)
 (append
   `((h3 (a ([href ,(string "/" (url t))]) ,(title t)))
     (p "Delivered by " ,(speaker t) " on " ,(human (datetime t))))
   (if (hasabstract t)
     (list ((. StdLib rendermd) (readstring (abstractpath t))))
     '())
   (if (hassummary t)
     `((a ([href ,(string "/" (url t))])
          "A summary of this talk is available here."))
     '())))
