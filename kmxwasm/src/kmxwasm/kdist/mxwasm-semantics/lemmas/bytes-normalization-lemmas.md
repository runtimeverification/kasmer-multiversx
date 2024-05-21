The normal form for bytes is (A +Bytes (B +Bytes (C +Bytes ... +Bytes (Y +Bytes Z))))

```k
requires "../ceils-syntax.k"

module BYTES-NORMALIZATION-LEMMAS  [symbolic]
    imports BYTES
    imports CEILS-SYNTAX

    rule (A +Bytes B) +Bytes C => A +Bytes (B +Bytes C)  [simplification]
    rule A +Bytes (B +Bytes C) => (A +Bytes B) +Bytes C
        [simplification, concrete(A, B), symbolic(C)]

    rule b"" +Bytes A => A
    rule A +Bytes b"" => A

    rule N <=Int Bytes2Int(_:Bytes, _:Endianness, Unsigned)
          => true
        requires N <=Int 0
        [simplification]

    rule Bytes2Int(Int2Bytes(Length:Int, Value:Int, E), E:Endianness, Unsigned)
        => Value modInt (2 ^Int (Length *Int 8))
        requires 0 <=Int Value andBool 0 <=Int Length
        [simplification, preserves-definedness]
        // The ^Int arguments are >= 0. The modInt argument is >= 1

    rule Bytes2Int(Int2Bytes(1, Value:Int, _:Endianness), _:Endianness, Unsigned)
        => Value modInt 256
        requires 0 <=Int Value
        [simplification, preserves-definedness]
        // The modInt argument is > 0

    rule Bytes2Int(Int2Bytes(Value:Int, E, S), E:Endianness, S:Signedness)
        => Value
        [simplification]
    rule Bytes2Int(Int2Bytes(Value:Int, E, Signed), E:Endianness, Unsigned)
        => Value
        requires 0 <=Int Value
        [simplification]
    rule Bytes2Int(A +Bytes B, LE, Unsigned)
        => Bytes2Int(A, LE, Unsigned) +Int Bytes2Int(B, LE, Unsigned) <<Int (8 *Int lengthBytes(A))
        [simplification, concrete(A), preserves-definedness]
        // The <<Int argument is >= 0.

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
    rule substrBytesTotal(_, Start:Int, Start:Int)
        => b""
        [simplification(40)]

    rule substrBytesTotal(Int2Bytes(Size:Int, Value:Int, LE), Start:Int, End:Int)
        => Int2Bytes(
            End -Int Start,
            (Value >>Int (8 *Int Start)),
            LE
        )
        requires 0 <=Int Start andBool Start <=Int End andBool End <=Int Size
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
    rule padRightBytesTotal(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2:Int, Value:Int)
        => padRightBytesTotal(B, maxInt (Length1, Length2), Value:Int)
        requires definedPadRightBytes(B, Length1, Value)
            andBool definedPadRightBytes(padRightBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2, Value)
        [simplification]

    rule padLeftBytesTotal (B:Bytes, Length:Int, Value:Int) => B
        requires Length <=Int lengthBytes(B)
            andBool definedPadLeftBytes(B, Length, Value)
    rule padLeftBytesTotal(padLeftBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2:Int, Value:Int)
        => padLeftBytesTotal(B, maxInt (Length1, Length2), Value:Int)
        requires definedPadLeftBytes(B, Length1, Value)
            andBool definedPadLeftBytes(padLeftBytesTotal(B:Bytes, Length1:Int, Value:Int), Length2, Value)
        [simplification]


    rule lengthBytes(Int2Bytes(Len:Int, _:Int, _:Endianness)) => Len  [simplification]
    rule lengthBytes(substrBytesTotal(B:Bytes, Start:Int, End:Int)) => End -Int Start
        requires definedSubstrBytes(B, Start, End)
        [simplification]
    rule lengthBytes(padRightBytesTotal(B:Bytes, Length:Int, Value:Int))
        => maxInt(lengthBytes(B:Bytes), Length:Int)
        requires definedPadRightBytes(B, Length, Value)
        [simplification]
    rule lengthBytes(padLeftBytesTotal(B:Bytes, Length:Int, Value:Int))
        => maxInt(lengthBytes(B:Bytes), Length:Int)
        requires definedPadLeftBytes(B, Length, Value)
        [simplification]
    rule lengthBytes(zeros(Len)) => Len  [simplification]
    rule lengthBytes(A +Bytes B) => lengthBytes(A) +Int lengthBytes(B)
        [simplification]
    rule 0 <=Int lengthBytes(_:Bytes) => true
        [simplification, smt-lemma]
    rule lengthBytes(replaceAtBytesTotal(Dest:Bytes, Index:Int, Src:Bytes))
        => lengthBytes(Dest)
        requires 0 <=Int Index andBool Index +Int lengthBytes(Src) <=Int lengthBytes(Dest)
        [simplification]

    rule { b"" #Equals Int2Bytes(Len:Int, _Value:Int, _E:Endianness) }:Bool
        => {0 #Equals Len}
        [simplification]
    rule { b"" #Equals Int2Bytes(Value:Int, _E:Endianness, _S:Signedness) }:Bool
        => {0 #Equals Value}
        [simplification]
    rule { b"" #Equals substrBytesTotal(B:Bytes, Start:Int, End:Int) }
        => {0 #Equals End -Int Start}
        requires definedSubstrBytes(B, Start, End)
        [simplification]
    rule { b"" #Equals A }
        => #Bottom
        requires lengthBytes(A) >Int 0
        [simplification(100)]


endmodule
```
