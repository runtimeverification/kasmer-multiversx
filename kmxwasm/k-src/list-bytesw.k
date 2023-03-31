module LIST-BYTESW
  imports private INT-SYNTAX
  imports private BASIC-K

  syntax Bytesw

  syntax ListBytesw [hook(LIST.List)]
  syntax ListBytesw ::= ListBytesw ListBytesw
          [ left, function, total, hook(LIST.concat),
            klabel(_ListBytesw_), symbol, smtlib(smt_seq_concat),
            assoc, unit(.ListBytesw), element(ListByteswItem),
            format(%1%n%2)
          ]
  syntax ListBytesw ::= ".ListBytesw"
          [ function, total, hook(LIST.unit), klabel(.ListBytesw),
            symbol, smtlib(smt_seq_nil), latex(\dotCt{ListBytesw})
          ]
  syntax ListBytesw ::= ListItem(Bytesw)
          [ function, total, hook(LIST.element), klabel(ListByteswItem),
            symbol, smtlib(smt_seq_elem)
          ]
  syntax Bytesw ::= ListBytesw "[" Int "]"
          [ function, hook(LIST.get), klabel(ListBytesw:get), symbol ]
  syntax ListBytesw ::= ListBytesw "[" index: Int "<-" value: Bytesw "]"
          [function, hook(LIST.update), klabel(ListBytesw:set)]
  syntax ListBytesw ::= makeListBytesw(length: Int, value: Bytesw)
          [function, hook(LIST.make)]
  syntax ListBytesw ::= updateList(dest: ListBytesw, index: Int, src: ListBytesw)
          [function, hook(LIST.updateAll)]
  syntax ListBytesw ::= fillList(ListBytesw, index: Int, length: Int, value: Bytesw)
          [function, hook(LIST.fill)]
  syntax ListBytesw ::= range(ListBytesw, fromFront: Int, fromBack: Int)
          [function, hook(LIST.range), klabel(ListBytesw:range), symbol]
  syntax Bool ::= Bytesw "in" ListBytesw
          [function, total, hook(LIST.in), klabel(_inListBytesw_)]
  syntax Int ::= size(ListBytesw)
          [function, total, hook(LIST.size), klabel (sizeListBytesw), smtlib(smt_seq_len)]
endmodule

module LIST-BYTESW-EXTENSIONS
  imports BOOL
  imports INT
  imports LIST-BYTESW

  syntax Bytesw ::= ListBytesw "[" Int "]" "orDefault" Bytesw
          [ function, total, klabel(ListBytesw:getOrDefault), symbol ]

  rule ListItem(V:Bytesw) _:ListBytesw [0] orDefault _:Bytesw
      => V
  rule _:ListBytesw ListItem(V:Bytesw) [-1] orDefault _:Bytesw
      => V
  rule .ListBytesw [_:Int] orDefault D:Bytesw => D

  rule ListItem(_:Bytesw) L:ListBytesw [I:Int] orDefault D:Bytesw
      => L[I -Int 1] orDefault D
    requires 0 <Int I
  rule L:ListBytesw ListItem(_:Bytesw) [I:Int] orDefault D:Bytesw
      => L[I +Int 1] orDefault D
    requires I <Int 0

  rule L:ListBytesw[I:Int] orDefault D:Bytesw => D
    requires notBool ((0 -Int size(L) <=Int I) andBool (I <Int size(L)))
    [simplification]
endmodule
