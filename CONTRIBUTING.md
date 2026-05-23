# Contributing to the Pony tutorial

Hi there! Thanks for your interest in contributing to the Pony Tutorial. The book is being developed in Markdown and built using [MkDocs](https://www.mkdocs.org/) and [Netlify](https://www.netlify.com/). We welcome external contributors. In fact, we encourage them.

Please note, that by submitting any content to the Pony Tutorial you are agreeing that it can be licensed under our [license](LICENSE.md). Furthermore, you are testifying that you own the copyright to the submitted content and indemnify Pony Tutorial from any copyright claim that might result from your not being the authorized copyright holder.

## AI-assisted contributions

We appreciate contributions, whatever the source. If AI tools help you contribute to Pony, we're glad to have you. Many of us use them too.

That also means we know what AI-assisted writing looks like when no one's reviewed it, and we won't merge PRs that read that way. If your contribution is clearly AI-assisted, you have an extra responsibility before opening it.

The Pony project publishes a set of LLM skills at [ponylang/llm-skills](https://github.com/ponylang/llm-skills). Familiarize yourself with what's there and make sure your contribution uses the ones that apply to it.

One skill isn't optional: `pony-docs-review`. We recommend running it against any contribution. For clearly AI-assisted PRs, we require it. Run it. Understand every finding. Then address it — by fixing it, or by dismissing it with a justification you can defend in the PR. The review surfaces the kind of issues a human maintainer would catch, but it isn't infallible. What you can't do is skip a finding because you didn't understand it. Don't open the PR until you've worked through them all.

If the review surfaces something you don't understand or don't know how to answer, stop. Don't open the PR. Come to the [Pony Zulip](https://ponylang.zulipchat.com/) and ask. We are happy to teach. We enjoy helping people learn Pony.

What we won't do is teach an AI. If a PR's open questions can only be resolved by maintainers explaining things to you so you can relay them to your AI for the next round, that's not a review. That's us teaching a tool that won't remember any of it. Our time is better spent on the contributor who came to Zulip first.

You don't have to disclose AI use, though saying so up front often makes review faster. What you do have to do is stand behind the work. If you can't answer questions about why your PR looks the way it does, it isn't ready.

### Junk PRs

This isn't new policy. Long before AI tools were any good, low-effort PRs that wasted maintainer time could get a contributor blocked. That hasn't changed. What's changed is how easy it has become to produce a junk PR. One won't get you blocked. A pattern of them will. How many makes a pattern is our call.

We don't owe anyone our time. We choose to give it. Don't waste it.

## How to format chapters

Each chapter should start with the title of the chapter as a level one header: `#` in Markdown. Each section of the page should appear as a second level heading: `##`. If you need to have any subsections, make them a third level heading: `###`. If you find yourself reaching for a forth level heading, stop and figure out a different way to present the info in that section.

After the title, before diving into your first section, you should have some level of expository text that explains what the reader can expect to get out of reading the page.

Avoid hard-wrapping lines within paragraphs (using line breaks in the middle of or between sentences to make lines shorter than a certain length). Instead, turn on soft-wrapping in your editor and expect the documentation renderer to let the text flow to the width of the container.

## How to submit a pull request

Once your content is done, please open a pull request against this repo with your changes. Based on the state of your particular PR, a number of requests for change might be requested:

* Changes to the content
* Change to where the content appears in the Table of Contents
* Change to where the markdown file for the content is stored in the repo

Please use a separate "topic branch" based off of the latest `main` branch for your change. If you are working on multiple changes, please use separate branches for each. This helps to avoid accidentally pushing changes to your pull request. We request that you create a good commit message as laid out in ["How to Write a Git Commit Message"](http://chris.beams.io/posts/git-commit/).

Each pull request should be for a single logical change. If the pull request contains multiple commits, we'll squash them into a single commit when we merge. In that case, please make sure the first comment on your PR is the content we should use as the final commit message.

## On writing good documentation

Writing good documentation is hard. In the end, "good" is highly subjective. All documentation assumes knowledge on the part of the reader. When you are writing content for the tutorial, stop and consider:

* What assumptions am I making about the reader, their background and their knowledge?
* How can I explain this in more than one way so a wider variety of people will understand it?

When writing documentation for the widest possible audience, brevity is not your friend. Even if you feel you have already explained something, explain it in a different way. The person who didn't understand the first explanation but understood the second will thank you.

The target audience for this tutorial is anyone with a modicum of experience with another programming language. It isn't targeting people who have no programming experience. We don't assume that the reader has worked with a statically typed language before. We don't assume a wealth of experience in the field. We strive to make this tutorial as accessible to the programmer with 9 months of Python experience as it is to the polyglot programmer with 20 years of industry experience. It is acceptable to create content that targets a subset of the audience (for example Java programmers) so long as the same content is addressed in a fashion that covers the general audience as well.

Lastly, this is a living document. It will grow, change and adapt. Your contributions don't have to be perfect. They should merely improve the overall usefulness and quality. Welcome to the community! We look forward to your contributions.
