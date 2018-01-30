(module UWSeminars
  (require (.Articles Remarkable))
  (require (.Common Remarkable))
  (require (.Tags Remarkable))
  (require (.Talks Remarkable))
  (require SExpressions)
  (require (.StdLib (.Remark Remarkable)))
  (require Dates)
  (require EnglishText)

  (provide human time-part render-document-brief render-talk-brief
           render-reference li interpolate render-inline-tags tag-link link-to)

  (define (human (:: d (.TimeType Dates)))
    ((.format Dates) d "E U d, YYYY"))

  (define (time-part t)
    ((.format Dates) t "HH:MM"))

  (define (render-document-brief t)
    `((h3 (a ([href ,(string "/" (ref t 'url))]) ,(ref t 'title)))
      (p ,(ref t 'summary))))

  (define (cut-abstracts-at-h2 abstracts)
    (if (or (empty? abstracts)
            (and (pair? (car abstracts)) (== (car (car abstracts)) 'h2)))
      '()
      (cons (car abstracts) (cut-abstracts-at-h2 (cdr abstracts)))))

  (define (cut-abstract-at-h2 abstract)
    (if (== (car abstract) 'div)
      (cut-abstracts-at-h2 (cdr abstract))))

  (define (render-talk-brief t)
    (append
      (list (append `(h3 (a ([href ,(string "/" (url t))]) ,(title t)))
                    (if (and (hassummary t)
                             (> (Date (DateTime (datetime t)))
                                (- ((.today Dates)) ((.Day Dates) 10))))
                      '(" (New!)") '())))
      `((p "Delivered by " ,(ItemList (authors t)) " on " ,(human (datetime t))))
      (if (hasabstract t)
        (cut-abstract-at-h2
          ((.rendermd StdLib) (read (abstractpath t) String)))
        '())
      (if (hassummary t)
        `((p (a ([href ,(string "/" (url t))])
                "A summary of this talk is available here.")))
        '())))

  (define (render-reference r)
    ((.rendermd StdLib) r))

  (define (li x)
    `(li ,x))

  (define (interpolate item between)
    (if (isempty between) '()
      (cons (car between) (cons item (interpolate item (cdr between))))))

  (define (render-inline-tags ts)
    (interpolate " " (convert list (map tag-link (sort ts)))))

  ;; TODO: in the long term, we want to use tag objects instead of strings
  ;; everywhere.
  (define (tag-link (:: tag-name String))
    (let ([uri (urinormalize tag-name)])
      `(a ([class ,(string "tag-link tag-" uri)]
           [href ,(string "/tag/" uri "/")]) ,tag-name)))

  (define (tag-link (:: tag Tag))
    (tag-link (tagname tag)))

  (define (link-to url text)
    `(a ([href ,(string "/" url "/")]) ,text)))
