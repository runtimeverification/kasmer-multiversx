```k
module HELPER-LEMMAS
    imports private MX-WASM-LEMMA-PROOFS

    claim  <mandos>
           <k>
             ( runProofStep ( tModuloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures ( 0 <=Int (X:Int) %IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) <Int M:Int
               ))


    claim  <mandos>
           <k>
             ( runProofStep ( tModuloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures ( (X:Int) %IntTotal (M:Int) <=Int 0
       andBool ( M:Int <Int (X:Int) %IntTotal (M:Int)
               ))


    claim  <mandos>
           <k>
             ( runProofStep ( moduloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures ( 0 <=Int (X:Int) modIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) <Int M:Int
               ))


    claim  <mandos>
           <k>
             ( runProofStep ( moduloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures ( 0 <=Int (X:Int) modIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) <Int (0) -Int (M:Int)
               ))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( 0 <Int M:Int
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) /IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) ==Int (Z:Int) %IntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( M:Int <Int 0
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) /IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) ==Int (Z:Int) %IntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberIsNumberMulDiv ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires notBool (0 ==Int M:Int)
       ensures X:Int ==Int ((X:Int) *Int (M:Int)) divIntTotal (M:Int)


    claim  <mandos>
           <k>
             ( runProofStep ( modAddMultiple ( ... number: X:Int , multiplier: Y:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires notBool (0 ==Int M:Int)
       ensures (X:Int) modIntTotal (M:Int) ==Int (((Y:Int) *Int (M:Int)) +Int (X:Int)) modIntTotal (M:Int)


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( 0 <Int M:Int
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) divIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) ==Int (Z:Int) modIntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))


    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( M:Int <Int 0
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) divIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) ==Int (Z:Int) modIntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))


endmodule

module HELPER-LEMMAS-TRUSTED
    imports private MX-WASM-LEMMA-PROOFS

    claim  <mandos>
           <k>
             ( runProofStep ( tModuloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures ( 0 <=Int (X:Int) %IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) <Int M:Int
               ))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( tModuloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures ( (X:Int) %IntTotal (M:Int) <=Int 0
       andBool ( M:Int <Int (X:Int) %IntTotal (M:Int)
               ))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( moduloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures ( 0 <=Int (X:Int) modIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) <Int M:Int
               ))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( moduloBetween0AndM ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures ( 0 <=Int (X:Int) modIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) <Int (0) -Int (M:Int)
               ))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( 0 <Int M:Int
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) /IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) ==Int (Z:Int) %IntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsTDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( M:Int <Int 0
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) /IntTotal (M:Int)
       andBool ( (X:Int) %IntTotal (M:Int) ==Int (Z:Int) %IntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) /IntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) %IntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires 0 <Int M:Int
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModulo ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires M:Int <Int 0
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberIsNumberMulDiv ( ... number: X:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires notBool (0 ==Int M:Int)
       ensures X:Int ==Int ((X:Int) *Int (M:Int)) divIntTotal (M:Int)
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( modAddMultiple ( ... number: X:Int , multiplier: Y:Int , mod: M:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires notBool (0 ==Int M:Int)
       ensures (X:Int) modIntTotal (M:Int) ==Int (((Y:Int) *Int (M:Int)) +Int (X:Int)) modIntTotal (M:Int)
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( 0 <Int M:Int
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) divIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) ==Int (Z:Int) modIntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))
      [trusted()]

    claim  <mandos>
           <k>
             ( runProofStep ( numberAsDivModuloHelper ( ... number: X:Int , mod: M:Int , divresult: Y:Int , modresult: Z:Int ) ) => end )
             ...
           </k>
           <commands>
             .K
           </commands>
           <instrs>
             .K
           </instrs>
           ...
         </mandos>
      requires ( M:Int <Int 0
       andBool ( X:Int ==Int ((Y:Int) *Int (M:Int)) +Int (Z:Int)
       andBool ( Y:Int ==Int ((X:Int) -Int (Z:Int)) divIntTotal (M:Int)
       andBool ( (X:Int) modIntTotal (M:Int) ==Int (Z:Int) modIntTotal (M:Int)
               ))))
       ensures X:Int ==Int (((X:Int) divIntTotal (M:Int)) *Int (M:Int)) +Int ((X:Int) modIntTotal (M:Int))
      [trusted()]

endmodule
```
