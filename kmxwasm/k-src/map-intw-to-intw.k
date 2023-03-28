module MAP-INTW-TO-INTW
  imports private BOOL-SYNTAX
  imports private INT-SYNTAX
  // imports private LIST-INTW
  // imports private LIST-INTW
  imports private LIST
  // imports private SET-INTW
  imports private SET

  syntax Intw
  syntax Intw

  syntax MapIntwToIntw [hook(MAP.Map)]
  syntax MapIntwToIntw ::= MapIntwToIntw MapIntwToIntw
         [ left, function, hook(MAP.concat), klabel(_MapIntwToIntw_),
           symbol, assoc, comm, unit(.MapIntwToIntw), element(_Int2Int|->_),
           index(0), format(%1%n%2)
         ]
  syntax MapIntwToIntw ::= ".MapIntwToIntw"
         [ function, total, hook(MAP.unit),
           klabel(.MapIntwToIntw), symbol, latex(\dotCt{MapIntwToIntw})
         ]
  syntax MapIntwToIntw ::= Intw "Int2Int|->" Intw
         [ function, total, hook(MAP.element),
           klabel(_Int2Int|->_), symbol,
           latex({#1}\mapsto{#2}), injective
         ]

  syntax priorities _Int2Int|->_ > _MapIntwToIntw_ .MapIntwToIntw
  syntax non-assoc _Int2Int|->_
  syntax Intw ::= MapIntwToIntw "[" Intw "]"
                 [function, hook(MAP.lookup), klabel(MapIntwToIntw:lookup), symbol]
  syntax Intw ::= MapIntwToIntw "[" Intw "]" "orDefault" Intw
                 [ function, total, hook(MAP.lookupOrDefault),
                   klabel(MapIntwToIntw:lookupOrDefault)
                 ]
  syntax MapIntwToIntw ::= MapIntwToIntw "[" key: Intw "<-" value: Intw "]"
                 [ function, total, klabel(MapIntwToIntw:update), symbol,
                   hook(MAP.update), prefer
                 ]
  syntax MapIntwToIntw ::= MapIntwToIntw "[" Intw "<-" "undef" "]"
                 [ function, total, hook(MAP.remove),
                   klabel(_MapIntwToIntw[_<-undef]), symbol
                 ]
  syntax MapIntwToIntw ::= MapIntwToIntw "-Map" MapIntwToIntw
                 [ function, total, hook(MAP.difference),
                   latex({#1}-_{\it MapIntwToIntwMap}{#2})
                 ]
  syntax MapIntwToIntw ::= updateMap(MapIntwToIntw, MapIntwToIntw)
                 [function, total, hook(MAP.updateAll)]

  syntax MapIntwToIntw ::= removeAll(MapIntwToIntw, Set)
                 [function, total, hook(MAP.removeAll)]
  // syntax MapIntwToIntw ::= removeAll(MapIntwToIntw, SetIntw)
  //                [function, total, hook(MAP.removeAll)]

  syntax Set ::= keys(MapIntwToIntw)
                 [function, total, hook(MAP.keys)]
  // syntax SetIntw ::= keys(MapIntwToIntw)
  //                [function, total, hook(MAP.keys)]

  syntax List ::= "keys_list" "(" MapIntwToIntw ")"
                 [function, hook(MAP.keys_list)]
  // syntax ListIntw ::= "keys_list" "(" MapIntwToIntw ")"
  //                [function, hook(MAP.keys_list)]

  syntax Bool ::= Intw "in_keys" "(" MapIntwToIntw ")"
                 [function, total, hook(MAP.in_keys)]

  syntax List ::= values(MapIntwToIntw)
                 [function, hook(MAP.values)]
  // syntax ListIntw ::= values(MapIntwToIntw)
  //                [function, hook(MAP.values)]

  syntax Int ::= size(MapIntwToIntw)
                 [function, total, hook(MAP.size), klabel(MapIntwToIntw.sizeMap)]
  syntax Bool ::= MapIntwToIntw "<=Map" MapIntwToIntw
                 [function, total, hook(MAP.inclusion)]
  syntax Intw ::= choice(MapIntwToIntw)
                 [function, hook(MAP.choice), klabel(MapIntwToIntw:choice)]
endmodule

module MAP-INTW-TO-INTW-KORE-SYMBOLIC
  imports MAP-INTW-TO-INTW
  imports private K-EQUAL
  imports private BOOL

  rule #Ceil(@M:MapIntwToIntw [@K:Intw])
      => {(@K in_keys(@M)) #Equals true}
          #And #Ceil(@M) #And #Ceil(@K)
      [simplification]

  rule (K Int2Int|-> _ M:MapIntwToIntw) [ K <- V ] => (K Int2Int|-> V M) [simplification]
  rule M:MapIntwToIntw [ K <- V ] => (K Int2Int|-> V M) requires notBool (K in_keys(M))
      [simplification]
  rule M:MapIntwToIntw [ K <- _ ] [ K <- V ] => M [ K <- V ] [simplification]
  rule (K1 Int2Int|-> V1 M:MapIntwToIntw) [ K2 <- V2 ] => (K1 Int2Int|-> V1 (M [ K2 <- V2 ]))
      requires K1 =/=K K2
      [simplification]

  rule (K Int2Int|-> _ M:MapIntwToIntw) [ K <- undef ] => M
      ensures notBool (K in_keys(M))
      [simplification]
  rule M:MapIntwToIntw [ K <- undef ] => M
      requires notBool (K in_keys(M))
      [simplification]
  rule (K1 Int2Int|-> V1 M:MapIntwToIntw) [ K2 <- undef ]
      => (K1 Int2Int|-> V1 (M [ K2 <- undef ]))
      requires K1 =/=K K2
      [simplification]

  rule (K  Int2Int|->  V M:MapIntwToIntw) [ K ] => V
      ensures notBool (K in_keys(M))
      [simplification]
  rule (K1 Int2Int|-> _V M:MapIntwToIntw) [ K2 ] => M [K2]
      requires K1 =/=K K2
      ensures notBool (K1 in_keys(M))
      [simplification]
  rule (_MAP:MapIntwToIntw [ K  <-  V1 ]) [ K ]  => V1 [simplification]
  rule ( MAP:MapIntwToIntw [ K1 <- _V1 ]) [ K2 ] => MAP [ K2 ]
      requires K1 =/=K K2
      [simplification]

  rule (K  Int2Int|->  V M:MapIntwToIntw) [  K ] orDefault _ => V
      ensures notBool (K in_keys(M))
      [simplification]
  rule (K1 Int2Int|-> _V M:MapIntwToIntw) [ K2 ] orDefault D
      => M [K2] orDefault D
      requires K1 =/=K K2
      ensures notBool (K1 in_keys(M))
      [simplification]
  rule (_MAP:MapIntwToIntw [ K  <-  V1 ]) [ K ] orDefault _ => V1 [simplification]
  rule ( MAP:MapIntwToIntw [ K1 <- _V1 ]) [ K2 ] orDefault D
      => MAP [ K2 ] orDefault D
      requires K1 =/=K K2
      [simplification]
  rule .MapIntwToIntw [ _ ] orDefault D => D [simplification]

  rule K in_keys(_M:MapIntwToIntw [ K <- undef ]) => false [simplification]
  rule K in_keys(_M:MapIntwToIntw [ K <- _ ]) => true [simplification]
  rule K1 in_keys(M:MapIntwToIntw [ K2 <- _ ])
      => true requires K1 ==K K2 orBool K1 in_keys(M)
      [simplification]
  rule K1 in_keys(M:MapIntwToIntw [ K2 <- _ ])
      => K1 in_keys(M)
      requires K1 =/=K K2
      [simplification]

  rule {false #Equals @Key in_keys(.MapIntwToIntw)} => #Ceil(@Key) [simplification]
  rule {@Key in_keys(.MapIntwToIntw) #Equals false} => #Ceil(@Key) [simplification]
  rule {false #Equals @Key in_keys(Key' Int2Int|-> Val @M:MapIntwToIntw)}
      =>  #Ceil(@Key) #And #Ceil(Key' Int2Int|-> Val @M)
          #And #Not({@Key #Equals Key'})
          #And {false #Equals @Key in_keys(@M)}
      [simplification]
  rule {@Key in_keys(Key' Int2Int|-> Val @M:MapIntwToIntw) #Equals false}
      =>  #Ceil(@Key) #And #Ceil(Key' Int2Int|-> Val @M)
          #And #Not({@Key #Equals Key'})
          #And {@Key in_keys(@M) #Equals false}
      [simplification]
endmodule
