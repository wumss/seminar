suggestions = JSON.parsefile("data/suggested-topics.json";
                             dicttype=Dict{Symbol,Any})
sort!(suggestions, by=x -> x[:topic])

new_suggestions = []

bytag = DefaultDict{Tag, Vector{Any}}(() -> [])
for s in suggestions
    # update tag popularity
    populate!(tagmatrix, s[:tags], 1)
end

tagsuggestions = Dict(
    s[:topic] => s for s in suggestions if s[:topic] in s[:tags]
)
suggestions = [s for s in suggestions if !(s[:topic] in s[:tags])]

for s in suggestions
    for t in s[:tags]
        push!(bytag[tagobject(tagmatrix, t)], s)
    end
end
