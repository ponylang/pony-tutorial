/**
 * @param {MouseEvent} evt 
 */
async function runSnippetInline(evt) {
    evt.preventDefault();
    const snippetRes = await fetch(`https://raw.githubusercontent.com/ponylang/pony-tutorial/main/code-samples/${evt.target.dataset.snippet}`)
    const snippetCode = await snippetRes.text()
    const evaluateRes = await fetch('https://playground.ponylang.io/evaluate.json', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            "code": snippetCode,
            "separate_output": true,
            "color": true,
            "branch": "release"
        })
    })
    const json = await evaluateRes.json()
    evt.target.previousElementSibling.querySelector('pre').append(Object.assign(document.create('pre'), {
        innerHTML: json.success ? json.stdout : json.compiler,
    }))
}

document$.subscribe(function() {
    const inlineRunButtons = document.querySelectorAll('.md-button[data-snippet]')

    for (const button of inlineRunButtons) {
        button.addEventListener('click', runSnippetInline)
    }
})