module SET-BYTES-RANGE
    imports MX-WASM-LEMMA-TESTS

    claim
      <k>
        runSimplification(
            #setBytesRange
              ( SBChunk ( #bytes (
                  Int2Bytes ( 8 , A , LE )
                  +Bytes b"\x00"
                ) )
              , 0
              , Int2Bytes ( 8 , A , LE )
                +Bytes b"\x00"
              )
        ) => doneSimplification(
            ( SBChunk ( #bytes (
                Int2Bytes ( 8 , A , LE )
                +Bytes b"\x00"
              ) )
              .SparseBytes
            ):SparseBytes
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 1000 <Int ARG_0
        andBool ARG_0:Int <Int 6668014432879854274079851790721257797144758322315908160396257811764037237817632071521432200871554290742929910593433240445888801654119365080363356052330830046095157579514014558463078285911814024728965016135886601981690748037476461291163877376

endmodule
