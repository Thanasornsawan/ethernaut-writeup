pragma solidity ^0.6.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol";
contract MaliciousToken is ERC20 {
    constructor () public ERC20("Malicious", "MAL") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}
//MaliciousToken contract address: 0x51789c75256E68b5A80233c9Fc4477649990960C