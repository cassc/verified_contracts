pragma solidity ^0.5.16;

import "./VBep20.sol";

/**
 * @title Venus's VBep20Delegate Contract
 * @notice VTokens which wrap an EIP-20 underlying and are delegated to
 * @author Venus
 */
contract VBep20Delegate is VBep20, VDelegateInterface {
    /**
     * @notice Construct an empty delegate
     */
    constructor() public {}

    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public onlyAdmin() {
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }
    }

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public onlyAdmin() {
        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

    }
}