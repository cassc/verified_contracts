// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/IVotingEscrow.sol";
import "../interfaces/IVotingEscrowMigrator.sol";
import "../libraries/Integers.sol";

contract VotingEscrowMigratorMock is IVotingEscrowMigrator {
    using SafeERC20 for IERC20;
    using Integers for int128;
    using Integers for uint256;

    struct LockedBalance {
        int128 amount;
        int128 discount;
        uint256 start;
        uint256 end;
    }

    address public immutable token;
    mapping(address => LockedBalance) public locked;
    mapping(address => address[]) public delegates;

    constructor(address ve) {
        token = IVotingEscrow(ve).token();
    }

    function migrate(
        address account,
        int128 amount,
        int128 discount,
        uint256 start,
        uint256 end,
        address[] calldata _delegates
    ) external override {
        locked[account] = LockedBalance(amount, discount, start, end);
        delegates[account] = _delegates;
    }

    function withdraw() external {
        LockedBalance memory _locked = locked[msg.sender];
        require(block.timestamp >= _locked.end, "VE: LOCK_NOT_EXPIRED");

        uint256 value = _locked.amount.toUint256();
        uint256 discount = _locked.discount.toUint256();

        locked[msg.sender] = LockedBalance(0, 0, 0, 0);

        if (value > discount) {
            IERC20(token).safeTransfer(msg.sender, value - discount);
        }
    }
}