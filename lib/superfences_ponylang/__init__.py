from pygments import highlight
from pygments.lexers import PonyLexer
from pygments.formatters import HtmlFormatter

from pymdownx.superfences import SuperFencesException
from pymdownx.superfences import _escape

from mkdocs.exceptions import PluginError
from mkdocs.config import base
from mkdocs.config import config_options as c
from mkdocs.structure.pages import Page, _AbsoluteLinksValidationValue
from mkdocs.utils.yaml import get_yaml_loader, yaml_load
from mkdocs.utils.templates import TemplateContext

import os
import re

def format(source, language, css_class, options, md, classes=None, id_value='', attrs=None, **kwargs):
    if "snippet" in attrs: #options
        #workingDir = os.getcwd().replace('/lib/superfences_ponylang')
        try:
            snippetPath = attrs.get('snippet')
            if ':' in snippetPath:
                snippetPath, lineNumbers = snippetPath.split(':', 2)
                lines = []
                _lines = {}
                if ',' in lineNumbers:
                    lineNumbers = lineNumbers.split(',')
                else:
                    lineNumbers = [ lineNumbers ]
                with open(os.getcwd() + "/code-samples/" + snippetPath, 'r') as f:
                    for i, line in enumerate(f):
                        for lineNum in lineNumbers:
                            if '-' in lineNum:
                                start, end = lineNum.split('-')
                                if (i + 1) >= int(start) and (i + 1) <= int(end):
                                    lines.append(line)
                            #        _lines[i] = (lineNumbers, line, True)
                            elif (i + 1) == int(lineNum):
                                lines.append(line)
                            #    _lines[i] = (lineNumbers, line, True)
                            #else:
                            #    _lines[i] = (lineNumbers, line, False)
                    #source = str(lines)
                    #source = str(_lines)

                    if 'dedent_subsections' in attrs and attrs.get('dedent_subsections'):
                        p = re.compile('^\s+')
                        indents = []
                        for line in lines:
                            m = p.match(line)
                            if m is None:
                                indents.append(0)
                            else:
                                indents.append(m.span()[1])
                        indent = min(indents)
                        if indent > 0:
                            for i, line in enumerate(lines):
                                lines[i] = line[indent:None]

                    source = ''.join(lines) #'\n'
                    #source = str(base.Config.user_configs.__dict__) + str(TemplateContext) + str(c) + str(options) + str(attrs) + str(classes) + str(kwargs)
            else:
                with open(os.getcwd() + "/code-samples/" + snippetPath, 'r') as f:
                    source = f.read()
        except:
            raise SuperFencesException('Snippet "%s" does not work' % (snippetPath))
    else:
        source = str(options) + str(attrs) + str(classes) + str(kwargs)

    try:
        highlighted = highlight(source, PonyLexer(), HtmlFormatter())
    except:
        raise SuperFencesException('Could not highlight source code "%s" passed' % (source))

    return '<code lang="pony">%s</code>' % highlighted

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