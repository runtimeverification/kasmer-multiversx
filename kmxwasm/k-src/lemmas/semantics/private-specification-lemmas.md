```k
module PRIVATE-SPECIFICATION-LEMMAS
  imports MX-WASM-NO-LOCAL-LEMMAS

  // Y > 0
  rule X /IntTotal Y => 0
      requires 0 <=Int X andBool X <Int Y
      [simplification]
  rule X /IntTotal Y => ((X -Int Y) /IntTotal Y) +Int 1
      requires 0 <Int Y andBool Y <=Int X
      [simplification]
  rule X /IntTotal Y => ((X +Int Y) /IntTotal Y) -Int 1
      requires 0 <Int Y andBool X <Int 0
      [simplification]
  // Y < 0
  rule X /IntTotal Y => 0
      requires Y <Int X andBool X <=Int 0
      [simplification]
  rule X /IntTotal Y => ((X -Int Y) /IntTotal Y) +Int 1
      requires X <=Int Y andBool Y <Int 0
      [simplification]
  rule X /IntTotal Y => ((X +Int Y) /IntTotal Y) -Int 1
      requires Y <Int 0 andBool 0 <Int X
      [simplification]

  // Y > 0
  rule X %IntTotal Y => X
      requires 0 <=Int X andBool X <Int Y
      [simplification]
  rule X %IntTotal Y => (X -Int Y) %IntTotal Y
      requires 0 <Int Y andBool Y <=Int X
      [simplification]
  rule X %IntTotal Y => (X +Int Y) %IntTotal Y
      requires 0 <Int Y andBool X <Int 0
      [simplification]
  // Y < 0
  rule X %IntTotal Y => X
      requires Y <Int X andBool X <=Int 0
      [simplification]
  rule X %IntTotal Y => (X -Int Y) %IntTotal Y
      requires X <=Int Y andBool Y <Int 0
      [simplification]
  rule X %IntTotal Y => (X +Int Y) %IntTotal Y
      requires Y <Int 0 andBool 0 <Int X
      [simplification]


  // Y > 0
  rule X divIntTotal Y => 0
      requires 0 <=Int X andBool X <Int Y
      [simplification]
  rule X divIntTotal Y => ((X -Int Y) divIntTotal Y) +Int 1
      requires 0 <Int Y andBool Y <=Int X
      [simplification]
  rule X divIntTotal Y => ((X +Int Y) divIntTotal Y) -Int 1
      requires 0 <Int Y andBool X <Int 0
      [simplification]
  // Y < 0
  rule X divIntTotal Y => 0
      requires Y <Int 0 andBool 0 <=Int X andBool X <Int 0 -Int Y
      [simplification]
  rule X divIntTotal Y => ((X -Int Y) divIntTotal Y) +Int 1
      requires Y <Int 0 andBool X <Int 0
      [simplification]
  rule X divIntTotal Y => ((X +Int Y) divIntTotal Y) -Int 1
      requires Y <Int 0 andBool 0 -Int Y <=Int X
      [simplification]

  // Y > 0
  rule X modIntTotal Y => X
      requires 0 <=Int X andBool X <Int Y
      [simplification]
  rule X modIntTotal Y => (X -Int Y) modIntTotal Y
      requires 0 <Int Y andBool Y <=Int X
      [simplification]
  rule X modIntTotal Y => (X +Int Y) modIntTotal Y
      requires 0 <Int Y andBool X <Int 0
      [simplification]
  // Y < 0
  rule X modIntTotal Y => X
      requires Y <Int 0 andBool 0 <=Int X andBool X <Int 0 -Int Y
      [simplification]
  rule X modIntTotal Y => (X -Int Y) modIntTotal Y
      requires Y <Int 0 andBool X <Int 0
      [simplification]
  rule X modIntTotal Y => (X +Int Y) modIntTotal Y
      requires Y <Int 0 andBool 0 -Int Y <=Int X
      [simplification]

endmodule
```