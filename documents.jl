documents = JSON.parsefile("data/documents.json";
                           dicttype=Dict{Symbol,Any})
sort!(documents, by=x -> x[:title])

docs_bytag = DefaultDict(String, Vector{Any}, () -> [])
try mkdir("public/document") end
for d in documents
    union!(tags, d[:tags])
    # update tag popularity
    for t in d[:tags]
        push!(docs_bytag[t], d)
    end
    populate!(tagmatrix, d[:tags], 2)

    generate_page(merge(Dict(
        :document => d,
        :pagetype => "document",
        :mathjaxplease => true,
        :brief => brief
    ), d), "document/$(d[:id])")
end
