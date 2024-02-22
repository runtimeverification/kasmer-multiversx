```k
requires "mx-lemmas.md"
requires "mx-semantics/kasmer.md"
requires "lemmas/proven-mx-lemmas.md"
requires "proof-extensions.md"
requires "specification-lemmas.md"
requires "wasm-semantics/kwasm-lemmas.md"

module MX-WASM-SYNTAX
  imports WASM-TEXT-SYNTAX
  imports KASMER-SYNTAX
endmodule

module MX-WASM
  imports MX-LEMMAS
  imports MX-LEMMAS-BASIC
  imports MX-WASM-NO-LOCAL-LEMMAS
  imports PROVEN-MX-LEMMAS
endmodule

module MX-WASM-NO-LOCAL-LEMMAS
  imports CEILS
  imports KASMER
  imports INT-KORE
  imports KWASM-LEMMAS
  imports MAP-KORE-SYMBOLIC
  imports PROOF-EXTENSIONS
  imports SPECIFICATION-LEMMAS

  rule <k> PGM => .K </k>
        <instrs> .K => sequenceStmts(text2abstract(PGM)) </instrs>

endmodule
```
