(#:include "definitions.lsp")

(html
  (head
    (meta ([charset "utf-8"]))
    (link ([rel "stylesheet"]
           [href "//yegor256.github.io/tacit/tacit.min.css"]))
    (link ([rel "stylesheet"]
           [href "/seminar/css/custom.css"]))
    (#:when (defined? 'mathjaxplease)
     (#:include "mathjax.lsp"))
    (title (#:var title)))
  (body
    (nav (ul (#:template nav-link "" "Math Seminar Home")
             (#:template nav-link "archive" "archive")
             (#:template nav-link "tags" "tags")
             (#:template nav-link "faq" "faq")))
    (section
      (article
        (#:include (string pagetype ".lsp")))
      (#:when (defined? 'github)
       (footer (p "Help improve this page by "
                  ;; can't use the obvious #:var, so use ugly workaround
                  ;; todo: support #:var in attributes in Htsx
                  (#:each _ 0 `(((a ([href ,github]) "editing it on GitHub"))))
                  "."))))))
