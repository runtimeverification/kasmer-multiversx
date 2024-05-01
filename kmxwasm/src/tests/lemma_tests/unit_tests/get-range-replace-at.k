module GET-RANGE-REPLACE-AT
    imports MX-WASM-LEMMA-TESTS

    // getRange before replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 0 , 1
                  )
            )
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 0 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(4)
            ListItem(4)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A



    // getRange in replaceAt
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 1 , 4
                  )
            )
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 1 , 4
                  )
            )
        ) => doneSimplification(
            ListItem(258)
            ListItem(A)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after replaceAt, same chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after replaceAt, different chunk
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk( #bytes ( b"\x05" ) )
                      , 1, b"\x02\x01\x00\x00"
                      )
                  , 5 , 1
                  )
            )
            ListItem(
                #getRange
                  ( replaceAt
                      ( SBChunk ( #bytes ( b"\x04\x00\x00\x00\x00" ) )
                        SBChunk ( #bytes ( b"\x05" ) )
                      , 1, Int2Bytes(4, A, LE)
                      )
                  , 5 , 1
                  )
            )
        ) => doneSimplification(
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32

    // getRange after replaceAt, incomplete overlap
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
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
                #getRange
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
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32


    // getRange after replaceAt, incomplete overlap, symbolic set length
    claim
      <k>
        runSimplification(
            ListItem(
                #getRange
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
                #getRange
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
            ListItem(5)
            ListItem(5)
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>
      requires 0 <Int A andBool A <Int 1 <<Int 32 andBool 0 <Int B andBool B <Int 5

endmodule
