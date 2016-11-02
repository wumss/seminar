#!/usr/bin/env julia

using SExpressions
using FunctionalCollections

function generate_page(data, root, page="themes/seminar/core.lsp")
    try mkdir("static/$root") end
    open("static/$root/index.html", "w") do f
        SExpressions.Htsx.tohtml(f, page, data)
        println(f)
    end
end

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md"
        data = stringmime("text/html",
                          Base.Markdown.parse(readstring("pages/$page")))
        generate_page(Dict(
            :title => root,
            :page => root,
            :pagetype => "page"), root)
    end
end

generate_page(Dict(
    :title => "Archived Talks",
    :pagetype => "archived-talks"), "archive")
