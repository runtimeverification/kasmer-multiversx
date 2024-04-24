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
            SBSetFunction, start:Int, size:Int
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
            SBSetFunction, start:Int, size:Int
        )  [function, total, symbol(getReplacementSparseBytes)]

    // Must convert to/from for each function
    syntax SparseBytes ::= extractSparseBytes(
            SBGetFunction, SparseBytes, start:Int, size:Int
        )
        [function, total, symbol(extractSparseBytes)]

    syntax SparseBytes ::= splitSparseBytes(
            toSplit:SparseBytes, prefix:SparseBytes, addr:Int
        )
        [function, total]

    syntax Bool ::= canSplitSparseBytes(
                        SBSetFunction, SparseBytes,
                        addr:Int, innerAddr:Int, innerWidth:Int
                    )  [function, total]
                  | #canSplitSparseBytes(SparseBytes, SparseBytes)  [function, total]

    syntax SparseBytes ::= splitSparseBytesFunction(
            function:SparseBytes, SBSetFunction, toSplit:SparseBytes,
            addr:Int, innerAddr:Int, innerWidth:Int
        )
        [function, total]
    syntax SparseBytes ::= #splitSparseBytesFunction(
            function:SparseBytes, toSplit:SparseBytes, splitter:SparseBytes, addr:Int
        )
        [function, total]

    syntax Bool ::= empty(SparseBytes)  [function, total]
    rule empty(.SparseBytes) => true
    rule empty(SBChunk(#bytes(B)) _SB:SparseBytes) => false requires lengthBytes(B) >Int 0
    rule empty(SBChunk(#bytes(B)) SB:SparseBytes) => empty(SB) requires lengthBytes(B) ==Int 0
    rule empty(SBChunk(#empty(N)) _SB:SparseBytes) => false requires N >Int 0
    rule empty(SBChunk(#empty(N)) SB:SparseBytes) => empty(SB) requires N <=Int 0
endmodule

module HANDLE-SPARSE-BYTES-LEMMAS
    imports private EXTRACT-SPARSE-BYTES-LEMMAS
    imports private UPDATE-SPARSE-BYTES-LEMMAS
    imports private SPLIT-SPARSE-BYTES

    rule empty(concat(SB1, _SB2)) => false requires notBool empty(SB1)  [simplification]
    rule empty(concat(SB1, SB2)) => empty(SB2) requires empty(SB1)  [simplification]
    rule empty(merge(SB1, _SB2)) => false requires notBool empty(SB1)  [simplification]
    rule empty(merge(SB1, SB2)) => empty(SB2) requires empty(SB1)  [simplification]
    rule empty(updateSparseBytes(Fn:SBSetFunction, SB:SparseBytes, Start:Int, Width:Int)) => false
        requires (0 <=Int Start)
          andBool (0 <Int startOffset(Fn) orBool notBool empty(SB) orBool 0 <Int Width)
        [simplification]
    rule empty(updateSparseBytes(Fn:SBSetFunction, SB:SparseBytes, Start:Int, Width:Int)) => true
        requires 0 <=Int Start
          andBool 0 ==Int startOffset(Fn) andBool empty(SB) andBool 0 ==Int Width
        [simplification]

endmodule

module SPLIT-SPARSE-BYTES
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    rule canSplitSparseBytes(F:SBSetFunction, SB, Addr, InnerAddr:Int, InnerWidth:Int)
        => #canSplitSparseBytes(SB, splitSparseBytes(SB, .SparseBytes, Addr -Int startOffset(F)))
        requires startOffset(F) <Int Addr
            andBool InnerAddr +Int InnerWidth <=Int Addr
    rule #canSplitSparseBytes(_, splitSparseBytes(Suffix, _, 0)) => true
        requires 0 <Int size(Suffix)
        [simplification]

    rule splitSparseBytesFunction(Function:SparseBytes, F:SBSetFunction, ToSplit:SparseBytes, Addr:Int, InnerAddr:Int, InnerWidth:Int)
        => #splitSparseBytesFunction(
            Function, ToSplit, splitSparseBytes(ToSplit, .SparseBytes, Addr -Int startOffset(F)), Addr
        )
        requires InnerAddr +Int InnerWidth <=Int Addr
    rule #splitSparseBytesFunction(
            updateSparseBytes(Fn:SBSetFunction, _:SparseBytes, Addr:Int, Width:Int),
            _:SparseBytes,
            splitSparseBytes(Suffix:SparseBytes, Prefix:SparseBytes, 0),
            _:Int
        )
        => concat(updateSparseBytes(Fn, Prefix, Addr, Width), Suffix)
        requires Addr +Int Width -Int startOffset(Fn) <=Int size(Prefix)
        [simplification]


    rule splitSparseBytes(SBI:SBItemChunk SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SB, concat(Prefix, SBI), Addr -Int size(SBI))
        requires size(SBI) <=Int Addr
        [simplification]
    rule splitSparseBytes(concat(SB1:SparseBytes, SB2:SparseBytes), Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SB2, concat(Prefix, SB1), Addr -Int size(SB1))
        requires size(SB1) <=Int Addr
        [simplification]
    rule splitSparseBytes(merge(SB1, SB2:SparseBytes), Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SB2, concat(Prefix, SB1), Addr -Int size(SB1))
        requires size(SB1) <=Int Addr
        [simplification]

    rule splitSparseBytes(SBChunk(#bytes(A +Bytes B)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SBChunk(#bytes(B)) SB, concat(Prefix, SBChunk(#bytes(A))), Addr -Int lengthBytes(A))
        requires lengthBytes(A) <=Int Addr
        [simplification]

    rule splitSparseBytes(SBChunk(#bytes(A +Bytes B)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes(SBChunk(#bytes(A)) SBChunk(#bytes(B)) SB, Prefix, Addr)
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
    rule splitSparseBytes(SBChunk(#empty(A)) SB:SparseBytes, Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes
            ( SBChunk(#empty(A -Int Addr))
              SB
            , concat(Prefix, SBChunk(#empty(Addr)))
            , 0
            )
        requires 0 <Int Addr andBool Addr <Int A
        [simplification, concrete(A, Addr)]

    rule splitSparseBytes(
              updateSparseBytes(
                  F:SBSetFunction, SB:SparseBytes, AddrF:Int, WidthF:Int),
              Prefix:SparseBytes, Addr:Int)
        => splitSparseBytes
            ( splitSparseBytesFunction
              ( updateSparseBytes(F, SB, AddrF, WidthF)
              , F, SB, Addr, AddrF, WidthF
              )
            , Prefix, Addr
            )
        requires canSplitSparseBytes(F, SB, Addr, AddrF, WidthF)
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
        requires functionSparseBytesWellDefined(F, Start, Width)
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
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SBI)
            andBool notBool empty(SB)
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A)) SBChunk(#bytes(B)) SB:SparseBytes,
              Start:Int, Width:Int)
        => updateSparseBytes(F, SBChunk(#bytes(A +Bytes B)) SB, Start, Width)
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start <Int lengthBytes(A)
            andBool lengthBytes(A) <Int Start +Int Width
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A +Bytes B)),
              Start:Int, Width:Int)
        => concat(
              updateSparseBytes(F, SBChunk(#bytes(A)), Start, Width),
              SBChunk(#bytes(B))
          )
        requires functionSparseBytesWellDefined(F, Start, Width)
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
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool lengthBytes(A) <=Int Start
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A +Bytes B)),
              Start:Int, Width:Int)
        => concat(
              SBChunk(#bytes(substrBytes(A, 0, Start))),
              updateSparseBytes(F, SBChunk(#bytes(substrBytes(A, Start, lengthBytes(A)) +Bytes B)), 0, Width)
          )
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start <Int lengthBytes(A)
            andBool lengthBytes(A) <Int Start +Int Width
        [simplification, concrete(A, Start)]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A)),
              Start:Int, Width:Int)
        => concat(
              SBChunk(#bytes(substrBytes(A, 0, Start))),
              updateSparseBytes(F, SBChunk(#bytes(substrBytes(A, Start, lengthBytes(A)))), 0, Width)
          )
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start <Int lengthBytes(A)
        [simplification, concrete(A, Start)]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#bytes(A)),
              0, Width:Int)
        => concat(
              updateSparseBytes(F, SBChunk(#bytes(substrBytes(A, 0, Width))), 0, Width),
              SBChunk(#bytes(substrBytes(A, Width, lengthBytes(A))))
          )
        requires functionSparseBytesWellDefined(F, 0, Width)
            andBool functionCommutesAtStart(F)
            andBool Width <Int lengthBytes(A)
        [simplification, concrete(A)]
    rule updateSparseBytes(
              F:SBSetFunction,
              SBChunk(#empty(A)),
              Start:Int, Width:Int)
        => concat(
              SBChunk(#empty(Start)),
              updateSparseBytes(F, SBChunk(#empty(A -Int Start)), 0, Width)
          )
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start <Int A
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
            SB1,
            updateSparseBytes(F, SB2, Start -Int size(SB1), Width))
        requires functionSparseBytesWellDefined(F, Start, Width)
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
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              merge(SB1, SB2:SparseBytes),
              Start:Int, Width:Int)
        => merge(
            SB1,
            updateSparseBytes(F, SB2, Start -Int size(SB1), Width))
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              merge(SB1, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
            updateSparseBytes(F, SB1, Start, Width),
            SB2)
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    rule updateSparseBytes(
              F:SBSetFunction,
              merge(SBChunk(#bytes(B)), merge(SBChunk(#empty(A)), SB2:SparseBytes)),
              Start:Int, Width:Int)
        => updateSparseBytes(
              F:SBSetFunction,
              merge(
                  SBChunk(#bytes(B +Bytes zeros(Start +Int Width -Int lengthBytes(B)))),
                  merge(
                    SBChunk(#empty(A +Int lengthBytes(B) -Int Start -Int Width)), 
                    SB2:SparseBytes
                  )
              ),
              Start:Int, Width:Int)
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start <Int lengthBytes(B)
            andBool lengthBytes(B) <Int Start +Int Width
            andBool Start +Int Width <Int lengthBytes(B) +Int A
        [simplification]
    rule updateSparseBytes(
              F:SBSetFunction,
              merge(SBChunk(#bytes(B)), merge(SBChunk(#empty(A)), SB2:SparseBytes)),
              Start:Int, Width:Int)
        => updateSparseBytes(
              F:SBSetFunction,
              merge(SBChunk(#bytes(B +Bytes zeros(A))), SB2:SparseBytes),
              Start:Int, Width:Int)
        requires functionSparseBytesWellDefined(F, Start, Width)
            andBool functionCommutesAtStart(F)
            andBool Start <Int lengthBytes(B)
            andBool lengthBytes(B) <Int Start +Int Width
            andBool lengthBytes(B) +Int A <=Int Start +Int Width
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
              splitSparseBytesFunction(
                  updateSparseBytes(F2, SB, Start2, Width2),
                  F2, SB, Start1, Start2, Width2
              ),
              Start1, Width1)
        requires disjontRanges(Start1, Width1, Start2, Width2)
          andBool canSplitSparseBytes(F2, SB, Start1, Start2, Width2)
        [simplification]

    // ----------------------------
    //  Included ranges cancelling
    // ----------------------------

    rule updateSparseBytes(
              F1:SBSetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => updateSparseBytes(F1, SB, Start1, Width1)
        requires Start1 <=Int Start2 andBool Start2 +Int Width2 <=Int Start1 +Int Width1
            andBool functionCommutesAtStart(F1)
            andBool functionCommutesAtStart(F2)
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
        requires functionCommutesAtStart(F)
            andBool size(SBI) <=Int Start
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB2, Start -Int size(SB1), Width)
        requires functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              merge(SB1, SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB2, Start -Int size(SB1), Width)
        requires functionCommutesAtStart(F)
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
        requires functionCommutesAtStart(F)
            andBool Start +Int Width <=Int size(SBI)
            andBool notBool empty(SB)
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              concat(SB1:SparseBytes, _SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB1, Start, Width)
        requires functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    rule extractSparseBytes(
              F:SBGetFunction,
              merge(SB1, _SB2:SparseBytes),
              Start:Int, Width:Int)
        => extractSparseBytes(F, SB1, Start, Width)
        requires functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Width <=Int size(SB1)
        [simplification]

    // ------------------------------------------
    // Simplify concatenation - only one chunk
    // ------------------------------------------

    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk,
              Start:Int, Width:Int)
        => substrSparseBytes(SBI, Start, Start +Int Width)
        requires functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start +Int Width <=Int size(SBI)
            andBool F =/=K substr
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk,
              Start:Int, Width:Int)
        => substrSparseBytes(SBI, Start, Start +Int Width)
        requires functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Width <Int size(SBI)
            andBool F =/=K substr
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              SBI:SBItemChunk _SB:SparseBytes,
              0, Width:Int)
        => SBI
        requires functionCommutesAtStart(F)
            andBool Width ==Int size(SBI)
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
        requires functionCommutesAtStart(F)
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
        requires functionCommutesAtStart(F)
            andBool Start <Int size(SB1)
            andBool size(SB1) <Int Start +Int Width
        [simplification]
    rule extractSparseBytes(
              F:SBGetFunction,
              merge(SB1, SB2:SparseBytes),
              Start:Int, Width:Int)
        => concat(
              substrSparseBytes(SB1, Start, size(SB1)),
              extractSparseBytes(F, SB2, 0, Width +Int Start -Int size(SB1))
          )
        requires functionCommutesAtStart(F)
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
          andBool startOffset(F2) <=Int Start1
        [simplification]

    // -------------------------------------------
    // With update - Included range - Skipping
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBGetFunction,
              updateSparseBytes(
                  F2:SBSetFunction,
                  _SB:SparseBytes,
                  Start2:Int, Width2:Int),
              Start1:Int, Width1:Int)
        => extractSparseBytes(
              F1,
              getReplacementSparseBytes(F2, Start2, Width2),
              Start1 -Int Start2, Width1
          )
        requires Start2 <=Int Start1 andBool Start1 +Int Width1 <=Int Start2 +Int Width2
          andBool functionCommutesAtStart(F1)
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
          andBool functionCommutesAtStart(F1)
          andBool startOffset(F2) <Int Start2 +Int Width2
        [simplification]

endmodule
```