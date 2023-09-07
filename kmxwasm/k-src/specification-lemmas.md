```k
module SPECIFICATION-LEMMAS
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

endmodule
```