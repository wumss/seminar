(#:markdown "../pages/archived-talks.md")

(#:each t (reverse talks)
  (render-talk-brief t))
