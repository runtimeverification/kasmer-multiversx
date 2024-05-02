```k
requires "../ceils.k"

module PAIR-SPECIFIC-LEMMAS
  imports INT
  imports CEILS-SYNTAX

  ```
  Simplification rules for the amounts that occur in an exchange with fees.

  * `Y` is the "100%" value
  * `Z` is the percentage, relative to `Y`
  * `X` is `Y - Z`
  * `A` and `B` are the initial liquidity values
  * `C` is the amount of liquidity being swapped.

  We assume the following:
  * `0 < Y`
  * `0 < Z`
  * `0 <= X`
  * `Y = X + Z`
  * `0 < C`
  * `0 < B`
  * `0 < A`

  The formula we need to prove is
  ```
    ( ( (A + C)
      * ( B
        + ( -1
          * ( ( X * (C * B) ) div ( (Y * A) + (X * C) ) )
          )
        )
      )
    <
      ( ( ( (A * B) + A ) + C )
      +
        ( ( ( (Z * C) div Y ) + 1 )
        * ( B
          + ( -1
            * ( ( X * (C * B) ) div ( (Y * A)  (X * C) ) )
            )
          )
        )
      )
    )
  ```

  Let use denote `X * C * B` by `S`
  and `(Y * A) + (X * C)` by `T`

  In order for the formula to be valid, we need `T != 0`
  which is true because we assumed `0 < Y`, `0 < A`, `0 <= X`.

  ```
    ( ( (A + C)
      * ( B + ( -1 * ( S div T ) ) )
      )
    <
      ( ( ( (A * B) + A ) + C )
      + ( ( ( (Z * C) div Y ) + 1 )
        * ( B + ( -1 * ( S div T ) ) )
        )
      )
    )
  ```

  There are `0 <= epsilon, delta < 1` such that
  * `S div T = S / T - epsilon`
  * `(Z * C) div Y = (Z * C) / Y - delta`
  where `/` is the real number division.

  ```
    ( ( (A + C)
      * ( B + ( -1 * ( S / T - epsilon) ) )
      )
    <
      ( ( ( (A * B) + A ) + C )
      + ( ( ( (Z * C) / Y - delta ) + 1 )
        * ( B + ( -1 * ( S / T - epsilon) ) )
        )
      )
    )
  ```

  Multiply everything by `T`.
  We need: `T > 0`, which we assumed at the start.

  ```
    ( ( (A + C)
      * ( T * B + ( -1 * ( S - epsilon * T ) ) )
      )
    <
      ( A * B * T + A * T + C * T
      + ( ( ( (Z * C) / Y - delta ) + 1 )
        * ( T * B + ( -1 * ( S - epsilon * T) ) )
        )
      )
    )
  ```

  Multiply everything by `Y`.
  We need: `Y > 0`, which we assumed at the start.

  ```
    ( ( (A + C)
      * ( T * B + ( -1 * ( S - epsilon * T ) ) )
      * Y
      )
    <
      ( (A * B * T * Y + A * T * Y + C * T* Y )
      +
        ( ( ( Z * C - delta * Y ) + Y )
        *
          ( T * B + ( -1 * ( S - epsilon * T) ) )
        )
      )
    )
  ```

  Remove parentheses (distributivity):

  ```
    ( ( A * Y * ( T * B + ( -1 * ( S - epsilon * T ) ) ) )
      + ( C * Y * ( T * B + ( -1 * ( S - epsilon * T ) ) ) )
    <
      ( A * B * T * Y + A * T * Y + C * T* Y
      + ( Z * C * ( T * B + ( -1 * ( S - epsilon * T) ) ) )
      + ( Y * ( T * B + ( -1 * ( S - epsilon * T) ) ) )
      - ( delta * Y * ( T * B + ( -1 * ( S - epsilon * T) ) ) )
      )
    )
  ```

  Remove parentheses (distributivity):

  ```
    ( ( ( A * Y * T * B )
      - ( A * Y * S )
      + ( A * Y * epsilon * T )
      + ( C * Y * T * B )
      - ( C * Y * S )
      + ( C * Y * epsilon * T )
      )
    <
      ( ( A * B * T * Y )
      + ( A * T * Y )
      + ( C * T * Y )
      + ( Z * C * T * B )
      - ( Z * C * S )
      + ( Z * C * epsilon * T )
      + ( Y * T * B )
      - ( Y * S )
      + ( Y * T )
      - ( delta * Y * T * B )
      + ( delta * Y * S )
      - ( delta * Y * epsilon * T )
      )
    )
  ```

  Remove common terms: `A * Y * T * B`

  ```
    ( (
      - ( A * Y * S )
      + ( A * Y * epsilon * T )
      + ( C * Y * T * B )
      - ( C * Y * S )
      + ( C * Y * epsilon * T )
      )
    <
      ( ( A * T * Y )
      + ( C * T * Y )
      + ( Z * C * T * B )
      - ( Z * C * S )
      + ( Z * C * epsilon * T )
      + ( Y * T * B )
      - ( Y * S )
      + ( Y * T )
      - ( delta * Y * T * B )
      + ( delta * Y * S )
      - ( delta * Y * epsilon * T )
      )
    )
  ```

  Move terms around:

  ```
    ( ( ( A * Y ) * epsilon * T )
      + ( C * Y * T * B )
      + ( C * Y * epsilon * T )
      + ( Z * C * S )
      + ( Y * S )
      + ( delta * (Y * T * B )
      + ( delta * Y * epsilon * T )
      )
    <
      ( ( A * T * Y )
      + ( C * T * Y )
      + ( Z * C * T * B )
      + ( Z * C * epsilon * T )
      + ( Y * T * B )
      + ( Y * T )
      + ( delta * Y * S )
      + ( C * Y * S )
      + ( A * Y * S )
      )
    )
  ```

  We replace `Y` by `X + Z`

  ```
    ( ( ( A * (X + Z) ) * epsilon * T )
      + ( C * (X + Z) * T * B )
      + ( C * (X + Z) * epsilon * T )
      + ( Z * C * S )
      + ( (X + Z) * S )
      + ( delta * (X + Z) * T * B )
      + ( delta * (X + Z) * epsilon * T )
      )
    <
      ( ( A * T * (X + Z) )
      + ( C * T * (X + Z) )
      + ( Z * C * T * B )
      + ( Z * C * epsilon * T )
      + ( (X + Z) * T * B )
      + ( (X + Z) * T )
      + ( delta * (X + Z) * S )
      + ( C * (X + Z) * S )
      + ( A * (X + Z) * S )
      )
    )
  ```

  Remove parentheses (distributivity):

  ```
    ( ( ( A * X * epsilon * T )
      + ( A * Z * epsilon * T )
      + ( C * X * T * B )
      + ( C * Z * T * B )
      + ( C * X * epsilon * T )
      + ( C * Z * epsilon * T )
      + ( Z * C * S )
      + ( X * S )
      + ( Z * S )
      + ( delta * X * T * B )
      + ( delta * Z * T * B )
      + ( delta * X * epsilon * T )
      + ( delta * Z * epsilon * T )
      )
    <
      ( ( A * T * X )
      + ( A * T * Z )
      + ( C * T * X )
      + ( C * T * Z )
      + ( Z * C * T * B )
      + ( Z * C * epsilon * T )
      + ( X * T * B )
      + ( Z * T * B )
      + ( X * T )
      + ( Z * T )
      + ( delta * X * S )
      + ( delta * Z * S )
      + ( C * X * S )
      + ( C * Z * S )
      + ( A * X * S )
      + ( A * Z * S )
      )
    )
  ```

  Remove common terms: `C*Z*epsilon*T`, `C*Z*T*B`, `Z*C*S`

  ```
    ( ( ( A * X * epsilon * T )
      + ( A * Z * epsilon * T )
      + ( C * X * T * B )
      + ( C * X * epsilon * T )
      + ( X * S )
      + ( Z * S )
      + ( delta * X * T * B )
      + ( delta * Z * T * B )
      + ( delta * X * epsilon * T )
      + ( delta * Z * epsilon * T )
      )
    <
      ( ( A * T * X )
      + ( A * T * Z )
      + ( C * T * X )
      + ( C * T * Z )
      + ( X * T * B )
      + ( Z * T * B )
      + ( X * T )
      + ( Z * T )
      + ( delta * X * S )
      + ( delta * Z * S )
      + ( C * X * S )
      + ( A * X * S )
      + ( A * Z * S )
      )
    )
  ```

  It is enough to prove this with `epsilon=1`
  on the LHS.
  Also, since, actually, `epsilon<1` and `0 < Z`, `0 < A`,
  and `0 < T`, then `Z * A * epsilon * T < Z * A * T`, so we can
  prove the relation with `<=` instead of `<`:

  ```
    ( ( ( A * X * T )
      + ( A * Z * T )
      + ( C * X * T * B )
      + ( C * X * T )
      + ( X * S )
      + ( Z * S )
      + ( delta * X * T * B )
      + ( delta * Z * T * B )
      + ( delta * X * T )
      + ( delta * Z * T )
      )
    <=
      ( ( A * T * X )
      + ( A * T * Z )
      + ( C * T * X )
      + ( C * T * Z )
      + ( X * T * B )
      + ( Z * T * B )
      + ( X * T )
      + ( Z * T )
      + ( delta * X * S )
      + ( delta * Z * S )
      + ( C * X * S )
      + ( A * X * S )
      + ( A * Z * S )
      )
    )
  ```

  Remove common terms: `A*X*T`, `A*Z*T` ans `C*X*T`:

  ```
    ( ( ( C * X * T * B )
      + ( X * S )
      + ( Z * S )
      + ( delta * X * T * B )
      + ( delta * Z * T * B )
      + ( delta * X * T )
      + ( delta * Z * T )
      )
    <=
      ( ( C * T * Z )
      + ( X * T * B )
      + ( Z * T * B )
      + ( X * T )
      + ( Z * T )
      + ( delta * X * S )
      + ( delta * Z * S )
      + ( C * X * S )
      + ( A * X * S )
      + ( A * Z * S )
      )
    )
  ```

  Replace `S`, `T` with the original values:
  * `S := X * C * B`
  * `T := (Y * A) + (X * C)`

  ```
    ( ( ( C * X * ( (Y * A) + (X * C) ) * B )
      + ( X * X * C * B )
      + ( Z * X * C * B )
      + ( delta * X * ( (Y * A) + (X * C) ) * B )
      + ( delta * Z * ( (Y * A) + (X * C) ) * B )
      + ( delta * X * ( (Y * A) + (X * C) ) )
      + ( delta * Z * ( (Y * A) + (X * C) ) )
      )
    <=
      ( ( C * ( (Y * A) + (X * C) ) * Z )
      + ( X * ( (Y * A) + (X * C) ) * B )
      + ( Z * ( (Y * A) + (X * C) ) * B )
      + ( X * ( (Y * A) + (X * C) ) )
      + ( Z * ( (Y * A) + (X * C) ) )
      + ( delta * X * X * C * B )
      + ( delta * Z * X * C * B )
      + ( C * X * X * C * B )
      + ( A * X * X * C * B )
      + ( A * Z * X * C * B )
      )
    )
  ```

  Remove parentheses (distributivity):

  ```
    ( ( ( C * X * Y * A * B )
      + ( C * X * X * C * B )
      + ( X * X * C * B )
      + ( Z * X * C * B )
      + ( delta * X * Y * A * B )
      + ( delta * X * X * C * B )
      + ( delta * Z * Y * A * B )
      + ( delta * Z * X * C * B )
      + ( delta * X * Y * A )
      + ( delta * X * X * C )
      + ( delta * Z * Y * A )
      + ( delta * Z * X * C )
      )
    <=
      ( ( C * Y * A * Z )
      + ( C * X * C * Z )
      + ( X * Y * A * B )
      + ( X * X * C * B )
      + ( Z * Y * A * B )
      + ( Z * X * C * B )
      + ( X * Y * A )
      + ( X * X * C )
      + ( Z * Y * A )
      + ( Z * X * C )
      + ( delta * X * X * C * B )
      + ( delta * Z * X * C * B )
      + ( C * X * X * C * B )
      + ( A * X * X * C * B )
      + ( A * Z * X * C * B )
      )
    )
  ```

  Remove: `C*X*X*C*B`, `X*X*C*B`, `Z*X*C*B`, `delta*X*X*C*B`, `delta*Z*X*C*B`

  ```
    ( ( ( C * X * Y * A * B )
      + ( delta * X * Y * A * B )
      + ( delta * Z * Y * A * B )
      + ( delta * X * Y * A )
      + ( delta * X * X * C )
      + ( delta * Z * Y * A )
      + ( delta * Z * X * C )
      )
    <=
      ( ( C * Y * A * Z )
      + ( C * X * C * Z )
      + ( X * Y * A * B )
      + ( Z * Y * A * B )
      + ( X * Y * A )
      + ( X * X * C )
      + ( Z * Y * A )
      + ( Z * X * C )
      + ( A * X * X * C * B )
      + ( A * Z * X * C * B )
      )
    )
  ```

  Replace `Y` by `X + Z`:

  ```
    ( ( ( C * X * (X + Z) * A * B )
      + ( delta * X * (X + Z) * A * B )
      + ( delta * Z * (X + Z) * A * B )
      + ( delta * X * (X + Z) * A )
      + ( delta * X * X * C )
      + ( delta * Z * (X + Z) * A )
      + ( delta * Z * X * C )
      )
    <=
      ( ( C * (X + Z) * A * Z )
      + ( C * X * C * Z )
      + ( X * (X + Z) * A * B )
      + ( Z * (X + Z) * A * B )
      + ( X * (X + Z) * A )
      + ( X * X * C )
      + ( Z * (X + Z) * A )
      + ( Z * X * C )
      + ( A * X * X * C * B )
      + ( A * Z * X * C * B )
      )
    )
  ```

  Distributivity:

  ```
    ( ( ( C * X * X * A * B )
      + ( C * X * Z * A * B )
      + ( delta * X * X * A * B )
      + ( delta * X * Z * A * B )
      + ( delta * Z * X * A * B )
      + ( delta * Z * Z * A * B )
      + ( delta * X * X * A )
      + ( delta * X * Z * A )
      + ( delta * X * X * C )
      + ( delta * Z * X * A )
      + ( delta * Z * Z * A )
      + ( delta * Z * X * C )
      )
    <=
      ( ( C * X * A * Z )
      + ( C * Z * A * Z )
      + ( C * X * C * Z )
      + ( X * X * A * B )
      + ( X * Z * A * B )
      + ( Z * X * A * B )
      + ( Z * Z * A * B )
      + ( X * X * A )
      + ( X * Z * A )
      + ( X * X * C )
      + ( Z * X * A )
      + ( Z * Z * A )
      + ( Z * X * C )
      + ( A * X * X * C * B )
      + ( A * Z * X * C * B )
      )
    )
  ```

  Remove: `C*X*X*A*B`, `C*X*Z*A*B`

  ```
    ( ( ( delta * X * X * A * B )
      + ( delta * X * Z * A * B )
      + ( delta * Z * X * A * B )
      + ( delta * Z * Z * A * B )
      + ( delta * X * X * A )
      + ( delta * X * Z * A )
      + ( delta * X * X * C )
      + ( delta * Z * X * A )
      + ( delta * Z * Z * A )
      + ( delta * Z * X * C )
      )
    <=
      ( ( C * X * A * Z )
      + ( C * Z * A * Z )
      + ( C * X * C * Z )
      + ( X * X * A * B )
      + ( X * Z * A * B )
      + ( Z * X * A * B )
      + ( Z * Z * A * B )
      + ( X * X * A )
      + ( X * Z * A )
      + ( X * X * C )
      + ( Z * X * A )
      + ( Z * Z * A )
      + ( Z * X * C )
      )
    )
  ```

  As above, it is enough to solve when `delta=1`:

  ```
    ( ( ( X * X * A * B )
      + ( X * Z * A * B )
      + ( Z * X * A * B )
      + ( Z * Z * A * B )
      + ( X * X * A )
      + ( X * Z * A )
      + ( X * X * C )
      + ( Z * X * A )
      + ( Z * Z * A )
      + ( Z * X * C )
      )
    <=
      ( ( C * X * A * Z )
      + ( C * Z * A * Z )
      + ( C * X * C * Z )
      + ( X * X * A * B )
      + ( X * Z * A * B )
      + ( Z * X * A * B )
      + ( Z * Z * A * B )
      + ( X * X * A )
      + ( X * Z * A )
      + ( X * X * C )
      + ( Z * X * A )
      + ( Z * Z * A )
      + ( Z * X * C )
      )
    )
  ```

  Remove: `X*X*A*B`, `X*Z*A*B`, `Z*X*A*B`, `Z*Z*A*B`, `X*X*A`, `X*Z*A`,
  `X*X*C`, `Z*X*A`, `Z*Z*A`, `Z*X*C`

  ```
    ( 0
    <=
      ( ( C * X * A * Z )
      + ( C * Z * A * Z )
      + ( C * X * C * Z )
      )
    )
  ```

  Divide by `C` (we assumed `C > 0`) and `Z` (we assumed `Z > 0`)


  ```
    ( 0
    <=
      ( ( X * A )
      + ( Z * A )
      + ( X * C )
      )
    )
  ```

  All terms above are `>=0` because we assumed `C > 0`, `Z > 0` and `A > 0`,
  so we proved the initial claim.

  ```k
  rule  ( ( (A +Int C)
          *Int
            ( B
            +Int
              ( -1
              *Int
                ( ( X *Int (C *Int B) )
                divIntTotal
                  ( (Y *Int A) +Int (X *Int C) )
                )
              )
            )
          )
        <Int
          ( ( ( (A *Int B) +Int A ) +Int C )
          +Int
            ( ( ( (Z *Int C) divIntTotal Y ) +Int 1 )
            *Int
              ( B
              +Int
                ( -1
                *Int
                  (
                    ( X *Int (C *Int B) )
                  divIntTotal
                    ( (Y *Int A) +Int (X *Int C) )
                  )
                )
              )
            )
          )
        )
      => true
      requires true
        andBool 0 <Int (Y *Int A) +Int (X *Int C)
        andBool 0 <=Int X
        andBool 0 <Int Y
        andBool 0 <Int Z
        andBool Y ==Int X +Int Z
        andBool 0 <Int A
        andBool 0 <Int B
        andBool 0 <Int C
      [simplification]
  rule  ( ( ( ( (A *Int B) +Int A ) +Int C )
          +Int
            ( ( ( (Z *Int C) divIntTotal Y ) +Int 1 )
            *Int
              ( B
              +Int
                ( -1
                *Int
                  (
                    ( X *Int (C *Int B) )
                  divIntTotal
                    ( (Y *Int A) +Int (X *Int C) )
                  )
                )
              )
            )
          )
        <=Int
          ( (A +Int C)
          *Int
            ( B
            +Int
              ( -1
              *Int
                ( ( X *Int (C *Int B) )
                divIntTotal
                  ( (Y *Int A) +Int (X *Int C) )
                )
              )
            )
          )
        )
      => false
      requires true
        andBool 0 <Int (Y *Int A) +Int (X *Int C)
        andBool 0 <=Int X
        andBool 0 <Int Y
        andBool 0 <Int Z
        andBool Y ==Int X +Int Z
        andBool 0 <Int A
        andBool 0 <Int B
        andBool 0 <Int C
      [simplification]
endmodule
```