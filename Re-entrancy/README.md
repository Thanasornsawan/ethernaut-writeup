# Re-entrancy

The goal of this level is for you to steal all the funds from the contract.<br/>
Things that might help: <br/>

Untrusted contracts can execute code where you least expect it. <br/>
- Fallback methods <br/>
- Throw/revert bubbling <br/>
- Sometimes the best way to attack a contract is with another contract. <br/>

## Attack

```javascript
await getBalance(contract.address);
> '0.001'
contract.address
> '0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd'
await getBalance(contract.address);
> '0'
```

![console](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Re-entrancy/photo/console.JPG)

Level completed! <br/>
Difficulty 6/10 <br/>

In order to prevent re-entrancy attacks when moving funds out of your contract, use the [Checks-Effects-Interactions pattern](https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern) being aware that `call` will only return false without interrupting the execution flow. Solutions such as [ReentrancyGuard](https://docs.openzeppelin.com/contracts/2.x/api/utils#ReentrancyGuard) or [PullPayment](https://docs.openzeppelin.com/contracts/2.x/api/payment#PullPayment) can also be used.<br/>

transfer and send are no longer recommended solutions as they can potentially break contracts after the Istanbul hard fork [Source 1](https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/) [Source 2](https://forum.openzeppelin.com/t/reentrancy-after-istanbul/1742).<br/>

Always assume that the receiver of the funds you are sending can be another contract, not just a regular address. Hence, it can execute code in its payable fallback method and re-enter your contract, possibly messing up your state/logic.<br/>

Re-entrancy is a common attack. You should always be prepared for it!<br/>

 

### The DAO Hack
The famous DAO hack used reentrancy to extract a huge amount of ether from the victim contract. See [15 lines of code that could have prevented TheDAO Hack](https://blog.openzeppelin.com/15-lines-of-code-that-could-have-prevented-thedao-hack-782499e00942).

