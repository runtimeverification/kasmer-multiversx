```k
require "mx-lemmas.md"
require "mx-semantics/foundry.md"
require "lemmas/proven-mx-lemmas.md"
require "proof-extensions.md"
require "specification-lemmas.md"
require "wasm-semantics/kwasm-lemmas.md"

module MX-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
  imports FOUNDRY-SYNTAX
endmodule

module MX-WASM
  imports MX-LEMMAS
  imports MX-WASM-NO-LOCAL-LEMMAS
  imports PROVEN-MX-LEMMAS
endmodule

module MX-WASM-NO-LOCAL-LEMMAS
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