# (So far unnamed) Math Seminar

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
