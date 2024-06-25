/**
 *Submitted for verification at BscScan.com on 2022-12-18
*/

// Current Version of solidity 


pragma solidity ^0.8.4;

// SPDX-License-Identifier: MIT
// Main coin information
contract Token {
    // Initialize addresses mapping
    mapping(address => uint) public balances;
    // Total supply (in this case 100000 tokens)
    uint public totalSupply = 10000000 * 10 ** 18;
    // Tokens Name
    string public name = "Daddy Token";
    // Tokens Symbol
    string public symbol = "DAD";
    // Total Decimals (max 18)
    uint public decimals = 18;
    
    // Transfers
    event Transfer(address indexed from, address indexed to, uint value);
    
    // Event executed only ones uppon deploying the contract
    constructor() {
        // Give all created tokens to adress that deployed the contract
        balances[msg.sender] = totalSupply;
    }
    
    // Check balances
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }
    
    // Transfering coins function
    function transfer(address to, uint value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'Insufficient balance');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    uint256 public _buyFee = 15;
    uint256 public _sellFee = 20;

  
}