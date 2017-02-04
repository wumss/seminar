#!/usr/bin/env julia

using Compat
using JSON
using English
using DataStructures
using Remarkable.Tags

include("talks.jl")
include("htsx-glue.jl")

using .Talks

const GITHUB = "https://github.com/wumss/seminar/edit/master"

# Make needed directories
for directory in ["public", "public/archive", "public/tag"]
    try
        mkdir(directory)
        info(directory; prefix="DIRECTORY: ")
    end
end

# Make simple static pages
publics = Dict(
    "write-markdown"        => "Markdown Guide",
    "important-information" => "Important Information for Speakers",
    "thanks"                => "Thank You for Your Feedback")

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md" && haskey(publics, root)
        data = stringmime("text/html",
                          Base.Markdown.parse(readstring("pages/$page")))
        generate_page(Dict(
            :pagetitle => root,
            :page => root,
            :pagetype => "page",
            :github => "$GITHUB/pages/$page",
            :mathjaxplease => true), root)
    end
end

# Make input-less lisp static pages
lisppublics = Dict("faq"         => "Frequently Asked Questions",
                   "submit-talk" => "Talk Submission Form")

for (k, v) in lisppublics
    generate_page(Dict(
        :pagetitle => v,
        :pagetype => k,
        :github => "$GITHUB/lisp/$k.lsp"), k)
end

function write_summary(t)
    generate_page(Dict(
        :pagetitle => title(t),
        :pagetype => "archive",
        :mathjaxplease => true,
        :talk => t), "archive/$(identifier(t))"; modules=[Talks])
end

# Parse the schedule
result = JSON.parsefile("data/schedule.json", dicttype=Dict{Symbol,Any})
result = [Talks.fromjson(obj) for obj in result]
sort!(result, by=x -> datetime(x))

talks = []

nexttalks = []
nextdate = Date(9999,12,31)
for t in result
    write_summary(t)
    if iscompleted(t)
        push!(talks, brief(t))
    else
        curdate = Date(datetime(t))
        if curdate < nextdate
            nextdate = curdate
            nexttalks = [t]
        elseif curdate == nextdate
            push!(nexttalks, t)
        end
    end
end

# tag collection
talkdict = Dict{String,Any}()

tagmatrix = TagMatrix()

for t in result
    talkdict[identifier(t)] = t
    value = valuate(t)
    populate!(tagmatrix, tags(t), value)
end

# suggestion gathering
include("topic-suggestions.jl")

# documents
include("documents.jl")
alltags = popular(tagmatrix)

# Generate poster
generate_page(Dict(
    :pagetitle => "Poster",
    :pagetype => "poster",
    :github => "$GITHUB/lisp/poster.lsp",
    :extracss => ["poster"],
    :mathjaxplease => true,
    :talks => nexttalks), "poster"; modules=[Talks, English])

generate_page(Dict(
    :pagetitle => "Archived Talks",
    :pagetype => "archived-talks",
    :talks => talks,
    :mathjaxplease => true), "archive"; modules=[Talks])

generate_page(Dict(
    :pagetitle => "Mathematics Student Seminars",
    :pagetype => "home",
    :talks => result,
    :github => "$GITHUB/lisp/home.lsp",
    :mathjaxplease => true), ""; modules=[Talks])

generate_page(Dict(
    :pagetitle => "List of Tags",
    :pagetype => "tags",
    :tags => alltags), "tags")

# Generate tag pages
for t in alltags
    active_set = filter(x -> t in tags(x), result)
    generate_page(Dict(
        :pagetitle => "Tag $t",
        :pagetype => "tag",
        :tag => t,
        :tagmatrix => tagmatrix,
        :talkdict => talkdict,
        :talks => active_set,
        :documents => docs_bytag[t],
        :mathjaxplease => true,
        :github => "$GITHUB/wiki/tag/$t.md",
        :suggestions => bytag[t]), "tag/$t"; modules=[Tags, Talks, English])
end

generate_page(Dict(
    :pagetitle => "Potential Topics",
    :pagetype => "suggested-topics",
    :talkdict => talkdict,
    :suggestions => suggestions,
    :mathjaxplease => true,
    :github => "$GITHUB/lisp/suggested-topics.lsp"), "potential-topics";
               modules=[Talks])

# Copy static files
for file in readdir("static")
    info(file; prefix="COPYING: ")
    cp("static/$file", "public/$file"; remove_destination=true)
end
