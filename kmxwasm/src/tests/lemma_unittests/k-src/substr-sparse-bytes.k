module SUBSTR-SPARSE-BYTES
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            substrSparseBytes
              ( merge
                ( SBChunk ( #empty ( 584 ) )
                , merge
                  ( SBChunk ( #bytes ( b"h\x02\x00\x00\x00\x00\x00\x00h\x02\x00\x00\x00\x00\x00\x00\xfe\xff\xff\x7f\x8b\xff\xff\xff\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ) )
                  , merge
                    ( SBChunk ( #empty ( 144 ) )
                    , concat
                      ( merge
                        ( SBChunk
                          ( #bytes
                            ( Int2Bytes ( 4 , (countConsecutiveZeroBytes ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , processed: 6 )) +Int (776) , LE )
                            +Bytes Int2Bytes ( 4 , ((-1) *Int (countConsecutiveZeroBytes ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , processed: 6 ))) +Int (8) , LE )
                            )
                          )
                        , updateSparseBytes
                          ( setRange ( ... value: 1929379839 )
                          , SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )
                            .SparseBytes
                          , 4 , 4
                          )
                        )
                      , SBChunk ( #empty ( 120 ) )
                        SBChunk ( #bytes ( b"\xbf\x03\x00\x00\x01\x00\x00\x00" ) )
                        SBChunk ( #empty ( 4 ) )
                        SBChunk ( #bytes ( b"{\xff\xff\xffw\xff\xff\xffv\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xffx\xff\xff\xff\x00\x00\x00\x00" ) )
                        SBChunk ( #empty ( 4 ) )
                        SBChunk ( #bytes ( b"\xfe\xff\xff\x7f\x00\x00\x00\x00\x00\x00\x00\x01" ) )
                        SBChunk ( #empty ( 24 ) )
                        SBChunk ( #bytes ( b"\x00\x00\x00 \x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xffqx\xff\xff\xff" ) )
                        SBChunk ( #empty ( 20 ) )
                        SBChunk ( #bytes ( b"recipient address not setargument decode error (): too few argumentswrong number of argumentscannot subtract because result would be negativeMultiESDTNFTTransferESDTNFTTransferESDTTransfersync resultinput too longinput too shortcast to i64 errorManagedVec index out of range\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00getStreamByIdcreateStreamgetLastStreamIdclaimFromStreamdelta_last_claim_timestampdelta_end_timedelta_first_claim_timestampdelta_start_timestorage decode error: bad array lengthinvalid valuefirstTokenbobaliceowner\x00\x00panic occurredowner___________________________coindrip________________________alice___________________________bob_____________________________FIRST-123456" ) )
                        SBChunk ( #empty ( 2 ) )
                        SBChunk ( #bytes ( b"p\xff\xff\xff" ) )
                        SBChunk ( #empty ( 10008 ) )
                        SBChunk ( #bytes ( b"coindrip________________________" ) )
                        SBChunk ( #bytes ( b"FIRST-123456" ) )
                        .SparseBytes
                      )
                    )
                  )
                )
              , 984
              , 984 +Int 16
              )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( b"\x00\x00\x00 \x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xffq" ) )
              .SparseBytes
            )::SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
          substrSparseBytes
            ( #setRange
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
              , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))
                +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)))
                +Int (96)
              , 4
              )
            , 0
            , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
            )
        ) => doneSimplification(
          (
            replaceAtB
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
          substrSparseBytes
            ( #setRange
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
              , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))
                +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)))
                +Int (96)
              , 4
              )
            , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
            , maxInt
              ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9908)
              , size
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
                )
              )
            )
        ) => doneSimplification(
          ( SBChunk
              ( #bytes
                ( Int2Bytes
                  ( 4
                  , ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
                    +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
                    +Int 96
                  , LE
                  )
                +Bytes b"\x01"
                )
              )
            .SparseBytes
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
