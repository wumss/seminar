(include "../pages/tags.md" #:markdown)

(#:execute
 (= alltags (collect (tags tagmatrix)))
 (= majortags (filter (λ (t) (> ((. Tags popularity) tagmatrix t) 2)) alltags))
 (= minortags (filter (λ (t) (≤ ((. Tags popularity) tagmatrix t) 2)) alltags))
 (= tagforest (forest tagmatrix majortags))
 (= (tohtml (:: t (. Tags TagTree)))
    (if (isempty (children t))
      `(li ,(tag-link (root t)))
      `(li ,(tag-link (root t)) ,(tohtml (children t)))))
 (= (tohtml (:: ts (. Tags TagForest)))
    (cons 'ul (map tohtml (convert list ts)))))

(h2 "Major tags")

(include (tohtml tagforest) #:object)

(h2 "Minor tags")

(ul
  (#:each tag minortags
   `((li ,(tag-link tag)))))

(script ([src "/scripts/collapse.js"]))
(script "CollapsibleLists.applyTo(document.querySelector('ul'), true);")
