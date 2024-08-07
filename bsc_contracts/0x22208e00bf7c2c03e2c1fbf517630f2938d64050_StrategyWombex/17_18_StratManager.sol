// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../Ownable.sol";
import "../Pausable.sol";

contract StratManager is Ownable, Pausable {
    /**
     * @dev Beefy Contracts:
     * {keeper} - Address to manage a few lower risk features of the strat
     * {HoldersFeeRecipient} - Address of the strategy author/deployer where strategist fee will go.
     * {vault} - Address of the vault that controls the strategy's funds.
     * {unirouter} - Address of exchange to execute swaps.
     */
    address public keeper;
    address public HoldersFeeRecipient;
    address public unirouter;
    address public vault;
    address public ProtocolFeeRecipient;

    /**
     * @dev Initializes the base strategy.
     * @param _keeper address to use as alternative owner.
     * @param _holdersFeeRecipient address where strategist fees go.
     * @param _unirouter router to use for swaps
     * @param _vault address of parent vault.
     * @param _protocolFeeRecipient address where to send Beefy's fees.
     */
    constructor(
        address _keeper,
        address _holdersFeeRecipient,
        address _unirouter,
        address _vault,
        address _protocolFeeRecipient
    ) {
        keeper = _keeper;
        HoldersFeeRecipient = _holdersFeeRecipient;
        unirouter = _unirouter;
        vault = _vault;
        ProtocolFeeRecipient = _protocolFeeRecipient;
    }

    // checks that caller is either owner or keeper.
    modifier onlyManager() {
        require(msg.sender == owner() || msg.sender == keeper, "!manager");
        _;
    }

    /**
     * @dev Updates address of the strat keeper.
     * @param _keeper new keeper address.
     */
    function setKeeper(address _keeper) external onlyManager {
        keeper = _keeper;
    }

    /**
     * @dev Updates address where strategist fee earnings will go.
     * @param _strategist new strategist address.
     */
    function setStrategist(address _strategist) external onlyOwner {
        HoldersFeeRecipient = _strategist;
    }

    /**
     * @dev Updates router that will be used for swaps.
     * @param _unirouter new unirouter address.
     */
    function setUnirouter(address _unirouter) external onlyOwner {
        unirouter = _unirouter;
    }

    /**
     * @dev Updates parent vault.
     * @param _vault new vault address.
     */
    function setVault(address _vault) external onlyOwner {
        vault = _vault;
    }

    /**
     * @dev Updates protocol fee recipient.
     * @param _protocolFeeRecipient new beefy fee recipient address.
     */
    function setProtocolFeeRecipient(address _protocolFeeRecipient) external onlyOwner {
        ProtocolFeeRecipient = _protocolFeeRecipient;
    }

    /**
     * @dev Function to synchronize balances before new user deposit.
     * Can be overridden in the strategy.
     */
    function beforeDeposit() external virtual {}
}