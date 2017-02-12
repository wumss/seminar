const EXTRA_MODULES = [Tags, Common]
function generate_page(data, root, page="remark/core.rem"; modules=[])
    start = Dates.now()
    info(isempty(root) ? "Index Page" : root; prefix="GENERATING: ")

    try mkdir("public/$root") end
    data[:currentpage] = root
    open("public/$root/index.html", "w") do f
        SExpressions.Htsx.tohtml(f, page, data;
                                 modules=vcat(EXTRA_MODULES, modules))
        println(f)
    end

    finish = Dates.now()
    println(lpad("done in $(lpad(finish - start, 17))", displaysize(STDERR)[2]))
end
