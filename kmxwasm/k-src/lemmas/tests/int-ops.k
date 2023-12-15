module INT-OPS
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            ( ( ( ( ( ( ((((ARG_0:Int) >>IntTotal (24)) <<IntTotal (8)) &Int (72057594037927935))
                      |Int (((ARG_0:Int) >>IntTotal (16)) &Int (255))
                      )
                    <<IntTotal (8)
                    ) &Int (72057594037927935)
                  )
                |Int (((ARG_0:Int) >>IntTotal (8)) &Int (255))
                )
              <<IntTotal (8)
              )
            |Int 
              ((ARG_0:Int) &Int (255))
            )
        ) => doneSimplification( ARG_0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0 andBool ARG_0 <=Int (1 <<Int 32)

    claim
      <k>
        runSimplification(
            ((ARG_0:Int) &Int (16711680)) >>IntTotal (32)
        ) => doneSimplification( 0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0

    claim
      <k>
        runSimplification(
            4294967296 <=Int _ARG_0:Int &Int 255
        ) => doneSimplification( false )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
