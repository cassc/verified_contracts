// developer: Lucas Iwai
// MyAI Platform Contract

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyAIPayment is Ownable {
    address public admin;
    IERC20 public token;
    bool public paused = false;
    address public treasuryWallet;
    address[2] public devWallets;
    uint16[2] public devFees;
    uint16 public totalPercent = 10000;

    event TokenSent(address payer, uint256 amount);

    modifier notPaused() {
        require(paused == false);
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "You are not an admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    function setTokenAddress(IERC20 _token) public onlyAdmin {
        token = _token;
    }

    function setTreasuryWallet(address _treasuryWallet) public onlyAdmin {
        treasuryWallet = _treasuryWallet;
    }

    function setDevWallets(address[2] calldata _devWallets) public onlyAdmin {
        devWallets[0] = _devWallets[0];
        devWallets[1] = _devWallets[1];
    }

    function setDevFees(uint16[2] calldata _devFees) public onlyAdmin {
        devFees[0] = _devFees[0];
        devFees[1] = _devFees[1];
    }

    function setPause(bool _paused) public onlyAdmin {
        paused = _paused;
    }

    function transferOwnership(address newOwner)
        public
        virtual
        override
        onlyAdmin
    {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
        admin = newOwner;
    }

    function sendToken(uint256 _amount) public notPaused {
        token.transferFrom(
            msg.sender,
            payable(treasuryWallet),
            (_amount * (totalPercent - devFees[0] - devFees[1])) / totalPercent
        );
        token.transferFrom(
            msg.sender,
            payable(devWallets[0]),
            (_amount * devFees[0]) / totalPercent
        );
        token.transferFrom(
            msg.sender,
            payable(devWallets[1]),
            (_amount * devFees[1]) / totalPercent
        );

        emit TokenSent(msg.sender, _amount);
    }
}