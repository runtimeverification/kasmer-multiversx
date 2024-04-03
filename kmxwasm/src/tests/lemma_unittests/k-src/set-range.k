module SET-RANGE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            #setRange
            ( SBChunk
              ( #empty ( (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) ) )
              SBChunk ( #bytes ( b"\x1a\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x01" ) )
            , (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))
            , (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) +Int (26)
            , 4
            )
        ) => doneSimplification(
            (
            SBChunk ( #empty ( 9974 -Int ( ( log2IntTotal ( ARG_0 +Int -1000 ) +Int 8 ) divIntTotal 8 ) ) )
            SBChunk ( #bytes ( Int2Bytes ( 4 , ( ( log2IntTotal ( ARG_0 +Int -1000 ) +Int 8 ) divIntTotal 8 ) +Int 26 , LE ) ) )
            SBChunk ( #bytes ( b"\x01" ) )
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

    claim
      <k>
        runSimplification(
          #setRange
            ( #setRange
              ( #setRange
                ( #setRange
                  ( #setRange
                    (
                      SBChunk ( #bytes ( Int2Bytes ( ((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8) , A:Int , BE ) +Bytes b"\x00\x00\x00\x00\x01" +Bytes Int2Bytes ( 8 , int64encoding ( (B:Int) +Int (C:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE ) +Bytes Int2Bytes ( 8 , int64encoding ( (((B:Int) +Int (C:Int)) +Int (D:Int)) +Int (E:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE ) +Bytes b"\x00" ) )
                      SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
                      SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)) +Int (92) , LE ) ) )
                      SBChunk ( #bytes ( b"\x01" ) )
                    , ((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)
                    , 0
                    , 1
                    )
                  , (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)) +Int (1)
                  , 0
                  , 1
                  )
                , (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)) +Int (2)
                , 0
                , 1
                )
              , 9908
              , (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)) +Int (96)
              , 4
              )
            , (((log2IntTotal ( A:Int )) +Int (8)) divIntTotal (8)) +Int (3)
            , ((log2IntTotal ( ((A:Int) *Int (D:Int)) divIntTotal ((D:Int) +Int (E:Int)) )) +Int (8)) divIntTotal (8)
            , 1
            )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( Int2Bytes ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 , A , BE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , ( log2IntTotal ( ( A *Int D ) divIntTotal ( D +Int E ) ) +Int 8 ) divIntTotal 8 , LE ) ) )
              SBChunk ( #bytes ( ( ( b"\x01" +Bytes Int2Bytes ( 8 , int64encoding ( B +Int C , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE ) ) +Bytes Int2Bytes ( 8 , int64encoding ( B +Int C +Int D +Int E , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE ) ) +Bytes b"\x00" ) )
              SBChunk ( #empty ( -1 *Int ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 ) +Int 9886 ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 ) +Int 96 , LE ) ) )
              SBChunk ( #bytes ( b"\x01" ) )
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool 0 <Int B andBool 0 <=Int C andBool 0 <=Int D andBool 0 <=Int E
        andBool B +Int C <Int A *Int B
        andBool A <=Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool B <=Int 4294967295 andBool C <=Int 4294967295 andBool D <=Int 4294967295 andBool E <=Int 4294967295

    claim
      <k>
        runSimplification(
          #setRange
          ( replaceAtB
            ( b"\x01"
              +Bytes Int2Bytes ( 8 , int64encoding ( (ARG_1:Int) +Int (ARG_2:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
              +Bytes Int2Bytes ( 8 , int64encoding ( (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
              +Bytes b"\x00"
            , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (96) , LE ) ) )
              SBChunk ( #bytes ( b"\x01" ) )
            , 0
            , Int2Bytes ( ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8) , ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) , BE )
            )
          , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
          , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8))) +Int (96)
          , 4
          )
      ) => doneSimplification(
          ( replaceAtB
              ( b"\x01"
                +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 +Int ARG_3 +Int ARG_4 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                +Bytes b"\x00"
              , SBChunk ( #empty ( -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int 9886 ) )
              , 0
              , Int2Bytes ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 , ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) , BE )
              )
            SBChunk ( #bytes ( Int2Bytes ( 4 , ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 ) +Int 96 , LE ) ) )
            SBChunk ( #bytes ( b"\x01" ) )
          ):SparseBytes:KItem
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
        andBool 0 <Int ARG_5
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
        andBool ARG_1 <Int 18446744056529682435
        andBool ARG_2 <=Int 4294967295
        andBool ARG_3 <=Int 4294967295
        andBool ARG_4 <=Int 4294967295
        andBool ARG_5 <=Int 4294967295
        andBool 0 =/=Int ARG_3 +Int ARG_4
        andBool 0 =/=Int (ARG_0 *Int ARG_3) divIntTotal (ARG_3 +Int ARG_4)
endmodule
