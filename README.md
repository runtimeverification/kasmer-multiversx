# DO NOT MERGEm TEST ONLY!

# mx-wasm
Symbolic execution backend for the MultiversX blockchain network

# Running

Example:

```
cd kmxwasm
time poetry run kmxwasm-property \
    --claim tmp2/test_change_quorum-spec-1k.json \
    --kcfg=../.property/kcfg.json
```

# Profiling

Example:

* Run a contract normally:
```
cd kmxwasm
time poetry run kmxwasm-property \
    --claim tmp2/test_change_quorum-spec-1k.json \
    --kcfg=../.property/kcfg.json
```

* List all configurations:
```
cd kmxwasm
time poetry run kmxwasm-property \
    --claim tmp2/test_change_quorum-spec-1k.json \
    --kcfg=../.property/kcfg.json \
    --tree
```

* Look at configurations and pick one (example for configuration 48):
```
cd kmxwasm
time poetry run kmxwasm-property \
    --claim tmp2/test_change_quorum-spec-1k.json \
    --kcfg=../.property/kcfg.json \
    --show-node 48
```


* Run profiling using that configuration as a base; also, pick an instruction from PROFILE_INSTRUCTIONS:
```
cd kmxwasm
time poetry run kmxwasm-property \
    --claim tmp2/test_change_quorum-spec-1k.json \
    --kcfg=../.property/kcfg.json \
    --profile 48
    --profile-instruction aIConst
```
