```k
require "list-bytesw.k"
require "list-esdttransfer.k"
require "map-bytesw-to-bytesw.k"
require "map-intw-to-bytesw.k"
require "map-intw-to-intw.k"

module ELROND-CONFIGURATION
    imports BYTES
    imports INT
    imports LIST-BYTESW
    imports LIST-ESDTTRANSFER
    imports MAP-BYTESW-TO-BYTESW
    imports MAP-INTW-TO-BYTESW
    imports MAP-INTW-TO-INTW

    // TODO: Move out of here
    syntax ESDTTransfer ::= esdtTrandfer(value:Int, tokenName:Bytes, tokenType:Int, tokenNonce:Int)

    configuration
        <elrond>
            <buffers>.MapIntwToBytesw</buffers>
            <ints>.MapIntwToIntw</ints>
            <storage>.MapByteswToBytesw</storage>
            <payments>.ListESDTTransfer</payments>
            <caller>.Bytes</caller>
            <owner>.Bytes</owner>
            <gas>0</gas>
            <call-value>0</call-value>
            <arguments>.ListBytesw</arguments>
            <original-tx-hash>.Bytes</original-tx-hash>
        </elrond>
endmodule
```