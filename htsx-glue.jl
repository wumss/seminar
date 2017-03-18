using SExpressions
using SchemeSyntax

for line in SExpressions.parsefile("remark/definitions.rkt")
    eval(SchemeSyntax.tojulia(line))
end
const EXTRA_MODULES = [Tags, Common, UWSeminars]
function generate_page(data, root, page="remark/core.rem"; modules=[])
    start = Dates.now()
    info(isempty(root) ? "Index Page" : root; prefix="GENERATING: ")

    try mkdir("public/$root") end
    data[:currentpage] = root
    open("public/$root/index.html", "w") do f
        Remarkable.Remark.tohtml(f, page, data;
                                 modules=vcat(EXTRA_MODULES, modules))
        println(f)
    end

    finish = Dates.now()
    println(lpad("done in $(lpad(finish - start, 17))", displaysize(STDERR)[2]))
end
