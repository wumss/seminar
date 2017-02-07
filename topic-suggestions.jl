suggestions = JSON.parsefile("data/suggested-topics.json";
                             dicttype=Dict{Symbol,Any})
sort!(suggestions, by=x -> x[:topic])

bytag = DefaultDict{Tag, Vector{Any}}(() -> [])
for s in suggestions
    # update tag popularity
    populate!(tagmatrix, s[:tags], 1)
    for t in s[:tags]
        push!(bytag[tagobject(tagmatrix, t)], s)
    end
end
