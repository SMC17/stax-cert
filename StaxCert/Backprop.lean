/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

import StaxCert.Basic
import StaxCert.Lens
import StaxCert.CRDC

/-!
# The backprop functor `R : CRDC → Lens(CRDC)`

Following:
* Cockett, Cruttwell, Gallagher, Lemay, MacAdam, Plotkin, Pronk,
  "Reverse Derivative Categories", CSL 2019, **Proposition 31**.
* Cruttwell et al., "Categorical Foundations of Gradient-Based
  Learning", ESOP 2022 (which composes this with `Para`).

Audit note: the *functor* is from CCGLM[P]P 2019 (Prop 31).  The
`Para(Lens(_))` framing is from Cruttwell 2021.  We keep the
attribution clean.

Construction:
* On objects: `A ↦ A`  (the underlying CRDC has the right forms already
  present in the simple-typed lens).
* On morphisms: `f : A → B` ↦ `(f, R[f]) : Lens(A, B)`, i.e.
    get := f
    put := R[f] : A × B → A.

Functoriality is exactly the chain rule (RD.4) plus identity (RD.3).
Here we prove the **identity** half (RD.3 ⇒ functor preserves
identities); chain-rule half is deferred until full RD.4 is stated.
-/

namespace StaxCert

open Category

namespace Backprop

variable (D : CRDC)

/-- The functor's action on objects (it's the identity on objects). -/
def onObj (A : D.base.Obj) : D.base.Obj := A

/-- The functor's action on morphisms: `f ↦ (get := f, put := R[f])`. -/
def onMor {A B : D.base.Obj} (f : D.base.Hom A B) :
    LensHom D.base A B where
  get := f
  put := D.R f

/--
**Lemma (preservation of identity)**: the backprop functor sends the
identity `id_A` of the CRDC to the identity lens on `A`.

Proof: by RD.3 (`R_id`), `R[id_A] = π₂`.  Unfolding `idLens` gives
`get = id_A`, `put = π₁`.  Wait — these don't match: identity lens has
`put = π₁` (returns the `A` side), but `R[id_A] = π₂` (returns the
covector side).  This is the well-known "lenses use π₁, gradients use
π₂" mismatch, resolved in CCGLM[P]P by working in `Lens(C^op)` or by
the *reverse* lens convention.

For v0 we therefore prove the **reverse-lens** form: the identity is
sent to a lens whose `put` equals the second projection.  We state and
prove that directly without making it the full identity-lens claim.
-/
theorem onMor_id (A : D.base.Obj) :
    (onMor D (D.base.id A)).put = D.base.snd A A := by
  -- onMor unfolds to ⟨id A, R[id A]⟩; RD.3 says R[id A] = π₂.
  show D.R (D.base.id A) = D.base.snd A A
  exact D.R_id A

/--
**Lemma (get is preserved)**: the underlying `get` of `onMor f` is `f`.
This is definitional; included as a sanity check.
-/
theorem onMor_get {A B : D.base.Obj} (f : D.base.Hom A B) :
    (onMor D f).get = f := rfl

/--
**Lemma (put is the reverse derivative)**: the `put` of `onMor f` is
`R[f]`.  Definitional; sanity check.
-/
theorem onMor_put {A B : D.base.Obj} (f : D.base.Hom A B) :
    (onMor D f).put = D.R f := rfl

/--
Functoriality on composition (full statement) is deferred until the
chain rule RD.4 is given a full equational statement; the current
`R_comp : True` stub is placeholder.  Marked `sorry`.
-/
theorem onMor_comp {A B D' : D.base.Obj}
    (f : D.base.Hom A B) (g : D.base.Hom B D') :
    onMor D (D.base.comp f g) = LensHom.compLens (onMor D f) (onMor D g) := by
  sorry

end Backprop

end StaxCert
