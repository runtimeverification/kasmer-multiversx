```k

module HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    imports SPARSE-BYTES-LEMMAS-BASIC

    // Must add on entry for each function
    syntax SBSetFunction
    syntax SBGetFunction ::= "substr"

    syntax SBFunction ::= SBSetFunction | SBGetFunction
    // Must convert to/from for each function
    syntax SparseBytes ::= updateSparseBytes(
            SBSetFunction, SparseBytes, start:Int, size:Int
        )  [function, total, symbol(updateSparseBytes)]
    // Must implement for each function
    syntax Bool ::= functionSparseBytesWellDefined(
            SBFunction, sbSize:Int, start:Int, size:Int
        )  [function, total, symbol(functionSparseBytesWellDefined)]
    // Must implement for each function
    syntax Int ::= updateSparseBytesSize(
            SBSetFunction, sbSize:Int, start:Int, size:Int
        )  [function, total, symbol(updateSparseBytesSize)]
    // Must implement for each function
    syntax Int ::= startOffset(SBSetFunction)
        [function, total, symbol(startOffset)]
    // Must implement for each function
    syntax Bool ::= functionCommutesAtStart(SBFunction)
        [function, total, symbol(functionCommutesAtStart)]
    // Must implement for each function
    syntax SparseBytes ::= getReplacementSparseBytes(
            SBSetFunction, SparseBytes, start:Int, size:Int
        )  [function, total, symbol(getReplacementSparseBytes)]

    syntax Bool ::= updateSparseBytesCanSwap(
                f1:SBSetFunction, start1:Int, size1:Int,
                f2:SBSetFunction, start2:Int, size2:Int,
                SparseBytes)
        [function, total]
    rule updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
        => functionSparseBytesWellDefined(F2, size(SB), Start2, Width2)
            andBool functionSparseBytesWellDefined(F1, updateSparseBytesSize(F2, size(SB), Start2, Width2), Start1, Width1)
            andBool functionSparseBytesWellDefined(F1, size(SB), Start1, Width1)
            andBool functionSparseBytesWellDefined(F2, updateSparseBytesSize(F1, size(SB), Start1, Width1), Start2, Width2)
            andBool functionCommutesAtStart(F1)
            andBool startOffset(F2) <=Int Start1

    // Must convert to/from for each function
    syntax SparseBytes ::= extractSparseBytes(
            SBGetFunction, SparseBytes, start:Int, size:Int
        )
        [function, total, symbol(extractSparseBytes)]
    syntax Bool ::= extractSparseBytesCanIgnore(
        f1:SBGetFunction, start1:Int, size1:Int,
        f2:SBSetFunction, start2:Int, size2:Int,
        SparseBytes)
        [function, total, symbol(extractSparseBytesCanIgnore)]
    rule extractSparseBytesCanIgnore(F1, Start1, Width1, F2, Start2, Width2, SB)
        => functionSparseBytesWellDefined(F2, size(SB), Start2, Width2)
            andBool functionSparseBytesWellDefined(F1, updateSparseBytesSize(F2, size(SB), Start2, Width2), Start1, Width1)
            andBool functionSparseBytesWellDefined(F1, size(SB), Start1 -Int startOffset(F2), Width1)
            andBool startOffset(F2) <=Int Start1

    syntax SparseBytes ::= splitSparseBytes(
            toSplit:SparseBytes, prefix:SparseBytes, addr:Int
        )
        [function, total]

    syntax Bool ::= canSplitSparseBytes(SBSetFunction, SparseBytes, addr:Int)  [function, total]
                  | #canSplitSparseBytes(SparseBytes, SparseBytes)  [function, total]

    syntax SparseBytes ::= splitSparseBytesFunction(
            function:SparseBytes, SBSetFunction, toSplit:SparseBytes, addr:Int
        )
        [function, total]
    syntax SparseBytes ::= #splitSparseBytesFunction(
            function:SparseBytes, toSplit:SparseBytes, splitter:SparseBytes, addr:Int
        )
        [function, total]
endmodule

module HANDLE-SPARSE-BYTES-LEMMAS
    imports private EXTRACT-SPARSE-BYTES-LEMMAS
    imports private UPDATE-SPARSE-BYTES-LEMMAS
    imports private SPLIT-SPARSE-BYTES
endmodule

module SPLIT-SPARSE-BYTES
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    rule canSplitSparseBytes(F:SBSetFunction, SB, Addr)
        => #canSplitSparseBytes(SB, splitSparseBytes(SB, .SparseBytes, Addr -Int startOffset(F)))
        requires startOffset(F) <Int Addr
    rule #canSplitSparseBytes(_, splitSparseBytes(Suffix, _, 0)) => true
        requires 0 <Int size(Suffix)
        [simplification]

    rule splitSparseBytesFunction(Function:SparseBytes, F:SBSetFunction, ToSplit:SparseBytes, Addr:Int)
        => #splitSparseBytesFunction(
            Function, ToSplit, splitSparseBytes(ToSplit, .SparseBytes, Addr -Int startOffset(F)), Addr
        )
    rule #splitSparseBytesFunction(
            updateSparseBytes(Fn:SBSetFunction, _:SparseBytes, Addr:Int, Width:Int),
            _:SparseBytes,
            splitSparseBytes(Suffix:SparseBytes, Prefix:SparseBytes, 0),
            _:Int
        )
        => concat(updateSparseBytes(Fn, Prefix, Addr, Width), Suffix)
        [simplification]


    rule splitSparseBytes(SBI:SBItemChunk SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SB, concat(Prefix, SBI), Addr -Int size(SBI))
        requires size(SBI) <=Int Addr
        [simplification]
    rule splitSparseBytes(concat(SB1:SparseBytes, SB2:SparseBytes), Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SB2, concat(Prefix, SB1), Addr -Int size(SB1))
        requires size(SB1) <=Int Addr
        [simplification]

    rule splitSparseBytes(SBChunk(#bytes(A +Bytes B)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SBChunk(#bytes(B)) SB, concat(Prefix, SBChunk(#bytes(A))), Addr -Int lengthBytes(A))
        requires lengthBytes(A) <=Int Addr
        [simplification]

    rule splitSparseBytes(SBChunk(#bytes(A +Bytes B)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SBChunk(#bytes(A)) SBChunk(#bytes(B)) SB, Prefix, Addr -Int lengthBytes(A))
        requires 0 <Int Addr andBool Addr <Int lengthBytes(A)
        [simplification]
    rule splitSparseBytes(SBChunk(#bytes(A)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes
            ( SBChunk(#bytes(substrBytes(A, Addr, lengthBytes(A))))
              SB
            , concat(Prefix, SBChunk(#bytes(substrBytes(A, 0, Addr))))
            , 0
            )
        requires 0 <Int Addr andBool Addr <Int lengthBytes(A)
        [simplification, concrete(A, Addr)]

    rule splitSparseBytes(
              updateSparseBytes(
                  F:SBSetFunction, SB:SparseBytes, AddrF:Int, WidthF:Int),
              Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes
            ( splitSparseBytesFunction(updateSparseBytes(F, SB, AddrF, WidthF), F, SB, Addr),
            Prefix, Addr
            )
        requires canSplitSparseBytes(F, SB, Addr)
        [simplification]


    rule size(updateSparseBytes(Fn:SBSetFunction, SB:SparseBytes, Start:Int, Width:Int))
        => updateSparseBytesSize(Fn, size(SB), Start, Width)
        [simplification]
endmodule

module UPDATE-SPARSE-BYTES-LEMMAS
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    // ----------------------------
    //    simplify concatenation
    // ----------------------------
    rule updateSparseBytes(
              F:SBSetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => concat(
            SBI,
            updateSparseBytes(F, SB, Start -Int size(SBI), Width))
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool size(SBI) <=Int Start
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => concat(
              updateSparseBytes(F, SBI, Start, Width),
              SB
          )
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SBI)
            andBool 0 <Int size(SB)
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A +Bytes B)),
              Start:Int, Width:Int)
        => concat(
              updateSparseBytes(F, SBChunk(#bytes(A)), Start, Width),
              SBChunk(#bytes(B))
          )
        requires functionSparseBytesWellDefined(F, lengthBytes(A +Bytes B), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int lengthBytes(A)
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A +Bytes B)),
              Start:Int, Width:Int)
        => concat(
              SBChunk(#bytes(A)),
              updateSparseBytes(F, SBChunk(#bytes(B)), Start -Int lengthBytes(A), Width)
          )
        requires functionSparseBytesWellDefined(F, lengthBytes(A +Bytes B), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool lengthBytes(A) <=Int Start +Int Width
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
            SB1,
            updateSparseBytes(F, SB2, Start -Int size(SB1), Width))
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
            updateSparseBytes(F, SB1, Start, Width),
            SB2)
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    // ----------------------------
    //      Disjoint ranges
    // ----------------------------
    rule updateSparseBytes(
              F1:SBSetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => updateSparseBytes(
              F1,
              splitSparseBytesFunction(updateSparseBytes(F2, SB, Start2, Width2), F2, SB, Start1),
              Start1, Width1)
        requires disjontRanges(Start1, Width1, Start2, Width2)
          // andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
          andBool canSplitSparseBytes(F2, SB, Start1)
        [simplification]

    // rule updateSparseBytes(
    //           F1:SBSetFunction,
    //           updateSparseBytes(
    //               F2:SBSetFunction,
    //               SB:SparseBytes,
    //               Start2:Int, Width2:Int),
    //           Start1:Int, Width1:Int)
    //     => updateSparseBytes(
    //           F2,
    //           updateSparseBytes(F1, SB, Start1 - startOffset(F2), Width1),
    //           Start2, Width2)
    //     requires disjontRanges(Start1, Width1, Start2, Width2)
    //       andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
    //     [simplification, concrete(Start1,Width1), symbolic(Start2)]
    // rule updateSparseBytes(
    //           F1:SBSetFunction,
    //           updateSparseBytes(
    //               F2:SBSetFunction,
    //               SB:SparseBytes,
    //               Start2:Int, Width2:Int),
    //           Start1:Int, Width1:Int)
    //     => updateSparseBytes(
    //           F2,
    //           updateSparseBytes(F1, SB, Start1 - startOffset(F2), Width1),
    //           Start2, Width2)
    //     requires disjontRanges(Start1, Width1, Start2, Width2)
    //       andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
    //   [simplification, concrete(Start1,Width1,Start2), symbolic(Width2)]

    // rule updateSparseBytes(
    //           F1:SBSetFunction,
    //           updateSparseBytes(
    //               F2:SBSetFunction,
    //               SB:SparseBytes,
    //               Start2:Int, Width2:Int),
    //           Start1:Int, Width1:Int)
    //     => updateSparseBytes(
    //           F2,
    //           updateSparseBytes(F1, SB, Start1 - startOffset(F2), Width1),
    //           Start2:Int, Width2:Int)
    //     requires disjontRanges(Start1, Width1, Start2, Width2)
    //       andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
    //       andBool Start1 <Int Start2
    //   [simplification, concrete(Start1,Width1,Start2,Width2)]
    // rule updateSparseBytes(
    //           F1:SBSetFunction,
    //           updateSparseBytes(
    //               F2:SBSetFunction,
    //               SB:SparseBytes,
    //               Start2:Int, Width2:Int),
    //           Start1:Int, Width1:Int)
    //     => updateSparseBytes(
    //           F2,
    //           updateSparseBytes(F1, SB, Start1 - startOffset(F2), Width1),
    //           Start2:Int, Width2:Int)
    //     requires disjontRanges(Start1, Width1, Start2, Width2)
    //       andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
    //       andBool Start1 <Int Start2
    //   [simplification, concrete(Start2),symbolic(Width2)]
    // rule updateSparseBytes(
    //           F1:SBSetFunction,
    //           updateSparseBytes(
    //               F2:SBSetFunction,
    //               SB:SparseBytes,
    //               Start2:Int, Width2:Int),
    //           Start1:Int, Width1:Int)
    //     => updateSparseBytes(
    //           F2,
    //           updateSparseBytes(F1, SB, Start1 - startOffset(F2), Width1),
    //           Start2:Int, Width2:Int)
    //     requires disjontRanges(Start1, Width1, Start2, Width2)
    //       andBool updateSparseBytesCanSwap(F1, Start1, Width1, F2, Start2, Width2, SB)
    //       andBool Start1 <Int Start2
    //   [simplification, symbolic(Start2)]

    // ----------------------------
    //  Included ranges cancelling
    // ----------------------------
    rule updateSparseBytes(
              F1:SBSetFunction,
              updateSparseBytes(
                  _F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => updateSparseBytes(F1, SB, Start1, Width1)
        requires Start1 <=Int Start2 andBool Start2 +Int Width2 <=Int Start1 +Int Width1
        // Assumes that an update over the larger range cancels the narrower range.
      [simplification]

    // ----------------------------
    //     Overlapping ranges
    // ----------------------------

    // Not implemented yet
endmodule

module EXTRACT-SPARSE-BYTES-LEMMAS
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    // Final extraction
    // rule extractSparseBytes(
    //           F:SBGetFunction, SB:SparseBytes, 0, Len
    //       ) => SB
    //     requires functionCommutesAtStart(F)
    //       andBool Len ==Int size(SB)
    // [simplification]


    // ------------------------------------------
    // Simplify concatenation - ignore first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB, Start -Int size(SBI), Width)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool size(SBI) <=Int Start
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB2, Start -Int size(SB1), Width)
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]

    // ------------------------------------------
    // Simplify concatenation - included in first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => substrSparseBytes(SBI, Start, Start +Int Width)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start +Int Width <=Int size(SBI)
            andBool (0 <Int size(SB) orBool F =/=K substr)
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => substrSparseBytes(SBI, Start, Start +Int Width)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Width <Int size(SBI)
            andBool (0 <Int size(SB) orBool F =/=K substr)
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              0, Width:Int)
        => SBI
        requires functionSparseBytesWellDefined(F, size(SBI SB), 0, Width)
            andBool functionCommutesAtStart(F)
            andBool Width ==Int size(SBI)
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB1, Start, Width)
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    // ------------------------------------------
    // Simplify concatenation - overlaps first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Width:Int)
        => concat(
              substrSparseBytes(SBI, Start, size(SBI)),
              extractSparseBytes(F, SB, 0, Width +Int Start -Int size(SBI))
          )
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start <Int size(SBI)
            andBool size(SBI) <Int Start +Int Width
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
              substrSparseBytes(SB1, Start, size(SB1)),
              extractSparseBytes(F, SB2, 0, Width +Int Start -Int size(SB1))
          )
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start <Int size(SB1)
            andBool size(SB1) <Int Start +Int Width
        [simplification]


    // -------------------------------------------
    // With update - Disjoint ranges
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBGetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => extractSparseBytes(F1, SB, Start1 -Int startOffset(F2), Width1)
        requires disjontRanges(Start1, Width1, Start2, Width2)
          andBool functionCommutesAtStart(F1)
          andBool extractSparseBytesCanIgnore(F1, Start1, Width1, F2, Start2, Width2, SB)
        [simplification]

    // -------------------------------------------
    // With update - Included range - Skipping
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBGetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => extractSparseBytes(
              F1,
              getReplacementSparseBytes(F2, SB, Start2, Width2),
              Start1 -Int Start2, Width1
          )
        requires Start2 <=Int Start1 andBool Start1 +Int Width1 <=Int Start2 +Int Width2
          andBool functionCommutesAtStart(F1)
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Width2)
        [simplification]

    // -------------------------------------------
    // With update - Overlapping ranges - Before
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBGetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => concat(
              extractSparseBytes(F1, SB, Start1, Start2 -Int Start1),
              extractSparseBytes(
                  F1, updateSparseBytes(F2, SB, Start2, Width2),
                  Start2, Start1 +Int Width1 -Int Start2)
          )
        requires Start1 <Int Start2 andBool Start2 <Int Start1 +Int Width1
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Width2)
          andBool functionCommutesAtStart(F1)
          andBool functionCommutesAtStart(F2)
        [simplification]

    // -------------------------------------------
    // With update - Overlapping ranges - After
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBGetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => concat(
              extractSparseBytes(
                  F1, updateSparseBytes(F2, SB, Start2, Width2),
                  Start1, Start2 +Int Width2 -Int Start1),
              extractSparseBytes(
                  F1, SB,
                  Start2 +Int Width2 -Int startOffset(F2),
                  Start1 +Int Width1 -Int (Start2 +Int Width2))
          )
        requires Start2 <=Int Start1
          andBool Start1 <Int Start2 +Int Width2
          andBool Start2 +Int Width2 <Int Start1 +Int Width1
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Width2)
          andBool functionCommutesAtStart(F1)
          andBool startOffset(F2) <Int Start2 +Int Width2
        [simplification]

endmodule
```