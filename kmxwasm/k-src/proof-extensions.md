```k
require "elrond-wasm-configuration.md"

module PROOF-EXTENSIONS
  imports ELROND-WASM-CONFIGURATION

  syntax Instr ::= "infiniteLoop"  [symbol, klabel(infiniteLoop)]
  rule <instrs> (infiniteLoop ~> _:KItem => infiniteLoop) ... </instrs>

endmodule
```
