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
        :pagetype => "archive",
        :mathjaxplease => true
    ), t), "archive/$(identifier(t))")
end

result = JSON.parsefile("schedule.json", dicttype=Dict{Symbol,Any})
sort(result, by=x -> x[:time])
map!(result) do d
    d[:date], d[:time] = split(d[:time], 'T')
    d
end
dates = unique(map(x -> x[:date], result))

summarize(t) = "Talk by $(t[:speaker])."

function brief(t)
    Dict(:title => t[:topic],
         :url => "/seminar/archive/$(identifier(t))",
         :summary => summarize(t))
end

tags = Set{String}()
talks = []
for d in dates
    if Date(d) < Dates.today()
        for t in filter(x -> x[:date] == d, result)
            write_summary(t)
            push!(talks, brief(t))
        end
    end
end

# tag collection
for t in result
    union!(tags, t[:tags])
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

generate_page(Dict(
    :title => "List of Tags",
    :pagetype => "tags",
    :tags => tags), "tags")

iscompleted(t) = Date(t[:date]) <= Dates.today()
try mkdir("public/tag") end
for t in tags
    active_set = filter(x -> t in x[:tags], result)
    generate_page(Dict(
        :title => "Tag $t",
        :tag => t,
        :pagetype => "tag",
        :brief => brief,
        :done => filter(iscompleted, active_set),
        :scheduled => filter(x -> !iscompleted(x), active_set)), "tag/$t")
end

for file in readdir("static")
    println("Copying file $file...")
    cp("static/$file", "public/$file"; remove_destination=true)
end
