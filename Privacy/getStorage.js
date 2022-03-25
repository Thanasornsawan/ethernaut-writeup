require("dotenv").config();
const Web3 = require('web3');
const rpcURL = process.env.INFURA_KEY; // Your RPC URL goes here
const web3 = new Web3(rpcURL);
let address= '0x71B36F81241A21Ba0712190D5Fd637085d18Db80'; //get from contract.address in 'Get new instance'
let storage = [];

let callbackFNConstructor = (index) => (error, contractData) => {
  storage[index] = contractData
  if(index==5){
    console.log(storage[5]); //got 0x621e4f9c9fce7ccc4829660be3ae726a0bee35eda2d34f2381083f76e5b25ffb
    //console.log(storage); 
    /* result if want to see all slot value
    [
    '0x0000000000000000000000000000000000000000000000000000000000000001', //bool locked
    '0x00000000000000000000000000000000000000000000000000000000623728e8', //uint256 ID
    '0x0000000000000000000000000000000000000000000000000000000028e8ff0a', //uint8 flattening
    '0x3809c1b6af00ce53bffe1fe85bbe005b489d69e276899b8922504cd3764fc6c7', //uint8 denomination
    '0xa952766b53db2509e7e6d344a103a4900e16f90a18b5ee17b4b7bd9ae48fe736', //uint16 awkwardness
    '0x621e4f9c9fce7ccc4829660be3ae726a0bee35eda2d34f2381083f76e5b25ffb' //bytes32[3] data
    ]
    Maximum one slot hold 32 bytes mean 256 bit (1byte=8 bit),if less than 32 byte,it possible to that slot can hold more than one parameters
    Ex: slot0= bool value have 1 byte and byte4 value have 4 byte
    */
  }
}

for(var i = 0; i < 6; i++) {
  web3.eth.getStorageAt(address, i, callbackFNConstructor(i))
}
