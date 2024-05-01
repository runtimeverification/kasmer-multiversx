module GET-BYTES-RANGE-REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    // getBytesRange before replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 0 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x04")
            ListItem(b"\x04")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A



    // getBytesRange in replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 1 , 4
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 1 , 4
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x02\x01\x00\x00")
            ListItem(Int2Bytes(4, A, LE))
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after replaceAt, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after replaceAt, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getBytesRange after replaceAt, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, Int2Bytes(4, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // getBytesRange after replaceAt, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, 257, LE) ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 0, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getBytesRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04" ) )
                        SBChunk( #bytes ( Int2Bytes(4, A, LE) ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 0, Int2Bytes(B, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(b"\x05")
            ListItem(b"\x05")
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
