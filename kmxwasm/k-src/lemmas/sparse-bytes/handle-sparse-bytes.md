```k

module HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
    imports SPARSE-BYTES-LEMMAS-BASIC

    syntax SBFunction ::= "substr"
    syntax SBFunctionData
    syntax SparseBytes ::= updateSparseBytes(
            SBFunction, SparseBytes, start:Int, size:Int, SBFunctionData
        )  [function, total, symbol(updateSparseBytes)]
    syntax Bool ::= functionSparseBytesWellDefined(
            SBFunction, sbSize:Int, start:Int, size:Int, SBFunctionData
        )  [function, total, symbol(functionSparseBytesWellDefined)]
    syntax Int ::= updateSparseBytesSize(
            SBFunction, sbSize:Int, start:Int, size:Int, SBFunctionData
        )  [function, total, symbol(updateSparseBytesSize)]
    syntax Bool ::= functionCommutesAtStart(SBFunction)
        [function, total, symbol(functionCommutesAtStart)]
    syntax SparseBytes ::= getReplacementSparseBytes(
            SBFunction, SparseBytes, start:Int, size:Int, SBFunctionData
        )  [function, total, symbol(getReplacementSparseBytes)]

    syntax Bool ::= updateSparseBytesCanSwap(
                f1:SBFunction, start1:Int, size1:Int, data1:SBFunctionData,
                f2:SBFunction, start2:Int, size2:Int, data2:SBFunctionData,
                SparseBytes)
        [function, total]
    rule updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
        => functionSparseBytesWellDefined(F2, size(SB), Start2, Size2, Data2)
            andBool functionSparseBytesWellDefined(F1, updateSparseBytesSize(F2, size(SB), Start2, Size2, Data2), Start1, Size1, Data1)
            andBool functionSparseBytesWellDefined(F1, size(SB), Start1, Size1, Data1)
            andBool functionSparseBytesWellDefined(F2, updateSparseBytesSize(F1, size(SB), Start1, Size1, Data1), Start2, Size2, Data2)

    syntax SparseBytes ::= extractSparseBytes(
            SBFunction, SparseBytes, start:Int, size:Int, SBFunctionData
        )
        [function, total, symbol(extractSparseBytes)]
    syntax Bool ::= extractSparseBytesCanIgnore(
        f1:SBFunction, start1:Int, size1:Int, data1:SBFunctionData,
        f2:SBFunction, start2:Int, size2:Int, data2:SBFunctionData,
        SparseBytes)
        [function, total, symbol(extractSparseBytesCanIgnore)]
    rule extractSparseBytesCanIgnore(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
        => functionSparseBytesWellDefined(F2, size(SB), Start2, Size2, Data2)
            andBool functionSparseBytesWellDefined(F1, updateSparseBytesSize(F2, size(SB), Start2, Size2, Data2), Start1, Size1, Data1)
            andBool functionSparseBytesWellDefined(F1, size(SB), Start1, Size1, Data1)

endmodule

module HANDLE-SPARSE-BYTES-LEMMAS
    imports private EXTRACT-SPARSE-BYTES-LEMMAS
    imports private UPDATE-SPARSE-BYTES-LEMMAS
endmodule

module UPDATE-SPARSE-BYTES-LEMMAS
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    // ----------------------------
    //    simplify concatenation
    // ----------------------------
    rule updateSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => concat(
            SBI,
            updateSparseBytes(F, SB, Start -Int size(SBI), Size, Data))
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool size(SBI) <=Int Start
        [simplification]

    rule updateSparseBytes(
              F:SBFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => concat(
            SB1,
            updateSparseBytes(F, SB2, Start -Int size(SB1), Size, Data))
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]

    // ----------------------------
    //      Disjoint ranges
    // ----------------------------
    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F2,
              updateSparseBytes(F1, SB, Start1, Size1, Data1),
              Start2, Size2,
              Data2)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
        [simplification, concrete(Start1,Size1), symbolic(Start2)]
    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F2,
              updateSparseBytes(F1, SB, Start1, Size1, Data1),
              Start2, Size2,
              Data2)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
      [simplification, concrete(Start1,Size1,Start2), symbolic(Size2)]

    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F2,
              updateSparseBytes(F1, SB, Start1, Size1, Data1),
              Start2:Int, Size2:Int,
              Data2:SBFunctionData)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
          andBool Start1 <Int Start2
      [simplification, concrete(Start1,Size1,Start2,Size2)]
    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F2,
              updateSparseBytes(F1, SB, Start1, Size1, Data1),
              Start2:Int, Size2:Int,
              Data2:SBFunctionData)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
          andBool Start1 <Int Start2
      [simplification, concrete(Start2),symbolic(Size2)]
    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F2,
              updateSparseBytes(F1, SB, Start1, Size1, Data1),
              Start2:Int, Size2:Int,
              Data2:SBFunctionData)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool updateSparseBytesCanSwap(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
          andBool Start1 <Int Start2
      [simplification, symbolic(Start2)]

    // ----------------------------
    //  Included ranges cancelling
    // ----------------------------
    rule updateSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  _F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  _Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => updateSparseBytes(
              F1,
              SB,
              Start1, Size1,
              Data1)
        requires Start1 <=Int Start2 andBool Start2 +Int Size2 <=Int Start1 +Int Size1
        // Assumes that an update over the larger range cancels the narrower range.
      [simplification]

    // ----------------------------
    //     Overlapping ranges
    // ----------------------------

    // Not implemented yet
endmodule

module EXTRACT-SPARSE-BYTES-LEMMAS
    imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX

    // ------------------------------------------
    // Simplify concatenation - ignore first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => extractSparseBytes(F, SB, Start -Int size(SBI), Size, Data)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool size(SBI) <=Int Start
        [simplification]

    rule extractSparseBytes(
              F:SBFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => extractSparseBytes(F, SB2, Start -Int size(SB1), Size, Data)
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool size(SB1) <=Int Start
        [simplification]

    // ------------------------------------------
    // Simplify concatenation - included in first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => substrSparseBytes(SBI, Start, Start +Int Size)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool 0 <Int Start
            andBool Start +Int Size <=Int size(SBI)
            andBool (0 <Int size(SB) orBool F =/=K substr)
        [simplification]
    rule extractSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => substrSparseBytes(SBI, Start, Start +Int Size)
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Size <Int size(SBI)
            andBool (0 <Int size(SB) orBool F =/=K substr)
        [simplification]
    rule extractSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              0, Size:Int,
              Data:SBFunctionData)
        => SBI
        requires functionSparseBytesWellDefined(F, size(SBI SB), 0, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool Size ==Int size(SBI)
        [simplification]

    rule extractSparseBytes(
              F:SBFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => extractSparseBytes(F, SB1, Start, Size, Data)
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool 0 <=Int Start
            andBool Start +Int Size <=Int size(SB1)
        [simplification]

    // ------------------------------------------
    // Simplify concatenation - overlaps first
    // ------------------------------------------
    rule extractSparseBytes(
              F:SBFunction,
              SBI:SBItemChunk SB:SparseBytes,
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => concat(
              substrSparseBytes(SBI, Start, size(SBI)),
              extractSparseBytes(F, SB, 0, Size +Int Start -Int size(SBI), Data)
          )
        requires functionSparseBytesWellDefined(F, size(SBI SB), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool Start <Int size(SBI)
            andBool size(SBI) <Int Start +Int Size
        [simplification]
    rule extractSparseBytes(
              F:SBFunction,
              concat(SB1:SparseBytes, SB2:SparseBytes),
              Start:Int, Size:Int,
              Data:SBFunctionData)
        => concat(
              substrSparseBytes(SB1, Start, size(SB1)),
              extractSparseBytes(F, SB2, 0, Size +Int Start -Int size(SB1), Data)
          )
        requires functionSparseBytesWellDefined(F, size(concat(SB1, SB2)), Start, Size, Data)
            andBool functionCommutesAtStart(F)
            andBool Start <Int size(SB1)
            andBool size(SB1) <Int Start +Int Size
        [simplification]


    // -------------------------------------------
    // With update - Disjoint ranges
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => extractSparseBytes(F1, SB, Start1, Size1, Data1)
        requires disjontRanges(Start1, Size1, Start2, Size2)
          andBool extractSparseBytesCanIgnore(F1, Start1, Size1, Data1, F2, Start2, Size2, Data2, SB)
        [simplification]

    // -------------------------------------------
    // With update - Included range - Skipping
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => extractSparseBytes(F1, getReplacementSparseBytes(F2, SB, Start2, Size2, Data2), Start1 -Int Start2, Size1, Data1)
        requires Start2 <=Int Start1 andBool Start1 +Int Size1 <=Int Start2 +Int Size2
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Size2, Data2)
        [simplification]

    // -------------------------------------------
    // With update - Overlapping ranges - Before
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => concat(
              extractSparseBytes(F1, SB, Start1, Start2 -Int Start1, Data1),
              extractSparseBytes(
                  F1, updateSparseBytes(F2, SB, Start2, Size2, Data2),
                  Start2, Start1 +Int Size1 -Int Start2, Data1)
          )
        requires Start1 <Int Start2 andBool Start2 <Int Start1 +Int Size1
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Size2, Data2)
        [simplification]

    // -------------------------------------------
    // With update - Overlapping ranges - After
    // -------------------------------------------
    rule extractSparseBytes(
              F1:SBFunction,
              updateSparseBytes(
                  F2:SBFunction,
                  SB:SparseBytes,
                  Start2:Int, Size2:Int,
                  Data2:SBFunctionData),
              Start1:Int, Size1:Int,
              Data1:SBFunctionData)
        => concat(
              extractSparseBytes(
                  F1, updateSparseBytes(F2, SB, Start2, Size2, Data2),
                  Start1, Start2 +Int Size2 -Int Start1, Data1),
              extractSparseBytes(
                  F1, SB,
                  Start2 +Int Size2, Start1 +Int Size1 -Int (Start2 +Int Size2), Data1)
          )
        requires Start2 <=Int Start1
          andBool Start1 <Int Start2 +Int Size2
          andBool Start2 +Int Size2 <Int Start1 +Int Size1
          andBool functionSparseBytesWellDefined(F2, size(SB), Start2, Size2, Data2)
        [simplification]

endmodule
```