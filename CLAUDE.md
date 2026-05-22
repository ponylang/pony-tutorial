# Pony Tutorial

MkDocs-based tutorial site for the Pony programming language.

<!-- contributor-only -->
## Contributing with an AI assistant

This is a Pony project. The ponylang org maintains a set of LLM coding skills. If your AI assistant isn't set up with them, install them once:

```bash
git clone https://github.com/ponylang/llm-skills.git
cd llm-skills
python install.py
```

See the [llm-skills README](https://github.com/ponylang/llm-skills) for details and other harnesses.

When you start working on this project, load the `pony-skills` skill — it tells your assistant which Pony skill to use for each task.

Before opening a pull request, read [CONTRIBUTING.md](CONTRIBUTING.md).
<!-- /contributor-only -->

## Local Verification

- **mkdocs**: Run via venv (`pip install -r requirements.txt`, then `mkdocs serve` or `mkdocs build`)
- **cspell**: Run using a Docker container (CI uses `streetsidesoftware/cspell-action`; locally, use `docker run -v $(pwd):/workdir ghcr.io/streetsidesoftware/cspell:latest "docs/**/*.md"`)

## llms.txt

The `llmstxt` MkDocs plugin (configured in `mkdocs.yml`) auto-generates `llms.txt` and `llms-full.txt` during build. When making changes to docs content or nav structure, verify that the llms.txt output is updated accordingly.

## Code Samples

Code samples live in `code-samples/` and are included in docs via `--8<--` snippets inside fenced code blocks. Sample files are bare expressions (no `actor Main`) unless they need to compile standalone.
