```k
module BACKEND-FIXES
  imports BOOL
  imports BYTES
  imports INT

  syntax Bool ::= definedSubstrBytes(Bytes, startIndex: Int, endIndex: Int)  [function, total]
  rule definedSubstrBytes(B:Bytes, StartIndex:Int, EndIndex:Int)
      => (0 <=Int StartIndex) andBool (0 <=Int EndIndex)
          andBool (StartIndex <Int lengthBytes(B))
          andBool (EndIndex <=Int lengthBytes(B))
  // syntax Bytes ::= #substrBytes(Bytes, startIndex: Int, endIndex: Int)  [function, total]
  // rule substrBytes(B:Bytes, Start:Int, End:Int) => #substrBytes(B, Start, End)
  //     requires definedSubstrBytes(B, Start, End)
  //     [symbolic, simplification]
  // rule #substrBytes(B:Bytes, Start:Int, End:Int) => substrBytes(B, Start, End)
  //     requires definedSubstrBytes(B, Start, End)
  //     [concrete]
  // rule #substrBytes(B:Bytes, Start:Int, End:Int) => .Bytes
  //     requires notBool definedSubstrBytes(B, Start, End)
  //     [concrete]

  syntax Bool ::= definedReplaceAtBytes(dest: Bytes, index: Int, src: Bytes)  [function, total]
  rule definedReplaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes)
      =>  (0 <=Int Index)
          andBool (Index +Int lengthBytes(Src) <=Int lengthBytes(Dest))
  // syntax Bytes ::= #replaceAtBytes(dest: Bytes, index: Int, src: Bytes)  [function, total, no-]
  // rule replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes) => #replaceAtBytes(Dest, Index, Src)
  //     requires definedReplaceAtBytes(Dest, Index, Src)
  //     [symbolic, simplification]
  // rule #replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes) => replaceAtBytes(Dest, Index, Src)
  //     requires definedReplaceAtBytes(Dest, Index, Src)
  //     [concrete, simplification]
  // rule #replaceAtBytes(Dest:Bytes, Index:Int, Src:Bytes) => .Bytes
  //     requires notBool definedReplaceAtBytes(Dest, Index, Src)
  //     [concrete, simplification]

  syntax Bool ::= definedPadRightBytes(Bytes, length: Int, value: Int)  [function, total]
  rule definedPadRightBytes(_B:Bytes, Length:Int, Value:Int)
      =>  (0 <=Int Length)
          andBool (0 <=Int Value)
          andBool (Value <=Int 255)

endmodule
```