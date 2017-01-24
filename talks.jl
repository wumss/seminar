module Talks

using Base.Iterators
using English
using SExpressions.Lists

topic(t) = t[:topic]
location(t) = t[:location]
speaker(t) = t[:speaker]
date(t) = Date(t[:date])
tags(t) = t[:tags]

identifier(t) = t[:identifier]
iscompleted(t) = Date(t[:date]) < Dates.today()

abstractpath(talk) = "abstract/$(identifier(talk))"
hasabstract(talk) = isfile(abstractpath(talk))

summarypath(talk) = "summary/$(identifier(talk))"
hassummary(talk) = isfile(summarypath(talk))

function valuate(talk)
    sum([1,
         iscompleted(talk),
         hasabstract(talk),
         hassummary(talk)])
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

export abstractpath, hasabstract, summarypath, hassummary, identifier,
       iscompleted, valuate, summarize, brief, topic, location, speaker, date,
       tags

end
