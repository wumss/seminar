using JSON
data = readdlm("input.tsv", '\t')
talks = []
for row in 1:size(data, 1)
    if length(data[row,1]) == 10
        for (i, j, k) in ((2, 3, 17), (4, 5, 18))
            push!(talks, Dict(
                "speaker"    => data[row,i],
                "topic"      => data[row,j],
                "location"   => "MC 4045",
                "time"       => "$(data[row,1])T$k:30:00Z",
                "tags"       => [],
                "identifier" => "$(data[row,i])-change-me"
            ))
        end
    end
end
println(JSON.json(talks, 4))
