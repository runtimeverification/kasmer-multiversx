```k
module SPECIFICATION-LEMMAS
    imports private CEILS-SYNTAX
    imports private INT
    imports private LIST

    rule size(ListItem(_) L:List) => 1 +Int size(L)
        [simplification]

    rule maxInt(A:Int, B:Int) => A requires B <=Int A
        [simplification]
    rule maxInt(A:Int, B:Int) => B requires A <=Int B
        [simplification]

    rule minInt(A:Int, B:Int) => B requires B <=Int A
        [simplification]
    rule minInt(A:Int, B:Int) => A requires A <=Int B
        [simplification]

    // Y > 0
    rule X /IntTotal Y => 0
        requires 0 <=Int X andBool X <Int Y
        [simplification]
    rule X /IntTotal Y => 1 +Int ((X -Int Y) /IntTotal Y)
        requires 0 <Int Y andBool Y <=Int X
        [simplification]
    rule X /IntTotal Y => ((X +Int Y) /IntTotal Y) -Int 1
        requires 0 <Int Y andBool X <Int 0
        [simplification]
    // Y < 0
    rule X /IntTotal Y => 0
        requires Y <Int X andBool X <=Int 0
        [simplification]
    rule X /IntTotal Y => 1 +Int ((X -Int Y) /IntTotal Y)
        requires X <=Int Y andBool Y <Int 0
        [simplification]
    rule X /IntTotal Y => ((X +Int Y) /IntTotal Y) -Int 1
        requires Y <Int 0 andBool 0 <Int X
        [simplification]

endmodule
```