#!/usr/bin/env julia

using JSON

include("build_help.jl")

try
    mkdir("public/archive")
end

human(d::Date) = Dates.format(d, "E U d, YYYY")
human(d) = human(Date(d))

identifier(t) = string(
    String(collect(take(filter(x -> !isspace(x), lowercase(t[:topic])), 10))),
    hash(t) % UInt16)

function write_summary(t)
    generate_page(merge(Dict(
        :title => t[:topic],
        :pagetype => "archive"
    ), t), "archive/$(identifier(t))")
end

result = JSON.parsefile("schedule.json", dicttype=Dict{Symbol,String})
sort(result, by=x -> x[:time])
map!(result) do d
    d[:date], d[:time] = split(d[:time], 'T')
    d
end
dates = unique(map(x -> x[:date], result))

summarize(t) = "Talk by $(t[:speaker])."

talks = []
for d in dates
    if Date(d) < Dates.today()
        for t in filter(x -> x[:date] == d, result)
            write_summary(t)
            push!(talks, Dict(
                :title => t[:topic],
                :url => "/seminar/archive/$(identifier(t))",
                :summary => summarize(t)))
        end
    end
end

generate_page(Dict(
    :title => "Archived Talks",
    :pagetype => "archived-talks",
    :talks => talks,
    :mathjaxplease => true), "archive")

generate_page(Dict(
    :title => "Mathematics Student Seminars",
    :pagetype => "home",
    :dates => dates,
    :talks => result,
    :mathjaxplease => true), "")

for file in readdir("static")
    println("Copying file $file...")
    cp("static/$file", "public/$file"; remove_destination=true)
end
