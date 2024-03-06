
#!/bin/bash

cd $1

poetry run python3 -m src.kmxwasm.property --booster --claim $2 --kcfg=$3 --step 1
