/**
 * @param {MouseEvent} evt 
 */
async function runSnippetInline(evt) {
    evt.preventDefault();
    const res = await fetch(`https://playground.ponylang.io/?snippet=${evt.target.dataset.snippet}`)
    const json = await res.json()
    evt.target.previousElementSibling.querySelector('pre').append(Object.assign(document.create('pre'), {
        innerHTML: json.success ? json.stdout : json.compiler
    }))
}

document$.subscribe(function() {
    const inlineRunButtons = document.querySelectorAll('.md-button[data-snippet]')

    for (const button of inlineRunButtons) {
        button.addEventListener('click', runSnippetInline)
    }
})