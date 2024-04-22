module REPLACE-AT-B-SET-RANGE
    imports MX-WASM-LEMMA-TESTS


    claim
      <k>
        runSimplification(
            ListItem(
                replaceAtB(
                    b"\x00\x00",
                    #setRange( SBChunk ( #bytes ( b"\x00\x00" ) ), 0, 258, 2 ),
                    0, Int2Bytes(4, 515, LE)
                )
            )
            // TODO: The symbolic part of this test is not working properly right now,
            // it would be nice if it did.
            // ListItem(
            //     replaceAtB(
            //         Int2Bytes(2, B, LE),
            //         #setRange( A, 0, 258, 2 ),
            //         0, Int2Bytes(4, 515, LE)
            //     )
            // )
        ) => doneSimplification(
            ListItem( SBChunk ( #bytes ( b"\x03\x02\x00\x00" ) ) )
            // ListItem( replaceAt( A, 0, Int2Bytes(4, 515, LE) ) )
        )
      </k>
      <commands> .K </commands>
      <instrs> .K </instrs>

endmodule
