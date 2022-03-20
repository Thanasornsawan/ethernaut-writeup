// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwo {

  address public entrant;

  //we can pass this condition by make another contract
  //tx.origin will be our metamask but msg.sender is contract
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  //we can pass this condition by call function enter from constructor
  //during deployment at constructor will still not fully complete contract with address
  //it knows only contract address.So, the size of contract (extcodesize) will be zero
  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  //we can pass this condition by swap logic XOR because A^B=C
  //So, B=A^C too while B is uint64(_gateKey)
  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}