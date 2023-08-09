requires "helper-lemmas.md"

module MAX-INEQUALITIES
    imports private ELROND-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int <=Int Y:Int
        orBool ( X:Int <=Int Z:Int
               ))
       ensures { X:Int <=Int maxInt ( Y:Int , Z:Int ) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int <Int Y:Int
        orBool ( X:Int <Int Z:Int
               ))
       ensures { X:Int <Int maxInt ( Y:Int , Z:Int ) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int >=Int Y:Int
       andBool ( X:Int >=Int Z:Int
               ))
       ensures { X:Int >=Int maxInt ( Y:Int , Z:Int ) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int >Int Y:Int
       andBool ( X:Int >Int Z:Int
               ))
       ensures { X:Int >Int maxInt ( Y:Int , Z:Int ) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int <=Int Y:Int
        orBool ( X:Int <=Int Z:Int
               ))
       ensures { maxInt ( Y:Int , Z:Int ) >=Int X:Int #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int <Int Y:Int
        orBool ( X:Int <Int Z:Int
               ))
       ensures { maxInt ( Y:Int , Z:Int ) >Int X:Int #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int >=Int Y:Int
       andBool ( X:Int >=Int Z:Int
               ))
       ensures { maxInt ( Y:Int , Z:Int ) <=Int X:Int #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( var ( X:Int ) , proofOperationList ( split ( Y:Int <=Int Z:Int , proofOperationList ( split ( X:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Z:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) , proofOperationList ( split ( Y:Int <Int Z:Int , .List{"proofOperationList"}_BytesStack (  ) , proofOperationList ( split ( Y:Int <Int X:Int , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) ) => end )
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
      requires ( X:Int >Int Y:Int
       andBool ( X:Int >Int Z:Int
               ))
       ensures { maxInt ( Y:Int , Z:Int ) <Int X:Int #Equals true }


endmodule