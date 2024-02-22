```k
module PROVEN-MX-LEMMAS
    imports private BOOL
    imports private CEILS
    imports private ELROND
    imports private INT
    imports private LIST

    rule  ( 0 <=Int #bool ( _B:Bool ) => true )
      [smt-lemma, simplification()]

    rule  ( #bool ( _B:Bool ) <=Int 1 => true )
      [smt-lemma, simplification()]

    rule  ( #bool ( B:Bool ) <Int 1 => notBool (B:Bool) )
      [simplification()]

    rule  ( { 0 #Equals #bool ( B:Bool ) }:Bool => { false #Equals B:Bool }:Bool )
      [simplification()]

    rule  ( { 1 #Equals #bool ( B:Bool ) }:Bool => { true #Equals B:Bool }:Bool )
      [simplification()]

    rule  ( size ( _L:List ) >=Int 0 => true )
      [smt-lemma, simplification()]

    rule  ( X:Int <=Int maxInt ( Y:Int , Z:Int ) => true )
      requires ( X:Int <=Int Y:Int
        orBool ( X:Int <=Int Z:Int
               ))
      [simplification()]

    rule  ( X:Int <Int maxInt ( Y:Int , Z:Int ) => true )
      requires ( X:Int <Int Y:Int
        orBool ( X:Int <Int Z:Int
               ))
      [simplification()]

    rule  ( X:Int >=Int maxInt ( Y:Int , Z:Int ) => true )
      requires ( X:Int >=Int Y:Int
       andBool ( X:Int >=Int Z:Int
               ))
      [simplification()]

    rule  ( X:Int >Int maxInt ( Y:Int , Z:Int ) => true )
      requires ( X:Int >Int Y:Int
       andBool ( X:Int >Int Z:Int
               ))
      [simplification()]

    rule  ( maxInt ( Y:Int , Z:Int ) >=Int X:Int => true )
      requires ( X:Int <=Int Y:Int
        orBool ( X:Int <=Int Z:Int
               ))
      [simplification()]

    rule  ( maxInt ( Y:Int , Z:Int ) >Int X:Int => true )
      requires ( X:Int <Int Y:Int
        orBool ( X:Int <Int Z:Int
               ))
      [simplification()]

    rule  ( maxInt ( Y:Int , Z:Int ) <=Int X:Int => true )
      requires ( X:Int >=Int Y:Int
       andBool ( X:Int >=Int Z:Int
               ))
      [simplification()]

    rule  ( maxInt ( Y:Int , Z:Int ) <Int X:Int => true )
      requires ( X:Int >Int Y:Int
       andBool ( X:Int >Int Z:Int
               ))
      [simplification()]

    rule  ( ((((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) +Int (T:Int)) modIntTotal (Y:Int) => (((X:Int) +Int (Z:Int)) +Int (T:Int)) modIntTotal (Y:Int) )
      [simplification()]

    rule  ( ((((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) -Int (T:Int)) modIntTotal (Y:Int) => (((X:Int) +Int (Z:Int)) -Int (T:Int)) modIntTotal (Y:Int) )
      [simplification()]

    rule  ( (((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) modIntTotal (Y:Int) => ((X:Int) +Int (Z:Int)) modIntTotal (Y:Int) )
      [simplification()]

    rule  ( ((X:Int) +Int ((Z:Int) modIntTotal (Y:Int))) modIntTotal (Y:Int) => ((X:Int) +Int (Z:Int)) modIntTotal (Y:Int) )
      [simplification()]

    rule  ( (_X:Int) modIntTotal (Y:Int) <Int Y:Int => true )
      requires Y:Int >Int 0
      [smt-lemma, simplification()]

    rule  ( 0 <=Int (_X:Int) modIntTotal (Y:Int) => true )
      requires Y:Int >Int 0
      [smt-lemma, simplification()]

    rule  ( ((X:Int) +Int (Y:Int)) modIntTotal (Z:Int) => ((X:Int) +Int ((Y:Int) modInt (Z:Int))) modIntTotal (Z:Int) )
      requires ( notBool (Z:Int ==Int 0)
       andBool ( Y:Int >=Int Z:Int
               ))
      [concrete(Y,Z), simplification()]

    rule  ( { ((X:Int) +Int (Y:Int)) modIntTotal (M:Int) #Equals ((X:Int) +Int (Z:Int)) modIntTotal (M:Int) }:Bool => { (Y:Int) modIntTotal (M:Int) #Equals (Z:Int) modIntTotal (M:Int) }:Bool )
      [simplification()]

    rule  ( (X:Int) modIntTotal (Y:Int) => X:Int )
      requires ( 0 <=Int X:Int
       andBool ( X:Int <Int Y:Int
               ))
      [simplification()]

endmodule
```
