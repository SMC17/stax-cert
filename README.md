# stax-cert

**v0 — Lean 4 prerequisites for compositional alignment.**
Para, Lens(C), CRDC, the backprop functor `R : CRDC → Lens(CRDC)`, and
one composition lemma. **No** double categories, **no** refinement
types, **no** full pullback theorem in v0.

This is the longest-lead-time workstream in the stax Sovereign Alignment
Stack. It will not "ship" for months. Day-1 goal: green `lake build`
plus an honest, audited public roadmap.

## What this is

`stax-cert` is a Lean 4 formalization seed targeting the categorical
foundations of gradient-based learning (Cruttwell-Gavranović-Ghani-
Wilson-Zanasi, ESOP 2022) and the reverse-derivative-category functor
that turns a CRDC into a category of lenses (Cockett-Cruttwell-Gallagher-
Lemay-MacAdam-Plotkin-Pronk, CSL 2019, **Proposition 31**).

Long-term, it grounds *behaviorally certified* model components: claim
"this submodule's gradient flow respects this contract" and have a
machine-checked proof.

## What v0 contains

| File                          | Purpose                                                   | sorry-count |
|-------------------------------|-----------------------------------------------------------|-------------|
| `StaxCert/Basic.lean`         | minimal `Category`, `StrictSMC`, `CartesianCategory`      | 0           |
| `StaxCert/Para.lean`          | `ParaHom`, `idPara`, `compPara`, associativity statements | 3           |
| `StaxCert/Lens.lean`          | simple-typed `LensHom`, `idLens`, `compLens`, lens laws   | 1           |
| `StaxCert/CRDC.lean`          | `LeftAdditive`, `CRDC` structure with RD.3 + RD.4 stubs   | 0           |
| `StaxCert/Backprop.lean`      | `onObj`, `onMor`, `onMor_id` (proven via RD.3)            | 1           |
| `StaxCert/Composition.lean`   | four definitionally-proven lemmas (no sorry)              | 0           |

`lake build` is green. See `STATUS.md` for full details.

## What v0 does **not** contain (deferred)

- mathlib4 dependency (audit constraint: the >30 min compile risked
  killing the day-one ship goal; we ship standalone first, integrate
  later)
- refinement-typed lenses
- the Heyting-fibration `π` for behavioral predicates
- the full pullback theorem
- a Hedges-style **double-category** structure (note: Cruttwell et al.
  build *at most* a 2-category in ESOP 2022 — the double-category
  framing is from Hedges, *Open Games*, MFPS 2018, with different lens
  types)
- dependent optics in the Capucci-Gavranović sense (paper- and Agda-
  only — there is no Lean 4 port to depend on; we will write one
  eventually, not import a fiction)
- the chain-rule half of backprop functoriality (needs full RD.4
  equation, not the current `True` stub)
- any concrete CRDC instance (`Smooth`, `PolyR`, etc.)

Solo Lean formalization of frontier category-theory content takes years
(Liquid Tensor: ~17 mathematicians × 18 months for one theorem). This
repo will move at hobbyist + AI-assisted pace. The next-six-month goal
is a single mathematically-real lemma machine-checked end-to-end.

## Build

```bash
# elan + Lean (one-time)
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
source $HOME/.elan/env       # or add ~/.elan/bin to PATH

# build this repo
cd stax-cert
lake build
```

Lean version pinned in `lean-toolchain` (currently `v4.29.1`).

## License

AGPL-3.0-or-later. See `LICENSE`.

The AGPL is deliberate: this codebase is a public good and any service
built on it should be a public good too. The wider sovereign-edge
roadmap follows the same convention.

## References (load-bearing for v0)

- Cockett, Cruttwell, Gallagher, Lemay, MacAdam, Plotkin, Pronk,
  *Reverse Derivative Categories*, **CSL 2019**.  (Source of the
  CRDC axioms RD.1–RD.7 and the backprop functor, Prop 31.)
- Cruttwell, Gavranović, Ghani, Wilson, Zanasi, *Categorical
  Foundations of Gradient-Based Learning*, **ESOP 2022**.  (Source of
  the modern Para construction.  Builds at most a 2-category; the
  double-category framing is **not** here.)
- Cruttwell 2021 lecture notes, *Para(Lens(C))* framing for backprop.
- Hedges, *Compositional Game Theory*, **MFPS 2018**.  (Source of the
  Hedges-lens / open-game double category — not implemented in v0.)
- Riley, *Categories of Optics*, arXiv:1809.00738.

## Status

See `STATUS.md` for the live build and proof status.
