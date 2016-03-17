# Pony Tutorials

This is the source code for generating the Pony tutorials. They are generated 
with [MkDocs](http://www.mkdocs.org).

To install mkdocs:

```
$ pip install mkdocs
```

To work on the docs locally, `cd` to the repo directory and:

```
$ mkdocs serve
```

This will give you a live-reloading local version of the docs. When you are
ready to publish your changes, commit everything and push to GitHub. TravisCI
rebuilds the tutorial any time you push to `master`.
