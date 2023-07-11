module homework.braid.PureBraidAlt where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat.Base
open import Cubical.Data.Fin.Base
open import Cubical.Data.Nat.Order renaming (pred-≤-pred to pred)
open import Cubical.Data.Empty as ⊥


finPred : {n : ℕ} (f : Fin (suc (suc n))) → Fin (suc n)
finPred {n = n} (zero , proof) = fzero
finPred (suc p , proof) = p , pred proof



data BPureBraid (n : ℕ) :  Type where -- the space whose loops are the pure braid group of n strands
  base : BPureBraid n
  gen  : (p q : Fin n)  → base ≡ base
  identity : (p : Fin n) → Square (gen p p) refl refl refl
  genEquality : (p q : Fin n) → Square (gen p q) refl (gen q p) refl
  twoGenCommutativity1 : (p q r s : Fin n) → (proof-rs : toℕ r < toℕ s)
                          → ( proof-sp : toℕ s < toℕ p)
                          → ( proof-pq : toℕ p < toℕ q)
                          →  Square (gen p q)  (gen p q) (gen r s ) (gen r s)
                          
  twoGenCommutativity2 : (p q r s : Fin n) → (proof-pr : toℕ p < toℕ r)
                          → ( proof-rs : toℕ r < toℕ s)
                          → ( proof-sq : toℕ s < toℕ q)
                          → Square (gen p q) (gen p q) (gen r s) (gen r s)
  


  threeGenCommutativityConnector : (r p q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-pq : toℕ p < toℕ q) → base ≡ base


  threeGenCommutativityLeft : (r p q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-pq : toℕ p < toℕ q) → Square
                                                                                                           (gen p q)
                                                                                                           (sym (gen r q))
                                                                                                           (threeGenCommutativityConnector r p q proof-rp proof-pq)
                                                                                                           (gen p r)
                                                                                                          

  threeGenCommutativityMiddle : (r p q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-pq : toℕ p < toℕ q) → Square
                                                                                                            (gen p r)
                                                                                                            (sym (gen p q))
                                                                                                            (threeGenCommutativityConnector r p q proof-rp proof-pq)
                                                                                                            (gen r q)


  threeGenCommutativityRight : (r p q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-pq : toℕ p < toℕ q) → Square
                                                                                                            (gen r q)
                                                                                                            (sym (gen p r))
                                                                                                            (threeGenCommutativityConnector r p q proof-rp proof-pq)
                                                                                                            (gen p q)
                            
                                                                                                
  fourGenCommutativityConnector : (r p s q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-ps : toℕ p < toℕ s) → (proof-sq : toℕ s < toℕ q) → base ≡ base
  
  fourGenCommutativityComposition : (r p s q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-ps : toℕ p < toℕ s) → (proof-sq : toℕ s < toℕ q) → Square 
                                                                                                                                                 (gen r q ) 
                                                                                                                                                 (sym (gen s q)) 
                                                                                                                                                 (fourGenCommutativityConnector r p s q proof-rp proof-ps proof-sq) 
                                                                                                                                                 (gen p q )

  fourGenCommutativity : (r p s q : Fin n) → (proof-rp : toℕ r < toℕ p) → (proof-ps : toℕ p < toℕ s) → (proof-sq : toℕ s < toℕ q) → Square 
                                                                                                                                      (gen r s)
                                                                                                                                      (gen r s) 
                                                                                                                                      (fourGenCommutativityConnector r p s q proof-rp proof-ps proof-sq) 
                                                                                                                                      (fourGenCommutativityConnector r p s q proof-rp proof-ps proof-sq)


addStrand : {n : ℕ} (b : BPureBraid n) → BPureBraid (suc n)

