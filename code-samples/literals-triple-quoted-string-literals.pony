let triple_quoted_string_docs =
  """
  Triple quoted strings are the way to go for long multi-line text.
  They are extensively used as docstrings which are turned into api documentation.

  They get some special treatment, in order to keep Pony code readable:

  * The string literal starts on the line after the opening triple quote.
  * Common indentation is removed from the string literal
    so it can be conveniently aligned with the enclosing indentation
    e.g. each line of this literal will get its first two whitespaces removed
  * Whitespace after the opening and before the closing triple quote will be
    removed as well. The first line will be completely removed if it only
    contains whitespace. e.g. this strings first character is `T` not `\n`.
  """