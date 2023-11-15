module BUG-SYNTAX
endmodule

module BUG
  imports INT
  imports K-EQUAL-SYNTAX

  syntax A ::= a(Int) | "b"

  syntax KItem ::= start(A) | "end"

  rule start(X) => end
    requires X =/=K b

endmodule