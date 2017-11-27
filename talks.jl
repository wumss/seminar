module Talks

using Dates
using Base.Iterators
using TimeZones
using EnglishText
using SExpressions.Lists
using Remarkable.Articles
using Remarkable.Tags

function fromjson(obj, tagmatrix)
    time = obj[:time]
    if length(time) == 2
        time = time[1]  # TODO: support time interval
    end
    properties = ArticleMetadata(
        obj[:identifier],
        obj[:title],
        [obj[:speaker]],
        ZonedDateTime(DateTime(time, "y-m-dTH:M:S"), tz"America/Toronto"))
    tag!(properties, tagmatrix, obj[:tags])
    LivePerformance(properties, obj[:location])
end

url(t) = "archive/$(identifier(t))"
iscompleted(t) = Date(DateTime(datetime(t))) < Dates.today()

abstractpath(talk) = "abstract/$(identifier(talk))"
hasabstract(talk) = isfile(abstractpath(talk))

summarypath(talk) = "summary/$(identifier(talk))"
hassummary(talk) = isfile(summarypath(talk))

# TODO: this has nothing to do with talks, move it to document
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
    end
end

export abstractpath, hasabstract, summarypath, hassummary, iscompleted,
       valuate, brief, fromjson, url

end
