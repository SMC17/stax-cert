# stax-cert — STATUS

Last updated: **2026-05-08** (v0 Day 1, Claude session).

## Toolchain

| Item            | Status                              |
|-----------------|-------------------------------------|
| elan            | **installed** (v4.2.1)              |
| Lean 4          | **installed** (v4.29.1, stable)     |
| lake            | **installed** (v5.0.0-src)          |
| Lean toolchain  | pinned in `lean-toolchain`          |
| mathlib4        | **NOT integrated** — see below      |

### Why no mathlib4 in v0

Audit constraint: the v0 ship-goal is a green `lake build` *today*. A
fresh mathlib4 build can take 30+ minutes (longer without `lake exe
cache get` priming). Standalone Lean files compile in seconds. We took
the standalone path. Mathlib integration is a Day-N upgrade — the local
`Category` / `StrictSMC` / `CartesianCategory` definitions in
`StaxCert/Basic.lean` are designed to be drop-in-replaceable with
`Mathlib.CategoryTheory.*` later.

## Build

```
$ lake build
✔ Built StaxCert.Basic
⚠ Built StaxCert.Para         (3 sorry)
⚠ Built StaxCert.Lens         (1 sorry)
✔ Built StaxCert.CRDC
⚠ Built StaxCert.Backprop     (1 sorry)
✔ Built StaxCert.Composition
✔ Built StaxCert
Build completed successfully (9 jobs).
```

**`lake build` exit status: 0 (green).**

## Files compiling cleanly

| File                          | Compiles? | sorry | proven lemmas        |
|-------------------------------|-----------|-------|----------------------|
| `StaxCert.lean` (root)        | yes       | 0     | (n/a; just imports)  |
| `StaxCert/Basic.lean`         | yes       | 0     | (definitions only)   |
| `StaxCert/Para.lean`          | yes       | 3     | 0                    |
| `StaxCert/Lens.lean`          | yes       | 1     | 0                    |
| `StaxCert/CRDC.lean`          | yes       | 0     | (definitions only)   |
| `StaxCert/Backprop.lean`      | yes       | 1     | 3 (`onMor_id`, `onMor_get`, `onMor_put`) |
| `StaxCert/Composition.lean`   | yes       | 0     | 4                    |

### `sorry` inventory (5 total)

* `StaxCert/Para.lean`
  - `compPara_assoc` — Para composition is associative under strictness.
  - `compPara_id_right` — right unit law for Para.
  - `compPara_id_left` — left unit law for Para.
* `StaxCert/Lens.lean`
  - `idLens_isLawful` — identity lens satisfies the lens laws (PutGet,
    GetPut). Provable per concrete `CartesianCategory` instance once we
    add one.
* `StaxCert/Backprop.lean`
  - `onMor_comp` — backprop functor preserves composition. Needs the
    full equational chain rule (currently RD.4 is a `True` stub).

### Provable / proven lemmas inventory

In `StaxCert/Backprop.lean`:
1. `onMor_id` — backprop sends `id_A` to a lens with `put = π₂` (this
   is exactly RD.3). **Real proof, no sorry.**
2. `onMor_get` — definitional. **Real proof, no sorry.**
3. `onMor_put` — definitional. **Real proof, no sorry.**

In `StaxCert/Composition.lean`:
4. `idLens_compLens_idLens` — composing the identity lens with itself
   yields the explicit unfolded form. Forces `compLens` to reduce
   correctly. **Real proof (`rfl`), no sorry.**
5. `compLens_get` — `get` of a composite lens equals composite of
   `get`s. **Real proof (`rfl`), no sorry.**
6. `backprop_get_eq` — backprop preserves `get`-as-underlying. **Real
   proof, no sorry.**
7. `backprop_id_put_eq_snd` — restatement of RD.3 in lens form. **Real
   proof, no sorry.**

## What's deferred (explicit)

These are NOT in v0 and are not promised on any near-term timeline:

- mathlib4 integration
- Hedges-style **double-category** structure on Lens (`Cruttwell et al.
  ESOP 2022 builds at most a 2-category` — the double-category framing
  is from Hedges 2018 and uses different lens types)
- refinement-typed lenses
- Heyting-fibration `π` over the lens base (the *behavioral predicate*
  layer; this is the hardest piece and unblocks Sovereign-Alignment
  Stack guarantees)
- full pullback theorem
- dependent optics (Capucci-Gavranović) — Agda or paper-only; a Lean 4
  port would have to be written from scratch and is not v0 work
- full equational RD.1, RD.2, RD.4, RD.5, RD.6, RD.7 — currently `True`
  stubs; only RD.3 has its real equation
- a concrete CRDC instance (e.g. `Smooth`, `PolyR`, `FVect_R`)
- functoriality of `R` on composition (the chain-rule half)
- the `Para(Lens(C))` 2-categorical structure (Cruttwell 2021 framing
  on top of what's here)

## Honest scope statement

> v0 is "the prerequisites compile, one lemma proven, the roadmap is
> public." That is not a Lean formalization of the Backprop functor.
> It is a credible *first commit* on the multi-year arc that ends in
> one. Liquid Tensor took ~17 mathematicians × 18 months for a single
> theorem; nothing here will be faster than that without lots of help.

## Next-day handoff

Day 2 candidates, in priority order:

1. **Pin a concrete CRDC instance** — start with the `One` CRDC (single
   object, identity morphism only). This lets us discharge `R_id` etc.
   on real data and unblocks the Backprop-`onMor_comp` proof.
2. **Replace `True` axioms in CRDC.lean with real equations** — at
   minimum RD.4 (chain rule); RD.5/RD.6 are mechanical given Cartesian
   structure.
3. **Decide whether to integrate mathlib4 now or after a second
   concrete CRDC.** Standalone is fine for a few more weeks; mathlib
   becomes mandatory once we touch `Smooth`.
4. **Write `Para(Lens(_))` as a one-line definition** (Cruttwell 2021
   framing) — currently we have `Para` and `Lens` separately; the
   composition is just `ParaHom (LensCategory C)` with the right
   monoidal structure. Worth doing while it's fresh.
5. **Discharge the Para identity laws** (`compPara_id_left`,
   `compPara_id_right`) — should be one rewrite each under strictness.
   `compPara_assoc` is harder; defer.
