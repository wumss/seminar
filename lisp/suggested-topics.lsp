(h1 "Potential Topics")

(p "Here is a list of potential topics.")

(#:each s suggestions
  (render-suggestion s))

(#:include "winter-2017.lsp")
