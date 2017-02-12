(include "../pages/tags.md" #:markdown)

(remark
  (define alltags (collect (tags tagmatrix)))
  (define majortags
    (filter (λ (t) (> ((. Tags popularity) tagmatrix t) 2)) alltags))
  (define minortags
    (filter (λ (t) (≤ ((. Tags popularity) tagmatrix t) 2)) alltags))
  (define tagforest (forest tagmatrix majortags))
  (define (tohtml (:: t (. Tags TagTree)))
    (if (isempty (children t))
      `(li ,(tag-link (root t)))
      `(li ,(tag-link (root t)) ,(tohtml (children t) #f))))
  (define (tohtml (:: ts (. Tags TagForest)) isroot)
    (append '(ul)
            (if isroot '(([class "collapsibleList"])) '())
            (map tohtml (convert list ts))))
  
  (append (tohtml tagforest #t)
          `((li "uncategorized"
                ,(cons 'ul
                       (map (∘ li tag-link)
                            (convert list minortags)))))))

(script ([src "/scripts/collapse.js"]))
(script "CollapsibleLists.apply(true);")
