# Write Talk Summaries

Talk summaries can be written in Markdown. Currently, the flavor of Markdown
we use is Julia flavored markdown.

A few of the details about Julia flavored markdown:

- Enclose inline math like ``` ``x = \frac{a}{b}`` ```. We support a large
  amount of LaTeX, including the AMS math libraries.
- Enclose block math using

`````md
```math
x = \frac{a}{b}
```
`````

Otherwise, consult a guide on markdown.

## Uploading Talk Summaries

You can submit talk summaries to any of the organizers, or directly submit a
Pull Request on GitHub. We store summaries in [this
folder](https://github.com/friedeggs/seminar/tree/master/summary) of our GitHub
repository. Currently, we also have to modify the [schedule
file](https://github.com/friedeggs/seminar/blob/master/schedule.json) for the
talk summary to show up. Please name the new file according to the convention
of the summary folder.

## Examples

We highly recommend that you read the example talk summary files to get an idea
of the expected format. The recommended examples are:

- Koosha Totonchi, [Game
  Theory](https://github.com/friedeggs/seminar/blob/master/summary/kt-GameTheory)
- Fengyang Wang, [2D Linear
  Algebra](https://github.com/friedeggs/seminar/blob/master/document/2d-linear-algebra)
  This one is actually a document, not a talk summary, but is a good example
  nevertheless.
