module SUBSTR-SPARSE-BYTES
    imports MX-WASM-LEMMA-TESTS

    // cfg 169, pair
    claim
      <k>
        runSimplification(
          substrSparseBytes
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
                  ( ((-1) *Int (((log2IntTotal ( (ARG_0:Int) +Int (-1000) )) +Int (8)) divIntTotal (8)))
                  +Int (9974)
                  )
                )
              SBChunk ( #bytes ( b"\x1c\x00\x00\x00" ) )
              SBChunk ( #bytes ( b"\x01" ) )
            , 2
            , 9979
            )
        ) => doneSimplification("hello")
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
    requires 0 <=Int ARG_0
        andBool 1000 <Int ARG_0
        andBool ARG_0 <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163878376
endmodule
