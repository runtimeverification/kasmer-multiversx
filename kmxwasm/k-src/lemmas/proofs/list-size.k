requires "helper-lemmas.md"

module LIST-SIZE
    imports private ELROND-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( proofOperationList ( basicListInduction ( L:List ) , .List{"proofOperationList"}_BytesStack (  ) ) ) => end )
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
       ensures { size ( L:List ) >=Int 0 #Equals true }


endmodule