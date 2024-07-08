use multiversx_sc_scenario::*;

fn world() -> ScenarioWorld {
    let mut blockchain = ScenarioWorld::new();

    blockchain.register_contract("mxsc:output/test-adder-int-64.mxsc.json", test_adder_int_64::ContractBuilder);
    blockchain
}

#[test]
fn empty_rs() {
    world().run("scenarios/test_adder_int_64.scen.json");
}
