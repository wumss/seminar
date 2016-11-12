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
        :brief => brief,
        :github => "$GITHUB/document/$(d[:id])"
    ), d), "document/$(d[:id])")
end

generate_page(Dict(
    :title => "Documents",
    :pagetype => "documents",
    :documents => documents,
    :brief => brief,
    :mathjaxplease => true,
    :github => "$GITHUB/pages/document.md"), "document")
