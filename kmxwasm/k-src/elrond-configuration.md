```k
require "map-intw-to-bytesw.k"
require "list-bytesw.k"

module ELROND-CONFIGURATION
    imports BYTES
    imports INT
    imports LIST-BYTESW
    imports MAP-INTW-TO-BYTESW

    configuration
        <elrond>
            <buffers>.MapIntwToBytesw</buffers>
            <caller>.Bytes</caller>
            <gas>0</gas>
            <call-value>0</call-value>
            <arguments>.ListBytesw</arguments>
            <original-tx-hash>.Bytes</original-tx-hash>
        </elrond>
endmodule
```