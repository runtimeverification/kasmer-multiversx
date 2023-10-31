requires "helper-lemmas.md"

module LIST-SIZE
    imports private MX-WASM-LEMMA-PROOFS
    imports private HELPER-LEMMAS

    claim  <mandos>
           <k>
             ( runProof ( basicListInduction ( L:List ) ; .ProofOperationList ) => end )
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
