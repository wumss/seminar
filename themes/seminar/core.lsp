(html
  (head
    (meta ([charset "utf-8"]))
    (link ([rel "stylesheet"]
           [href "//yegor256.github.io/tacit/tacit.min.css"]))
    (link ([rel "stylesheet"]
           [href "/seminar/css/custom.css"]))
    (title (#:var title)))
  (body
    (nav (ul (li (a ([href "/seminar"]) "Math Seminar Home"))
             (li (a ([href "/seminar/archive"]) "archive"))
             (li (a ([href "/seminar/#upcoming_talks"]) "upcoming talks"))
             (li (a ([href "/seminar/#feedback"]) "feedback")))
         (form
           (input ([id "search"] [type "text"] [placeholder "Search"]))
           (button ([type "submit"]) "Search")))
    (section
      (article
        (#:var page)))
    (script ([src "/seminar/js/vendor/lunr.min.js"]))
    (script ([src "/seminar/js/script.js"]))))
