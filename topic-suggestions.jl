suggestions = JSON.parsefile("data/suggested-topics.json";
                             dicttype=Dict{Symbol,Any})
sort!(suggestions, by=x -> x[:topic])

bytag = DefaultDict{String, Vector{Any}}(() -> [])
for s in suggestions
    # update tag popularity
    for t in s[:tags]
        push!(bytag[t], s)
    end
    populate!(tagmatrix, s[:tags], 1)
end
