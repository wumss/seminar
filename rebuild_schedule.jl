#!/usr/bin/env julia

using JSON
using English
using DataStructures

include("tags.jl")
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
    if haskey(t, :type) && t[:type] == "reference"
        Dict(:title => t[:title],
             :url => "document/$(t[:id])",
             :summary => join(flatten([
                ["This is a reference document on $(t[:title])",
                 "by $(ItemList(t[:authors]))."],
                (haskey(t, :subsetof) && !isempty(t[:subsetof]) ?
                    ["It covers a subset of the material of",
                     "$(ItemList(t[:subsetof], Disjunction()))."] :
                    [])
             ]), " "))
    else
        Dict(:title => t[:topic],
             :url => "archive/$(identifier(t))",
             :summary => summarize(t))
    end
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

for t in result
    write_summary(t)
    if Date(t[:date]) < Dates.today()
        push!(talks, brief(t))
    end
end

# tag collection
talkdict = Dict{String,Any}()

tagmatrix = TagMatrix()
function populate!(m::TagMatrix, tags, value)
    for tag in tags
        m.popularity[tag] += value
        for tag2 in tags
            if tag2 > tag
                m.correlation[(tag, tag2)] += value
            end
        end
    end
end

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
        :related => relatedto(tagmatrix, t),
        :talkdict => talkdict,
        :done => filter(iscompleted, active_set),
        :scheduled => filter(x -> !iscompleted(x), active_set),
        :documents => docs_bytag[t],
        :mathjaxplease => true,
        :suggestions => bytag[t]), "tag/$t")
end

generate_page(Dict(
    :title => "Potential Topics",
    :pagetype => "suggested-topics",
    :talkdict => talkdict,
    :suggestions => suggestions,
    :mathjaxplease => true,
    :github => "$GITHUB/lisp/suggested-topics.lsp"), "potential-topics")

for file in readdir("static")
    println("Copying file $file...")
    cp("static/$file", "public/$file"; remove_destination=true)
end
