(include "../pages/tags.md" #:markdown)

(remark
  (define alltags (collect (tags tagmatrix)))
  (define majortags
    (filter (λ (t) (> ((. Tags popularity) tagmatrix t) 2)) alltags))
  (define minortags
    (filter (λ (t) (≤ ((. Tags popularity) tagmatrix t) 2)) alltags)))

;; TODO: this is a really good idea in theory, but we need a way to associate
;; tag names with their URIs from the JavaScript side before it's practical.
;;(p (label "Find a tag: "
;;          (input ([type "text"]
;;                  [id "selectedtag"]
;;                  [list "taglist"]))
;;          (datalist ([id "taglist"])
;;                    (#:each t alltags
;;                     `((option ([value ,(tagname t)]))))))
;;   (button ([id "tagclick"]) "View tag page"))

(remark
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
;; TODO: see above
;; (script ([src "/scripts/tagclick.js"]))
