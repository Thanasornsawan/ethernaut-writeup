pragma solidity ^0.6.6;

contract Wallet {
    address public owner;
    //Del deploy this contact and become owner because msg.sender
    constructor() public {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function transfer(address payable _to, uint _amount) public {
        //tx.origin refer to external own account or wallet that initial transaction
        //Goal is Laura lure Del to execute transfer function by himself 
        //so,tx.origin still be Del and owner who deploy also Del
        require(tx.origin == owner, "Now owner");
        //the safe way for protect phising attack is use
        //require(msg.sender == owner) because when use other contract to execute function
        //the address of msg.sender will be the address of that contract instread

        _to.transfer(_amount);
    }

    function getBalance() public view returns(uint) {
        return address(this.balance);
    }
}