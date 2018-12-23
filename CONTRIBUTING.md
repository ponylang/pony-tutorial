# Contributing to the Pony tutorial

Hi there! Thanks for your interest in contributing to the Pony Tutorial. The book is being developed in Markdown and built using [Hugo](https://gohugo.io/) and [Netlify](https://www.netlify.com/). We welcome external contributors. In fact, we encourage them.

Please note, that by submitting any content to the Pony Tutorial book you are agreeing that it can be licensed under our [license](LICENSE.md). Furthermore, you are testifying that you own the copyright to the submitted content and indemnify Pony Tutorial from any copyright claim that might result from your not being the authorized copyright holder.

## How the tutorial is organized

The tutorial is organized into folders, which become sections in the rendered book. Each folder contains a number of files, which each become a page within the section. New sections should be added by creating a new folder with an `index.md` file that has a level-one Markdown header (_i.e._, a line starting with `#`) and an introductory paragraph or two for the section. This introduction should describe the contents of the entire section.

The ordering of the tutorial as well as the Table of Contents is handled by the `SUMMARY.md` file. This file is a list of links to each section, with sub-lists for pages within each section. If you add a new section or page, don't forget to link to them in the `SUMMARY.md` file or they won't appear in the final book.

## How to format chapters

Each chapter should start with the title of the chapter as a level one header: `#` in Markdown. Each section of the page should appear as a second level heading: `##`. If you need to have any subsections, make them a third level heading: `###`. If you find yourself reaching for a forth level heading, stop and figure out a different way to present the info in that section.

After the title, before diving into your first section, you should have some level of expository text that explains what the reader can expect to get out of reading the page.

Avoid hard-wrapping lines within paragraphs (using line breaks in the middle of or between sentences to make lines shorter than a certain length). Instead, turn on soft-wrapping in your editor and expect the documentation renderer to let the text flow to the width of the container.

## How to submit a pull request

Once your content is done, please open a pull request against this repo with your changes. Based on the state of your particular PR, a number of requests for change might be requested:

* Changes to the content
* Change to where the content appears in the Table of Contents
* Change to where the markdown file for the content is stored in the repo

Please use a separate "topic branch" based off of the latest `master` branch for your change. If you are working on multiple changes, please use separate branches for each. This helps to avoid accidentally pushing changes to your pull request. We request that you create a good commit message as laid out in ["How to Write a Git Commit Message"](http://chris.beams.io/posts/git-commit/).

Each pull request should be for a single logical change. If the pull request contains multiple commits, we'll ask you to squash them into a single commit before we merge. Steve Klabnik wrote a handy guide for that: [How to squash commits in a GitHub pull request](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request).

## On writing good documentation

Writing good documentation is hard. In the end, "good" is highly subjective. All documentation assumes knowledge on the part of the reader. When you are writing content for the tutorial, stop and consider:

* What assumptions am I making about the reader, their background and their knowledge?
* How can I explain this in more than one way so a wider variety of people will understand it?

When writing documentation for the widest possible audience, brevity is not your friend. Even if you feel you have already explained something, explain it in a different way. The person who didn't understand the first explanation but understood the second will thank you. 

The target audience for this tutorial is anyone with a modicum of experience with another programming language. It isn't targetting people who have no programming experience. We don't assume that the reader has worked with a statically typed language before. We don't assume a wealth of experience in the field. We strive to make this tutorial as accessible to the programmer with 9 months of Python experience as it is to the polyglot programmer with 20 years of industry experience. It is acceptable to create content that targets a subset of the audience (for example Java programmers) so long as the same content is addressed in a fashion that covers the general audience as well.

Lastly, this is a living document. It will grow, change and adapt. Your contributions don't have to be perfect. They should merely improve the overall usefulness and quality. Welcome to the community! We look forward to your contributions.
