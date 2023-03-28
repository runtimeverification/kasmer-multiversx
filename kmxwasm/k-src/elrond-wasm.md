```k
require "elrond-lemmas.md"
require "elrond-wasm-configuration.md"
require "kwasm-lemmas.md"
require "proof-extensions.md"

module ELROND-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
endmodule

module ELROND-WASM
  imports ELROND-LEMMAS
  imports ELROND-WASM-CONFIGURATION
  imports KWASM-LEMMAS
  imports MAP-KORE-SYMBOLIC
  imports PROOF-EXTENSIONS

  rule <k> PGM => .K </k>
        <instrs> .K => sequenceStmts(text2abstract(PGM)) </instrs>

endmodule
```
