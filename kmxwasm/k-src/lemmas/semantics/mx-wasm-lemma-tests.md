```k

requires "../../mx-wasm.md"

module MX-WASM-LEMMA-TESTS-SYNTAX
  syntax KItem  ::= runSimplification(KItem)   [symbol(runSimplification)]
                  | doneSimplification(KItem)  [symbol(doneSimplification)]
endmodule

module MX-WASM-LEMMA-TESTS
  imports MX-WASM
  imports MX-WASM-LEMMA-TESTS-SYNTAX

  rule runSimplification(X:KItem) => doneSimplification(X)
endmodule

```