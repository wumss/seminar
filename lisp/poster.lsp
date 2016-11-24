(svg ([width 850] [height 1100])
  ;(text ([fill "#000000"]
  ;       [font-size 45]
  ;       [font-family "Ubuntu"]
  ;       [x 50]
  ;       [y 86]) "Mathematics Student Seminars")
  (image ([width 828]
          [height 276]
          [xlink:href "https://friedeggs.github.io/seminar/seminar.png"]
          [x 11]
          [y 80]))
  (text ([fill "#000000"]
         [font-size 40]
         [font-family "Ubuntu"]
         [x 50]
         [y 385])
        (#:var (human date))
        " in " (#:var (ref (ref talks 1) 'location)))
  (text ([fill "#000000"]
         [font-size 20]
         [font-family "Ubuntu"]
         [x 50]
         [y 420])
        "All are welcome.")
  (#:each i (colon 1 (length talks))
   `((text ([fill "#000000"]
            [font-size 30]
            [font-family "Ubuntu"]
            [x 50]
            [y ,(+ (* 240 i) 240)])
           ,(ref (ref talks i) 'topic))
     (text ([fill "#000000"]
            [font-size 30]
            [font-family "Ubuntu"]
            [x 800]
            [y ,(+ (* 240 i) 240)]
            [text-anchor "end"])
           ,(String (ref (ref (ref talks i) 'time) (colon 1 5))))
     (text ([fill "#000000"]
            [font-size 18]
            [font-family "Ubuntu"]
            [x 50]
            [y ,(+ (* 240 i) 270)])
           "by " ,(ref (ref talks i) 'speaker))
     (foreignObject
       ([x 50] [y ,(+ (* 240 i) 290)] [width 750] [height 400])
       (p ([style "font-family:Ubuntu; font-size: 16pt;"])
          ,(join (ref (split
                        (readstring
                          (string "abstract/"
                                  (ref (ref talks i) 'identifier))) ".")
                      (colon 1 3)) ".") ".")))))
