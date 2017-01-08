function generate_page(data, root, page="lisp/core.lsp"; modules=[])
    start = Dates.now()
    info(isempty(root) ? "Index Page" : root; prefix="GENERATING: ")

    try mkdir("public/$root") end
    open("public/$root/index.html", "w") do f
        SExpressions.Htsx.tohtml(f, page, data; modules=modules)
        println(f)
    end

    finish = Dates.now()
    println(lpad("done in $(lpad(finish - start, 17))", displaysize(STDERR)[2]))
end
