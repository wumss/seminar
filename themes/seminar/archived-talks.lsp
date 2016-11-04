(h1 "Past Talks")

(p "Summaries of some past talks are available. "
   "This page is currently under renovation; come back later for content.")

(#:each x talks
 `((h2 (a ([href ,(ref x 'url)]) ,(ref x 'title)))
   (p ,(ref x 'summary))))
