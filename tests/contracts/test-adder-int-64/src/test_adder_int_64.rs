#![no_std]

use testapi;

#[allow(unused_imports)]
use multiversx_sc::imports::*;

static INIT_SUM : u64 = 5u64;

mod adder_proxy {
    multiversx_sc::imports!();

    #[multiversx_sc::proxy]
    pub trait AdderInt64pProxy {
        #[endpoint]
        fn add(&self, value: u64) -> u64;
    }
}

#[multiversx_sc::contract]
pub trait TestAdderInt64 {

    #[storage_mapper("ownerAddress")]
    fn owner_address(&self) -> SingleValueMapper<ManagedAddress>;

    #[storage_mapper("adderAddress")]
    fn adder_address(&self) -> SingleValueMapper<ManagedAddress>;

    #[init]
    fn init(&self, code_path: ManagedBuffer) {
        // create the owner account
        let owner = ManagedAddress::from(b"owner___________________________");
        self.owner_address().set(&owner);

        testapi::create_account(&owner, 1, &BigUint::from(0u64));

        // register an address for the contract to be deployed
        let adder = ManagedAddress::from(b"adder___________________________");
        testapi::register_new_address(&owner, 1, &adder);

        // deploy the adder contract
        let mut adder_init_args = ManagedArgBuffer::new();
        adder_init_args.push_arg(INIT_SUM); // initial sum

        // deploy a contract from `owner`
        let adder = testapi::deploy_contract(
                &owner,
                5000000000000,
                &BigUint::zero(),
                &code_path,
                &adder_init_args,
            );

        // save the deployed contract's address
        self.adder_address().set(&adder);
    }

    #[upgrade]
    fn upgrade(&self) {}

    // Make a call from 'owner' to 'adder' and check the sum value
    #[endpoint(test_call_add)]
    fn test_call_add(&self, value: u64) {

        testapi::assume(value < 100u64);

        let owner = self.owner_address().get();
        let adder = self.adder_address().get();

        testapi::start_prank(&owner);
        let sum: u64 = self
            .adder_proxy(adder)
            .add(value)
            .execute_on_dest_context();
        testapi::stop_prank();

        // check the sum value
        testapi::assert( sum == (value + INIT_SUM) );
    }

    #[proxy]
    fn adder_proxy(&self, sc_address: ManagedAddress) -> adder_proxy::Proxy<Self::Api>;
}
