module CEILS-SYNTAX
    imports BOOL
    imports BYTES
    imports INT
    imports WASM-DATA

    syntax Bool ::= definedSubstrBytes(Bytes, startIndex: Int, endIndex: Int)  [function, total]
    syntax Bool ::= definedReplaceAtBytes(dest: Bytes, index: Int, src: Bytes)  [function, total]
    syntax Bool ::= definedPadRightBytes(Bytes, length: Int, value: Int)  [function, total]
    syntax Bool ::= definedModInt(Int, Int)  [function, total]
    syntax Bool ::= definedShlInt(Int, Int)  [function, total]
    syntax Bool ::= definedShrInt(Int, Int)  [function, total]
    syntax Bool ::= definedPowInt(Int, Int)  [function, total]
    syntax Bool ::= definedDivInt(Int, Int)  [function, total]
    syntax Bool ::= definedLog2Int(Int)  [function, total]
    syntax Bool ::= definedProjectBytes(KItem)  [function, total]
    syntax Bool ::= definedProjectInt(KItem)  [function, total]
    syntax Bool ::= definedMapLookup(Map, KItem)  [function, total]

    syntax Bool ::= definedGetInts(Ints, Int)  [function, total]
    syntax Bool ::= definedGetElemSegment(ElemSegment, Int)  [function, total]

    // ---------------------------------------

    syntax Bytes ::= substrBytesTotal(Bytes, startIndex: Int, endIndex: Int)
        [function, total, klabel(substrBytesTotal), symbol, no-evaluators]
    syntax Bytes ::= replaceAtBytesTotal(dest: Bytes, index: Int, src: Bytes)
        [function, total, klabel(replaceAtBytesTotal), symbol, no-evaluators]
    syntax Bytes ::= padRightBytesTotal(Bytes, length: Int, value: Int)
        [function, total, klabel(padRightBytesTotal), symbol, no-evaluators]
    syntax Int ::= Int "modIntTotal" Int
        [function, total, klabel(modIntTotal), symbol, no-evaluators, smt-hook(mod)]
    syntax Int ::= Int "<<IntTotal" Int
        [function, total, klabel(shlIntTotal), symbol, no-evaluators]
    syntax Int ::= Int ">>IntTotal" Int
        [function, total, klabel(shrIntTotal), symbol, no-evaluators]
    syntax Int ::= Int "^IntTotal" Int
        [function, total, klabel(powIntTotal), symbol, no-evaluators]
    syntax Int ::= Int "/IntTotal" Int
        [function, total, klabel(divIntTotal), symbol, no-evaluators, smt-hook(div)]
    syntax Int ::= log2IntTotal(Int)
        [ function, total, klabel(log2IntTotal), symbol, no-evaluators,
          smtlib(log2IntTotal)
        ]
    syntax Bytes ::= projectBytesTotal(KItem)
        [function, total, klabel(projectBytesTotal), symbol, no-evaluators]
    syntax Int ::= projectIntTotal(KItem)
        [function, total, klabel(projectIntTotal), symbol, no-evaluators]


    syntax Int ::= #getIntsTotal(Ints, Int)
        [function, total, klabel(#getIntsTotal), symbol, no-evaluators/*, smtlib(poundGetInts)*/]
    syntax Index ::= #getElemSegmentTotal(ElemSegment, Int)
        [function, total, klabel(#getElemSegmentTotal), symbol, no-evaluators]

endmodule
