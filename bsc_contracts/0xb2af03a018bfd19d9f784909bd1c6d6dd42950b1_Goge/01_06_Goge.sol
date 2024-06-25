// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "ERC20.sol";
import "Ownable.sol";

contract Goge is ERC20, Ownable {
    constructor(uint256 _initialTaxRate) ERC20("Goge", "GOG") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
        setTaxWallet(owner());
        setTaxRate(_initialTaxRate);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function setTaxWallet(address _newTaxWallet) public onlyOwner {
        ERC20.taxWallet = _newTaxWallet;
    }

    function setTaxRate(uint256 _newTaxRate) public onlyOwner {
        ERC20.taxRate = _newTaxRate;
    }
    
}
