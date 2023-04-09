```k
require "summaries.k"
require "ceils.k"
require "elrond-impl.md"
require "elrond-lemmas.md"
require "elrond-configuration.md"
require "elrond-wasm-configuration.md"
require "proof-extensions.md"

module ELROND-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
endmodule

module ELROND-WASM
  imports CEILS
  imports ELROND-IMPL
  imports ELROND-LEMMAS
  imports ELROND-WASM-CONFIGURATION
  imports INT-SYMBOLIC-KORE
  imports SUMMARIES
  imports PROOF-EXTENSIONS

  rule <k> PGM => . </k>
        <instrs> .K => sequenceStmts(text2abstract(PGM)) </instrs>

endmodule
```
