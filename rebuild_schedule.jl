#!/usr/bin/env julia

using JSON
using TextWrap  # English once its wrapping capability is finished

human(d::Date) = Dates.format(d, "E U d, YYYY")
human(d) = human(Date(d))

println("""
+++
date = "2016-09-23T21:24:42-04:00"
title = "Upcoming Talks"
type = "home-section"
+++

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
      inlineMath: [ ['\$','\$'], ["\\\\(","\\\\)"] ],
      displayMath: [ ['\$\$','\$\$'], ["\\\\[","\\\\]"] ],
      processEscapes: true
    },
    "HTML-CSS": { availableFonts: ["TeX"] }
  });
</script>

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_CHTML">
</script>
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
    println("<tr><th colspan=4>Talks on $(human(d))</th></tr>")
    for t in filter(x -> x[:date] == d, result)
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
            println_wrapped(STDOUT,
                readstring(joinpath("abstract", t[:abstract])),
                width=79,
                initial_indent=4,
                subsequent_indent=4,
                replace_whitespace=true,
                break_long_words=false
            )
            println("  </td>")
            println("</tr>")
        end
    end
end
println("</tbody>")
println("</table>")
