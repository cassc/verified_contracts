/*

https://twitter.com/fkfantaERC
https://t.me/fkfanta

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FkFantaCoin is ERC20, Ownable {
    error ErrMaxWallet();
    error ErrBots();

    uint256 public constant MAX_SUPPLY = 69_000_000 ether;
    uint256 public constant INITIAL_MAX_WALLET = 69_000 ether;
    address private constant BURN_ADDRESS = address(0xdead);

    uint256 public maxWallet;
    bool public maxWalletEnabled = true;

    constructor() ERC20("FKFANTA Coin", "FKFANTA") {
        maxWallet = INITIAL_MAX_WALLET;
        _mint(tx.origin, MAX_SUPPLY);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (maxWalletEnabled) {
            bool isOwner = from == owner() || to == owner();
            bool isBurning = to == BURN_ADDRESS;
            if (!isOwner && !isBurning) {
                if (amount + balanceOf(to) > maxWallet) {
                    revert ErrMaxWallet();
                }
            }
        }

        super._transfer(from, to, amount);
    }

    function removeLimits() external onlyOwner {
        maxWalletEnabled = false;
    }

    function maxWalletX2() external onlyOwner {
        maxWallet = maxWallet * 2;
    }

    function setMaxWallet(uint256 m_) external onlyOwner {
        maxWallet = m_;
    }
}