/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

/-!
# StaxCert.Basic

Common foundations for the stax-cert formalization.

This module defines a minimal `Category` typeclass-style structure used
throughout the v0 development.  We deliberately do NOT depend on mathlib4
in v0 because (a) the mathlib build can take 30+ minutes from scratch on
this laptop and (b) the v0 goal is a green `lake build` with one provable
lemma, not a full integration.  When this codebase grows, swap these
local definitions for `Mathlib.CategoryTheory.Category.Basic` etc.

References (for the larger development):
* Mac Lane, *Categories for the Working Mathematician*, Ch. I
* nLab, "category"
-/

namespace StaxCert

universe u v

/--
A (locally small, strict) category.  We use `=` rather than a hom-equality
relation; this is the strict-1-category presentation, sufficient for the
v0 development of `Para` and `Lens` over a strict (symmetric) monoidal
base.  Higher-categorical / bicategorical refinement is deferred.
-/
structure Category where
  Obj : Type u
  Hom : Obj → Obj → Type v
  id  : ∀ X, Hom X X
  comp : ∀ {X Y Z}, Hom X Y → Hom Y Z → Hom X Z
  id_comp : ∀ {X Y} (f : Hom X Y), comp (id X) f = f
  comp_id : ∀ {X Y} (f : Hom X Y), comp f (id Y) = f
  assoc : ∀ {W X Y Z} (f : Hom W X) (g : Hom X Y) (h : Hom Y Z),
            comp (comp f g) h = comp f (comp g h)

/--
A strict symmetric monoidal category, presented in the strict form (no
coherence isos, just a tensor functor and a unit).  This is the base
needed for `Para`.  We collapse the usual associator / unitor / braiding
into equalities, which is sound for the strict case.
-/
structure StrictSMC extends Category where
  tensorObj : Obj → Obj → Obj
  unit : Obj
  tensorHom : ∀ {X₁ Y₁ X₂ Y₂},
    Hom X₁ Y₁ → Hom X₂ Y₂ → Hom (tensorObj X₁ X₂) (tensorObj Y₁ Y₂)
  -- Strictness equations (kept abstract; users discharge per-instance):
  tensor_id : ∀ X Y, tensorHom (id X) (id Y) = id (tensorObj X Y)
  tensor_unit_left  : ∀ X, tensorObj unit X = X
  tensor_unit_right : ∀ X, tensorObj X unit = X
  tensor_assoc : ∀ X Y Z,
    tensorObj (tensorObj X Y) Z = tensorObj X (tensorObj Y Z)
  -- Symmetry as a chosen swap morphism (data).
  swap : ∀ X Y, Hom (tensorObj X Y) (tensorObj Y X)

/--
A Cartesian category: a category with chosen finite products, presented
strictly.  Sufficient for `Lens(C)`.  In the full development this would
be a mathlib `ChosenFiniteProducts` instance.
-/
structure CartesianCategory extends Category where
  prod : Obj → Obj → Obj
  terminal : Obj
  pair : ∀ {X A B}, Hom X A → Hom X B → Hom X (prod A B)
  fst : ∀ A B, Hom (prod A B) A
  snd : ∀ A B, Hom (prod A B) B
  bang : ∀ X, Hom X terminal
  -- Universal-property equations (left as data; per-instance proofs):
  pair_fst : ∀ {X A B} (f : Hom X A) (g : Hom X B),
    comp (pair f g) (fst A B) = f
  pair_snd : ∀ {X A B} (f : Hom X A) (g : Hom X B),
    comp (pair f g) (snd A B) = g

end StaxCert
