#!/usr/bin/env julia

using Compat
using DataStructures
using Dates
using EnglishText
using Glob
using JSON
using Logging
using SExpressions
using SchemeSyntax
using Remarkable.Articles
using Remarkable.Common
using Remarkable.Talks
using Remarkable.Tags
using Remarkable.StaticSites

for line in SExpressions.parsefile("remark/definitions.rkt")
    eval(SchemeSyntax.tojulia(line))
end
const site = StaticSite(default_modules=[
    Dates, Tags, Common, UWSeminars, EnglishText, Articles])

const GITHUB = "https://github.com/wumss/seminar/edit/master"

# Make needed directories and copy static files
prepare(site)

# Make simple static pages
publics = Dict(
    "write-markdown"        => "Markdown Guide",
    "important-information" => "Important Information for Speakers",
    "thanks"                => "Thank You for Your Feedback")

for page in readdir("pages")
    root, ext = splitext(page)
    if ext == ".md" && haskey(publics, root)
        generate_page(site, root;
                      data=Dict(:pagetitle => root,
                                :page => root,
                                :pagetype => "page",
                                :github => "$GITHUB/pages/$page",
                                :mathjaxplease => true))
    end
end

# Make input-less lisp static pages
lisppublics = Dict("faq"         => "Frequently Asked Questions",
                   "submit-talk" => "Talk Submission Form",
                   "pttool"      => "Potential Topics Tool")

for (k, v) in lisppublics
    generate_page(site, k;
                  data=Dict(:pagetitle => v,
                            :pagetype => k,
                            :github => "$GITHUB/remark/$k.rem"))
end

function write_summary(t)
    generate_page(site, "archive/$(identifier(t))";
                  data=Dict(:pagetitle => title(t),
                            :pagetype => "archive",
                            :mathjaxplease => true,
                            :talk => t),
                  modules=[Talks])
end

# tag collection
tagmatrix = TagMatrix()

# Parse the schedule
result = []
for file ∈ glob("data/schedule/*.json")
    @info "Read schedule from " file
    append!(result,
            JSON.parsefile(file, dicttype=Dict{Symbol,Any}))
end
result = [Talks.fromjson(obj, tagmatrix) for obj in result]
sort!(result, by=x -> datetime(x))

talks = []

nexttalks = []
nextdate = Date(9999,12,31)
talkdict = Dict{String,Any}()

for t in result
    write_summary(t)
    if iscompleted(t)
        push!(talks, t)
    else
        curdate = Date(DateTime(datetime(t)))
        if curdate < nextdate
            nextdate = curdate
            nexttalks = [t]
        elseif curdate == nextdate
            push!(nexttalks, t)
        end
    end

    talkdict[identifier(t)] = t
end

# suggestion gathering
include("topic-suggestions.jl")

# documents
include("documents.jl")
alltags = popular(tagmatrix)

# Generate poster
generate_page(site, "poster"; data=Dict(
    :pagetitle => "Poster",
    :pagetype => "poster",
    :github => "$GITHUB/remark/poster.rem",
    :extracss => ["poster"],
    :mathjaxplease => true,
    :talks => nexttalks), modules=[Talks])

generate_page(site, "archive"; data=Dict(
    :pagetitle => "Archived Talks",
    :pagetype => "archived-talks",
    :talks => talks,
    :mathjaxplease => true), modules=[Talks])

# Index page
generate_page(site, ""; data=Dict(
    :pagetitle => "UW Student Seminars",
    :pagetype => "home",
    :talks => result,
    :github => "$GITHUB/remark/home.rem",
    :mathjaxplease => true), modules=[Talks])

# Generate tag pages
generate_page(site, "tag"; data=Dict(
    :pagetitle => "List of Tags",
    :pagetype => "tags",
    :tagmatrix => tagmatrix), modules=[])

for t in alltags
    active_set = filter(x -> t in tags(x), result)
    generate_page(site, "tag/$(urinormalize(tagname(t)))"; data=Dict(
        :pagetitle => uppercasefirst(tagname(t)),
        :pagetype => "tag",
        :tag => t,
        :tagmatrix => tagmatrix,
        :talkdict => talkdict,
        :talks => active_set,
        :documents => docs_bytag[t],
        :mathjaxplease => true,
        :github => "$GITHUB/wiki/tag/$(urinormalize(tagname(t))).md",
        :references => get(tagsuggestions, tagname(t),
                           Dict(:references => []))[:references],
        :suggestions => bytag[t]), modules=[Talks])
end

generate_page(site, "potential-topics"; data=Dict(
    :pagetitle => "Potential Topics",
    :pagetype => "suggested-topics",
    :talkdict => talkdict,
    :suggestions => suggestions,
    :tagsuggestions => tagsuggestions,
    :mathjaxplease => true,
    :github => "$GITHUB/remark/suggested-topics.rem"), modules=[Talks])
