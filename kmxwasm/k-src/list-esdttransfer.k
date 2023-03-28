module LIST-ESDTTRANSFER
  imports private INT-SYNTAX
  imports private BASIC-K

  syntax ESDTTransfer

  syntax ListESDTTransfer [hook(LIST.List)]
  syntax ListESDTTransfer ::= ListESDTTransfer ListESDTTransfer
          [ left, function, total, hook(LIST.concat),
            klabel(_ListESDTTransfer_), symbol, smtlib(smt_seq_concat),
            assoc, unit(.ListESDTTransfer), element(ListESDTTransferItem),
            format(%1%n%2)
          ]
  syntax ListESDTTransfer ::= ".ListESDTTransfer"
          [ function, total, hook(LIST.unit), klabel(.ListESDTTransfer),
            symbol, smtlib(smt_seq_nil), latex(\dotCt{ListESDTTransfer})
          ]
  syntax ListESDTTransfer ::= ListItem(ESDTTransfer)
          [ function, total, hook(LIST.element), klabel(ListESDTTransferItem),
            symbol, smtlib(smt_seq_elem)
          ]
  syntax ESDTTransfer ::= ListESDTTransfer "[" Int "]"
          [ function, hook(LIST.get), klabel(ListESDTTransfer:get), symbol ]
  syntax ListESDTTransfer ::= ListESDTTransfer "[" index: Int "<-" value: ESDTTransfer "]"
          [function, hook(LIST.update), klabel(ListESDTTransfer:set)]
  syntax ListESDTTransfer ::= makeListESDTTransfer(length: Int, value: ESDTTransfer)
          [function, hook(LIST.make)]
  syntax ListESDTTransfer ::= updateList(dest: ListESDTTransfer, index: Int, src: ListESDTTransfer)
          [function, hook(LIST.updateAll)]
  syntax ListESDTTransfer ::= fillList(ListESDTTransfer, index: Int, length: Int, value: ESDTTransfer)
          [function, hook(LIST.fill)]
  syntax ListESDTTransfer ::= range(ListESDTTransfer, fromFront: Int, fromBack: Int)
          [function, hook(LIST.range), klabel(ListESDTTransfer:range), symbol]
  syntax Bool ::= ESDTTransfer "in" ListESDTTransfer
          [function, total, hook(LIST.in), klabel(_inListESDTTransfer_)]
  syntax Int ::= size(ListESDTTransfer)
          [function, total, hook(LIST.size), klabel (sizeListESDTTransfer), smtlib(smt_seq_len)]
endmodule

module LIST-ESDTTRANSFER-EXTENSIONS
  imports BOOL
  imports INT
  imports LIST-ESDTTRANSFER

  syntax ESDTTransfer ::= ListESDTTransfer "[" Int "]" "orDefault" ESDTTransfer
          [ function, total, klabel(ListESDTTransfer:getOrDefault), symbol ]

  rule ListItem(V:ESDTTransfer) _:ListESDTTransfer [0] orDefault _:ESDTTransfer
      => V
  rule _:ListESDTTransfer ListItem(V:ESDTTransfer) [-1] orDefault _:ESDTTransfer
      => V
  rule .ListESDTTransfer [_:Int] orDefault D:ESDTTransfer => D

  rule ListItem(_:ESDTTransfer) L:ListESDTTransfer [I:Int] orDefault D:ESDTTransfer
      => L[I -Int 1] orDefault D
    requires 0 <Int I
  rule L:ListESDTTransfer ListItem(_:ESDTTransfer) [I:Int] orDefault D:ESDTTransfer
      => L[I +Int 1] orDefault D
    requires I <Int 0

  rule L:ListESDTTransfer[I:Int] orDefault D:ESDTTransfer => D
    requires notBool (0 -Int size(L) <=Int I andBool I <Int size(L))
    [simplification]
endmodule
