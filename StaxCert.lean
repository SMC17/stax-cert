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
import StaxCert.CRDC
import StaxCert.Backprop
import StaxCert.Composition

/-!
# StaxCert — root module

v0 prerequisites for compositional alignment in Lean 4:
* `StaxCert.Basic`        — minimal Category / SMC / Cartesian skeleton
* `StaxCert.Para`         — Para construction over a strict SMC
* `StaxCert.Lens`         — simple-typed Lens(C) over a Cartesian base
* `StaxCert.CRDC`         — Cartesian Reverse Differential Category
* `StaxCert.Backprop`     — the functor R : CRDC → Lens(CRDC)
* `StaxCert.Composition`  — the v0 provable composition lemmas

NOT in v0 (deferred — see STATUS.md):
* mathlib4 integration
* refinement-typed lenses
* Heyting-fibration `π`
* full pullback theorem
* double-category structure (Hedges-style)
* dependent optics (Capucci-Gavranović)
-/
