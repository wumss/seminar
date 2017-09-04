# Math Seminar

A simple static site for an informal math seminar series. The site is built
with [Remarkable](https://github.com/TotalVerb/Remarkable.jl).

Here are some tutorials on how to edit the website:

- [Talks, abstract, summaries](https://www.youtube.com/watch?v=0bCAP7vxUAU)
- [Potential topics](https://www.youtube.com/watch?v=wLpMqp4P28I)
- [Making posters](https://www.youtube.com/watch?v=cP3Ti0x8ln4)

Here are some tools to help out:

- [Potential Topics Tool](http://uwseminars.com/pttool/)
- [Marketing Poster](http://uwseminars.com/poster/)


When editing markdown using the Potential Topics Tool, note that double
asterisk appears as **bold** and single asterisk appears as *italics*. Also
another thing to keep in mind is that equations are entered using double
backquotes. The [Write Markdown](http://uwseminars.com/write-markdown/) page
has some examples.

## To deploy:
Generate the site (note that the scripts are, for historical reasons, named
somewhat misleadingly):

```sh
./make.jl
```

Push the generated `public` folder to the `gh-pages` branch.

# Editing

All the content is stored in the `pages` directory as markdown files, or in the
`lisp` directory as HTSX files.

You can edit them directly on Github, or clone the repository to your computer.
