async function main() {
require("dotenv").config();
const { ALCHEMY_KEY, PRIVATE_KEY } = process.env;
const { Transaction } = require('@ethereumjs/tx');
const Common = require('@ethereumjs/common').default;
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(ALCHEMY_KEY);
const instance = "0xdcde1dfC141EE526afE58C48be75835565806f7C";
const player = "0x176366cFD97885245fAEA72f8cB6951e52655Adf";

    const contract = require("./PuzzleProxy.json"); 
    const PuzzleProxyContract = new web3.eth.Contract(contract.abi, instance);
    const nonce = await web3.eth.getTransactionCount(player, 'latest'); // get latest nonce
    const gasEstimate = await PuzzleProxyContract.methods.proposeNewAdmin(player).estimateGas({from: player, to:instance}); // estimate gas
    const data = await PuzzleProxyContract.methods.proposeNewAdmin(player).encodeABI();
    console.log(data); //0xa6376746000000000000000000000000176366cfd97885245faea72f8cb6951e52655adf
    // Create the transaction
    const txParams = {
      'from': player,
      'to': instance,
      'nonce': nonce,
      'gas' : gasEstimate, //26988
      'data': PuzzleProxyContract.methods.proposeNewAdmin(player).encodeABI()
    };

    const signedTx = await web3.eth.accounts.signTransaction(txParams, PRIVATE_KEY);
    
    web3.eth.sendSignedTransaction(signedTx.rawTransaction, function(error, hash) {
    if (!error) {
      console.log("🎉 The hash of your transaction is: ", hash, "\n Check Alchemy's Mempool to view the status of your transaction!");
    } else {
      console.log("❗Something went wrong while submitting your transaction:", error)
    }
   });

}
main();