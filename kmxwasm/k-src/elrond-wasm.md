```k
require "elrond-lemmas.md"
require "wasm-semantics/kwasm-lemmas.md"
require "proof-extensions.md"
require "elrond-semantics/foundry.md"

module ELROND-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
  imports FOUNDRY-SYNTAX
endmodule

module ELROND-WASM
  imports ELROND-LEMMAS
  imports FOUNDRY
  imports KWASM-LEMMAS
  imports MAP-KORE-SYMBOLIC
  imports PROOF-EXTENSIONS

  rule <k> PGM => .K </k>
        <instrs> .K => sequenceStmts(text2abstract(PGM)) </instrs>

endmodule
```
