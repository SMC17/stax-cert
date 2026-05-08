/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

import StaxCert.Basic

/-!
# Cartesian Reverse Differential Category (CRDC)

We follow:

* Cockett, Cruttwell, Gallagher, Lemay, MacAdam, Plotkin, Pronk,
  "Reverse Derivative Categories", CSL 2019.

A *Cartesian Reverse Differential Category* is a Cartesian left-additive
category equipped with a **reverse differential combinator** `R[_]`
satisfying axioms RD.1–RD.7.  Intuitively `R[f] : A × B → A` is the
gradient / pullback of `f : A → B` along a covector at `B`.

Axioms (paraphrased, full statements as `sorry`-stubbed equations):

* RD.1  Additivity in the covector argument.
* RD.2  Linearity / additivity of `R` w.r.t. `+` on morphisms.
* RD.3  `R[id_A] = π₂` (identity gradient is the covector itself).
* RD.4  Chain rule: `R[g ∘ f] = ⟨π₁, R[g] ∘ ⟨f ∘ π₁, π₂⟩⟩ ; R[f]`.
* RD.5  Pairing rule: `R[⟨f,g⟩] = R[f] ∘ ⟨π₁, π₁ ∘ π₂⟩ + R[g] ∘ ⟨π₁, π₂ ∘ π₂⟩`.
* RD.6  Projection rule: `R[π_i] = ι_i` (insertions).
* RD.7  Symmetry of the second derivative ("Schwarz / Clairaut").

For v0 we only fix the *signature* of `R` and stub axioms as `sorry`;
the `Backprop.lean` functor only needs RD.3 and RD.4 to define `R` on
morphisms.
-/

namespace StaxCert

open Category

/--
Cartesian left-additive structure on a Cartesian category: each hom-set
has a chosen zero and binary sum, compatible with composition on the
right.  We keep this minimal — full Blute-Cockett-Seely additive
structure is deferred.
-/
structure LeftAdditive (C : CartesianCategory) where
  zero : ∀ {A B}, C.Hom A B
  add  : ∀ {A B}, C.Hom A B → C.Hom A B → C.Hom A B
  -- Compatibility (skeleton; proper laws deferred):
  add_zero_left  : ∀ {A B} (f : C.Hom A B), add zero f = f
  add_zero_right : ∀ {A B} (f : C.Hom A B), add f zero = f

/--
A Cartesian Reverse Differential Category: a Cartesian category with a
left-additive structure and a reverse-derivative combinator `R[_]`
sending `f : A → B` to `R[f] : A × B → A`, satisfying RD.1–RD.7.

In v0 the axioms are present as Prop fields stubbed `sorry` per
instance; this is sufficient to write the backprop functor.
-/
structure CRDC where
  base : CartesianCategory
  add  : LeftAdditive base
  /-- The reverse-derivative combinator. -/
  R    : ∀ {A B}, base.Hom A B → base.Hom (base.prod A B) A
  -- RD.3: `R[id_A] = π₂`  (gradient of identity is the incoming covector).
  R_id : ∀ A, R (base.id A) = base.snd A A
  -- RD.4: chain rule (skeleton).  Full equation deferred.
  R_comp : ∀ {A B D} (_f : base.Hom A B) (_g : base.Hom B D), True
  -- RD.6: projections (skeleton).
  R_fst : ∀ (_A _B : base.Obj), True  -- `R[π₁] = ⟨π₂, 0⟩` deferred
  R_snd : ∀ (_A _B : base.Obj), True  -- `R[π₂] = ⟨0, π₂⟩` deferred
  -- RD.7 (Clairaut): deferred.
  R_clairaut : True

end StaxCert
