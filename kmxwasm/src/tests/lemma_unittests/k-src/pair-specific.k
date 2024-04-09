module PAIR-SPECIFIC
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
          ( ( (ARG_0 +Int ARG_2)
            *Int
              ( ARG_1
              +Int
                ( -1
                *Int
                  ( ( 99000 *Int (ARG_2 *Int ARG_1) )
                  divIntTotal
                    ( (100000 *Int ARG_0) +Int (99000 *Int ARG_2) )
                  )
                )
              )
            )
          <Int
            ( ( ( (ARG_0 *Int ARG_1) +Int ARG_0 )
              +Int
                ARG_2
              )
            +Int
              ( ( ( (1000 *Int ARG_2) divIntTotal 100000 )
                +Int
                  1
                )
              *Int
                ( ARG_1
                +Int
                  ( -1
                  *Int
                    (
                      ( 99000 *Int (ARG_2 *Int ARG_1) )
                    divIntTotal
                      ( (100000 *Int ARG_0) +Int (99000 *Int ARG_2) )
                    )
                  )
                )
              )
            )
          )
        ) => doneSimplification(
          true
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int ARG_0 andBool 0 <Int ARG_1 andBool 0 <Int ARG_2

    claim
      <k>
        runSimplification(
          (
            ( ( ( (ARG_0 *Int ARG_1) +Int ARG_0 )
              +Int
                ARG_2
              )
            +Int
              ( ( ( (1000 *Int ARG_2) divIntTotal 100000 )
                +Int
                  1
                )
              *Int
                ( ARG_1
                +Int
                  ( -1
                  *Int
                    (
                      ( 99000 *Int (ARG_2 *Int ARG_1) )
                    divIntTotal
                      ( (100000 *Int ARG_0) +Int (99000 *Int ARG_2) )
                    )
                  )
                )
              )
            )
          <=Int
            ( (ARG_0 +Int ARG_2)
            *Int
              ( ARG_1
              +Int
                ( -1
                *Int
                  ( ( 99000 *Int (ARG_2 *Int ARG_1) )
                  divIntTotal
                    ( (100000 *Int ARG_0) +Int (99000 *Int ARG_2) )
                  )
                )
              )
            )
          )
        ) => doneSimplification(
          false
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int ARG_0 andBool 0 <Int ARG_1 andBool 0 <Int ARG_2

endmodule
