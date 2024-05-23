```k
requires "../ceils.k"

module COINDRIP-SPECIFIC-LEMMAS
  imports INT
  imports CEILS-SYNTAX

  ```

  We are trying to prove:
  ```
  0 < A and 0 < B and B <= C and D < B
  implies 0 < (A * C) div B + (-1) * ((A * D) div B)
  ```
  This is equivalent to:
  ```
  0 < A and 0 < B and B <= C and D < B
  implies ((A * D) div B) < (A * C) div B
  ```
  We know that `B <= C` so `(A * C) div B <= (A * B) div B = A`.
  It is enough to prove that
  ```
  0 < A and 0 < B and B <= C and D < B
  implies ((A * D) div B) < A
  ```
  Since `D < B`, we have `A * D < A * B`, i.e., `A * D <= A * B - 1` so it is enough to prove that
  ```
  0 < A and 0 < B and B <= C and 0 < D < B
  implies ((A * B - 1) div B) < A
  ```
  But `(A * B - 1) div B = A - 1`, so the statement above is true.

  ```k
  rule 0 <Int ((A *Int C) divIntTotal B) +Int (-1) *Int ((A *Int D) divIntTotal B)
      => true
      requires 0 <Int A andBool 0 <Int B 
          andBool B <=Int C andBool D <Int B
      [simplification]
endmodule
```