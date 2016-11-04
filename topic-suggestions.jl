suggestions = JSON.parsefile("data/suggested-topics.json";
                             dicttype=Dict{Symbol,Any})

bytag = DefaultDict(String, Vector{Any}, () -> [])
for s in suggestions
    union!(tags, s[:tags])
    # update tag popularity
    for t in s[:tags]
        tagpopularity[t] += 1
        push!(bytag[t], s)
    end
end
