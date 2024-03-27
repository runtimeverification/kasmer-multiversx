```k
requires "../ceils-syntax.k"

module BYTES-NORMALIZATION-LEMMAS  [symbolic]
    imports BYTES
    imports CEILS-SYNTAX

    rule A +Bytes (B +Bytes C) => (A +Bytes B) +Bytes C  [simplification]

    rule b"" +Bytes A => A
    rule A +Bytes b"" => A

  rule substrBytesTotal(A:Bytes +Bytes _B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(A, Start, End)
      requires End <=Int lengthBytes(A)
      [simplification]
  rule substrBytesTotal(A:Bytes +Bytes B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(B, Start -Int lengthBytes(A), End -Int lengthBytes(A))
      requires lengthBytes(A) <=Int Start
      [simplification]
  rule substrBytesTotal(A:Bytes +Bytes B:Bytes, Start:Int, End:Int)
      => substrBytesTotal(A, Start, lengthBytes(A)) +Bytes substrBytesTotal(B, 0, End -Int lengthBytes(A))
      requires Start <Int lengthBytes(A) andBool lengthBytes(A) <Int End
      [simplification]
  rule substrBytesTotal(B:Bytes, 0:Int, Len:Int) => B
      requires true
        andBool Len ==Int lengthBytes(B)
      [simplification]

  rule replaceAtBytesTotal(Dest:Bytes, Start:Int, Src:Bytes)
      => substrBytes(Dest, 0, Start)
        +Bytes Src
        +Bytes substrBytes(Dest, Start +Int lengthBytes(Src), lengthBytes(Dest))
      requires 0 <=Int Start andBool Start +Int lengthBytes(Src) <=Int lengthBytes(Dest)
      [simplification]

  rule padRightBytesTotal (B:Bytes, Length:Int, Value:Int) => B
      requires Length <=Int lengthBytes(B)
          andBool definedPadRightBytes(B, Length, Value)
  // rule padRightBytesTotal(replaceAtBytesTotal(Dest:Bytes, Pos:Int, Source:Bytes), Length:Int, Value:Int)
  //     => replaceAtBytesTotal(padRightBytesTotal(Dest, Length, Value), Pos, Source)
  //     requires definedReplaceAtBytes(Dest, Pos, Source)
  //         andBool definedPadRightBytes(Dest, Length, Value)
  //     [simplification]
  rule padRightBytesTotal(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2:Int, Value:Int)
      => padRightBytesTotal(B, maxInt (Length1, Length2), Value:Int)
      requires definedPadRightBytes(B, Length1, Value)
          andBool definedPadRightBytes(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2, Value)
      [simplification]

  rule lengthBytes(substrBytesTotal(B:Bytes, Start:Int, End:Int)) => End -Int Start
      requires definedSubstrBytes(B, Start, End)
      [simplification]
  rule lengthBytes(padRightBytesTotal(B:Bytes, Length:Int, Value:Int))
      => maxInt(lengthBytes(B:Bytes), Length:Int)
      requires definedPadRightBytes(B, Length, Value)
      [simplification]
  rule lengthBytes(A +Bytes B) => lengthBytes(A) +Int lengthBytes(B)
      [simplification]
  rule 0 <=Int lengthBytes(_:Bytes) => true
      [simplification]
  rule lengthBytes(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes))
      => lengthBytes(Dest)
      requires 0 <=Int Index andBool Index +Int lengthBytes(Src) <=Int lengthBytes(Dest)
      [simplification]
endmodule
```
