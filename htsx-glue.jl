using SExpressions
using SchemeSyntax
using Remarkable.StaticSites

for line in SExpressions.parsefile("remark/definitions.rkt")
    eval(SchemeSyntax.tojulia(line))
end
const site = StaticSite(default_modules=[Tags, Common, UWSeminars])
