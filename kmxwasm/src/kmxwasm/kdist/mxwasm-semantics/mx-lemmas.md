```k
requires "ceils.k"
requires "lemmas/bytes-normalization-lemmas.md"
requires "lemmas/int-encoding-lemmas.md"
requires "lemmas/int-inequalities-lemmas.md"
requires "lemmas/int-length-lemmas.md"
requires "lemmas/int-normalization-lemmas.md"
requires "lemmas/pair-specific-lemmas.md"
requires "lemmas/sparse-bytes/sparse-bytes-lemmas.md"

module MX-LEMMAS-BASIC
  imports BOOL
  imports GET-BYTES-RANGE-LEMMAS-BASIC
  imports GET-RANGE-LEMMAS-BASIC
  imports HANDLE-SPARSE-BYTES-LEMMAS-SYNTAX
  imports INT
  imports INT-ENCODING-BASIC
  imports INT-LENGTH-LEMMAS-BASIC
  imports INT-NORMALIZATION-LEMMAS-BASIC
  imports REPLACE-AT-B-LEMMAS-BASIC
  imports REPLACE-AT-LEMMAS-BASIC
  imports SET-RANGE-LEMMAS-BASIC
  imports SPARSE-BYTES-LEMMAS-BASIC
  imports SUBSTR-SPARSE-BYTES-LEMMAS-BASIC
endmodule

module MX-UPDATE-MAP
  imports private BOOL
  imports private MAP

  // supply updateMap simplifications to avoid the MAP.updateAll hook error
  // TODO upstream these equations to K:domains.md
  rule updateMap(M, .Map) => M
      [simplification]
  rule updateMap(.Map, M) => M
      [simplification]
  rule updateMap(M1, K |-> V M2) => updateMap(M1[K <- V], M2)
      requires notBool (K in_keys(M2))
      [simplification, preserves-definedness]
endmodule

module MX-LEMMAS  [symbolic]
  imports private BYTES-NORMALIZATION-LEMMAS
  imports private CEILS
  imports private ELROND
  imports private INT-ENCODING-LEMMAS
  imports private INT-INEQUALITIES-LEMMAS
  imports private INT-LENGTH-LEMMAS
  imports private INT-KORE
  imports private INT-NORMALIZATION-LEMMAS
  imports public MX-LEMMAS-BASIC
  imports public MX-UPDATE-MAP
  imports private PAIR-SPECIFIC-LEMMAS
  imports private SET
  imports private SPARSE-BYTES-LEMMAS
  imports private WASM-TEXT

  rule Bytes2Int(#getBytesRange(_:SparseBytes, _:Int, N:Int), _:Endianness, _:Signedness) <Int M:Int
        => true
      requires 2 ^Int (8 *Int N) <=Int M
      [simplification]

  rule {false #Equals B:Bool} => #Not ({true #Equals B:Bool})
      [simplification]

  // rule { _:Int #Equals undefined } => #Top  [simplification]
  rule { (< _:IValType > _:Int) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:FValType > _:Float) #Equals undefined } => #Bottom  [simplification]
  rule { (< _:RefValType > _:Int) #Equals undefined } => #Bottom  [simplification]

  rule { undefined #Equals (< _:IValType > _:Int) } => #Bottom  [simplification]
  rule { undefined #Equals (< _:FValType > _:Float) } => #Bottom  [simplification]
  rule { undefined #Equals (< _:RefValType > _:Int) } => #Bottom  [simplification]

  rule undefined ==K (< _:IValType > _:Int) => false
      [simplification]
  rule undefined ==K (< _:FValType > _:Float) => false
      [simplification]
  rule undefined ==K (< _:RefValType > _:Int) => false
      [simplification]

  rule (< _:IValType > _:Int) ==K undefined => false
      [simplification]
  rule (< _:FValType > _:Float) ==K undefined => false
      [simplification]
  rule (< _:RefValType > _:Int) ==K undefined => false
      [simplification]

  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => maxInt(Addr +Int Width, size(M))
    requires #setRangeActuallySets(Addr, Val, Width)
      [simplification]
  rule size(#setRange(M:SparseBytes, Addr:Int, Val:Int, Width:Int))
    => size(M)
    requires notBool (#setRangeActuallySets(Addr, Val, Width))
      [simplification]

  rule size(replaceAtB(Current:Bytes, Rest:SparseBytes, Start:Int, Value:Bytes))
      => lengthBytes(Current) +Int size(Rest)
      requires Start +Int lengthBytes(Value) <=Int lengthBytes(Current) +Int size(Rest)
      [simplification]

  rule size(replaceAt(Dest:SparseBytes, Index:Int, Src:Bytes))
      => maxInt(size(Dest), Index +Int lengthBytes(Src))
      requires 0 <=Int Index
      [simplification]
  rule size(substrSparseBytes(B:SparseBytes, Start:Int, End:Int))
      => End -Int Start
      requires 0 <=Int Start andBool Start <=Int End andBool End <=Int size(B)
      [simplification]
  rule size(concat(A:SparseBytes, B:SparseBytes)) => size(A) +Int size(B)
      [simplification]
  rule size(merge(A:SBItemChunk, B:SparseBytes)) => size(A) +Int size(B)
      [simplification]
  rule 0 <=Int size(_:SparseBytes) => true
      [simplification]

  rule 0 <=Int #signedTotal(T:IValType, N:Int) => 0 <=Int N andBool N <Int #pow1(T)
      requires definedSigned(T, N)
      [simplification]

  rule #signedTotal(IType:IValType, A:Int modIntTotal M:Int) => A
      requires M ==Int #pow(IType)
          andBool 0 -Int #pow1(IType) <=Int A
          andBool A <Int #pow1(IType)
      [simplification]

  rule -1 <=Int #cmpInt(_:Int, _:Int) => true
      [simplification, smt-lemma]
  rule #cmpInt(_:Int, _:Int) <=Int 1 => true
      [simplification, smt-lemma]

  rule #cmpInt(A:Int, B:Int) <Int 0 => A <Int B
      [simplification]
  rule 0 <Int #cmpInt(A:Int, B:Int) => B <Int A
      [simplification]

  rule #cmpInt(A, B) modIntTotal M ==Int 0 => A ==Int B
      requires M >Int 1
      [simplification]

  rule (A +String B) +String C => A +String (B +String C)
      [simplification, concrete(B,C)]

  rule notBool notBool B => B
      [simplification]

  // rule -1 <=Int #bigIntSign(_) => true  [simplification, smt-lemma]
  // rule #bigIntSign(_) <=Int 1 => true  [simplification, smt-lemma]

  rule X <=Int #bigIntSign(_) => true requires X <=Int -1  [simplification]
  rule X <Int #bigIntSign(_) => true requires X <Int -1  [simplification]
  rule #bigIntSign(_) <=Int X => true requires 1 <=Int X  [simplification]
  rule #bigIntSign(_) <Int X => true requires 1 <Int X  [simplification]

  // TODO: Rewrite the following two rules similar to the third.
  rule 0 <=Int #bigIntSign(X) => true requires 0 <=Int X  [simplification]
  rule #bigIntSign(X) <=Int 0 => true requires X <=Int 0  [simplification]
  rule 0 <Int #bigIntSign(X) => 0 <Int X  [simplification]
  rule #bigIntSign(X) <Int 0 => X <Int 0  [simplification]
  rule #bigIntSign(X) ==Int 0 => X ==Int 0  [simplification]

  // #if is parametric in the sort of the return value, and matching
  // works on exact sort matches, so we need symplification rules
  // for all possible combinations.
  rule #typeMatches(T, #if _ #then A:Val #else B:Val #fi) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:IVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:FVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:RefVal) => true
      requires #typeMatches(T, A) andBool #typeMatches(T, B)
      [simplification]

  // #if is parametric in the sort of the return value, and matching
  // works on exact sort matches, so we need symplification rules
  // for all possible combinations.
  rule #typeMatches(T, #if _ #then A:Val #else B #fi) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:IVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:FVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
  rule #typeMatches(T, #if _ #then A #else B #fi:RefVal) => false
      requires notBool #typeMatches(T, A) andBool notBool #typeMatches(T, B)
      [simplification]
endmodule

```
