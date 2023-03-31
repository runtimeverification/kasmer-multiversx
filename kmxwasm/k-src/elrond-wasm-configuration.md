```k
require "summaries.k"
require "elrond-impl.md"
require "elrond-lemmas.md"
require "elrond-configuration.md"

module ELROND-WASM-CONFIGURATION
  imports ELROND-CONFIGURATION
  imports ELROND-IMPL

  configuration
    <elrond-wasm>
      <k> $PGM:Stmts </k>
      <wasm/>
      <elrond/>
    </elrond-wasm>
endmodule
```
