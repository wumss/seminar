#!/usr/bin/env julia

using Compat
using JSON
using English
using DataStructures
using SExpressions.Htsx.StdLib.Tags

include("talks.jl")
include("htsx-glue.jl")

using .Talks

try
    mkdir("public/archive")
end

human(d::Date) = Dates.format(d, "E U d, YYYY")
human(d) = human(Date(d))

function write_summary(t)
    generate_page(merge(Dict(
        :title => t[:topic],
        :pagetype => "archive",
        :mathjaxplease => true
    ), t), "archive/$(identifier(t))")
end

result = JSON.parsefile("data/schedule.json", dicttype=Dict{Symbol,Any})
sort!(result, by=x -> x[:time])
map!(result, result) do d
    d[:date], d[:time] = split(d[:time], 'T')
    d
end
dates = unique(map(x -> x[:date], result))

tags = Set{String}()
talks = []

nexttalks = []
nextdate = Date(9999,12,31)
for t in result
    write_summary(t)
    if Date(t[:date]) < Dates.today()
        push!(talks, brief(t))
    else
        if Date(t[:date]) < nextdate
            nextdate = Date(t[:date])
            nexttalks = [t]
        elseif Date(t[:date]) == nextdate
            push!(nexttalks, t)
        end
    end
end

# tag collection
talkdict = Dict{String,Any}()

tagmatrix = TagMatrix()

for t in result
    talkdict[identifier(t)] = t
    union!(tags, t[:tags])
    value = valuate(t)
    populate!(tagmatrix, t[:tags], value)
end

# suggestion gathering
include("topic-suggestions.jl")

# documents
include("documents.jl")
tags = sort(collect(tags), by=t -> -tagmatrix.popularity[t])

generate_page(Dict(
    :title => "Archived Talks",
    :pagetype => "archived-talks",
    :talks => talks,
    :mathjaxplease => true), "archive"; modules=[Talks])

generate_page(Dict(
    :title => "Mathematics Student Seminars",
    :pagetype => "home",
    :dates => dates,
    :talks => result,
    :github => "$GITHUB/lisp/home.lsp",
    :mathjaxplease => true), ""; modules=[Talks])

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
        :related => relatedto(tagmatrix, t),
        :talkdict => talkdict,
        :talks => active_set,
        :documents => docs_bytag[t],
        :mathjaxplease => true,
        :suggestions => bytag[t]), "tag/$t"; modules=[Talks])
end

generate_page(Dict(
    :title => "Potential Topics",
    :pagetype => "suggested-topics",
    :talkdict => talkdict,
    :suggestions => suggestions,
    :mathjaxplease => true,
    :github => "$GITHUB/lisp/suggested-topics.lsp"), "potential-topics")

generate_page(Dict(
    :title => "Talk Submission Form",
    :pagetype => "winter-2017",
    :github => "$GITHUB/lisp/winter-2017.lsp"), "submit-talk")

generate_page(Dict(
    :title => "Poster",
    :pagetype => "poster",
    :github => "$GITHUB/lisp/poster.lsp",
    :date => nextdate,
    :talks => nexttalks), "poster")

for file in readdir("static")
    println("Copying file $file...")
    cp("static/$file", "public/$file"; remove_destination=true)
end
