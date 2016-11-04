#!/usr/bin/env julia

using SExpressions
using FunctionalCollections

try mkdir("public") end

function generate_page(data, root, page="lisp/core.lsp")
    println(STDERR, "Generating page $root...")
    try mkdir("public/$root") end
    open("public/$root/index.html", "w") do f
        SExpressions.Htsx.tohtml(f, page, data)
        println(f)
    end
end

publics = [
    "write-markdown",
    "suggested-topics",
    "faq"]

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md" && root in publics
        data = stringmime("text/html",
                          Base.Markdown.parse(readstring("pages/$page")))
        generate_page(Dict(
            :title => root,
            :page => root,
            :pagetype => "page",
            :mathjaxplease => true), root)
    end
end
