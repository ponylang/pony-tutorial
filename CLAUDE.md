# Pony Tutorial

MkDocs-based tutorial site for the Pony programming language.

## Local Verification

- **mkdocs**: Run via venv (`pip install -r requirements.txt`, then `mkdocs serve` or `mkdocs build`)
- **cspell**: Run using a Docker container (CI uses `streetsidesoftware/cspell-action`; locally, use `docker run -v $(pwd):/workdir ghcr.io/streetsidesoftware/cspell:latest "docs/**/*.md"`)

## Code Samples

Code samples live in `code-samples/` and are included in docs via `--8<--` snippets inside fenced code blocks. Sample files are bare expressions (no `actor Main`) unless they need to compile standalone.
