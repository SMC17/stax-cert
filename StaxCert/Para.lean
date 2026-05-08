/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

import StaxCert.Basic

/-!
# Para(C) — the Para construction over a strict symmetric monoidal category

A `Para`-morphism `A ↛ B` is a pair `(P, f)` where `P : Obj` is the
*parameter* object and `f : P ⊗ A → B` is a morphism in the underlying
SMC.  Composition tensors the parameter spaces.

References:
* Cruttwell, Gavranović, Ghani, Wilson, Zanasi, "Categorical Foundations
  of Gradient-Based Learning" (ESOP 2022) — the modern Para construction.
* Cruttwell 2021 "Para(Lens(C))" framing for backprop.

Audit note: Cruttwell et al. construct **at most a 2-category**, not a
double category, in this paper.  The double-category structure is from
Hedges' open games (MFPS 2018), which uses different lens types.  v0
treats `Para` as a 1-categorical skeleton; the 2-cell layer is deferred.
-/

namespace StaxCert

open Category

/--
A `Para`-morphism in a strict SMC `C` from `A` to `B`: a parameter object
`param` together with a "parameterized morphism" `body : param ⊗ A → B`.
-/
structure ParaHom (C : StrictSMC) (A B : C.Obj) where
  param : C.Obj
  body  : C.Hom (C.tensorObj param A) B

namespace ParaHom

variable {C : StrictSMC}

/--
The identity `Para`-morphism on `A` has parameter `unit` and body the
left-unitor — which under strictness is just `id A` (since
`unit ⊗ A = A`).
-/
def idPara (C : StrictSMC) (A : C.Obj) : ParaHom C A A where
  param := C.unit
  body  :=
    -- Goal: Hom (tensorObj unit A) A.  By tensor_unit_left, that = Hom A A.
    -- Rewrite the goal type backwards using the strictness equation.
    (C.tensor_unit_left A).symm ▸ C.id A

/--
Composition of `Para`-morphisms.  Given `(P, f) : A ↛ B` and
`(Q, g) : B ↛ C`, the composite has parameter `Q ⊗ P` and body
`(Q ⊗ P) ⊗ A ≅ Q ⊗ (P ⊗ A) → Q ⊗ B → C`.  Under strictness the
re-association is an equality.
-/
def compPara {A B D : C.Obj}
    (φ : ParaHom C A B) (ψ : ParaHom C B D) : ParaHom C A D where
  param := C.tensorObj ψ.param φ.param
  body  :=
    -- (ψ.param ⊗ φ.param) ⊗ A = ψ.param ⊗ (φ.param ⊗ A) by strictness.
    -- Goal: Hom ((ψ.param ⊗ φ.param) ⊗ A) D.  Rewrite goal backwards.
    (C.tensor_assoc ψ.param φ.param A).symm ▸
      C.comp (C.tensorHom (C.id ψ.param) φ.body) ψ.body

/--
Associativity of `Para` composition (the 2-categorical associator
collapsed under strictness).  In v0 we state it; the proof requires
machinery (interchange + tensor associativity) we will build out
incrementally.  Marked `sorry` for now.
-/
theorem compPara_assoc {A B D E : C.Obj}
    (φ : ParaHom C A B) (ψ : ParaHom C B D) (χ : ParaHom C D E) :
    compPara (compPara φ ψ) χ = compPara φ (compPara ψ χ) := by
  sorry

/--
Right identity: `(P, f) ⨟ id_B = (P, f)` up to strict equality.
Proof deferred (`sorry`) — see roadmap.
-/
theorem compPara_id_right {A B : C.Obj} (φ : ParaHom C A B) :
    compPara φ (idPara C B) = φ := by
  sorry

/--
Left identity: `id_A ⨟ (P, f) = (P, f)`.  Proof deferred.
-/
theorem compPara_id_left {A B : C.Obj} (φ : ParaHom C A B) :
    compPara (idPara C A) φ = φ := by
  sorry

end ParaHom

end StaxCert
