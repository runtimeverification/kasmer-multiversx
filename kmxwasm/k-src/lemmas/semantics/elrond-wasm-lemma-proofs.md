```k

requires "../../elrond-wasm.md"
requires "destructors.md"
requires "private-specification-lemmas.md"
requires "user-operations.md"

module ELROND-WASM-LEMMA-PROOFS-SYNTAX
  imports ELROND-WASM-SYNTAX
endmodule

module ELROND-WASM-LEMMA-PROOFS
  imports BOOL
  imports DESTRUCTORS
  imports ELROND-WASM-NO-LOCAL-LEMMAS
  imports INT
  imports LIST
  imports PRIVATE-SPECIFICATION-LEMMAS
  imports PROOF-SYNTAX
  imports USER-OPERATIONS

  rule  runProof(Op:ProofOperation ; Ops:ProofOperationList)
        => runProofStep(Op) ~> runProof(Ops)
  rule  runProof(.ProofOperationList)
        => end
  rule  (end => .K) ~> runProof(_)

  rule  runProofStep(nop) => .K
  rule  runProofStep(var(_)) => .K
  rule  runProofStep(split(true, TrueBranch, _FalseBranch))
        => runProof(TrueBranch)
  rule  runProofStep(split(_, _TrueBranch, FalseBranch))
        => runProof(FalseBranch)
      [owise]  // This is an owise branch to avoid https://github.com/runtimeverification/haskell-backend/issues/3649
endmodule


```