```k
require "elrond-lemmas.md"
require "elrond-semantics/foundry.md"
require "lemmas/proven-elrond-lemmas.md"
require "proof-extensions.md"
require "specification-lemmas.md"
require "wasm-semantics/kwasm-lemmas.md"

module ELROND-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
  imports FOUNDRY-SYNTAX
endmodule

module ELROND-WASM
  imports ELROND-LEMMAS
  imports ELROND-WASM-NO-LOCAL-LEMMAS
  imports PROVEN-ELROND-LEMMAS
endmodule

module ELROND-WASM-NO-LOCAL-LEMMAS
  imports CEILS
  imports FOUNDRY
  imports INT-KORE
  imports KWASM-LEMMAS
  imports MAP-KORE-SYMBOLIC
  imports PROOF-EXTENSIONS
  imports SPECIFICATION-LEMMAS

  rule <k> PGM => .K </k>
        <instrs> .K => sequenceStmts(text2abstract(PGM)) </instrs>

endmodule
```
