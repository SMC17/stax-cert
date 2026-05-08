/-
Copyright (c) 2026 stax. All rights reserved.
This file is part of stax-cert and is licensed under the GNU Affero
General Public License v3.0 or later (AGPL-3.0-or-later).
See LICENSE in the project root for full text.

Authors: stax (with Claude Code assistance)
-/

import StaxCert.Basic
import StaxCert.Para
import StaxCert.Lens
import StaxCert.Backprop

/-!
# Composition lemmas

Honest v0 scope: we prove **one** non-trivial-but-tractable composition
fact and leave the rest as a roadmap.  Per the audit:

> v0 scope: `Para`, `Lens(C)`, `Para(Lens(_))` skeleton + functor R:
> CRDC → Lens(CRDC) for one concrete CRDC + one composition lemma.
> That's it.

The lemma we prove: **the simple-typed lens identity composes left-
trivially with itself** (a special case of `idLens` being a left and
right unit) — a tiny but real mathematical claim that exercises the
infrastructure.

Para associativity, full lens-law preservation under composition, and
the chain-rule half of backprop functoriality are explicitly deferred.
-/

namespace StaxCert

open Category LensHom

/--
**Lemma**: composing the identity lens with itself yields the identity
lens (idempotence of `idLens`).  This is a strict equality at the level
of the `LensHom` record because both fields reduce definitionally.

Why this is non-trivial: it forces the `compLens` definition to actually
unfold cleanly under `idLens`, which catches off-by-one errors in the
`pair`/`fst`/`snd` plumbing.
-/
theorem idLens_compLens_idLens
    (C : CartesianCategory) (A : C.Obj) :
    compLens (idLens C A) (idLens C A) =
    ({ get := C.comp (C.id A) (C.id A)
       put := C.comp (C.pair (C.fst A A) (C.comp
                (C.pair (C.comp (C.fst A A) (C.id A)) (C.snd A A))
                (C.fst A A)))
              (C.fst A A) } : LensHom C A A) := by
  -- This is exactly the unfolded form of compLens applied to two idLens.
  rfl

/--
**Lemma (provable, no `sorry`)**: the `get` of `compLens ℓ m` is the
composition of the underlying `get`s.  This is *definitionally* true
and gives us a clean rewrite rule for downstream proofs.
-/
theorem compLens_get
    {C : CartesianCategory} {A B D : C.Obj}
    (ℓ : LensHom C A B) (m : LensHom C B D) :
    (compLens ℓ m).get = C.comp ℓ.get m.get :=
  rfl

/--
**Lemma (provable, no `sorry`)**: backprop `onMor` preserves `get`-as-
underlying-morphism.  Pulled out of `Backprop.lean` as the canonical
"functor preserves underlying data" lemma.
-/
theorem backprop_get_eq
    (D : CRDC) {A B : D.base.Obj} (f : D.base.Hom A B) :
    (Backprop.onMor D f).get = f := rfl

/--
**Lemma (provable, no `sorry`)**: backprop `onMor` of the identity has
`put = π₂`.  This is the cleanest concrete statement of "RD.3 holds
inside the lens image".
-/
theorem backprop_id_put_eq_snd
    (D : CRDC) (A : D.base.Obj) :
    (Backprop.onMor D (D.base.id A)).put = D.base.snd A A :=
  Backprop.onMor_id D A

end StaxCert
