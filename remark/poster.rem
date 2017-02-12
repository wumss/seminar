(#:when (isempty talks)
 (p "There are currently no scheduled talks."))
(#:when (! (isempty talks))
 (h1 "Marketing Poster")
 (p (label ([for "color-pick"])
           "Color: " (input ([type "text"]
                             [value "#FFF"]
                             [id "color-pick"]))))
 (div ([class "minipage"])
      (img ([width 750]
            [height 285]
            [src "http://uwseminars.com/seminar-transparent.png"]
            [class "banner"]))
      (p ([class "location-time"])
         (remark (human (datetime (ref talks 1))))
         " in " (remark (location (ref talks 1))))
      (div ([class "talks"])
           (#:each t talks
            `((h2 ,(title t))
              (time ,(time-part (datetime t)))
              (p ([fill "#000000"]
                  [font-size 18]
                  [font-family "Ubuntu"]
                  [x 50])
                 "by " ,(speaker t))
              (div ([class "talk-abstract"]
                    [contenteditable "true"])
                 ,((. StdLib rendermd)
                   (join (take (sentences
                                 (if (hasabstract t)
                                   (readstring
                                     (abstractpath t))
                                   "No abstract available."))
                              3) " "))))))
      (p ([class "website-link"])
         "For more details, go to http://uwseminars.com")))

(script ([src "/scripts/poster.js"]))
