requires "helper-lemmas.md"

module POUND-BOOL
    imports private ELROND-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( split ( B:Bool , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
             ( runProof ( proofOperationList ( split ( B:Bool , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
             ( runProof ( proofOperationList ( split ( B:Bool , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
             ( runProof ( proofOperationList ( split ( B:Bool , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
       ensures { 0 #Equals #bool ( B:Bool ) }:Bool #Implies { false #Equals B:Bool }
      #And { false #Equals B:Bool }:Bool #Implies { 0 #Equals #bool ( B:Bool ) }


    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( split ( B:Bool , .List{"proofOperationList"}_BytesStack (  ) , .List{"proofOperationList"}_BytesStack (  ) ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
       ensures { 1 #Equals #bool ( B:Bool ) }:Bool #Implies { true #Equals B:Bool }
      #And { true #Equals B:Bool }:Bool #Implies { 1 #Equals #bool ( B:Bool ) }


endmodule