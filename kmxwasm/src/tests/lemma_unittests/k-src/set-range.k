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
            updateSparseBytes
            ( setRange (... value: 0 )
            , SBChunk
                ( #bytes
                  ( ( ( ( Int2Bytes ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 , A , BE )
                        +Bytes b"\x00\x00\x00\x00\x01"
                        )
                      +Bytes Int2Bytes ( 8 , int64encoding (... value: B +Int C , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                      )
                    +Bytes Int2Bytes ( 8 , int64encoding (... value: B +Int C +Int D +Int E , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                    )
                  +Bytes b"\x00"
                  )
                )
              .SparseBytes
            , ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8
            , 1
            )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( Int2Bytes ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 , A , BE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C +Int D +Int E , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
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
            updateSparseBytes
            ( setRange (... value: 0 )
            , SBChunk
              ( #bytes
                ( ( ( ( Int2Bytes
                        ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 , A , BE )
                      +Bytes b"\x00\x00\x00\x00\x01"
                      )
                    +Bytes Int2Bytes ( 8 , int64encoding (... value: B +Int C , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                    )
                  +Bytes Int2Bytes ( 8 , int64encoding (... value: B +Int C +Int D +Int E , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                  )
                +Bytes b"\x00"
                )
              ) 
              SBChunk ( #empty ( -1 *Int ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 ) +Int 9886 ) ) 
              SBChunk ( #bytes ( Int2Bytes ( 4 , ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 ) +Int 96 , LE ) ) ) 
              SBChunk ( #bytes ( b"\x01" ) )
              .SparseBytes
            , ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8
            , 1
            )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( Int2Bytes ( ( log2IntTotal ( A ) +Int 8 ) divIntTotal 8 , A , BE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C +Int D +Int E , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
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
              SBChunk ( #bytes ( b"\x01" ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding (... value: B +Int C +Int D +Int E , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
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
            , Int2Bytes
              ( ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)
              , ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int))
              , BE
              )
            )
          , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
          , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8))) +Int (96)
          , 4
          )
      ) => doneSimplification(
          ( concat
            ( replaceAtB
                ( b"\x01"
                  +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes Int2Bytes ( 8 , int64encoding ( ARG_1 +Int ARG_2 +Int ARG_3 +Int ARG_4 , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes b"\x00"
                , SBChunk ( #empty ( -1 *Int ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int 9886 ) )
                , 0
                , Int2Bytes ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 , ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) , BE )
                )
            , SBChunk ( #bytes ( Int2Bytes ( 4 , ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 ) +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 ) +Int 96 , LE ) ) )
              SBChunk ( #bytes ( b"\x01" ) )
            )
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

    claim
      <k>
        runSimplification(
            #setRange
            ( SBChunk ( #empty ( 130856 ) )
              SBChunk ( #bytes ( b"@\x00\x00\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x95\xff\xff\xff" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (132009) , LE ) ) )
              SBChunk ( #bytes ( b"\x01\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"8\x03\x02\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: 0 , b6pos: 1 , b5pos: 2 , b4pos: 3 , b3pos: 4 , b2pos: 5 , b1pos: 6 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: 0 , b5pos: 1 , b4pos: 2 , b3pos: 3 , b2pos: 4 , b1pos: 5 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: 0 , b4pos: 1 , b3pos: 2 , b2pos: 3 , b1pos: 4 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: 0 , b3pos: 1 , b2pos: 2 , b1pos: 3 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: -1 , b3pos: 0 , b2pos: 1 , b1pos: 2 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: -1 , b3pos: -1 , b2pos: 0 , b1pos: 1 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x01\x00\x00\x00\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE ) ) )
              SBChunk ( #bytes ( b"\x03\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x99\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x98\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x01" ) )
              SBChunk ( #empty ( 71 ) )
              SBChunk ( #bytes ( b"input too longincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeinput too shortcast to i64 errorManagedVec index out of rangeEGLD.item.indexstorage decode error: .lenbad array lengthinvalid valueinput out of rangecancelStreamcreateStreamclaimFromStreamstreamByIdstreamsListlastStreamId_with_claim_can_cancelrecipientaddressStream does not existThis stream is cancelledthis stream can't be canceledOnly recipient or sender can cancel streamstream to the current smart contractstream to the callerdeposit is zerostart time before current timeend time before the start timeonly recipient can claimamount is zeroThis stream is not cancelledOnly recipient or sender can claimindex out of rangepanic occurred" ) )
              SBChunk ( #bytes ( b"\x95\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +Bytes Int2Bytes ( 1 , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , LE ) +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE ) +Bytes b"\x00\x00\x00\x00\x01" +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) +Bytes b"\x00" ) )
              SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
            , 130844
            , 0
            , 4
            )
        ) => doneSimplification(
            ( SBChunk ( #empty ( 130844 ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( b"@\x00\x00\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x95\xff\xff\xff" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (132009) , LE ) ) )
              SBChunk ( #bytes ( b"\x01\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"8\x03\x02\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: 0 , b6pos: 1 , b5pos: 2 , b4pos: 3 , b3pos: 4 , b2pos: 5 , b1pos: 6 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: 0 , b5pos: 1 , b4pos: 2 , b3pos: 3 , b2pos: 4 , b1pos: 5 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: 0 , b4pos: 1 , b3pos: 2 , b2pos: 3 , b1pos: 4 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: 0 , b3pos: 1 , b2pos: 2 , b1pos: 3 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: -1 , b3pos: 0 , b2pos: 1 , b1pos: 2 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 1 , (int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: -1 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: -1 , b3pos: -1 , b2pos: 0 , b1pos: 1 )) modIntTotal (256) , LE ) ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )
              SBChunk ( #bytes ( b"\x01\x00\x00\x00\x00\x00\x00\x01" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE ) ) )
              SBChunk ( #bytes ( Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE ) ) )
              SBChunk ( #bytes ( b"\x03\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x04\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x99\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x98\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x01" ) )
              SBChunk ( #empty ( 71 ) )
              SBChunk ( #bytes ( b"input too longincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeinput too shortcast to i64 errorManagedVec index out of rangeEGLD.item.indexstorage decode error: .lenbad array lengthinvalid valueinput out of rangecancelStreamcreateStreamclaimFromStreamstreamByIdstreamsListlastStreamId_with_claim_can_cancelrecipientaddressStream does not existThis stream is cancelledthis stream can't be canceledOnly recipient or sender can cancel streamstream to the current smart contractstream to the callerdeposit is zerostart time before current timeend time before the start timeonly recipient can claimamount is zeroThis stream is not cancelledOnly recipient or sender can claimindex out of rangepanic occurred" ) )
              SBChunk ( #bytes ( b"\x95\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +Bytes Int2Bytes ( 1 , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , LE ) +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE ) +Bytes b"\x00\x00\x00\x00\x01" +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) +Bytes b"\x00" ) )
              SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

endmodule
