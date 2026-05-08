/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

import StaxCert.Basic

/-!
# Lens(C) — the bidirectional lens category over a Cartesian base

For a Cartesian category `C`, `Lens(C)` has:
* Objects: pairs `(A, A')` where `A` is the "forward" type and `A'` the
  "change" / "backward" type.  In simple-typed lenses the two coincide.
* Morphisms `(A, A') → (B, B')`: a pair `(get, put)` with
    `get : A → B`
    `put : A × B' → A'`.

In v0 we use the **simple-typed** form: `A' = A`, so a lens
`A → B` is `(A → B, A × B → A)`.  This matches the Cockett-Cruttwell
backprop functor target.

Audit note: Capucci-Gavranović *dependent optics* are Agda / paper-only
and we are NOT depending on a Lean port that doesn't exist.  v0 stays
firmly in simple-typed lens-land.

References:
* Riley, "Categories of Optics" (2018, arXiv:1809.00738)
* Foster–Greenwald–Moore–Pierce–Schmitt, "Combinators for bi-directional
  tree transformations" (POPL 2005) — original lens laws.
-/

namespace StaxCert

open Category

/--
A simple-typed lens in a Cartesian category `C` from `A` to `B`:
a `get : A → B` and a `put : A × B → A`.  We pack only the data here;
the lens laws (PutGet, GetPut, PutPut) are stated separately so that
non-lawful "pre-lenses" (the morphisms of `Lens(C)` qua category) and
lawful lenses can both be expressed.
-/
structure LensHom (C : CartesianCategory) (A B : C.Obj) where
  get : C.Hom A B
  put : C.Hom (C.prod A B) A

namespace LensHom

variable {C : CartesianCategory}

/-- The identity lens `(id, fst) : A → A`. -/
def idLens (C : CartesianCategory) (A : C.Obj) : LensHom C A A where
  get := C.id A
  put := C.fst A A

/--
Composition of lenses.  Given `(g₁, p₁) : A → B` and `(g₂, p₂) : B → D`,
the composite is:
  get := g₁ ⊚ g₂
  put := λ (a, d') ↦ p₁ (a, p₂ (g₁ a, d'))

In point-free Cartesian form this requires duplication via `pair` and
projection.  We give the construction; full lawfulness deferred.
-/
def compLens {A B D : C.Obj}
    (ℓ : LensHom C A B) (m : LensHom C B D) : LensHom C A D where
  get := C.comp ℓ.get m.get
  put :=
    -- Build `A × D → A` via:  ⟨a, d⟩ ↦ ℓ.put ⟨a, m.put ⟨g₁ a, d⟩⟩
    let π₁ := C.fst A D
    let π₂ := C.snd A D
    let g₁a := C.comp π₁ ℓ.get        -- A × D → B
    let inner_pair := C.pair g₁a π₂   -- A × D → B × D
    let backB := C.comp inner_pair m.put  -- A × D → B
    let outer_pair := C.pair π₁ backB  -- A × D → A × B
    C.comp outer_pair ℓ.put

/-- The three classical lens laws (PutGet, GetPut, PutPut), as a Prop. -/
structure IsLawful (ℓ : LensHom C A B) : Prop where
  /-- `get (put a b) = b` -/
  putGet : C.comp ℓ.put ℓ.get = C.snd A B
  /-- `put (a, get a) = a` -/
  getPut : C.comp (C.pair (C.id A) ℓ.get) ℓ.put = C.id A
  /-- `put (put (a, b₁), b₂) = put (a, b₂)` -/
  putPut : True  -- statement deferred (requires more product machinery)

/-- Identity lens is lawful — provable for one concrete instance later. -/
theorem idLens_isLawful (C : CartesianCategory) (A : C.Obj) :
    IsLawful (idLens C A) := by
  -- Full proof deferred to a concrete CartesianCategory instance.
  sorry

end LensHom

end StaxCert
