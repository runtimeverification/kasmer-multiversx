module INT-INEQUALITIES-DIVISION
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
          (log2IntTotal ( X ) +Int 8) divIntTotal 8 <Int 4294967296
        ) => doneSimplification(
          true
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <Int 2 ^Int 800

    claim
      <k>
        runSimplification(
          9908 <Int ((log2IntTotal ( X ) +Int 8) divIntTotal 8) modIntTotal 4294967296
        ) => doneSimplification(
          false
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int X andBool X <Int 2 ^Int 800

endmodule
