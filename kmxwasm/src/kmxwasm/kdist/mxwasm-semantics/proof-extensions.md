```k
requires "mx-semantics/elrond.md"

module PROOF-EXTENSIONS
  imports ELROND
  imports WASM

  syntax Instr ::= "infiniteLoop"  [symbol(infiniteLoop)]
  rule <instrs> (infiniteLoop ~> _:KItem => infiniteLoop) ... </instrs>

  syntax Bool ::= firstCommandIsNotException(K)  [function, total]
  rule firstCommandIsNotException(#exception(_, _) ~> _:K) => false
  rule firstCommandIsNotException(_:K) => true  [owise]

endmodule
```
