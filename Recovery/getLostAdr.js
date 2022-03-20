const rlp = require('rlp');
const keccak = require('keccak');

var nonce = 0x01;
var sender = '0x1e55C163a6Dbd82413636332BA1321686FF8D101'; //Recover contract (owner who create SimpleToken contract)

var input_arr = [ sender, nonce ];
var rlp_encoded = rlp.encode(input_arr);
const encodedAsBuffer = Buffer.from(rlp_encoded)

var contract_address_long = keccak('keccak256').update(encodedAsBuffer).digest('hex');
/* Another method by web3
web3.utils.soliditySha3("0xd6","0x94","0x1e55C163a6Dbd82413636332BA1321686FF8D101", "0x01")
got '0x268c20205154f510787344a86ddec4068e33bbe420685122ba02db89abbac01c'
Just remove 0x at the front, it same value with contract_address_long but keccak use digest('hex') to remove 0x
*/
var contract_address = contract_address_long.substring(24); //Trim the first 24 characters.
console.log("contract_address: 0x" + contract_address); //contract_address: 0x6ddec4068e33bbe420685122ba02db89abbac01c