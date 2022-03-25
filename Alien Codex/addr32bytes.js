/*
Address have 20 byte value size (160 bits or 40 hex characters). 
We need byte32.So, 32-20= need more 12 byte or 24 hex characters
*/

let player = "176366cFD97885245fAEA72f8cB6951e52655Adf";
let prefix= "0x";
let pad_zero_left = (player).padStart(64, '0');
let addr = prefix.concat(pad_zero_left);
console.log(addr); //0x000000000000000000000000176366cFD97885245fAEA72f8cB6951e52655Adf