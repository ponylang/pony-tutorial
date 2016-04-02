# Contributing to the Pony tutorial

Hi there! Thanks for your interest in contributing to the Pony Tutorial. The
book is being developed in Markdown and hosted at 
[Gitbook](https://www.gitbook.com/book/ponylang/pony-tutorial/details). We
welcome external contributors. In fact, we encourage them.

Please note, that by submitting any content to the Pony Tutorial book you are
agreeing that it can be licensed under our [license](LICENSE.md). Furthermore,
you are testifying that you own the copyright to the submitted content and
indemnify Pony Patterns from any copyright claim that might result from your not
being the authorized copyright holder.

## How the tutorial is organized

The tutorial layout is in the process of being reogranized. Previously, all
content for the tutorial was stored in the `docs` directory. Within that,
there were folders for each section of the book. The sections act as logical
groupings for chapters they contain. For new sections, they should be added to
the top level of the repo. When creating a new section, be sure to add an
`index.md` file that has the name of section as a level one entry: `#` as well
as an introductory paragraph or two for the section. After reading the
introduction, a reader should have a good idea of the type of content covered by
the chapters that make up the section.

## How to format chapters

Each chapter should start with the title of the chapter as a level one header:
`#` in Markdown. Each section of the page should appear as a second level
heading: `##`. If you need to have any subsections, make them a third level
heading: `###`. If you find yourself reaching for a forth level heading, stop
and figure out a different way to present the info in that section.

After the title, before diving into your first section, you should have some
level of expository text that explains what the reader can expect to get out of
reading the page.

Please make sure to keep any individual line under 80 characters except in
instance where that would break link with the markdown (which only happens if
the linked text and url are more than 76 characters).

## How to update the Table of Contents

Table of contents is handled by the `Summary.md` file. Each section of the book
will appear as a top level item in the list contained in `Summary.md`. Each
topic in turn appears as sub item beneath that. If you added a new section,
don't forget to link to both the section `index.md` as well as the content for
your topic.

## How to submit a pattern

Once your content is done, please open a pull request against this repo with
your changes. Based on the state of your particular PR, a number of requests for
change might be requested:

* Changes to the content
* Change to where the content appears in the Table of Contents
* Change to where the markdown file for the pattern is stored in the repo

Be sure to keep your PR to a single topic or logical change. If you are working
on multiple changes, make sure they are each on their own branch and that
before creating a new branch that you are on the master branch (others multiple
changes might end up in your pull request). To repeat, each PR should be for a
single logical change. We request that you create a good commit messages as laid
out in 
['How to Write a Git Commit Message'](http://chris.beams.io/posts/git-commit/).

If your PR is for a single logical change (which is should be) but spans
multiple commits, we'll ask you to squash them into a single commit before we
merge. Steve Klabnik wrote a handy guide for that: 
[How to squash commits in a GitHub pull request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request).


