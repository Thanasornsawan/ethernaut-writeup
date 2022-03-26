# Magic Number

To solve this level, you only need to provide the Ethernaut with a `Solver`, a contract that responds to `whatIsTheMeaningOfLife()` with the right number.<br />
The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 opcodes at most.<br />
**Hint**: The challenge hidden big number `42` in comment of contract and want the solver's code use only 10 opcodes.<br />

## Part1: Run time opcode

First, we need to store `42` in 10 bytes of opcode:
```
Step1: PUSH1 2a // push 42 on the stack (PUSH1 is opcode=x60) =>x602a
Step2: PUSH1 0 // push 0x0 on top of the stack (we only have one storage variable so it will be located at storage slot 0x0 =>x6000
Step3: MSTORE // store value of opcodes in memory which MSTORE=x52
Step4: PUSH1 20 // push all opcodes into 32 bytes =>x6020
Step5: PUSH1 0 // push 0x0 on top of this stack =>x6000
Step6: RETURN // return value to EVM ( RETURN is opcode which is 0xf3 in hex value)
Total now from step1-step6 is 10 bytes = "0x602a60005260206000f3" //this is value that we want program to have in one slot
```

refer from [ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes](https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2)

## Part2: Initialization opcodes.
These opcodes need to replicate your runtime opcodes to memory, before returning them to the EVM. Recall that the EVM will then automatically save the runtime sequence 0x602a60005260206000f3 to the blockchain.<br />

Store your `42` or `0x2a` as hex value in memory with `mstore(p, v)`, where p is position and v is the value in hexadecimal,we store value in memory index 0:
```
mstore(0, 0x602a60005260206000f3) //replicate your runtime opcodes to memory during creation contract in constructor
```

Acoording to runtime code logic,returning values is handled by the RETURN opcode, which takes in two arguments:<br />
p: the position where your value is stored in memory<br />
s: the size of your stored data. Recall your value is 32 bytes long (or 0x20 in hex).<br />

1 Slot is 32 bytes long and our value `42` was store in memory of opcodes 10 bytes => it means size of data store in 10 bytes or 0x0a.So, the position of your value in memory from all slot will be 32-10=22 (at byte 22 or 0x16 in hex)<br />
it means: p=0x16, s=0x0a //return opcodes to EVM = return(0x16, 0x0a)<br />

Deploy MagicSolver contract on rinkeby network and got address = 0xB0fCAA86efcF31b8d571EAF060ab15782ED80D89
```javascript
await contract.setSolver("0xB0fCAA86efcF31b8d571EAF060ab15782ED80D89");
await contract.solver();
> '0xB0fCAA86efcF31b8d571EAF060ab15782ED80D89'
```