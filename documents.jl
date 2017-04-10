documents = JSON.parsefile("data/documents.json";
                           dicttype=Dict{Symbol,Any})
sort!(documents, by=x -> x[:title])

docs_bytag = DefaultDict{Tag, Vector{Any}}(() -> [])
for d in documents
    # update tag popularity
    populate!(tagmatrix, d[:tags], 2)
    for t in d[:tags]
        push!(docs_bytag[tagobject(tagmatrix, t)], d)
    end

    generate_page(site, "document/$(d[:id])"; data=Dict(
        :pagetitle => d[:title],
        :document => d,
        :pagetype => "document",
        :mathjaxplease => true,
        :github => "$GITHUB/document/$(d[:id])"
    ), modules=[Talks])
end

generate_page(site, "document"; data=Dict(
    :pagetitle => "Documents",
    :pagetype => "documents",
    :documents => documents,
    :mathjaxplease => true,
    :talks => talks,
    :github => "$GITHUB/pages/document.md"), modules=[Talks])
