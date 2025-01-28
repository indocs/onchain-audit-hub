// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A tiny utility contract added to ease incremental testing and compilation sanity.
// This contract does not affect existing audit hub logic and provides a simple pure function.
contract Utils {
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
}
