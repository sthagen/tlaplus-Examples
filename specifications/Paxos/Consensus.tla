----------------------------- MODULE Consensus ------------------------------ 
EXTENDS Naturals, FiniteSets, TLAPS, FiniteSetTheorems

CONSTANT Value 
  (*************************************************************************)
  (* The set of all values that can be chosen.                             *)
  (*************************************************************************)
  
VARIABLE chosen
  (*************************************************************************)
  (* The set of all values that have been chosen.                          *)
  (*************************************************************************)
  
(***************************************************************************)
(* The type-correctness invariant.                                         *)
(***************************************************************************)
TypeOK == /\ chosen \subseteq Value
          /\ IsFiniteSet(chosen) 

(***************************************************************************)
(* The initial predicate and next-state relation.                          *)
(***************************************************************************)
Init == chosen = {}

Next == /\ chosen = {}
        /\ \E v \in Value : chosen' = {v}

(***************************************************************************)
(* The complete spec.                                                      *)
(***************************************************************************)
Spec == Init /\ [][Next]_chosen 
-----------------------------------------------------------------------------
(***************************************************************************)
(* Safety: At most one value is chosen.                                    *)
(***************************************************************************)
Inv == /\ TypeOK
       /\ Cardinality(chosen) \leq 1

THEOREM Invariance == Spec => []Inv
<1>1. Init => Inv
  BY FS_EmptySet DEF Init, Inv, TypeOK
<1>2. Inv /\ [Next]_chosen => Inv'
  <2>1. Inv /\ Next => Inv'
    BY FS_Singleton DEF Inv, TypeOK, Next
  <2>2. Inv /\ UNCHANGED chosen => Inv'
    BY DEF Inv, TypeOK
  <2>. QED  BY <2>1, <2>2
<1>3. QED   BY <1>1, <1>2, PTL DEF Spec

-----------------------------------------------------------------------------
(***************************************************************************)
(* Liveness: A value is eventually chosen.                                 *)
(***************************************************************************)
Success == <>(chosen # {})
LiveSpec == Spec /\ WF_chosen(Next)  

ASSUME ValuesNonempty == Value # {}

THEOREM LivenessTheorem == LiveSpec =>  Success
<1>1. [][Next]_chosen /\ WF_chosen(Next) => [](Init => Success)
  <2>1. Init' \/ (chosen # {})'
    BY DEF Init
  <2>2. Init /\ <<Next>>_chosen => (chosen # {})'
    BY DEF Init, Next
  <2>3. Init => ENABLED <<Next>>_chosen
    BY ValuesNonempty, ExpandENABLED DEF Init, Next
  <2>. QED  BY <2>1, <2>2, <2>3, PTL DEF Success
<1>. QED  BY <1>1, PTL DEF LiveSpec, Spec
=============================================================================
