// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract MagicSolver {
  constructor() public {
    assembly {

      // Bytecode: 0x604260005260206000f3 (length 0x0a or 10)
      // Bytecode within a 32 byte word:
      // 0x00000000000000000000000000000000000000000000604260005260206000f3 (length 0x20 or 32)
      //                                               ^ (offset 0x16 or 22)
      
      mstore(0, 0x602a60005260206000f3)
      return(0x16, 0x0a)
    }
  }
}