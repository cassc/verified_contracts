/**
 *Submitted for verification at BscScan.com on 2022-12-26
*/

// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

contract Collector {

    event Replenish(address user, uint256 amount);
    event ReplenishFor(address sender, address receiver, uint256 amount);
    event Withdraw(address user, uint256 amount);

    error EtherTransferFailed();
    error InsuffisientBalance();

    mapping(address => uint256) private _balances;
    
    function balanceOf(address user) external view returns(uint256) {
        return _balances[user];
    }

    function replenish() external payable {
        _balances[msg.sender] += msg.value;

        emit Replenish(msg.sender, msg.value);
    }
    
    function replenishFor(address receiver) external payable {
        _balances[receiver] += msg.value;

        emit ReplenishFor(msg.sender, receiver, msg.value);
    }

    function withdraw(uint256 amount) external {
        _withdraw(msg.sender, amount);
    }

    function withdrawTo(address to, uint256 amount) external {
        _withdraw(to, amount);
    }

    function transfer(address to, uint256 amount) external {
        if(_balances[msg.sender] < amount) revert InsuffisientBalance();
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
    }

    function _withdraw(address to, uint256 amount) internal {
        if(_balances[msg.sender] < amount) revert InsuffisientBalance();
        _balances[msg.sender] -= amount;

        (bool sent,) =to.call{ value: amount }("");
        if(!sent) revert EtherTransferFailed();
    }
}