// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';

/*
contract Recovery create contract SimpleToken and owner lost SimpleToken contract address wiht lock up 0.5 ETH
Contract addresses are deterministic and are calculated by keccack256(address, nonce) 
where the address is the address of the contract (or ethereum address that created the transaction) 
and nonce is the number of contracts the spawning contract has created (or the transaction nonce, for regular transactions).
Because of this, one can send ether to a pre-determined address (which has no private key) and 
later create a contract at that address which recovers the ether. This is a non-intuitive and 
somewhat secretive way to (dangerously) store ether without holding a private key.

If you're going to implement this technique, make sure you don't miss the nonce, or your funds will be lost forever.

contract address are deterministic from the compute of the owner address (wallet address or contract address)
address = rightmost_20_bytes(keccak(RLP(sender address, nonce)))
see solution to get contract address in getLostAdr.js
*/

/*
contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}
*/

contract SimpleToken {

  using SafeMath for uint256;
  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value.mul(10);
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}