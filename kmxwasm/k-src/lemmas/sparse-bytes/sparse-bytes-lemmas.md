```k
requires "get-bytes-range-lemmas.md"
requires "get-range-lemmas.md"
requires "handle-sparse-bytes.md"
requires "replace-at-b-lemmas.md"
requires "replace-at-lemmas.md"
requires "set-range-lemmas.md"
requires "sparse-bytes-lemmas-basic.md"
requires "substr-sparse-bytes-lemmas.md"

module SPARSE-BYTES-LEMMAS2
    imports private GET-BYTES-RANGE-LEMMAS
    imports private GET-RANGE-LEMMAS
    imports private HANDLE-SPARSE-BYTES-LEMMAS
    imports private REPLACE-AT-B-LEMMAS
    imports private REPLACE-AT-LEMMAS
    imports private SET-RANGE-LEMMAS
    imports private SPARSE-BYTES-LEMMAS-BASIC
    imports private SUBSTR-SPARSE-BYTES-LEMMAS

    rule concat(A, .SparseBytes) => A
        [simplification]
    rule concat(concat(A:SparseBytes, B:SparseBytes), C:SparseBytes) => concat(A, concat(B, C))
        [simplification]

  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int) +Int B1:Int, Len1:Int
        , (A2:Int modIntTotal M2:Int) +Int B2:Int, Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      )
    [simplification]

  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int), Len1:Int
        , (A2:Int modIntTotal M2:Int) +Int B2:Int, Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int B2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int M2 +Int B2, Len2)
            )
          )
        )
      )
    [simplification]
  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int) +Int B1:Int, Len1:Int
        , (A2:Int modIntTotal M2:Int), Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 , Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int B1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1 +Int B1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      )
    [simplification]
  rule disjontRanges
        ( (A1:Int modIntTotal M1:Int), Len1:Int
        , (A2:Int modIntTotal M2:Int), Len2:Int
        )
      => true
    requires
      ( ( (0 <=Int A1 andBool A1 <Int M1)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      orBool
        ( (0 -Int M1 <=Int A1 andBool A1 <Int 0)
        andBool
          ( ( (A2 >=Int 0 andBool A2 <Int M2)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2, Len2)
            )
          orBool
            ( (0 -Int M2 <=Int A2 andBool A2 <Int 0)
            andBool disjontRangesSimple(A1 +Int M1, Len1, A2 +Int M2, Len2)
            )
          )
        )
      )
    [simplification]
endmodule

```