module GET-BYTES-RANGE
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            extractSparseBytes
              ( getBytesRange
              , substrSparseBytes
                ( updateSparseBytes
                  ( setRange ( ... value: 1 )
                  , updateSparseBytes
                    ( setRange ( ... value: 72057594037927936 )
                    , updateSparseBytes
                      ( setRange ( ... value: 2264924159 )
                      , updateSparseBytes
                        ( setRange ( ... value: 503316480 )
                        , updateSparseBytes
                          ( setRange ( ... value: 0 )
                          , updateSparseBytes
                            ( setRange ( ... value: 0 )
                            , updateSparseBytes
                              ( setRange ( ... value: int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) )
                              , merge
                                ( SBChunk
                                  ( #bytes
                                    ( b"\r\x00\x00\x00\x94\xff\xff\xff"
                                    +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                    +Bytes b"\x00\x00\x00\f\x90\xff\xff\xff"
                                    +Bytes Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE )
                                    +Bytes b"\x00\x00\x00\x00"
                                    )
                                  )
                                , concat
                                  ( updateSparseBytes
                                    ( setRange ( ... value: 1 )
                                    , SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)) <<IntTotal (24) , LE ) ) )
                                      .SparseBytes
                                    , 3 , 1
                                    )
                                  , SBChunk
                                    ( #bytes
                                      ( b"\x00\x00\x00\x00\x00\x00\x00\x00"
                                      +Bytes Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE ) +Bytes Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE )
                                      +Bytes b"\x03\x00\x00\x00\x04\x00\x00\x00\x05\x00\x00\x00\x99\xff\xff\xff\x98\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x9a\xff\xff\xff\x01"
                                      )
                                    )
                                    SBChunk ( #empty ( 7 ) )
                                    SBChunk
                                      ( #bytes
                                        ( b"\x00\x00\x00\x00\x00\x00\x00\x00"
                                        +Bytes Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE ) 
                                        +Bytes Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE )
                                        +Bytes b"\x12\x00\x00\x00\x13\x00\x00\x00\x14\x00\x00\x00\x8f\xff\xff\xff\x8e\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x90\xff\xff\xff\x01"
                                        )
                                      )
                                    SBChunk ( #empty ( 7 ) )
                                    SBChunk ( #bytes ( b"input too longincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeinput too shortcast to i64 errorManagedVec index out of rangeEGLD.item.indexstorage decode error: .lenbad array lengthinvalid valueinput out of rangecancelStreamcreateStreamclaimFromStreamstreamByIdstreamsListlastStreamId_with_claim_can_cancelrecipientaddressStream does not existThis stream is cancelledthis stream can't be canceledOnly recipient or sender can cancel streamstream to the current smart contractstream to the callerdeposit is zerostart time before current timeend time before the start timeonly recipient can claimamount is zeroThis stream is not cancelledOnly recipient or sender can claimindex out of rangepanic occurred" ) )
                                    .SparseBytes
                                  )
                                )
                              , 24 , 8
                              )
                            , 31 , 1
                            )
                          , 20 , 8
                          )
                        , 16 , 4
                        )
                      , 28 , 4
                      )
                    , 8 , 8
                    )
                  , 4 , 4
                  )
                , 4 , 980
                )
              , 0 , 4
              )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( b"\x01\x00\x00\x00" ) )
              .SparseBytes
            )::SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int ARG_0 andBool 0 <Int ARG_1 andBool 0 <Int ARG_2
          andBool 0 <Int ARG_3 andBool 0 <Int ARG_4


    claim
      <k>
        runSimplification(
            extractSparseBytes
              ( substr
              , SBChunk
                ( #bytes
                  ( b"\x00\x00\x00\x00\x00\x00\x00\x01\x95\xff\xff\xff"
                  +Bytes Int2Bytes
                    ( 4
                    , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))
                      +Int (114)
                    , LE
                    )
                  +Bytes b"\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x008\x03\x02\x00"
                  +Bytes Int2Bytes
                    ( 4
                    , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114)
                    , LE
                    )
                  +Bytes Int2Bytes
                    ( 8
                    , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int)
                    , LE
                    )
                  )
                )
              .SparseBytes
              , 0 , 8
              )
        ) => doneSimplification(
            ( SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x01" ) )
              .SparseBytes
            )::SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int ARG_0 andBool 0 <Int ARG_1 andBool 0 <Int ARG_2
          andBool 0 <Int ARG_3 andBool 0 <Int ARG_4


    claim
      <k>
        runSimplification(
            extractSparseBytes
              ( getBytesRange
              , SBChunk
                ( #bytes
                  ( Int2Bytes
                    ( 8
                    , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )
                    , LE
                    )
                  )
                )
                SBChunk ( #empty ( 132 ) )
                SBChunk ( #bytes ( b"{\xff\xff\xff" ) )
                SBChunk ( #empty ( 28 ) )
                SBChunk ( #bytes ( b"\xfe\xff\xff\x7f" ) )
                SBChunk ( #empty ( 32 ) )
                SBChunk ( #bytes ( b"w\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"v\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"\xff\xff\xff\xff\xff\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"x\xff\xff\xff" ) )
                SBChunk ( #empty ( 20 ) )
                SBChunk ( #bytes ( b"recipient address not setargument decode error (): too few argumentswrong number of argumentscannot subtract because result would be negativeMultiESDTNFTTransferESDTNFTTransferESDTTransfersync resultinput too longinput too shortcast to i64 errorManagedVec index out of range\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00getStreamByIdcreateStreamgetLastStreamIdclaimFromStreamdelta_last_claim_timestampdelta_end_timedelta_first_claim_timestampdelta_start_timestorage decode error: bad array lengthinvalid valuefirstTokenbobaliceowner\x00\x00panic occurredowner___________________________coindrip________________________alice___________________________bob_____________________________FIRST-123456" ) )
                SBChunk ( #empty ( 2 ) )
                SBChunk ( #bytes ( b"t\xff\xff\xff" ) )
                SBChunk ( #empty ( 10008 ) )
                SBChunk ( #bytes ( b"coindrip________________________" ) )
                SBChunk ( #bytes ( b"FIRST-123456" ) )
                .SparseBytes
              , countConsecutiveZeroBytes ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , processed: 6 )
              , 1
              )
        ) => doneSimplification(
            ( SBChunk
              ( #bytes
                ( Int2Bytes
                  ( 1
                  , int64encoding (... value: ARG_1 +Int ARG_2 , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )
                    >>IntTotal ( 8 *Int countConsecutiveZeroBytes (... value: ARG_1 +Int ARG_2 , processed: 6 ) )
                  , LE
                  )
                )
              )
              .SparseBytes
            ):SparseBytes:KItem
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            #getBytesRange
              ( SBChunk
                ( #bytes
                  ( Int2Bytes
                    ( 8
                    , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )
                    , LE
                    )
                  )
                )
                SBChunk ( #empty ( 132 ) )
                SBChunk ( #bytes ( b"{\xff\xff\xff" ) )
                SBChunk ( #empty ( 28 ) )
                SBChunk ( #bytes ( b"\xfe\xff\xff\x7f" ) )
                SBChunk ( #empty ( 32 ) )
                SBChunk ( #bytes ( b"w\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"v\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"\xff\xff\xff\xff\xff\xff\xff\xff" ) )
                SBChunk ( #bytes ( b"x\xff\xff\xff" ) )
                SBChunk ( #empty ( 20 ) )
                SBChunk ( #bytes ( b"recipient address not setargument decode error (): too few argumentswrong number of argumentscannot subtract because result would be negativeMultiESDTNFTTransferESDTNFTTransferESDTTransfersync resultinput too longinput too shortcast to i64 errorManagedVec index out of range\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00getStreamByIdcreateStreamgetLastStreamIdclaimFromStreamdelta_last_claim_timestampdelta_end_timedelta_first_claim_timestampdelta_start_timestorage decode error: bad array lengthinvalid valuefirstTokenbobaliceowner\x00\x00panic occurredowner___________________________coindrip________________________alice___________________________bob_____________________________FIRST-123456" ) )
                SBChunk ( #empty ( 2 ) )
                SBChunk ( #bytes ( b"t\xff\xff\xff" ) )
                SBChunk ( #empty ( 10008 ) )
                SBChunk ( #bytes ( b"coindrip________________________" ) )
                SBChunk ( #bytes ( b"FIRST-123456" ) )
                .SparseBytes
              , countConsecutiveZeroBytes ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , processed: 6 )
              , 1
              )
        ) => doneSimplification(
            Int2Bytes
              ( 1
              , int64encoding (... value: ARG_1 +Int ARG_2 , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 )
                >>IntTotal ( 8 *Int countConsecutiveZeroBytes (... value: ARG_1 +Int ARG_2 , processed: 6 ) )
              , LE
              )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>


    claim
      <k>
        runSimplification(
            #getBytesRange
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
              , 16
              )
        ) => doneSimplification(
            b"\x00\x00\x00 \x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xffq"
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
endmodule
