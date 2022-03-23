# Motorbike

Ethernaut's motorbike has a brand new upgradeable engine design.

Would you be able to selfdestruct its engine and make the motorbike unusable ?

Things that might help:

[EIP-1967](https://eips.ethereum.org/EIPS/eip-1967)
[UUPS](https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786) upgradeable pattern
[Initializable](https://github.com/OpenZeppelin/openzeppelin-upgrades/blob/master/packages/core/contracts/Initializable.sol) contract

From [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967)
> To avoid clashes in storage usage between the proxy and logic contract, the address of the logic contract is typically saved in a specific storage slot guaranteed to be never allocated by a compiler.

From the challenge, we are Motorbike contract now and Motorbike is proxy calling engine contact in delegatecall but the challenge want we try to `selfdestruct` engine contract.

Get address of the engine contract from slot by web3
```javascript
await web3.eth.getStorageAt(instance,'0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc');
> '0x000000000000000000000000f97aee26e411142f5a36834fc8efe54ee6592e3f'
web3.utils.isAddress('0xf97aee26e411142f5a36834fc8efe54ee6592e3f')
> true
```

## Exploitation

Step1: load [engine.sol](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Motorbike/engine.sol) in Remix at address '0xf97aee26e411142f5a36834fc8efe54ee6592e3f'

![deploy](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Motorbike/photo/deploy.JPG)

Step2: call function initialize() to change upgrader
Step3: check 'upgrader' that is our address
Step4: Deploy [engineAttack.sol](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Motorbike/engineAttack.sol) in Remix => 0x02Da9928301dE6f8C76baEc71E132292dF84C34b
Step5: Call function getSignature() => 0x83197ef0 for use as data in function upgradeToAndCall(...)

![sig](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Motorbike/photo/sig.JPG)
Step5: Upgrade engine contract to engineAttack contract and call function destroy() to `selfdestruct` its engine contract

![destroy](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Motorbike/photo/destroy.JPG)

Level completed!
Difficulty 6/10

The advantage of following an UUPS pattern is to have very minimal proxy to be deployed. The proxy acts as storage layer so any state modification in the implementation contract normally doesn't produce side effects to systems using it, since only the logic is used through delegatecalls.

This doesn't mean that you shouldn't watch out for vulnerabilities that can be exploited if we leave an implementation contract uninitialized.

This was a slightly simplified version of what has really been discovered after months of the release of UUPS pattern.

Takeways: never leaves implementation contracts uninitialized ;)

If you're interested in what happened, read more [here.](https://forum.openzeppelin.com/t/uupsupgradeable-vulnerability-post-mortem/15680)