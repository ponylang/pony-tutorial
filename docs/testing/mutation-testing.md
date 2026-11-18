# Mutation Testing

Mutation testing checks whether your tests actually verify the code they cover. Small modifications are applied to your program — operators swapped, constants changed, calls removed — and the test suite is run against each one. A failed test run kills the mutant. If the test run passes, the mutant survives.

## How it works

Mutation testing in Pony has two parts. The compiler instruments the binary when you compile with the `--mutate` flag. You can then use the `pony-mutate` runner to execute the binary, activating each mutant in turn and running the test suite against it in parallel.

## Basic workflow

Compile with the `--mutate` flag. This produces an instrumented binary and a `.mutants.json` file listing every mutation site.

```bash
ponyc --mutate -b myapp .
```

Run `pony-mutate` against the binary:

```bash
pony-mutate ./myapp
```

`pony-mutate` first runs the unmodified test suite as a baseline. It then runs each mutant in parallel, using one worker per CPU by default. If the baseline fails, `pony-mutate` exits without running any mutants.

## Example

The following program bounds an integer to a range and has three tests:

```pony
--8<-- "mutation-testing-example.pony"
```

Save the example as `bounded.pony` in a new, empty directory. Run these commands from that directory. The scope covers lines 4–8, which contain the declaration and body of `Bounded.apply`.

```bash
ponyc --mutate --mutate-scope=bounded.pony:4-8 -b bounded .
pony-mutate ./bounded
```

!!! note
    The terminal output format, progress order, and timing may vary. The example uses a shortened source path.

Progress lines print to stderr as each mutant finishes.

```text
[ 1/12] Mutant 2 (ror lt -> gt at bounded.pony:5:14) killed (0.1s)
```

The final report gives the mutation score and lists the surviving mutants.

```text
Mutation Testing Report
=======================

Total mutants:  12
Killed:         10 (83.3%)
Survived:       2 (16.6%)
Timed out:      0 (0.0%)

Mutation score: 83.3% (killed + timed out) / tested

Survived mutants:
  bounded.pony:5:14  ror  lt -> le  [Bounded]
  bounded.pony:6:18  ror  gt -> ge  [Bounded]
```

The runner exits with status 1 because two mutants survived. The `lt -> le` mutant changes `value < low` to `value <= low`. The comparisons differ only when `value == low`. At that boundary, both versions return `low` if `low <= high`.

## Mutation categories

The compiler groups mutations into categories. Current categories include:

| Category | What it does |
|----------|-------------|
| aor | Replaces arithmetic operators (`+` with `-`, `*` with `/`, etc.) |
| bor | Replaces boolean operators (`and` with `or`, `xor` variants) |
| ror | Replaces relational operators (`<` with `<=`, `==` with `!=`, etc.) |
| sor | Replaces shift operators (`<<` with `>>`) |
| uoi | Inserts unary operators (negation, complement) |
| cr | Replaces numeric and character literals |
| rvr | Replaces return values (e.g., a String return becomes an empty String) |
| vcr | Removes calls that return None |
| amr | Swaps the safe and unsafe forms of integer division (`/`), integer remainder (`%`), left shift (`<<`), and right shift (`>>`) |

## Scoping mutations

Two compiler flags limit the scope.

`--mutate-operators` restricts which categories are applied:

```bash
ponyc --mutate --mutate-operators=aor,ror -b myapp .
```

`--mutate-scope` restricts mutations to a specific file, optionally with a line range:

```bash
ponyc --mutate --mutate-scope=bounded.pony:4-8 -b myapp .
```

`--mutate-scope` can be passed more than once to target multiple files:

```bash
ponyc --mutate --mutate-scope=foo.pony --mutate-scope=bar.pony:10-20 -b myapp .
```

## Selecting mutations in source

Use `\mutate_only(aor, ror)\` to select arithmetic and relational mutations, or `\mutate_except(aor, ror)\` to remove those categories from the current selection. The category codes are the same ones you use with `--mutate-operators`.

On a concrete type, either annotation limits the categories available to every method. A method can narrow that selection further. If a method's `mutate_only` lists a category excluded by its type, compilation fails even without `--mutate`.

Use `\nomutate\` on a method to suppress mutations in that method. On a type, `\nomutate\` disables mutations by default. You can opt individual methods back in with `mutate_only`.

```pony
--8<-- "mutation-testing-ledger.pony"
```

Both `Main` and `Ledger` use `nomutate`. The compiler can mutate the subtraction and comparison in `Ledger.affordable` because that method has `mutate_only(aor, ror)`. It skips `Ledger.balance` and `Main.create`.

Save the example as `main.pony` in a new, empty directory. From that directory, compile it and list the categories in the generated file using `jq`.

```bash
ponyc --mutate --mutate-scope=main.pony -b ledger .
jq -r '.mutants[].category' ledger.mutants.json | sort -u
```

```text
aor
ror
```

The file and line filters limit where the compiler can apply the categories selected in source. You can narrow the categories on the command line too. Add `--mutate-operators=ror` to the compile command and run the `jq` command again. This time it prints only `ror`.

## Additional resources

The [Pony website](https://www.ponylang.io/use/testing/mutation-testing/) has a reference page covering `pony-mutate` options, output formats, and Stryker JSON reports.
