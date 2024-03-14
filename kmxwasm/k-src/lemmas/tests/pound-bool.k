module POUND-BOOL
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
          ( ( ( ( ( ( ( ( #bool(B1) &Int #bool(B2) )
                      +Int #bool(B1)
                      )
                    +Int
                      ( ( #bool(B3) &Int #bool(B1) ) &Int #bool(B2) )
                    )
                  +Int
                    ( ( ( #bool(B4) &Int #bool(B3) ) &Int #bool(B1) ) &Int #bool(B2) )
                  )
                +Int
                  ( ( ( ( #bool(B5) &Int #bool(B4) ) &Int #bool(B3) ) &Int #bool(B1) ) &Int #bool(B2) )
                )
              +Int
                ( ( ( ( ( #bool(B6) &Int #bool(B5) ) &Int #bool(B4) ) &Int #bool(B3) ) &Int #bool(B1) ) &Int #bool(B2) )
              )
            +Int
              ( ( ( ( ( ( #bool(_B7) &Int #bool(B6) ) &Int #bool(B5) ) &Int #bool(B4) ) &Int #bool(B3) ) &Int #bool(B1) ) &Int #bool(B2) )
            ) modIntTotal (4294967296) ==Int 0
          )
        ) => doneSimplification(4)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
