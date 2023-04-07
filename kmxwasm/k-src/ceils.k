module CEILS
    imports BOOL
    imports BYTES
    imports INT

    syntax Bool ::= definedSubstrBytes(Bytes, startIndex: Int, endIndex: Int)  [function, total]
    rule definedSubstrBytes(B:Bytes, StartIndex:Int, EndIndex:Int)
        => (0 <=Int StartIndex) andBool (0 <=Int EndIndex)
            andBool (StartIndex <Int lengthBytes(B))
            andBool (EndIndex <=Int lengthBytes(B))
            andBool (StartIndex <=Int EndIndex)


    syntax Bool ::= definedReplaceAtBytes(dest: Bytes, index: Int, src: Bytes)  [function, total]
    rule definedReplaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
        =>  (0 <=Int Index)
            andBool (Index +Int lengthBytes(Src) <=Int lengthBytes(Dest))


    syntax Bool ::= definedPadRightBytes(Bytes, length: Int, value: Int)  [function, total]
    rule definedPadRightBytes(_B:Bytes, Length:Int, Value:Int)
        =>  (0 <=Int Length)
            andBool (0 <=Int Value)
            andBool (Value <=Int 255)


    syntax Bool ::= definedModInt(Int, Int)  [function, total]
    rule definedModInt (_:Int, X:Int) => X =/=Int 0


    // ---------------------------------------


    rule #Ceil(substrBytes(@Arg0:Bytes, @StartIndex:Int, @EndIndex:Int))
        =>  ((({ definedSubstrBytes(@Arg0, @StartIndex, @EndIndex)  #Equals true }
          #And #Ceil(@Arg0))
          #And #Ceil(@StartIndex))
          #And #Ceil(@EndIndex))
        [simplification]


    syntax Bytes ::= substrBytesTotal(Bytes, startIndex: Int, endIndex: Int)
        [function, total, klabel(substrBytesTotal), symbol, no-evaluators]

    rule substrBytesTotal(Arg0:Bytes, StartIndex:Int, EndIndex:Int)
        => substrBytes(Arg0, StartIndex, EndIndex)
        requires definedSubstrBytes(Arg0, StartIndex, EndIndex)
        [concrete, simplification]

    rule substrBytes(Arg0:Bytes, StartIndex:Int, EndIndex:Int)
        => substrBytesTotal(Arg0, StartIndex, EndIndex)
        requires definedSubstrBytes(Arg0, StartIndex, EndIndex)
        [symbolic(Arg0), simplification]

    rule substrBytes(Arg0:Bytes, StartIndex:Int, EndIndex:Int)
        => substrBytesTotal(Arg0, StartIndex, EndIndex)
        requires definedSubstrBytes(Arg0, StartIndex, EndIndex)
        [symbolic(StartIndex), simplification]

    rule substrBytes(Arg0:Bytes, StartIndex:Int, EndIndex:Int)
        => substrBytesTotal(Arg0, StartIndex, EndIndex)
        requires definedSubstrBytes(Arg0, StartIndex, EndIndex)
        [symbolic(EndIndex), simplification]

    rule #Ceil(replaceAtBytes(@Dest:Bytes, @Index:Int, @Src:Bytes))
        =>  ((({ definedReplaceAtBytes(@Dest, @Index, @Src)  #Equals true }
          #And #Ceil(@Dest))
          #And #Ceil(@Index))
          #And #Ceil(@Src))
        [simplification]


    syntax Bytes ::= replaceAtBytesTotal(dest: Bytes, index: Int, src: Bytes)
        [function, total, klabel(replaceAtBytesTotal), symbol, no-evaluators]

    rule replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes)
        => replaceAtBytes(Dest, Index, Src)
        requires definedReplaceAtBytes(Dest, Index, Src)
        [concrete, simplification]

    rule replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
        => replaceAtBytesTotal(Dest, Index, Src)
        requires definedReplaceAtBytes(Dest, Index, Src)
        [symbolic(Dest), simplification]

    rule replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
        => replaceAtBytesTotal(Dest, Index, Src)
        requires definedReplaceAtBytes(Dest, Index, Src)
        [symbolic(Index), simplification]

    rule replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
        => replaceAtBytesTotal(Dest, Index, Src)
        requires definedReplaceAtBytes(Dest, Index, Src)
        [symbolic(Src), simplification]

    rule #Ceil(padRightBytes(@Arg0:Bytes, @Length:Int, @Value:Int))
        =>  ((({ definedPadRightBytes(@Arg0, @Length, @Value)  #Equals true }
          #And #Ceil(@Arg0))
          #And #Ceil(@Length))
          #And #Ceil(@Value))
        [simplification]


    syntax Bytes ::= padRightBytesTotal(Bytes, length: Int, value: Int)
        [function, total, klabel(padRightBytesTotal), symbol, no-evaluators]

    rule padRightBytesTotal(Arg0:Bytes, Length:Int, Value:Int)
        => padRightBytes(Arg0, Length, Value)
        requires definedPadRightBytes(Arg0, Length, Value)
        [concrete, simplification]

    rule padRightBytes(Arg0:Bytes, Length:Int, Value:Int)
        => padRightBytesTotal(Arg0, Length, Value)
        requires definedPadRightBytes(Arg0, Length, Value)
        [symbolic(Arg0), simplification]

    rule padRightBytes(Arg0:Bytes, Length:Int, Value:Int)
        => padRightBytesTotal(Arg0, Length, Value)
        requires definedPadRightBytes(Arg0, Length, Value)
        [symbolic(Length), simplification]

    rule padRightBytes(Arg0:Bytes, Length:Int, Value:Int)
        => padRightBytesTotal(Arg0, Length, Value)
        requires definedPadRightBytes(Arg0, Length, Value)
        [symbolic(Value), simplification]

    rule #Ceil(@Arg0:Int modInt @Arg1:Int)
        =>  (({ definedModInt(@Arg0, @Arg1)  #Equals true }
          #And #Ceil(@Arg0))
          #And #Ceil(@Arg1))
        [simplification]


    syntax Int ::= Int "modIntTotal" Int
        [function, total, klabel(modIntTotal), symbol, no-evaluators]

    rule Arg0:Int modIntTotal Arg1:Int
        => Arg0 modInt Arg1
        requires definedModInt(Arg0, Arg1)
        [concrete, simplification]

    rule Arg0:Int modInt Arg1:Int
        => Arg0 modIntTotal Arg1
        requires definedModInt(Arg0, Arg1)
        [symbolic(Arg0), simplification]

    rule Arg0:Int modInt Arg1:Int
        => Arg0 modIntTotal Arg1
        requires definedModInt(Arg0, Arg1)
        [symbolic(Arg1), simplification]

endmodule
