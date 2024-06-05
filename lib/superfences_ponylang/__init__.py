from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter

def format(source, language, css_class, options, md, classes=None, id_value='', attrs=None, **kwargs):
    return """
    <pre class_name="ponylang %s %s", data-option="%s">
        <nav class="md-code__nav">
            <button class="md-code__button" title="Copy to clipboard" data-clipboard-target="#__code_1 &gt; code" data-md-type="copy"></button>
        </nav>
        <code>%s</code>
    </pre>
    """ % (language, class_name, options['opt'], html_escape(highlight(source, PythonLexer(), HtmlFormatter())))

def validate(language: str, options: dict) -> bool:
    allowed_options = { "snippet", "dedent_subsections" } #lambda v: v in ENGINES
    for opt in options.keys():
        if opt not in allowed_options:
            return False
    return True