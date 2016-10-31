using SExpressions
using FunctionalCollections

tmpl = SExpressions.parsefile("themes/seminar/core.lsp")
for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md"
        data = stringmime("text/html",
                          Base.Markdown.parse(readstring("pages/$page")))
        html = SExpressions.Htsx.tohtml(tmpl, @Persistent Dict(
            :title => page,
            :page => HTML(data)))
        try mkdir("static/$root") end
        open("static/$root/index.html", "w") do f
            println(f, html)
        end
    end
end
