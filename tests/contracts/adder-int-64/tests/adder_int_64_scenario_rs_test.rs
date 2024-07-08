use multiversx_sc_scenario::*;

fn world() -> ScenarioWorld {
    let mut blockchain = ScenarioWorld::new();

    blockchain.register_contract("mxsc:output/adder-int-64.mxsc.json", adder_int_64::ContractBuilder);
    blockchain
}

#[test]
fn empty_rs() {
    world().run("scenarios/adder_int_64.scen.json");
}
