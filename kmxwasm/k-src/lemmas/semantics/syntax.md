```k
module PROOF-SYNTAX
  imports BOOL
  imports LIST

  syntax ProofOperation ::= "nop"  [klabel(proofNop), symbol]
                          | var(KItem)  [klabel(proofVar), symbol]
                          | split(Bool, ProofOperationList, ProofOperationList)  [klabel(proofSplit), symbol]
                          | DestructOperation
                          | ProofUserOperation
  syntax ProofOperationList ::= List{ProofOperation, ";"}  [klabel(proofOperationList)]

  syntax ProofUserOperation
  syntax DestructOperation

  syntax KItem  ::= runProof(ProofOperationList)  [klabel(runProof), symbol]
                  | runProofStep(ProofOperation)  [klabel(runProofStep), symbol]
                  | "end"  [klabel(proofEnd), symbol]
endmodule
```