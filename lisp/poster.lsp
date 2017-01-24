(#:when (isempty talks)
 (p "There are currently no scheduled talks."))
(#:when (! (isempty talks))
 (div ([class "minipage"])
      (img ([width 750]
            [height 285]
            [src "http://uwseminars.com/seminar-transparent.png"]
            [class "banner"]))
      (p ([class "location-time"])
         (#:var (human (date (ref talks 1))))
         " in " (#:var (location (ref talks 1))))
      (div ([class "talks"])
           (#:each t talks
            `((h2 ,(topic t))
              (time ,(ref (ref t 'time) (colon 1 5)))
              (p ([fill "#000000"]
                  [font-size 18]
                  [font-family "Ubuntu"]
                  [x 50])
                 "by " ,(speaker t))
              (p ([class "talk-abstract"])
                 ,((. StdLib rendermd)
                   (join (take (sentences
                                 (if (hasabstract t)
                                   (readstring
                                     (abstractpath t))
                                   "No abstract available."))
                              3) " "))))))
      (p ([class "website-link"])
         "For more details, go to http://uwseminars.com, "
         "or UW Student Seminars on Facebook")))
