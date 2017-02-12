(include "../pages/archived-talks.md" #:markdown)

(#:each t (reverse talks)
 (render-talk-brief t))
