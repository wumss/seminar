module Talks

using Base.Iterators
using EnglishText
using SExpressions.Lists
using Remarkable.Articles
import Remarkable.Articles: title
import Remarkable.Tags: tags

# TODO: make non-mutating and return object instead of dict
function fromjson(obj)
    obj[:time] = DateTime(obj[:time], "y-m-dTH:M:SZ")
    obj
end

title(t) = t[:title]
tags(t) = t[:tags]
location(t) = t[:location]
speaker(t) = t[:speaker]
datetime(t) = t[:time]

identifier(t) = t[:identifier]
url(t) = "archive/$(identifier(t))"
iscompleted(t) = Date(datetime(t)) < Dates.today()

abstractpath(talk) = "abstract/$(identifier(talk))"
hasabstract(talk) = isfile(abstractpath(talk))

summarypath(talk) = "summary/$(identifier(talk))"
hassummary(talk) = isfile(summarypath(talk))

Base.@deprecate valuate(talk) 1 + hassummary(talk)

summarize(t) = string(
    "This is a talk by $(t[:speaker]). ",
    if hassummary(t)
        "A summary for this talk is available."
    else
        "The speaker has not provided a summary of this talk."
    end
)

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
        Dict(:title => title(t),
             :url => url(t),
             :summary => summarize(t))
    end
end

export abstractpath, hasabstract, summarypath, hassummary, identifier,
       iscompleted, valuate, summarize, brief, location, speaker,
       datetime, tags, fromjson, title

end
