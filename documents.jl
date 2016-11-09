documents = JSON.parsefile("data/documents.json";
                           dicttype=Dict{Symbol,Any})
sort!(documents, by=x -> x[:topic])

docs_bytag = DefaultDict(String, Vector{Any}, () -> [])
try mkdir("public/document") end
for d in documents
    union!(tags, d[:tags])
    # update tag popularity
    for t in d[:tags]
        tagpopularity[t] += 1
        push!(docs_bytag[t], d)
    end

    generate_page(merge(Dict(
        :document => d,
        :pagetype => "document",
        :mathjaxplease => true,
        :brief => brief
    ), d), "document/$(d[:id])")
end
