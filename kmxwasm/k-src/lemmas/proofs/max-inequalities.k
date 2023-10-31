requires "helper-lemmas.md"

module MAX-INEQUALITIES
    imports private MX-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
             ( runProof ( var ( X:Int ) ; split ( Y:Int <=Int Z:Int , split ( X:Int <Int Z:Int , .ProofOperationList , split ( Z:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList , split ( Y:Int <Int Z:Int , .ProofOperationList , split ( Y:Int <Int X:Int , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) ; .ProofOperationList ) => end )
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
