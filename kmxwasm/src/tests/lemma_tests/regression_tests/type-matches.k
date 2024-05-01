module TYPE-MATCHES
    imports MX-WASM-LEMMA-TESTS

    // claim
    //   <k>
    //     runSimplification(
    //       #typeMatches( i32, < i32 > 2 )
    //     ) => doneSimplification(
    //       true
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>

    // claim
    //   <k>
    //     runSimplification(
    //       #typeMatches( i32, < i32 > 1 )
    //     ) => doneSimplification(
    //       true
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>

    // claim
    //   <k>
    //     runSimplification(
    //       #typeMatches
    //         ( i32
    //         , #if _ #then < i32 > 2 #else < i32 > 1 #fi
    //         )
    //     ) => doneSimplification(
    //       true
    //     )
    //   </k>
    //   <commands> .K </commands>
    //   <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          #typeMatches
            ( i32
            , #if _
              #then (< i32 > 2):Val
              #else (< i32 > 1):Val
              #fi:Val
            )
          ) => doneSimplification(
          true
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
