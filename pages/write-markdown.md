# Write Talk Summaries

Talk summaries can be written in Markdown. Currently, the flavor of Markdown we
use is Julia flavored markdown.

If you are already familiar with Markdown, here are a few of the specific
details about Julia flavored markdown:

- Enclose inline math like ``` ``x = \frac{a}{b}`` ```. We support a large
  amount of LaTeX, including the AMS math libraries.
- Enclose block math using

`````md
```math
x = \frac{a}{b}
```
`````

If you are not yet familiar with Markdown, or you wish to learn more about Julia flavoured
markdown, consult the documentation of [Julia flavoured
markdown](https://docs.julialang.org/en/release-0.5/manual/documentation/#markdown-syntax).

## Uploading Talk Summaries

You can submit talk summaries to any of the organizers, or directly submit a
Pull Request on GitHub. We store summaries in [this
folder](https://github.com/wumss/seminar/tree/master/summary) of our GitHub
repository. Currently, we also have to modify the [schedule
file](https://github.com/wumss/seminar/blob/master/schedule.json) for the talk
summary to show up. Please name the new file according to the convention of the
summary folder.

## Examples

We highly recommend that you read the example talk summary files to get an idea
of the expected format. The recommended examples are:

- Koosha Totonchi, [Game
  Theory](https://github.com/wumss/seminar/blob/master/summary/kt-GameTheory)

- Fengyang Wang, [2D Linear
  Algebra](https://github.com/wunss/seminar/blob/master/document/2d-linear-algebra)

  This one is actually a document, not a talk summary, but is a good example
  nevertheless.