addStrand base = base
addStrand (gen p q i) = gen (fsuc p) (fsuc q) i
addStrand (identity p i j) = identity (fsuc p) i j
addStrand (genEquality p q i j) = genEquality (fsuc p) (fsuc q) i j
addStrand (twoGenCommutativity1 p q r s proof-rs proof-sp proof-pq i j) = twoGenCommutativity1 (fsuc p) (fsuc q) (fsuc r) (fsuc s) (suc-≤-suc proof-rs) (suc-≤-suc proof-sp) (suc-≤-suc proof-pq) i j
addStrand (twoGenCommutativity2 p q r s proof-pr proof-rs proof-sq i j) = twoGenCommutativity2 (fsuc p) (fsuc q) (fsuc r) (fsuc s) (suc-≤-suc proof-pr) (suc-≤-suc proof-rs) (suc-≤-suc proof-sq) i j
addStrand (threeGenCommutativityConnector r p q proof-rp proof-pq i) = threeGenCommutativityConnector (fsuc r) (fsuc p) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-pq) i
addStrand (threeGenCommutativityLeft r p q proof-rp proof-pq i j) = threeGenCommutativityLeft (fsuc r) (fsuc p) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-pq) i j
addStrand (threeGenCommutativityMiddle r p q proof-rp proof-pq i j) = threeGenCommutativityMiddle (fsuc r) (fsuc p) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-pq) i j
addStrand (threeGenCommutativityRight r p q proof-rp proof-pq i j) = threeGenCommutativityRight (fsuc r) (fsuc p) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-pq) i j
addStrand (fourGenCommutativityConnector r p s q proof-rp proof-ps proof-sq i) = fourGenCommutativityConnector (fsuc r ) (fsuc p) (fsuc s) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-ps) (suc-≤-suc proof-sq) i
addStrand (fourGenCommutativityComposition r p s q proof-rp proof-ps proof-sq i j) = fourGenCommutativityComposition (fsuc r ) (fsuc p) (fsuc s) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-ps) (suc-≤-suc proof-sq) i j
addStrand (fourGenCommutativity r p s q proof-rp proof-ps proof-sq i j) = fourGenCommutativity (fsuc r ) (fsuc p) (fsuc s) (fsuc q) (suc-≤-suc proof-rp) (suc-≤-suc proof-ps) (suc-≤-suc proof-sq) i j


delStrand : {n : ℕ} (b : BPureBraid (suc n)) → BPureBraid n

--base always goes to base
delStrand base = base


-- zeroth strand gets deleted, so generators on that strand cease to exist
delStrand (gen (zero , proof-p) q i ) = base
delStrand (gen (suc p , proof-p) (zero , proof-q) i) = base
delStrand (gen (suc p , proof-p) (suc q , proof-q) i) = gen (p , pred proof-p) (q , pred proof-q) i


-- identity element for zeroth strand is removed
delStrand (identity (zero , proof-p) i j) = base
delStrand (identity (suc p , proof-p) i j) = identity (p , pred proof-p) i j


-- any cases with a zero strand reduce to refl
delStrand (genEquality (zero , proof-p) (zero , proof-q) i j) = base
delStrand (genEquality (zero , proof-p) (suc q , proof-q) i j) = base
delStrand (genEquality (suc p , proof-p) (zero , proof-q) i j) = base
delStrand (genEquality (suc p , proof-p) (suc q , proof-q) i j) = genEquality (p , pred proof-p) (q , pred proof-q) i j


