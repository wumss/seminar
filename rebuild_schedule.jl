#!/usr/bin/env julia

using JSON
using TextWrap  # English once its wrapping capability is finished

try
    mkdir("content/archive")
end

human(d::Date) = Dates.format(d, "E U d, YYYY")
human(d) = human(Date(d))

identifier(t) = string(
    String(collect(take(filter(x -> !isspace(x), lowercase(t[:topic])), 10))),
    hash(t) % UInt16)

function render_markdown_from_file(io, t, sym, indent)
    abstract_md = readstring(joinpath(string(sym), t[sym]))
    abstract_html = stringmime("text/html",
                               Base.Markdown.parse(abstract_md))
    println_wrapped(io,
        abstract_html,
        width=79,
        initial_indent=indent,
        subsequent_indent=indent,
        replace_whitespace=true,
        break_long_words=false
    )
end

function print_row(t)
    println("""
            <tr>
              <td>$(t[:topic])</td>
              <td>$(t[:speaker])</td>
              <td>$(t[:location])</td>
              <td>$(String(collect(take(t[:time], 5))))</td>
            </tr>""")
    if haskey(t, :abstract)
        println("<tr>")
        println("  <td colspan=4>")
        render_markdown_from_file(STDOUT, t, :abstract, 4)
        println("  </td>")
        println("</tr>")
    end
end

function write_summary(t)
    open("content/archive/$(identifier(t)).md", "w") do f
        println(f, """
        +++
        date = "$(t[:date])T$(t[:time])"
        title = "$(t[:topic])"
        +++
        """)

        println(f, """
        This talk, delivered by $(t[:speaker]) was held on $(human(t[:date]))
        in $(t[:location]).
        """)
        if haskey(t, :abstract)
            println(f, """
            ## Abstract
            """)
            render_markdown_from_file(f, t, :abstract, 0)
        end
        if haskey(t, :summary)
            render_markdown_from_file(f, t, :summary, 0)
        end
    end
end

println("""
+++
date = "2016-09-23T21:24:42-04:00"
title = "Upcoming Talks"
type = "home-section"
+++

""")

println("""
## Upcoming Talks

See the [archive](archive) for talks before today’s date.
""")

result = JSON.parsefile("schedule.json", dicttype=Dict{Symbol,String})
sort(result, by=x -> x[:time])
map!(result) do d
    d[:date], d[:time] = split(d[:time], 'T')
    d
end
dates = unique(map(x -> x[:date], result))
println("""
        <table>
        <thead>
        <tr>
          <th>Topic</th>
          <th>Speaker</th>
          <th>Location</th>
          <th>Time</th>
        </tr>
        </thead>
        <tbody>""")

for d in dates
    if Date(d) < Dates.today()
        for t in filter(x -> x[:date] == d, result)
            write_summary(t)
        end
    else
        println("<tr><th colspan=4>Talks on $(human(d))</th></tr>")
        for t in filter(x -> x[:date] == d, result)
            print_row(t)
        end
    end
end
println("</tbody>")
println("</table>")
