#!/usr/bin/env julia

using SExpressions
using FunctionalCollections

tmpl = SExpressions.parsefile("themes/seminar/core.lsp")

function generate_page(data, root, tmpl=tmpl; title=root)
    data = stringmime("text/html",
                      Base.Markdown.parse(data))
    html = SExpressions.Htsx.tohtml(tmpl, @Persistent Dict(
        :title => title,
        :page => HTML(data)))
    try mkdir("static/$root") end
    open("static/$root/index.html", "w") do f
        println(f, html)
    end
end

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md"
        generate_page(readstring("pages/$page"), root; title=page)
    end
end
