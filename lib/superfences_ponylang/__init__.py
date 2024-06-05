def format(source, language, css_class, options, md, classes=None, id_value='', attrs=None, **kwargs):
    return '<pre class_name="ponylang %s %s", data-option="%s"><nav class="md-code__nav"><button class="md-code__button" title="Copy to clipboard" data-clipboard-target="#__code_1 &gt; code" data-md-type="copy"></button></nav><code>%s</code></pre>' % (language, class_name, options['opt'], html_escape(source))

def validate(language: str, options: dict) -> bool:
    return True # TODO allowed attributes and values