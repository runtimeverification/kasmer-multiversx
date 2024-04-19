requires "helper-lemmas.k"

module INT-INEQUALITIES-SIMPLE
    imports private MX-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS-TRUSTED

    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int >Int Y:Int #Equals Y:Int <Int X:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int >=Int Y:Int #Equals Y:Int <=Int X:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int X:Int #Equals false }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int X:Int #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) +Int (Y:Int) <=Int X:Int #Equals Y:Int <=Int 0 }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (Y:Int) +Int (X:Int) <=Int X:Int #Equals Y:Int <=Int 0 }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) +Int (Y:Int) <Int X:Int #Equals Y:Int <Int 0 }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (Y:Int) +Int (X:Int) <Int X:Int #Equals Y:Int <Int 0 }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int (X:Int) +Int (Y:Int) #Equals 0 <=Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int (Y:Int) +Int (X:Int) #Equals 0 <=Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int (X:Int) +Int (Y:Int) #Equals 0 <Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int (Y:Int) +Int (X:Int) #Equals 0 <Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { notBool (X:Int <=Int Y:Int) #Equals Y:Int <Int X:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { notBool (X:Int <Int Y:Int) #Equals Y:Int <=Int X:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) +Int (Y:Int) <=Int Z:Int #Equals X:Int <=Int (Z:Int) -Int (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) +Int (Y:Int) <Int Z:Int #Equals X:Int <Int (Z:Int) -Int (Y:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int (Y:Int) +Int (Z:Int) #Equals (X:Int) -Int (Z:Int) <=Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int (Y:Int) +Int (Z:Int) #Equals (X:Int) -Int (Z:Int) <Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) -Int (Y:Int) <=Int Z:Int #Equals X:Int <=Int (Y:Int) +Int (Z:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) -Int (Y:Int) <Int Z:Int #Equals X:Int <Int (Y:Int) +Int (Z:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) -Int (Y:Int) <=Int Z:Int #Equals (X:Int) -Int (Z:Int) <=Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { (X:Int) -Int (Y:Int) <Int Z:Int #Equals (X:Int) -Int (Z:Int) <Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int (Y:Int) -Int (Z:Int) #Equals (X:Int) +Int (Z:Int) <=Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int (Y:Int) -Int (Z:Int) #Equals (X:Int) +Int (Z:Int) <Int Y:Int }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <=Int (Y:Int) -Int (Z:Int) #Equals Z:Int <=Int (Y:Int) -Int (X:Int) }


    claim  <mandos>
           <k>
             ( runProof ( var ( X:Int ) ; var ( Y:Int ) ; var ( Y:Int ) ; var ( Z:Int ) ; var ( Z:Int ) ; .ProofOperationList ) => end )
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
       ensures { X:Int <Int (Y:Int) -Int (Z:Int) #Equals Z:Int <Int (Y:Int) -Int (X:Int) }


endmodule
