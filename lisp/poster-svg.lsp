(#:when (isempty talks)
 (p "There are currently no scheduled talks."))
(#:when (! (isempty talks))
 (svg ([width 850] [height 1100])
      ;(text ([fill "#000000"]
      ;       [font-size 45]
      ;       [font-family "Ubuntu"]
      ;       [x 50]
      ;       [y 86]) "Mathematics Student Seminars")
      (image ([width 828]
              [height 276]
              [xlink:href "http://uwseminars.com/seminar.png"]
              [x 11]
              [y 70]))
      (text ([fill "#000000"]
             [font-size 40]
             [font-family "Ubuntu"]
             [x 50]
             [y 375])
            (#:var (human (date (ref talks 1))))
            " in " (#:var (location (ref talks 1))))
      (text ([fill "#000000"]
             [font-size 20]
             [font-family "Ubuntu"]
             [x 50]
             [y 410])
            "All are welcome.")
      (text ([fill "#000000"]
             [font-size 18]
             [font-family "Ubuntu"]
             [x 50]
             [y 995])
            "For more details, visit us at our website:")
      (text ([fill "#000000"]
             [font-size 18]
             [font-family "Ubuntu"]
             [x 50]
             [y 1020])
            "http://uwseminars.com")
      (#:each i (colon 1 (length talks))
       `((text ([fill "#000000"]
                [font-size 30]
                [font-family "Ubuntu"]
                [x 50]
                [y ,(+ (* 240 i) 230)])
               ,(ref (ref talks i) 'topic))
         (text ([fill "#000000"]
                [font-size 30]
                [font-family "Ubuntu"]
                [x 800]
                [y ,(+ (* 240 i) 230)]
                [text-anchor "end"])
               ,(ref (ref (ref talks i) 'time) (colon 1 5)))
         (text ([fill "#000000"]
                [font-size 18]
                [font-family "Ubuntu"]
                [x 50]
                [y ,(+ (* 240 i) 260)])
               "by " ,(speaker (ref talks i)))
         (foreignObject
           ([x 50] [y ,(+ (* 240 i) 280)] [width 750] [height 400])
           (p ([style "font-family:Ubuntu; font-size: 16pt;"])
              ,(join (take (split
                             (if (hasabstract (ref talks i))
                               (readstring
                                 (abstractpath (ref talks i)))
                               "No abstract available") ".")
                           3) ".") "."))))))
