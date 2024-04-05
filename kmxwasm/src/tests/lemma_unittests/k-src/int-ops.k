module INT-OPS
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            ( ( ( ( ( ( ((((ARG_0:Int) >>IntTotal (24)) <<IntTotal 8) &Int (72057594037927935))
                      |Int (((ARG_0:Int) >>IntTotal (16)) &Int (255))
                      )
                    <<IntTotal 8
                    ) &Int (72057594037927935)
                  )
                |Int (((ARG_0:Int) >>IntTotal 8) &Int (255))
                )
              <<IntTotal 8
              )
            |Int 
              ((ARG_0:Int) &Int (255))
            )
        ) => doneSimplification( ARG_0 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int ARG_0 andBool ARG_0 <Int (1 <<Int 32)

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

    claim
      <k>
        runSimplification(
            0 <=Int 9974 -Int ( ( log2IntTotal ( ARG_0 +Int -1000 ) +Int 8 ) divIntTotal 8 )
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

    claim
      <k>
        runSimplification(
            ((ARG_2 *Int 99000) *Int ARG_1)
            divIntTotal
            (ARG_0 *Int 100000 +Int ARG_2 *Int 99000)
            >Int 1
        ) => doneSimplification( true )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int ARG_2
          andBool 2 <Int ARG_2
          andBool 0 <=Int ARG_0
          andBool 0 <=Int ARG_1
          andBool 0 <=Int ARG_2
          andBool 1000 <Int ARG_0
          andBool 1000 <Int ARG_1
          andBool ARG_0 <Int ARG_1
          andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376
          andBool ARG_1 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376
          andBool 0 =/=Int (log2IntTotal( ARG_0 ) +Int 8) divIntTotal 8
          andBool 0 =/=Int (log2IntTotal ( ARG_1 ) +Int 8) divIntTotal 8
          andBool 0 =/=Int ARG_0 *Int 100000 +Int ARG_2 *Int 99000

    claim
      <k>
        runSimplification( log2Int(3) ) => doneSimplification( 1 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification( log2Int(4) ) => doneSimplification( 2 )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification( #bool( notBool (ARG_0:Int ==Int 100) ) &Int 255 )
        => doneSimplification( #bool( notBool (ARG_0:Int ==Int 100) ) )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 100 <=Int ARG_0

    claim
      <k>
        runSimplification(A &Int 4294967295)
        => doneSimplification(A)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <=Int A andBool A <=Int 4294967295

endmodule
