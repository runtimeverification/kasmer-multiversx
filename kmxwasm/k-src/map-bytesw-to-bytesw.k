module MAP-BYTESW-TO-BYTESW
  imports private BOOL-SYNTAX
  imports private INT-SYNTAX
  imports private LIST-BYTESW
  imports private LIST-BYTESW
  // imports private LIST
  // imports private SET-BYTESW
  imports private SET

  syntax Bytesw
  syntax Bytesw

  syntax MapByteswToBytesw [hook(MAP.Map)]
  syntax MapByteswToBytesw ::= MapByteswToBytesw MapByteswToBytesw
         [ left, function, hook(MAP.concat), klabel(_MapByteswToBytesw_),
           symbol, assoc, comm, unit(.MapByteswToBytesw), element(_Bytes2Bytes|->_),
           index(0), format(%1%n%2)
         ]
  syntax MapByteswToBytesw ::= ".MapByteswToBytesw"
         [ function, total, hook(MAP.unit),
           klabel(.MapByteswToBytesw), symbol, latex(\dotCt{MapByteswToBytesw})
         ]
  syntax MapByteswToBytesw ::= Bytesw "Bytes2Bytes|->" Bytesw
         [ function, total, hook(MAP.element),
           klabel(_Bytes2Bytes|->_), symbol,
           latex({#1}\mapsto{#2}), injective
         ]

  syntax priorities _Bytes2Bytes|->_ > _MapByteswToBytesw_ .MapByteswToBytesw
  syntax non-assoc _Bytes2Bytes|->_
  syntax Bytesw ::= MapByteswToBytesw "[" Bytesw "]"
                 [function, hook(MAP.lookup), klabel(MapByteswToBytesw:lookup), symbol]
  syntax Bytesw ::= MapByteswToBytesw "[" Bytesw "]" "orDefault" Bytesw
                 [ function, total, hook(MAP.lookupOrDefault),
                   klabel(MapByteswToBytesw:lookupOrDefault)
                 ]
  syntax MapByteswToBytesw ::= MapByteswToBytesw "[" key: Bytesw "<-" value: Bytesw "]"
                 [ function, total, klabel(MapByteswToBytesw:update), symbol,
                   hook(MAP.update), prefer
                 ]
  syntax MapByteswToBytesw ::= MapByteswToBytesw "[" Bytesw "<-" "undef" "]"
                 [ function, total, hook(MAP.remove),
                   klabel(_MapByteswToBytesw[_<-undef]), symbol
                 ]
  syntax MapByteswToBytesw ::= MapByteswToBytesw "-Map" MapByteswToBytesw
                 [ function, total, hook(MAP.difference),
                   latex({#1}-_{\it MapByteswToByteswMap}{#2})
                 ]
  syntax MapByteswToBytesw ::= updateMap(MapByteswToBytesw, MapByteswToBytesw)
                 [function, total, hook(MAP.updateAll)]

  syntax MapByteswToBytesw ::= removeAll(MapByteswToBytesw, Set)
                 [function, total, hook(MAP.removeAll)]
  // syntax MapByteswToBytesw ::= removeAll(MapByteswToBytesw, SetBytesw)
  //                [function, total, hook(MAP.removeAll)]

  syntax Set ::= keys(MapByteswToBytesw)
                 [function, total, hook(MAP.keys)]
  // syntax SetBytesw ::= keys(MapByteswToBytesw)
  //                [function, total, hook(MAP.keys)]

  // syntax List ::= "keys_list" "(" MapByteswToBytesw ")"
  //                [function, hook(MAP.keys_list)]
  syntax ListBytesw ::= "keys_list" "(" MapByteswToBytesw ")"
                 [function, hook(MAP.keys_list)]

  syntax Bool ::= Bytesw "in_keys" "(" MapByteswToBytesw ")"
                 [function, total, hook(MAP.in_keys)]

  // syntax List ::= values(MapByteswToBytesw)
  //                [function, hook(MAP.values)]
  syntax ListBytesw ::= values(MapByteswToBytesw)
                 [function, hook(MAP.values)]

  syntax Int ::= size(MapByteswToBytesw)
                 [function, total, hook(MAP.size), klabel(MapByteswToBytesw.sizeMap)]
  syntax Bool ::= MapByteswToBytesw "<=Map" MapByteswToBytesw
                 [function, total, hook(MAP.inclusion)]
  syntax Bytesw ::= choice(MapByteswToBytesw)
                 [function, hook(MAP.choice), klabel(MapByteswToBytesw:choice)]
endmodule

module MAP-BYTESW-TO-BYTESW-KORE-SYMBOLIC
  imports MAP-BYTESW-TO-BYTESW
  imports private K-EQUAL
  imports private BOOL

  rule #Ceil(@M:MapByteswToBytesw [@K:Bytesw])
      => {(@K in_keys(@M)) #Equals true}
          #And #Ceil(@M) #And #Ceil(@K)
      [simplification]

  rule (K Bytes2Bytes|-> _ M:MapByteswToBytesw) [ K <- V ] => (K Bytes2Bytes|-> V M) [simplification]
  rule M:MapByteswToBytesw [ K <- V ] => (K Bytes2Bytes|-> V M) requires notBool (K in_keys(M))
      [simplification]
  rule M:MapByteswToBytesw [ K <- _ ] [ K <- V ] => M [ K <- V ] [simplification]
  rule (K1 Bytes2Bytes|-> V1 M:MapByteswToBytesw) [ K2 <- V2 ] => (K1 Bytes2Bytes|-> V1 (M [ K2 <- V2 ]))
      requires K1 =/=K K2
      [simplification]

  rule (K Bytes2Bytes|-> _ M:MapByteswToBytesw) [ K <- undef ] => M
      ensures notBool (K in_keys(M))
      [simplification]
  rule M:MapByteswToBytesw [ K <- undef ] => M
      requires notBool (K in_keys(M))
      [simplification]
  rule (K1 Bytes2Bytes|-> V1 M:MapByteswToBytesw) [ K2 <- undef ]
      => (K1 Bytes2Bytes|-> V1 (M [ K2 <- undef ]))
      requires K1 =/=K K2
      [simplification]

  rule (K  Bytes2Bytes|->  V M:MapByteswToBytesw) [ K ] => V
      ensures notBool (K in_keys(M))
      [simplification]
  rule (K1 Bytes2Bytes|-> _V M:MapByteswToBytesw) [ K2 ] => M [K2]
      requires K1 =/=K K2
      ensures notBool (K1 in_keys(M))
      [simplification]
  rule (_MAP:MapByteswToBytesw [ K  <-  V1 ]) [ K ]  => V1 [simplification]
  rule ( MAP:MapByteswToBytesw [ K1 <- _V1 ]) [ K2 ] => MAP [ K2 ]
      requires K1 =/=K K2
      [simplification]

  rule (K  Bytes2Bytes|->  V M:MapByteswToBytesw) [  K ] orDefault _ => V
      ensures notBool (K in_keys(M))
      [simplification]
  rule (K1 Bytes2Bytes|-> _V M:MapByteswToBytesw) [ K2 ] orDefault D
      => M [K2] orDefault D
      requires K1 =/=K K2
      ensures notBool (K1 in_keys(M))
      [simplification]
  rule (_MAP:MapByteswToBytesw [ K  <-  V1 ]) [ K ] orDefault _ => V1 [simplification]
  rule ( MAP:MapByteswToBytesw [ K1 <- _V1 ]) [ K2 ] orDefault D
      => MAP [ K2 ] orDefault D
      requires K1 =/=K K2
      [simplification]
  rule .MapByteswToBytesw [ _ ] orDefault D => D [simplification]

  rule K in_keys(_M:MapByteswToBytesw [ K <- undef ]) => false [simplification]
  rule K in_keys(_M:MapByteswToBytesw [ K <- _ ]) => true [simplification]
  rule K1 in_keys(M:MapByteswToBytesw [ K2 <- _ ])
      => true requires K1 ==K K2 orBool K1 in_keys(M)
      [simplification]
  rule K1 in_keys(M:MapByteswToBytesw [ K2 <- _ ])
      => K1 in_keys(M)
      requires K1 =/=K K2
      [simplification]

  rule {false #Equals @Key in_keys(.MapByteswToBytesw)} => #Ceil(@Key) [simplification]
  rule {@Key in_keys(.MapByteswToBytesw) #Equals false} => #Ceil(@Key) [simplification]
  rule {false #Equals @Key in_keys(Key' Bytes2Bytes|-> Val @M:MapByteswToBytesw)}
      =>  #Ceil(@Key) #And #Ceil(Key' Bytes2Bytes|-> Val @M)
          #And #Not({@Key #Equals Key'})
          #And {false #Equals @Key in_keys(@M)}
      [simplification]
  rule {@Key in_keys(Key' Bytes2Bytes|-> Val @M:MapByteswToBytesw) #Equals false}
      =>  #Ceil(@Key) #And #Ceil(Key' Bytes2Bytes|-> Val @M)
          #And #Not({@Key #Equals Key'})
          #And {@Key in_keys(@M) #Equals false}
      [simplification]
endmodule
