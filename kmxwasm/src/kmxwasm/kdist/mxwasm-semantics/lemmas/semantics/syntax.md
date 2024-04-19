```k
module PROOF-SYNTAX
  imports BOOL
  imports LIST

  syntax ProofOperation ::= "nop"  [symbol(proofNop)]
                          | var(KItem)  [symbol(proofVar)]
                          | split(Bool, ProofOperationList, ProofOperationList)  [symbol(proofSplit)]
                          | DestructOperation
                          | ProofUserOperation
  syntax ProofOperationList ::= List{ProofOperation, ";"}  [symbol(proofOperationList)]

  syntax ProofUserOperation
  syntax DestructOperation

  syntax KItem  ::= runProof(ProofOperationList)  [symbol(runProof)]
                  | runProofStep(ProofOperation)  [symbol(runProofStep)]
                  | "end"  [symbol(proofEnd)]
endmodule
```
