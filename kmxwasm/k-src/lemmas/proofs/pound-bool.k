requires "helper-lemmas.md"

module POUND-BOOL
    imports private MX-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS-TRUSTED

    claim  <mandos>
           <k>
             ( runProof ( split ( B:Bool , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) => end )
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
       ensures { 0 <=Int #bool ( B:Bool ) #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( split ( B:Bool , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) => end )
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
       ensures { #bool ( B:Bool ) <=Int 1 #Equals true }


    claim  <mandos>
           <k>
             ( runProof ( split ( B:Bool , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) => end )
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
       ensures { #bool ( B:Bool ) <Int 1 #Equals notBool (B:Bool) }


    claim  <mandos>
           <k>
             ( runProof ( split ( B:Bool , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) => end )
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
       ensures { { 0 #Equals #bool ( B:Bool ) }:Bool #Equals { false #Equals B:Bool }:Bool }


    claim  <mandos>
           <k>
             ( runProof ( split ( B:Bool , .ProofOperationList , .ProofOperationList ) ; .ProofOperationList ) => end )
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
       ensures { { 1 #Equals #bool ( B:Bool ) }:Bool #Equals { true #Equals B:Bool }:Bool }


endmodule
