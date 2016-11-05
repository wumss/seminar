#!/usr/bin/env julia

using SExpressions
using FunctionalCollections

const GITHUB = "https://github.com/friedeggs/seminar/blob/master"

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
    "important-information",
    "thanks"]

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md" && root in publics
        data = stringmime("text/html",
                          Base.Markdown.parse(readstring("pages/$page")))
        generate_page(Dict(
            :title => root,
            :page => root,
            :pagetype => "page",
            :github => "$GITHUB/pages/$page",
            :mathjaxplease => true), root)
    end
end

generate_page(Dict(
    :title => "Frequently Asked Questions",
    :pagetype => "faq",
    :github => "$GITHUB/pages/faq.md"), "faq")
