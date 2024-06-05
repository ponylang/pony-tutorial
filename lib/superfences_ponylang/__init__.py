from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter

from pymdownx.superfences import SuperFencesException
from pymdownx.superfences import _escape

from mkdocs.exceptions import PluginError

def format(source, language, css_class, options, md, classes=None, id_value='', attrs=None, **kwargs):
    try:
        highlighted = highlight(source, PythonLexer(), HtmlFormatter())
    except:
        raise SuperFencesException('Could not highlight source code "%s" passed' % (source))

    return highlighted

    return """
    <pre class_name="ponylang %s %s", data-option="%s">
        <nav class="md-code__nav">
            <button class="md-code__button" title="Copy to clipboard" data-clipboard-target="#__code_1 &gt; code" data-md-type="copy"></button>
            <button class="md-code__button" title="Run in playground" data-md-type="run"></button>
            <button class="md-code__button" title="Run in playground" data-md-type="inline"></button>
        </nav>
        <code>%s</code>
    </pre>
    """ % (language, class_name, options['opt'], _escape(highlighted)) # html_escape

def validate(language: str, options: dict, attrs: dict, md) -> bool:
    return True
    allowed_options = { "snippet", "dedent_subsections" } #lambda v: v in ENGINES
    for opt in options.keys():
        if opt not in allowed_options:
            raise SuperFencesException('unknown config key "%s" passed' % (opt))
            return False
    print('valid fence')
    return True