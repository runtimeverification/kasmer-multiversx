module SUBSTR-SPARSE-BYTES-REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    // substrSparseBytes before replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 0 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x04"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x04"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A



    // substrSparseBytes in replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 1 , 5
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 1 , 5
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x02\x01\x00\x00"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(Int2Bytes(4, A, LE)))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after replaceAt, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 6
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after replaceAt, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 6
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // substrSparseBytes after replaceAt, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, b"\x02\x01\x00\x00"
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, Int2Bytes(4, A, LE)
                      )
                  , 5 , 6
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // substrSparseBytes after replaceAt, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, b"\x02\x01\x00\x00"
                      )
                  , 5 , 6
                  )
            )
            ListItem(
                substrSparseBytes
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, Int2Bytes(B, A, LE)
                      )
                  , 5 , 6
                  )
            )
        ) => doneSimplification(
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
            ListItem(
                ( SBChunk(#bytes(b"\x05"))
                  .SparseBytes
                ):SparseBytes:KItem
            )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
