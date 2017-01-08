documents = JSON.parsefile("data/documents.json";
                           dicttype=Dict{Symbol,Any})
sort!(documents, by=x -> x[:title])

docs_bytag = DefaultDict{String, Vector{Any}}(() -> [])
try mkdir("public/document") end
for d in documents
    # update tag popularity
    for t in d[:tags]
        push!(docs_bytag[t], d)
    end
    populate!(tagmatrix, d[:tags], 2)

    generate_page(Dict(
        :title => d[:title],
        :document => d,
        :pagetype => "document",
        :mathjaxplease => true,
        :github => "$GITHUB/document/$(d[:id])"
    ), "document/$(d[:id])"; modules=[Talks])
end

generate_page(Dict(
    :title => "Documents",
    :pagetype => "documents",
    :documents => documents,
    :mathjaxplease => true,
    :github => "$GITHUB/pages/document.md"), "document"; modules=[Talks])
