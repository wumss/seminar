module Talks

using Base.Iterators
using English
using SExpressions.Lists

# TODO: make non-mutating and return object instead of dict
function fromjson(obj)
    obj[:time] = DateTime(obj[:time], "y-m-dTH:M:SZ")
    obj
end

title(t) = t[:title]
location(t) = t[:location]
speaker(t) = t[:speaker]
datetime(t) = t[:time]
tags(t) = t[:tags]

identifier(t) = t[:identifier]
iscompleted(t) = Date(datetime(t)) < Dates.today()

abstractpath(talk) = "abstract/$(identifier(talk))"
hasabstract(talk) = isfile(abstractpath(talk))

summarypath(talk) = "summary/$(identifier(talk))"
hassummary(talk) = isfile(summarypath(talk))

function valuate(talk)
    sum([1,
         hasabstract(talk),
         hassummary(talk)])
end
summarize(t) = string(
    "Talk by $(t[:speaker]). ",
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
             :url => "archive/$(identifier(t))",
             :summary => summarize(t))
    end
end

export abstractpath, hasabstract, summarypath, hassummary, identifier,
       iscompleted, valuate, summarize, brief, topic, location, speaker, date,
       datetime, tags, fromjson, title

Base.@deprecate date(t) Date(datetime(t))
Base.@deprecate topic(t) title(t)

end
