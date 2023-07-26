{-# OPTIONS --safe #-}

module Braid.Subgroup.MPureBraidtoBraidA where

open import Cubical.Core.Primitives
open import Cubical.Foundations.Prelude 
open import Cubical.Foundations.Path
open import Cubical.Data.Nat
open import Cubical.Data.Fin 
open import Cubical.Data.Int
open import Cubical.Data.Nat.Order renaming (pred-≤-pred to pred ; suc-< to presuc ; ¬-<-zero to !<0 ; ¬m<m to !m<m ; <-weaken to weaken; <-asym to asym ; <-trans to trans ; <→≢  to <!=)
open import Cubical.Foundations.GroupoidLaws
open import Cubical.Data.Empty as ⊥


open import Braid.BraidGroup
open import Braid.PureBraidAlt hiding (GenComposer)

----------------------------------------------------------------------
{-
    Some helpers for order relations
-}

-- If r < p < q then r + 1 < q
zero-<-suc : (n : ℕ) → 0 < (suc n)
zero-<-suc n = ≤→< zero-≤ znots

sucTrans< : (r p q : ℕ) → (r < p) → (p < q) → ((suc r) < q)
sucTrans< r p zero proof-rp proof-pq = ⊥.rec {A = (suc r) < 0} (!<0 proof-pq)
sucTrans< r p (suc q) proof-rp proof-pq = ≤-trans (suc-≤-suc proof-rp) proof-pq

p-<-suc : (n p : ℕ) → (p < (suc (suc n))) → (p < suc n)
p-<-suc n zero proof-suc = zero-<-suc n

p-<-suc n (suc p) proof-suc = {!   !}
-----------------------------------------------------------------------


Gen_^_ : {n : ℕ} (p : Fin n) (k : ℕ)  → Path (Braid n) base base -- composes a generator with itself k times
Gen p ^ zero = refl
Gen p ^ (suc zero) = gen p
Gen p ^ (suc (suc k)) = gen p ∙ (Gen p ^ (suc k))


-- when p = 0 i.e A₀ₖ 
-- q and p are Fin (suc n) so that Pure Braid has n + 1 strands to match Braid n
GenHelperZero : (n : ℕ) (q : ℕ) → (q < (suc n)) → Path (Braid n) base base

-- 3 base cases
GenHelperZero zero zero proof-q = refl
GenHelperZero zero (suc q) proof-q = ⊥.rec (!<0 (pred proof-q))
GenHelperZero (suc n) zero proof-q = refl

GenHelperZero (suc n) (suc zero) proof-q = gen (zero , zero-<-suc n) ∙ gen (zero , zero-<-suc n)
GenHelperZero (suc n) (suc (suc q)) proof-q = gen (suc q , pred proof-q) ∙∙ GenHelperZero (suc n) (suc q) (presuc proof-q) ∙∙  sym (gen (suc q , pred proof-q))

GenConvertor : {n : ℕ}  →  (p q : ℕ) → (p < (suc n)) → (q < (suc n)) → (p < q) → Path (Braid n) base base

-- 3 base cases
GenConvertor {n = zero} p zero proof-p proof-q proof-pq = ⊥.rec (!<0 proof-pq)
GenConvertor {n = zero} p (suc q) proof-p proof-q proof-pq = ⊥.rec (!<0 (pred proof-q))

GenConvertor {n = suc n} zero q proof-p proof-q proof-pq = GenHelperZero (suc n) q proof-q
GenConvertor {n = suc n} (suc p) zero proof-p proof-q proof-pq = ⊥.rec (!<0 proof-pq)

GenConvertor {n = suc n} (suc p) (suc q) proof-p proof-q proof-pq i = addGen {n = n} ((GenConvertor {n = n} p q (pred proof-p) (pred proof-q) (pred proof-pq) i))




SwapCompositions1 : {n : ℕ} → (p q : ℕ) → (proof-p : p < n) → (proof-q : q < n) → ((suc p) < q) → 
    Square (Gen (p , proof-p) ^ 2) (Gen (p , proof-p) ^ 2) (gen (q , proof-q)) (gen (q , proof-q)) 
    
-- using vertical composition to get the required square-- using vertical composition to get the required square
SwapCompositions1 p q proof-p proof-q proof-pq = 
    (Braid.commutativity1 (p , proof-p) (q , proof-q) proof-pq) ∙₂ (Braid.commutativity1 (p , proof-p) (q , proof-q) proof-pq)


SwapCompositions2 : {n : ℕ} → (p q : ℕ) → (proof-p : p < n) → (proof-q : q < n) → ((suc q) < p)→ 
    Square (gen (p , proof-p)) (gen (p , proof-p)) (Gen (q , proof-q) ^ 2) (Gen (q , proof-q) ^ 2)
SwapCompositions2 p q proof-p proof-q proof-qp =
     (Braid.commutativity2 (p , proof-p) (q , proof-q) proof-qp) ∙v' (Braid.commutativity2 (p , proof-p) (q , proof-q) proof-qp)


GenSwapper : {n : ℕ} → (p q r : ℕ) → (proof-p : p < (suc n)) → (proof-q : q < (suc n)) → (proof-r : r < n) → (proof-pq : p < q) → (proof-qr : q < r) →
    Square (GenConvertor p q proof-p proof-q proof-pq) (GenConvertor p q proof-p proof-q proof-pq)  (gen (r , proof-r)) (gen (r , proof-r))

GenSwapper zero zero r proof-p proof-q proof-r proof-pq proof-qr = ⊥.rec (!<0 proof-pq)

GenSwapper zero (suc zero) r proof-p proof-q proof-r proof-pq proof-qr = {! SwapCompositions1  zero r (pred proof-q) proof-r proof-qr  !}

GenSwapper zero (suc (suc q)) r proof-p proof-q proof-r proof-pq proof-qr = {!   !}
GenSwapper (suc p) zero r proof-p proof-q proof-r proof-pq proof-qr = {!   !}



GenSwapper (suc p) (suc q) r proof-p proof-q proof-r proof-pq proof-qr = {!   !}









-- r < s < p < q

Commutativity1Zero : {n : ℕ} → (p q s : ℕ) -- r is zero 
                    → (p < (suc n)) → (q < (suc n)) → (s < (suc n))   -- proofs to make them fin n
                    → (p < q)           -- since we use only one presentation of a generator
                    → (s < p)           -- condition for commutativity 1
                    → (Path (Braid n) base base)

Commutativity1Zero p q zero proof-p proof-q proof-s proof-pq proof-sp = GenConvertor  p q proof-p proof-q proof-pq -- A rs does not exist so

Commutativity1Zero {n = n} zero zero (suc s) proof-p proof-q proof-s proof-pq proof-sp = ⊥.rec (!<0 proof-sp) -- these cases cannot exist as s < p but not if p = 0
Commutativity1Zero {n = n} zero (suc q) (suc s) proof-p proof-q proof-s proof-pq proof-sp = ⊥.rec (!<0 proof-sp)
Commutativity1Zero {n = n} (suc p) zero (suc s) proof-p proof-q proof-s proof-pq proof-sp = ⊥.rec (!<0 proof-pq)


Commutativity1Zero (suc p) (suc q) (suc zero) proof-p proof-q proof-s proof-pq proof-sp = {!   !}

Commutativity1Zero (suc p) (suc q) (suc (suc s)) proof-p proof-q proof-s proof-pq proof-sp = {!   !}

Commutativity1Helper : {n : ℕ}  →  (p q r s : ℕ) 
                      → (p < n) → (q < n) → (r < n) → (s < n) -- proofs to make them fin n
                      → (p < q) → (r < s)                     -- since we use only one presentation of a generator
                      → (s < p)                               -- condition for commutativity 1
                      → (Path (Braid n) base base)
Commutativity1Helper = {!   !}

-- A₁₃  = σ₂ σ₁² σ₂⁻¹   A₁₃ . A₄₅ =  σ₂ σ₁² σ₂⁻¹ . σ₄ σ₄
-- A₄₅  = σ₄ σ₄         A₄₅ . A₁₃ =  σ₄ σ₄ . σ₂ σ₁² σ₂⁻¹




PBraid≤Braid : {n : ℕ} (b : BPureBraid' (suc n)) → Braid n
PBraid≤Braid base = base
PBraid≤Braid (gen p q proof-pq i) = GenConvertor (fst p) (fst q) (snd p) (snd q) proof-pq i
PBraid≤Braid (twoGencommutativity1 p q r s proof-rs proof-sp proof-pq i j) = {!   !}
PBraid≤Braid (twoGencommutativity2 p q r s proof-pr proof-rs proof-sq proof-pq i j) = {!   !}
PBraid≤Braid (threeGenCommutativityConnector r p q proof-rp proof-pq proof-rq i) = {!   !}
PBraid≤Braid (threeGenCommutativityLeft r p q proof-rp proof-pq proof-rq i j) = {!   !}
PBraid≤Braid (threeGenCommutativityMiddle r p q proof-rp proof-pq proof-rq i j) = {!   !}
PBraid≤Braid (threeGenCommutativityRight r p q proof-rp proof-pq proof-rq i j) = {!   !}
PBraid≤Braid (fourGenCommutativityConnector r p s q proof-rp proof-ps proof-sq proof-rq proof-pq i) = {!   !}
PBraid≤Braid (fourGenCommutativityComposition r p s q proof-rp proof-ps proof-sq proof-rq proof-pq i j) = {!   !}
PBraid≤Braid (fourGenCommutativity r p s q proof-rp proof-ps proof-sq proof-rs proof-rq proof-pq i j) = {!   !}