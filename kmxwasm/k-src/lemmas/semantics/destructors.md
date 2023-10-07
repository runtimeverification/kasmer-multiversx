```k
requires "syntax.md"

module DESTRUCTORS
  imports K-EQUAL-SYNTAX
  imports PROOF-SYNTAX

  syntax DestructOperation ::=
              "destruct" List "as" "head_tail" "(" ProofOperationList ")" "empty" "(" ProofOperationList ")"
              [klabel(destructList), symbol]

  rule  runProofStep(destruct ListItem(_) _:List as head_tail(Ops) empty(_))
        => runProof(Ops)
  rule  runProofStep(destruct L:List as head_tail(_) empty(Ops))
        => runProof(Ops)
      ensures L ==K .List
    [owise]

  syntax KItem ::= totalHead(List)  [function, total]
  rule totalHead(ListItem(Item) _:List) => Item
  rule totalHead(L:List) => L  [owise]
  syntax List ::= totalTail(List)  [function, total]
  rule totalTail(ListItem(_) L:List) => L
  rule totalTail(L:List) => L  [owise]
endmodule
```