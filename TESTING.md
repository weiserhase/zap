# Testing Guide

This repository uses [Tytanic](https://github.com/tingerrr/tytanic) snapshot tests for Typst output.

## What tests check

- Each test under `tests/<name>/test.typ` renders one or more pages.
- `ref/*.png` are the expected snapshots.
- `out/*.png` are current render outputs.
- `diff/*.png` are visual differences generated when output and reference differ.

A test is:

- `persistent`: has references and is compared against them.
- `compile-only`: compiles but has no references yet.

## Prerequisites

Install the tools used by CI:

```bash
typst --version
```

If Typst is missing, install it with your preferred method.

Install Tytanic CLI:

```bash
cargo install tytanic --locked --version 0.2.2
```

## Run tests locally

Run all package tests:

```bash
tt run --no-fail-fast
```

Run one test suite only:

```bash
tt run logic
```

List available tests and their mode:

```bash
tt list
```

## Update snapshots (references)

Update all persistent references:

```bash
tt update
```

Update one suite only:

```bash
tt update logic
```

After updating, run tests again:

```bash
tt run --no-fail-fast
```

## Create a new test

1. Add a file: `tests/<name>/test.typ`.
2. Import the shared helper:

```typst
#import "/tests/utils.typ": test
#import "/src/lib.typ"

#test({
    import lib: *
    // your symbol calls
})
```

3. Generate first references:

```bash
tt update <name>
```

4. Verify:

```bash
tt run <name>
```

## Common issues

### "attempted to update compile-only test"

Cause: the test has no references yet, so it is marked compile-only.

Fix:

1. Run the test once:

```bash
tt run <name>
```

2. If needed, seed references from output:

```bash
mkdir -p tests/<name>/ref
cp tests/<name>/out/*.png tests/<name>/ref/
```

3. Re-run and then update normally:

```bash
tt run <name>
tt update <name>
```

### Avoid manual PDF extraction for references

Do not create `ref/*.png` with external PDF/image tools.
Those tools can change dimensions and antialiasing, leading to false diffs.
Always generate references via `tt run`/`tt update`.

## CI parity commands

The CI workflow in `.github/workflows/test.yml` runs:

```bash
tt run --no-fail-fast
typst compile docs/main.typ --format html --features html --root .
```

Running both locally is the closest match to CI behavior.
