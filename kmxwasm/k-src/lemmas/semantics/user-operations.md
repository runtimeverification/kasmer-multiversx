```k
requires "syntax.md"
requires "destructors.md"

module USER-OPERATIONS
  imports DESTRUCTORS
  imports INT
  imports LIST
  imports PROOF-SYNTAX

  syntax ProofUserOperation ::= basicListInduction(List)  [symbol, klabel(basicListInduction)]

  rule runProofStep(basicListInduction(L:List))
      => runProof(
            destruct L as
              head_tail(basicListInduction(totalTail(L)))
              empty(nop)
          )

  syntax ProofUserOperation ::= moduloBetween0AndM(number:Int, mod:Int)  [symbol, klabel(moduloBetween0AndM)]

  rule runProofStep(moduloBetween0AndM(A:Int, M:Int))
      => runProof(
            split(
              M >Int 0,
              split(
                A <Int 0,
                moduloBetween0AndM(A +Int M, M),
                split(M <=Int A, moduloBetween0AndM(A -Int M, M), nop)
              ),
              split(
                0 -Int M <Int A,
                moduloBetween0AndM(A +Int M, M),
                split(A <=Int 0, moduloBetween0AndM(A -Int M, M), nop)
              )
            )
          )

  syntax ProofUserOperation ::= tModuloBetween0AndM(number:Int, mod:Int)  [symbol, klabel(tModuloBetween0AndM)]

  rule runProofStep(tModuloBetween0AndM(A:Int, M:Int))
      => runProof(
            split(
              M >Int 0,
              split(
                A <Int 0,
                tModuloBetween0AndM(A +Int M, M),
                split(M <=Int A, tModuloBetween0AndM(A -Int M, M), nop)
              ),
              split(
                0 <Int A,
                tModuloBetween0AndM(A +Int M, M),
                split(A <=Int M, tModuloBetween0AndM(A -Int M, M), nop)
              )
            )
          )

  syntax ProofUserOperation ::= numberAsTDivModulo(number:Int, mod:Int)  [symbol, klabel(numberAsTDivModulo)]

  rule runProofStep(numberAsTDivModulo(A:Int, M:Int))
      => runProof(
            numberAsTDivModuloHelper(A, M, 0, A)
          )

  syntax ProofUserOperation ::= numberAsTDivModuloHelper(number:Int, mod:Int, divresult:Int, modresult:Int)
      [symbol, klabel(numberAsTDivModuloHelper)]

  rule runProofStep(numberAsTDivModuloHelper(A:Int, M:Int, Div:Int, Mod:Int))
      => runProof(
          split(
            0 <Int M,
            split(
              M <=Int Mod,
              numberAsTDivModuloHelper(A, M, Div +Int 1, Mod -Int M),
              split(
                Mod <Int 0,
                numberAsTDivModuloHelper(A, M, Div -Int 1, Mod +Int M),
                nop
              )
            ),
            split(
                M <Int 0,
                split(
                  Mod <=Int M,
                  numberAsTDivModuloHelper(A, M, Div +Int 1, Mod -Int M),
                  split(
                    0 <Int Mod,
                    numberAsTDivModuloHelper(A, M, Div -Int 1, Mod +Int M),
                    nop
                  )
                ),
                nop
              )
          )
        )


  syntax ProofUserOperation ::= numberAsDivModulo(number:Int, mod:Int)  [symbol, klabel(numberAsDivModulo)]

  rule runProofStep(numberAsDivModulo(A:Int, M:Int))
      => runProof(
            numberAsDivModuloHelper(A, M, 0, A)
          )

  syntax ProofUserOperation ::= numberAsDivModuloHelper(number:Int, mod:Int, divresult:Int, modresult:Int)
      [symbol, klabel(numberAsDivModuloHelper)]

  rule runProofStep(numberAsDivModuloHelper(A:Int, M:Int, Div:Int, Mod:Int))
      => runProof(
          split(
            0 <Int M,
            split(
              M <=Int Mod,
              numberAsDivModuloHelper(A, M, Div +Int 1, Mod -Int M),
              split(
                Mod <Int 0,
                numberAsDivModuloHelper(A, M, Div -Int 1, Mod +Int M),
                nop
              )
            ),
            split(
                M <Int 0,
                split(
                  Mod <=Int 0,
                  numberIsNumberMulDiv(Div +Int 1, M); numberAsDivModuloHelper(A, M, Div +Int 1, Mod -Int M),
                  split(
                    0 -Int M <Int Mod,
                    numberAsDivModuloHelper(A, M, Div -Int 1, Mod +Int M),
                    nop
                  )
                ),
                nop
              )
          )
        )

  syntax ProofUserOperation ::= numberIsNumberMulDiv(number:Int, mod:Int)
      [symbol, klabel(numberIsNumberMulDiv)]

  rule runProofStep(numberIsNumberMulDiv(A:Int, M:Int))
      => runProof(
          split(
              M >Int 0,
              split(
                  A ==K 0,
                  nop,
                  split(
                      A <Int 0,
                      numberIsNumberMulDiv(A +Int 1, M),
                      numberIsNumberMulDiv(A -Int 1, M)
                  )
              ),
              split(
                  A ==K 0,
                  nop,
                  split(
                      A <Int 0,
                      numberIsNumberMulDiv(A +Int 1, M),
                      numberIsNumberMulDiv(A -Int 1, M)
                  )
              )
          )
      )


  syntax ProofUserOperation ::= modAddMultiple(number:Int, multiplier: Int, mod:Int)
      [symbol, klabel(modAddMultiple)]

  rule runProofStep(modAddMultiple(A:Int, B:Int, M:Int))
      => runProof(
          split(
              0 <Int M, // 2
              split(
                  B ==K 0,  // 5
                  nop,
                  split(
                      B <Int 0,  // 16
                      split(
                          A +Int B *Int M <Int 0, // 19
                          modAddMultiple(A, B +Int 1, M),
                          split(
                              A +Int B *Int M <Int M,
                              modAddMultiple(A, B +Int 1, M),
                              modAddMultiple(A, B +Int 1, M)
                          )
                      ),
                      split(
                          A +Int B *Int M <Int 0,
                          modAddMultiple(A, B -Int 1, M),
                          split(
                              A +Int B *Int M <Int M,
                              modAddMultiple(A, B -Int 1, M),
                              modAddMultiple(A, B -Int 1, M)
                          )
                      )
                  )
              ),
              split(
                  B ==K 0,
                  nop,
                  split(
                      B <Int 0,
                      split(
                          A +Int B *Int M <Int 0,
                          modAddMultiple(A, B +Int 1, M),
                          split(
                              A +Int B *Int M <Int M,
                              modAddMultiple(A, B +Int 1, M),
                              modAddMultiple(A, B +Int 1, M)
                          )
                      ),
                      split(
                          A +Int B *Int M <Int 0,
                          modAddMultiple(A, B -Int 1, M),
                          split(
                              A +Int B *Int M <Int M,
                              modAddMultiple(A, B -Int 1, M),
                              modAddMultiple(A, B -Int 1, M)
                          )
                      )
                  )
              )
          )
      )

endmodule
```