-- if r is zero, gen r s cannot exist so not splitting case on s
delStrand (twoGenCommutativity1 (zero , proof-p) (zero , proof-q) (zero , proof-r) (s , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (zero , proof-p) (suc q , proof-q) (zero , proof-r) (s , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (suc p , proof-p) (zero , proof-q) (zero , proof-r) (s , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (suc p , proof-p) (suc q , proof-q) (zero , proof-r) (s , proof-s) proof-rs proof-sp proof-pq i j) = gen (p , pred proof-p) (q , pred proof-q) j

-- if s is zero, gen r s cannot exist so these will reduce to base or gen p q
delStrand (twoGenCommutativity1 (zero , proof-p) (zero , proof-q) (suc r , proof-r) (zero , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (zero , proof-p) (suc q , proof-q) (suc r , proof-r) (zero , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (suc p , proof-p) (zero , proof-q) (suc r , proof-r) (zero , proof-s) proof-rs proof-sp proof-pq i j) = base
delStrand (twoGenCommutativity1 (suc p , proof-p) (suc q , proof-q) (suc r , proof-r) (zero , proof-s) proof-rs proof-sp proof-pq i j) = gen (p , pred proof-p) (q , pred proof-q) j

-- if gen r s exists :
-- if p or q are zero only gen r s remains
delStrand (twoGenCommutativity1 (zero , proof-p) (zero , proof-q) (suc r , proof-r) (suc s , proof-s) proof-rs proof-sp proof-pq i j) = gen (r , pred proof-r) (s , pred proof-s) i
delStrand (twoGenCommutativity1 (zero , proof-p) (suc q , proof-q) (suc r , proof-r) (suc s , proof-s) proof-rs proof-sp proof-pq i j) = gen (r , pred proof-r) (s , pred proof-s) i
delStrand (twoGenCommutativity1 (suc p , proof-p) (zero , proof-q) (suc r , proof-r) (suc s , proof-s) proof-rs proof-sp proof-pq i j) = gen (r , pred proof-r) (s , pred proof-s) i

-- if all strands exist after deletion, map commutativity rule
delStrand (twoGenCommutativity1 (suc p , proof-p) (suc q , proof-q) (suc r , proof-r) (suc s , proof-s) proof-rs proof-sp proof-pq i j) = 
    twoGenCommutativity1 (p , pred proof-p) (q , pred proof-q) (r , pred proof-r) (s , pred proof-s) (pred proof-rs) (pred proof-sp) (pred proof-pq) i j



-- if p is removed, gen p q cannot exist. no need to case split on q
delStrand (twoGenCommutativity2 (zero , proof-p) q (zero , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (zero , proof-p) q (zero , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (zero , proof-p) q (suc r , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (zero , proof-p) q (suc r , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = gen (r , pred proof-r) (s , pred proof-s) i



--if q is zero, either gen r s exists or it does not
delStrand (twoGenCommutativity2 (suc p , proof-p) (zero , proof-q) (zero , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (suc p , proof-p) (zero , proof-q) (zero , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (suc p , proof-p) (zero , proof-q) (suc r , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = base
delStrand (twoGenCommutativity2 (suc p , proof-p) (zero , proof-q) (suc r , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = gen (r , pred proof-r) (s , pred proof-s) i

-- gen p q exist, if gen r s also exists then we map the rule
delStrand (twoGenCommutativity2 (suc p , proof-p) (suc q , proof-q) (zero , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = gen (p , pred proof-p) (q , pred proof-q) j
delStrand (twoGenCommutativity2 (suc p , proof-p) (suc q , proof-q) (zero , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = gen (p , pred proof-p) (q , pred proof-q) j
delStrand (twoGenCommutativity2 (suc p , proof-p) (suc q , proof-q) (suc r , proof-r) (zero , proof-s) proof-pr proof-rs proof-sq i j) = gen (p , pred proof-p) (q , pred proof-q) j
delStrand (twoGenCommutativity2 (suc p , proof-p) (suc q , proof-q) (suc r , proof-r) (suc s , proof-s) proof-pr proof-rs proof-sq i j) = 
    twoGenCommutativity2 (p , pred proof-p) (q , pred proof-q) (r , pred proof-r) (s , pred proof-s)  (pred proof-pr) (pred proof-rs) (pred proof-sq) i j




delStrand (threeGenCommutativityConnector (zero , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i) = base
delStrand (threeGenCommutativityConnector (zero , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i) = base
delStrand (threeGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i) = base
delStrand (threeGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i) = gen (p , pred proof-p) (q , pred proof-q) i
delStrand (threeGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i) = base
delStrand (threeGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i) = gen (r , pred proof-r) (q , pred proof-q) i
delStrand (threeGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i) = gen (p , pred proof-p) (r , pred proof-r) i
delStrand (threeGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i) = threeGenCommutativityConnector (r , pred proof-r) (p , pred proof-p) (q , pred proof-q) (pred proof-rp) (pred proof-pq) i

delStrand (threeGenCommutativityLeft (zero , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityLeft (zero , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityLeft (zero , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityLeft (zero , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = gen (p , pred proof-p) (q , pred proof-q) (i ∨ j)
delStrand (threeGenCommutativityLeft (suc r , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityLeft (suc r , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = gen (r , pred proof-r) (q , pred proof-q) (i ∧ ~ j)
delStrand (threeGenCommutativityLeft (suc r , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = gen  (p , pred proof-p) (r , pred proof-r) i
delStrand (threeGenCommutativityLeft (suc r , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = threeGenCommutativityLeft (r , pred proof-r) (p , pred proof-p) (q , pred proof-q) (pred proof-rp) (pred proof-pq) i j

delStrand (threeGenCommutativityMiddle (zero , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityMiddle (zero , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityMiddle (zero , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityMiddle (zero , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = gen (p , pred proof-p) (q , pred proof-q) (i ∧ ~ j)
delStrand (threeGenCommutativityMiddle (suc r , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityMiddle (suc r , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = gen (r , pred proof-r) (q , pred proof-q) i
delStrand (threeGenCommutativityMiddle (suc r , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = gen  (p , pred proof-p) (r , pred proof-r) (i ∨ j)
delStrand (threeGenCommutativityMiddle (suc r , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = threeGenCommutativityMiddle (r , pred proof-r) (p , pred proof-p) (q , pred proof-q) (pred proof-rp) (pred proof-pq) i j

delStrand (threeGenCommutativityRight (zero , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityRight (zero , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityRight (zero , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityRight (zero , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) =   gen (p , pred proof-p) (q , pred proof-q) i
delStrand (threeGenCommutativityRight (suc r , proof-r) (zero , proof-p) (zero , proof-q) proof-rp proof-pq i j) = base
delStrand (threeGenCommutativityRight (suc r , proof-r) (zero , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = gen (r , pred proof-r) (q , pred proof-q) (i ∨ j)
delStrand (threeGenCommutativityRight (suc r , proof-r) (suc p , proof-p) (zero , proof-q) proof-rp proof-pq i j) = gen  (p , pred proof-p) (r , pred proof-r) (i ∧ ~ j)
delStrand (threeGenCommutativityRight (suc r , proof-r) (suc p , proof-p) (suc q , proof-q) proof-rp proof-pq i j) = threeGenCommutativityRight (r , pred proof-r) (p , pred proof-p) (q , pred proof-q) (pred proof-rp) (pred proof-pq) i j


delStrand (fourGenCommutativityConnector (zero , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = base
delStrand (fourGenCommutativityConnector (zero , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (zero , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (zero , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}

delStrand (fourGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = {!   !}
delStrand (fourGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i) = {!   !}


--valid cases
delStrand (fourGenCommutativityConnector (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = ((gen (p , pred proof-p) (q , pred proof-q)) ∙ (gen (s , pred proof-s) (q , pred proof-q))) i


delStrand (fourGenCommutativityConnector (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i) = fourGenCommutativityConnector  
                                                                                                                                                     (r , pred proof-r) (p , pred proof-p)
                                                                                                                                                     (s , pred proof-s) (q , pred proof-q)
                                                                                                                                                     (pred proof-rp) (pred proof-ps) (pred proof-sq) i


delStrand (fourGenCommutativityComposition (zero , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}

delStrand (fourGenCommutativityComposition (suc r , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativityComposition (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}

--valid cases
delStrand (fourGenCommutativityComposition (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = compPath-filler (gen (p , pred proof-p) ( q , pred proof-q  ) ) ( gen (s , pred proof-s) (q , pred proof-q) ) (~ j) i

delStrand (fourGenCommutativityComposition (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = fourGenCommutativityComposition  
                                                                                                                                                     (r , pred proof-r) (p , pred proof-p)
                                                                                                                                                     (s , pred proof-s) (q , pred proof-q)
                                                                                                                                                     (pred proof-rp) (pred proof-ps) (pred proof-sq) i j


delStrand (fourGenCommutativity (zero , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}

delStrand (fourGenCommutativity (suc r , proof-r) (zero , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (zero , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (zero , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (suc p , proof-p) (zero , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}
delStrand (fourGenCommutativity (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (zero , proof-q) proof-rp proof-ps proof-sq i j) = {!   !}


--valid cases
delStrand (fourGenCommutativity (zero , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = ((gen (p , pred proof-p) (q , pred proof-q)) ∙ (gen (s , pred proof-s) (q , pred proof-q))) i 
delStrand (fourGenCommutativity (suc r , proof-r) (suc p , proof-p) (suc s , proof-s) (suc q , proof-q) proof-rp proof-ps proof-sq i j) = fourGenCommutativity  
                                                                                                                                                     (r , pred proof-r) (p , pred proof-p)
                                                                                                                                                     (s , pred proof-s) (q , pred proof-q)
                                                                                                                                                     (pred proof-rp) (pred proof-ps) (pred proof-sq) i j
  
                                                                                                    



  