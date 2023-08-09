requires "helper-lemmas.md"

module MOD-INT-TOTAL
    imports private MX-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
       ensures { ((((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) +Int (T:Int)) modIntTotal (Y:Int) #Equals (((X:Int) +Int (Z:Int)) +Int (T:Int)) modIntTotal (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
       ensures { ((((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) -Int (T:Int)) modIntTotal (Y:Int) #Equals (((X:Int) +Int (Z:Int)) -Int (T:Int)) modIntTotal (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
       ensures { (((X:Int) modIntTotal (Y:Int)) +Int (Z:Int)) modIntTotal (Y:Int) #Equals ((X:Int) +Int (Z:Int)) modIntTotal (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
       ensures { ((X:Int) +Int ((Z:Int) modIntTotal (Y:Int))) modIntTotal (Y:Int) #Equals ((X:Int) +Int (Z:Int)) modIntTotal (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
      requires Y:Int >Int 0
       ensures { (X:Int) modIntTotal (Y:Int) <Int Y:Int #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
      requires Y:Int >Int 0
       ensures { 0 <=Int (X:Int) modIntTotal (Y:Int) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
      requires ( notBool (Z:Int ==Int 0)
       andBool ( Y:Int >=Int Z:Int
               ))
       ensures { ((X:Int) +Int (Y:Int)) modIntTotal (Z:Int) #Equals ((X:Int) +Int ((Y:Int) modInt (Z:Int))) modIntTotal (Z:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
       ensures { ((X:Int) +Int (Y:Int)) modIntTotal (M:Int) #Equals ((X:Int) +Int (Z:Int)) modIntTotal (M:Int) }:Bool #Implies { (Y:Int) modIntTotal (M:Int) #Equals (Z:Int) modIntTotal (M:Int) }
      #And { (Y:Int) modIntTotal (M:Int) #Equals (Z:Int) modIntTotal (M:Int) }:Bool #Implies { ((X:Int) +Int (Y:Int)) modIntTotal (M:Int) #Equals ((X:Int) +Int (Z:Int)) modIntTotal (M:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( T:Int ) ; var ( M:Int ) ; .ProofOperationList ) => end )
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
      requires ( 0 <=Int X:Int
       andBool ( X:Int <Int Y:Int
               ))
       ensures { (X:Int) modIntTotal (Y:Int) #Equals X:Int }


endmodule
