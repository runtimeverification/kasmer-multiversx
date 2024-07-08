#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

/// An empty contract. To be used as a template when starting a new contract from scratch.
#[multiversx_sc::contract]
pub trait AdderInt64 {
    #[init]
    fn init(&self, value: u64) {
        self.sum().set(value);
    }

    #[upgrade]
    fn upgrade(&self) {}

    #[endpoint]
    fn add(&self, value: u64) -> u64 {
        self.sum().set(self.sum().get() + value);
        self.sum().get()
    }

    #[view(getFirstTokenId)]
    #[storage_mapper("sum")]
    fn sum(&self) -> SingleValueMapper<u64>;
}
