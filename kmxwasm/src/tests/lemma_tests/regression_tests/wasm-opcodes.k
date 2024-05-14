module WASM-OPCODES
    imports MX-WASM-LEMMA-TESTS

    claim
        <k> .K </k>
        <commands> .K </commands>
        <instrs> 
            load
              { i32
                i8
                131980
                Unsigned
                merge
                  ( SBChunk ( #empty ( 130824 ) )
                  , merge
                    ( SBChunk ( #bytes
                        ( b"8\x03\x02\x00"
                        +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                        )
                      )
                    , updateSparseBytes
                      ( setRange ( ... value: 0 )
                      , updateSparseBytes
                        ( setRange ( ... value: 0 )
                        , updateSparseBytes
                          ( setRange ( ... value: 0 )
                          , updateSparseBytes
                            ( setRange ( ... value: 0 )
                            , updateSparseBytes
                              ( setRange ( ... value: 0 )
                              , merge
                                ( SBChunk ( #empty ( 12 ) )
                                , merge
                                  ( SBChunk ( #bytes ( b"\x00\x00\x00\f" ) )
                                  , concat
                                    ( merge
                                      ( SBChunk ( #empty ( 8 ) )
                                      , merge
                                        ( SBChunk ( #bytes
                                            ( b"P\x00\x00\x00"
                                            +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                            +Bytes b"\x95\xff\xff\xff"
                                            +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                            )
                                          )
                                        , concat
                                          ( merge
                                            ( SBChunk ( #bytes ( b"\x01\x00\x00\x00\x00\x00\x00\x01" ) )
                                            , merge
                                              ( SBChunk ( #empty ( 8 ) )
                                              , merge
                                                ( SBChunk ( #bytes
                                                    ( b"8\x03\x02\x00"
                                                    +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                                    )
                                                  )
                                                , merge
                                                  ( SBChunk ( #empty ( 8 ) )
                                                  , concat
                                                    ( updateSparseBytes
                                                      ( setRange ( ... value: 0 )
                                                      , SBChunk ( #bytes
                                                          ( Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                                                          )
                                                        )
                                                        .SparseBytes
                                                      , 7, 1
                                                      )
                                                    , SBChunk ( #empty ( 8 ) )
                                                      .SparseBytes
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          , SBChunk ( #bytes
                                              ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                              +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                              +Bytes b"\x9a\xff\xff\xff"
                                              +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                              +Bytes b"\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00"
                                              +Bytes Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE )
                                              +Bytes Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE )
                                              +Bytes b"\x03\x00\x00\x00\x04\x00\x00\x00\x05\x00\x00\x00\x99\xff\xff\xff\x98\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x9a\xff\xff\xff\x01"
                                              )
                                            )
                                            SBChunk ( #empty ( 71 ) )
                                            .SparseBytes
                                          )
                                        )
                                      )
                                    , concat
                                      ( merge
                                        ( SBChunk ( #bytes
                                            ( b"input too longincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeinput too shortcast to i64 errorManagedVec index out of rangeEGLD.item.indexstorage decode error: .lenbad array lengthinvalid valueinput out of rangecancelStreamcreateStreamclaimFromStreamstreamByIdstreamsListlastStreamId_with_claim_can_cancelrecipientaddressStream does not existThis stream is cancelledthis stream can't be canceledOnly recipient or sender can cancel streamstream to the current smart contractstream to the callerdeposit is zerostart time before current timeend time before the start timeonly recipient can claimamount is zeroThis stream is not cancelledOnly recipient or sender can claimindex out of rangepanic occurred\x95\xff\xff\xff"
                                            )
                                          )
                                        , updateSparseBytes
                                          ( replaceAt
                                            ( ... value: b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00"
                                              +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE )
                                              +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                                              +Bytes b"\x00\x00\x00\x00\x01"
                                              +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                                              +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                                              +Bytes b"\x00"
                                            )
                                          , SBChunk ( #bytes
                                              ( b"alice___________________________bob_____________________________\x00\x00\x00\fFIRST-123456\x00\x00\x00\x00\x00\x00\x00\x00"
                                                +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE )
                                                +Bytes Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE )
                                                +Bytes b"\x00\x00\x00\x00\x01"
                                                +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) 
                                                +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                                                +Bytes b"\x00"
                                              )
                                            )
                                            .SparseBytes
                                          , 0
                                          , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114)
                                          )
                                        )
                                      , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
                                        SBChunk ( #bytes
                                            ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) 
                                              +Bytes b"\x01"
                                            )
                                          )
                                        .SparseBytes
                                      )
                                    )
                                  )
                                )
                              , 8 , 8
                              )
                            , 8 , 1
                            )
                          , 9 , 1
                          )
                        , 10 , 1
                        )
                      , 11 , 1
                      )
                    )
                  )
                }
            => .K
        </instrs>
        <valstack> S => <i32> 0 : S </valstack>
    requires 0 <Int ARG_0
      andBool 0 <Int ARG_2
      andBool 0 <Int ARG_3
      andBool 0 <Int ARG_4
      andBool 0 <Int ARG_5
      andBool 0 <=Int ARG_0
      andBool 0 <=Int ARG_1
      andBool 0 <=Int ARG_2
      andBool 0 <=Int ARG_3
      andBool 0 <=Int ARG_4
      andBool 0 <=Int ARG_5
      andBool ARG_1 =/=Int 0
      andBool ARG_2 <=Int 4294967295
      andBool ARG_3 <=Int 4294967295
      andBool ARG_4 <=Int 4294967295
      andBool ARG_5 <=Int 4294967295
      andBool ARG_1 <Int 18446744056529682435
      andBool ARG_3 <Int 18446744073709551616
      andBool ARG_1 <=Int 18446744073709551615
      andBool 0 =/=Int (ARG_3) +Int (ARG_4)
      andBool (ARG_3) +Int (ARG_4) <=Int (ARG_0) *Int (ARG_3)
      andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376


endmodule
