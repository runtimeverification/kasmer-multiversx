module SIZE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #empty ( 808 ) )
                SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
            )
        ) => doneSimplification(813)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #empty ( (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) ) )
            )
        ) => doneSimplification( (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
            )
        ) => doneSimplification(5)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            size (
                SBChunk ( #bytes ( Int2Bytes ( 4 , _ARG_0:Int , LE ) ) )
            )
        ) => doneSimplification(4)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            size (
              SBChunk
              ( #bytes
                ( replaceAtBytesTotal
                  ( ... dest: b"\x00\x00\x00\x00\x00\x00\x00\x00"
                  , index: 0
                  , src: Int2Bytes
                    ( 4
                    , ( (((ARG_0:Int) &Int (255)) <<IntTotal (24))
                      |Int (((ARG_0:Int) &Int (65280)) <<IntTotal (8))
                      )
                      |Int
                      ( (((ARG_0:Int) >>IntTotal (8)) &Int (65280))
                      |Int ((ARG_0:Int) >>IntTotal (24))
                      )
                    , LE
                    )
                  )
                )
              )
            )
        ) => doneSimplification(8)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            size(
              replaceAtB
                ( b"\x01"
                  +Bytes Int2Bytes ( 8 , int64encoding ( (ARG_1:Int) +Int (ARG_2:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes Int2Bytes ( 8 , int64encoding ( (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes b"\x00"
                , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
                , 0
                , Int2Bytes ( ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8) , ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) , BE )
                )
            )
        ) => doneSimplification(-1 *Int ((log2IntTotal ( ARG_0:Int ) +Int 8) divIntTotal 8) +Int 9904)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires true
          andBool 0 <Int ARG_0
          andBool 0 <Int ARG_1
          andBool 0 <Int ARG_2
          andBool 0 <Int ARG_3
          andBool 0 <Int ARG_4
          andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
          andBool ARG_1 <Int 18446744056529682435
          andBool ARG_2 <=Int 4294967295
          andBool ARG_3 <=Int 4294967295
          andBool ARG_4 <=Int 4294967295
          andBool 0 =/=Int ARG_3 +Int ARG_4
          andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)


    claim
      <k>
        runSimplification(
            size (
              concat
                ( replaceAtB
                  ( b"\x01"
                    +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                    +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 +Int ARG_3 +Int ARG_4 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                    +Bytes b"\x00"
                  , SBChunk ( #empty ( -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int 9886 ) )
                  , 0
                  , Int2Bytes
                    ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8
                    , ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 )
                    , BE
                    )
                  )
                , SBChunk
                    ( #bytes
                      ( Int2Bytes
                        ( 4
                        , ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
                          +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
                          +Int 96
                        , LE
                        )
                      )
                    )
                )
            )
        ) => doneSimplification(
          -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int 9908
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 0 <Int ARG_0
        andBool 0 <Int ARG_1
        andBool 0 <Int ARG_2
        andBool 0 <Int ARG_3
        andBool 0 <Int ARG_4
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)

endmodule
