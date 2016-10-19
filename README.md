# Math Seminar

A simple static site for an informal math seminar series. Generated using [Hugo](https://gohugo.io/).

## Search Functionality
This site uses [Lunrjs](https://lunrjs.com) through [this Gist](https://gist.github.com/sebz/efddfc8fdcb6b480f567).

To index searchable text on the site and create the necessary `PagesIndex.json` file, run `grunt lunr-index`.


## To run locally:
`hugo server --theme=seminar`

## To deploy:
Generate the site:
`hugo --theme=seminar`

Push the generated `public` folder to the `gh-pages` branch.


# Editing

All the content is stored in the `content` directory as markdown files.

You can edit them directly on Github, or clone the repository to your computer.

Running `hugo new archive/[filename].md` will create a new file in `content/archive` with the date automatically set in the TOML header.
