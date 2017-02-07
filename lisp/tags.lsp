(include "../pages/tags.md" #:markdown)

(#:execute
 (= alltags (collect (tags tagmatrix)))
 (= majortags (filter (λ (t) (> ((. Tags popularity) tagmatrix t) 2)) alltags))
 (= minortags (filter (λ (t) (≤ ((. Tags popularity) tagmatrix t) 2)) alltags))
 (= tagforest (forest tagmatrix majortags))
 (= (tohtml (:: t (. Tags TagTree)))
    (if (isempty (children t))
      `(li ,(tag-link (root t)))
      `(li ,(tag-link (root t)) ,(tohtml (children t) #f))))
 (= (tohtml (:: ts (. Tags TagForest)) isroot)
    (append '(ul)
            (if isroot '(([class "collapsibleList"])) '())
            (map tohtml (convert list ts)))))

(include (append (tohtml tagforest #t)
                 `((li "uncategorized"
                       ,(cons 'ul
                              (map (∘ li tag-link)
                                   (convert list minortags))))))
         #:object)

(script ([src "/scripts/collapse.js"]))
(script "CollapsibleLists.apply(true);")
