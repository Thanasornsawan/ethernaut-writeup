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

### Analyze from mythril
```shell
ploy@DESKTOP-J2I6GJ1:~$ myth analyze -a 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd --rpc infura-rinkeby --infura-id="YOUR_INFURA_ID"
==== External Call To User-Supplied Address ====
SWC ID: 107
Severity: Low
Contract: 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd
Function name: withdraw(uint256)
PC address: 698
Estimated Gas Usage: 7977 - 62921
A call to a user-supplied address is executed.
An external message call to an address specified by the caller is executed. Note that the callee account might contain arbitrary code and could re-enter any function within this contract. Reentering the contract in an intermediate state may lead to unexpected behaviour. Make sure that no state modifications are executed after this call and/or reentrancy guards are in place.
--------------------
Initial State:

Account: [ATTACKER], balance: 0x3, nonce:0, storage:{}
Account: [SOMEGUY], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0

==== Unchecked return value from external call. ====
SWC ID: 104
Severity: Medium
Contract: 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd
Function name: withdraw(uint256)
PC address: 698
Estimated Gas Usage: 7977 - 62921
The return value of a message call is not checked.
External calls return a boolean value. If the callee halts with an exception, 'false' is returned and execution continues in the caller. The caller should check whether an exception happened and react accordingly to avoid unexpected behavior. For example it is often desirable to wrap external calls in require() so the transaction is reverted if the call fails.
--------------------
Initial State:

Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}
Account: [SOMEGUY], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [SOMEGUY], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0

==== Unprotected Ether Withdrawal ====
SWC ID: 105
Severity: High
Contract: 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd
Function name: withdraw(uint256)
PC address: 698
Estimated Gas Usage: 7977 - 62921
Any sender can withdraw Ether from the contract account.
Arbitrary senders other than the contract creator can profitably extract Ether from the contract account. Verify the business logic carefully and make sure that appropriate security controls are in place to prevent unexpected loss of funds.--------------------
Initial State:

Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}
Account: [SOMEGUY], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], function: donate(address), txdata: 0x00362a95000000000000000000000000deadbeefdeadbeefdeadbeefdeadbeefdeadbeef, value: 0x1
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000001, value: 0x0

==== State access after external call ====
SWC ID: 107
Severity: Medium
Contract: 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd
Function name: withdraw(uint256)
PC address: 823
Estimated Gas Usage: 7977 - 62921
Read of persistent state following external call
The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
--------------------
Initial State:

Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}
Account: [SOMEGUY], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0

==== State access after external call ====
SWC ID: 107
Severity: Medium
Contract: 0xA19Ba55F3CB5970cbC53298aDD5f8C6d542c65dd
Function name: withdraw(uint256)
PC address: 830
Estimated Gas Usage: 7977 - 62921
Write to persistent state following external call
The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
--------------------
Initial State:

Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}
Account: [SOMEGUY], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, value: 0x0
```

