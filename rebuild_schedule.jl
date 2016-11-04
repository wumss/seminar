#!/usr/bin/env julia

using JSON
using DataStructures

include("build_help.jl")

try
    mkdir("public/archive")
end

human(d::Date) = Dates.format(d, "E U d, YYYY")
human(d) = human(Date(d))

identifier(t) = t[:identifier]

function write_summary(t)
    generate_page(merge(Dict(
        :title => t[:topic],
        :pagetype => "archive",
        :mathjaxplease => true
    ), t), "archive/$(identifier(t))")
end

iscompleted(t) = Date(t[:date]) < Dates.today()
function valuate(talk)
    sum([1,
         talk[:location] != "Online",
         iscompleted(talk),
         haskey(talk, :abstract),
         haskey(talk, :summary)])
end

summarize(t) = "Talk by $(t[:speaker])."

function brief(t)
    Dict(:title => t[:topic],
         :url => "/seminar/archive/$(identifier(t))",
         :summary => summarize(t))
end

result = JSON.parsefile("schedule.json", dicttype=Dict{Symbol,Any})
sort!(result, by=x -> x[:time])
map!(result) do d
    d[:date], d[:time] = split(d[:time], 'T')
    d
end
dates = unique(map(x -> x[:date], result))

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
talkdict = Dict{String,Any}()
tagpopularity = DefaultDict(String, Int, 0)
for t in result
    talkdict[identifier(t)] = t
    union!(tags, t[:tags])
    value = valuate(t)
    for tag in t[:tags]
        tagpopularity[tag] += value
    end
end
tags = sort(collect(tags), by=t -> -tagpopularity[t])

# suggestion gathering
include("topic-suggestions.jl")

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
    :github => "$GITHUB/lisp/home.lsp",
    :mathjaxplease => true), "")

generate_page(Dict(
    :title => "List of Tags",
    :pagetype => "tags",
    :tags => tags), "tags")

try mkdir("public/tag") end
for t in tags
    active_set = filter(x -> t in x[:tags], result)
    generate_page(Dict(
        :title => "Tag $t",
        :tag => t,
        :pagetype => "tag",
        :brief => brief,
        :talkdict => talkdict,
        :done => filter(iscompleted, active_set),
        :scheduled => filter(x -> !iscompleted(x), active_set),
        :suggestions => bytag[t]), "tag/$t")
end

for file in readdir("static")
    println("Copying file $file...")
    cp("static/$file", "public/$file"; remove_destination=true)
end
