module GET-RANGE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            #getRange (
                SBChunk (
                    #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) )
                )
                , 0 , 1
            )
        ) => doneSimplification(4)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            #getRange (
                SBChunk ( #empty ( 808 ) )
                    SBChunk ( #bytes ( b"\x04\x00\x00\x00" +Bytes Int2Bytes ( 1 , _ARG_0:Int , LE ) ) )
                , 12452 , 4
            )
        ) => doneSimplification(0)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            #getRange
              ( SBChunk
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
                SBChunk
                ( #bytes
                  ( b"xargument decode error (): wrong number of argumentsinput too longstorage decode error: num\x00panic occurred"
                  )
                )
                SBChunk ( #empty ( 2 ) )
                SBChunk ( #bytes ( b"\x98\xff\xff\xff" ) )
              , 116
              , 4
              )
        ) => doneSimplification(4294967192)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            #getRange
            ( #setRange
              ( SBChunk
                ( #empty ( (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) ) )
                SBChunk ( #bytes ( b"\x1a\x00\x00\x00" ) )
                SBChunk ( #bytes ( b"\x01" ) )
              , (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))
              , (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)) +Int (26)
              , 4
              )
            , (9974) -Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))
            , 4
            )
        ) => doneSimplification(
            ( ( log2IntTotal ( ARG_0 +Int -1000 ) +Int 8 ) divIntTotal 8 ) +Int 26
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

    claim
      <k>
        runSimplification(
            #getRange
            ( SBChunk(#empty(
                  (-1 *Int ((log2IntTotal(ARG_0 +Int -1000) +Int 8) divIntTotal 8)) +Int 9974
                ))
                SBChunk(#bytes(b"\x1c\x00\x00\x00"))
                SBChunk(#bytes(b"\x01")),
              (-1 *Int ((log2IntTotal(ARG_0 +Int -1000) +Int 8) divIntTotal 8)) +Int 9974,
              4
            )
        ) => doneSimplification(28)
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

    claim
      <k>
        runSimplification(
            #getRange (
                concat(
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
                    SBChunk ( #bytes ( b"\x01" ) )
                )
            , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
            , 4
            )
        ) => doneSimplification(
          ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
          +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
          +Int 96
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
          #getRange
            ( concat
              ( replaceAtB
                ( b"\x01"
                  +Bytes Int2Bytes ( 8 , int64encoding ( (ARG_1:Int) +Int (ARG_2:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes Int2Bytes ( 8 , int64encoding ( (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 ) , LE )
                  +Bytes b"\x00"
                , SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )
                , 0
                , Int2Bytes
                  ( ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)
                  , ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int))
                  , BE
                  )
                )
              , SBChunk
                  ( #bytes
                    ( Int2Bytes
                      ( 4
                      , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))
                        +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)))
                        +Int (96)
                      , LE
                      )
                    )
                  )
                SBChunk ( #bytes ( b"\x01" ) )
              )
            , ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9904)
            , 4
            )
        ) => doneSimplification(
          ( ( log2IntTotal ( ARG_0 ) +Int 8 ) divIntTotal 8 )
          +Int ( ( log2IntTotal ( ( ARG_0 *Int ARG_3 ) divIntTotal ( ARG_3 +Int ARG_4 ) ) +Int 8 ) divIntTotal 8 )
          +Int 96
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
          #getRange
            ( concat
              ( substrSparseBytes
                ( SBChunk
                    ( #bytes
                      ( Int2Bytes
                        ( ((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)
                        , (ARG_0:Int) +Int (-1000)
                        , BE
                        )
                      )
                    )
                  SBChunk
                    ( #empty
                      ( ( (-1)
                        *Int
                          (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8))
                        )
                      +Int (9974)
                      )
                    )
                , 2
                , 9974
                )
              , SBChunk ( #bytes ( b"\x1c\x00\x00\x00" ) )
                SBChunk ( #bytes ( b"\x01" ) )
              )
            , 9972
            , 4
            )
        ) => doneSimplification(
          28
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires true
        andBool 1000 <Int ARG_0
        andBool 1000 <Int ARG_1
        andBool ARG_1:Int <Int ARG_0:Int

    claim
      <k>
        runSimplification(
          #getRange
            ( SBChunk ( #bytes ( b"L\xff\xff\xff\x01\x00\x00\x00L\xff\xff\xff\x01\x00\x00\r" ) ) 
              SBChunk ( #empty ( 8 ) ) 
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) ) 
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"*\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"h\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"+\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"g\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b",\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"f\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\xf8'\x00\x00" ) )
              SBChunk ( #bytes ( b"\x8c\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x98\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x96\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x93\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x90\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"w\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x01" ) )
              SBChunk ( #empty ( 3 ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x11\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x06\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x10\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x05\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x9b\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x81\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x80\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x7f\xff\xff\xff" ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( b"o\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x11\x00\x00\x00\x06\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x10\x00\x00\x00\x05\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x9b\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x9a\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x81\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x80\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x7f\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )
              SBChunk ( #empty ( 8 ) )
              SBChunk ( #bytes ( b"recipient address not setinput too longinvalid valuelockTokensESDTLocalBurnESDTLocalMintincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeMultiESDTNFTTransferESDTNFTTransferESDTTransfersync resultinput too shortcast to i64 errorManagedVec index out of range\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00ESDT expectedEGLD.mapped.node_id.item.node_links.value.infostorage decode error: depositSwapFees.lenbad array lengthvar argsaddressprevious_ownerinput out of rangefee_destinationtrusted_swap_pairfeesCollectorAddressfeesCollectorCutPercentagewhiteliststatereservefirst_token_idrouter_addresslp_token_supplysecond_token_idtotal_fee_percentlpTokenIdentifierspecial_fee_percentinitial_liquidity_adderswapadd_liquidityremove_liquidityswap_no_fee_and_forwardnew_addressInvalid SC Addressinputdestination_addressadminsrouter_owner_addressswapNoFeeAndForwardfee_to_addressenabledfees_collector_addresspair_addressInvalid fees collector addressInvalid fees percentageInvalid tokensprice_observationssafe_price_current_indexpermissionsunlockEpochlockingScAddresslocking_deadline_epochaddress_listBad input tokenPermission deniedBad parametersEndpoint can only be called by ownerindex out of range\x00\x00\x00panic occurredActive stateNot activeLP token not issuedBad payment tokensInvalid argsFirst tokens needs to be greater than minimum liquidityInsufficient liquidity mintedInsufficient first token computed amountInsufficient second token computed amountOptimal amount greater than desired amountK invariant failedInsufficient liquidity burnedSlippage amount does not matchNot enough reserveNot enough LP token supplyInitial liquidity was not addedInitial liquidity was already addedNot a valid esdt idExchange tokens cannot be the sameToken ID cannot be the same as LP token IDBad percentsNot whitelistedAlready whitelistedPair already trustedPair not trustedAlready a fee destinationNot a fee destinationDestination fee token differsZero amountUnknown tokenLP token should differ from the exchange tokensSwap is not enabledSlippage exceededNothing to do with fee sliceThe safe price can be computed only between different roundsThe current safe price index is greater than the maximum number of observationsThe price observation does not exist" ) )
              SBChunk ( #empty ( 3 ) )
              SBChunk ( #bytes ( b"K\xff\xff\xff\xeb\xff\xff\xff" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\f" ) )
              SBChunk ( #bytes ( b"FIRST-123456" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              SBChunk ( #bytes ( b"\x00" ) )
              replaceAt
                ( concat
                  ( #setRange
                    ( concat
                      ( #setRange
                        ( SBChunk
                          ( #bytes
                            ( Int2Bytes
                              ( (log2IntTotal ( ARG_0:Int +Int -1000 ) +Int 8) divIntTotal 8 , ARG_0:Int +Int -1000 , BE )
                            )
                          )
                          .SparseBytes
                        , 0
                        , 0
                        , 1
                        )
                      , SBChunk ( #empty ( -1 *Int ((log2IntTotal ( ARG_0:Int +Int -1000 ) +Int 8) divIntTotal 8) +Int 9974 ) )
                        .SparseBytes
                      )
                    , 1
                    , (log2IntTotal ( ARG_0:Int ) +Int 8) divIntTotal 8
                    , 1
                    )
                  , SBChunk ( #bytes ( Int2Bytes ( 4 , ((log2IntTotal ( ARG_0:Int ) +Int 8) divIntTotal 8) +Int 28 , LE ) ) )
                    SBChunk ( #bytes ( b"\x01" ) )
                    .SparseBytes
                  )
                , 2
                , Int2Bytes ( ( log2IntTotal ( ARG_0:Int ) +Int 8 ) divIntTotal 8 , ARG_0:Int , BE )
                )
            , 12
            , 1
            )
        ) => doneSimplification(
          1
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

    claim
      <k>
        runSimplification(
            #getRange
              ( SBChunk ( #empty ( 130792 ) )
                SBChunk ( #bytes ( b"8\x03\x02\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )  
                SBChunk ( #empty ( 8 ) )  
                SBChunk ( #bytes ( b"8\x03\x02\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )  
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
                SBChunk ( #bytes ( b"8\x03\x02\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )  
                SBChunk ( #bytes ( b"\x95\xff\xff\xff" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (114) , LE ) ) )  
                SBChunk ( #bytes ( b"|\x03\x02\x00" ) )  
                SBChunk ( #bytes ( b"\f\x00\x00\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (132009) , LE ) ) )  
                SBChunk ( #bytes ( b"\x01\x00\x00\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8))) +Int (131993) , LE ) ) )  
                SBChunk ( #bytes ( b"\x08\x00\x00\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE ) ) )  
                SBChunk ( #bytes ( Int2Bytes ( 4 , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8))) +Int (131993) , LE ) ) )  
                SBChunk ( #bytes ( b"\x08\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\r\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x94\xff\xff\xff" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) ) )  
                SBChunk ( #bytes ( b"\x8c\xff\xff\xff" ) )  
                SBChunk ( #bytes ( b"\x01" ) )  
                SBChunk ( #bytes ( b"\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x8c\xff\xff\xff\x01\x00\x00\x01" ) )  
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
                SBChunk ( #empty ( 7 ) )  
                SBChunk ( #bytes ( b"\x00\x00\x00\x00\x00\x00\x00\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 8 , (ARG_1:Int) +Int (ARG_2:Int) , LE ) ) )  
                SBChunk ( #bytes ( Int2Bytes ( 8 , (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , LE ) ) )  
                SBChunk ( #bytes ( b"\x12\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x13\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x14\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x8f\xff\xff\xff" ) )  
                SBChunk ( #bytes ( b"\x8e\xff\xff\xff" ) )  
                SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x00\x00\x00\x00" ) )  
                SBChunk ( #bytes ( b"\x90\xff\xff\xff" ) )  
                SBChunk ( #bytes ( b"\x01" ) )  
                SBChunk ( #empty ( 7 ) )  
                SBChunk ( #bytes ( b"input too longincorrect number of ESDT transfersargument decode error (): too few argumentstoo many argumentswrong number of argumentscannot subtract because result would be negativeinput too shortcast to i64 errorManagedVec index out of rangeEGLD.item.indexstorage decode error: .lenbad array lengthinvalid valueinput out of rangecancelStreamcreateStreamclaimFromStreamstreamByIdstreamsListlastStreamId_with_claim_can_cancelrecipientaddressStream does not existThis stream is cancelledthis stream can't be canceledOnly recipient or sender can cancel streamstream to the current smart contractstream to the callerdeposit is zerostart time before current timeend time before the start timeonly recipient can claimamount is zeroThis stream is not cancelledOnly recipient or sender can claimindex out of rangepanic occurred" ) )  
                SBChunk ( #bytes ( b"\x8a\xff\xff\xff" ) )  
                SBChunk ( #bytes ( b"alice___________________________bob_____________________________" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\f" ) )  
                SBChunk ( #bytes ( b"FIRST-123456" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes ( 1 , ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , LE ) ) )  
                SBChunk ( #bytes ( Int2Bytes ( ((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8) , ARG_0:Int , BE ) ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( b"\x00" ) )  
                SBChunk ( #bytes ( Int2Bytes
                    ( 1
                    , ( ( log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) ) )
                        +Int (8)) divIntTotal (8)
                    , LE
                    ) ) ) 
                concat
                  ( #setRange ( #setRange ( replaceAtB ( b"\x01" +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE ) +Bytes Int2Bytes ( 8 , int64encoding ( ... value: (((ARG_1:Int) +Int (ARG_2:Int)) +Int (ARG_3:Int)) +Int (ARG_4:Int) , b8pos: 0 , b7pos: 1 , b6pos: 2 , b5pos: 3 , b4pos: 4 , b3pos: 5 , b2pos: 6 , b1pos: 7 ) , LE )
                    +Bytes b"\x00" , 
                    SBChunk ( #empty ( ((-1) *Int (((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8))) +Int (9886) ) )  .SparseBytes , 0 , Int2Bytes ( ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8) , ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) , BE ) ) , ((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8) , 1 , 1 ) , (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8)) +Int (1) , int64encoding ( ... value: (ARG_1:Int) +Int (ARG_2:Int) , b8pos: 0 , b7pos: -1 , b6pos: -1 , b5pos: -1 , b4pos: -1 , b3pos: -1 , b2pos: -1 , b1pos: -1 ) , 1 ) , 
                    SBChunk ( #bytes ( Int2Bytes ( 4 , ((((log2IntTotal ( ARG_0:Int )) +Int (8)) divIntTotal (8)) +Int (((log2IntTotal ( ((ARG_0:Int) *Int (ARG_3:Int)) divIntTotal ((ARG_3:Int) +Int (ARG_4:Int)) )) +Int (8)) divIntTotal (8))) +Int (97) , LE ) ) )  
                    SBChunk ( #bytes ( b"\x01" ) )
                  )
              , 130921
              , 1
              )
        ) => doneSimplification(
          int64encoding (... value: ARG_1 +Int ARG_2 , b8pos: -1 , b7pos: 0 , b6pos: 1 , b5pos: 2 , b4pos: 3 , b3pos: 4 , b2pos: 5 , b1pos: 6 ) modIntTotal 256
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
endmodule
