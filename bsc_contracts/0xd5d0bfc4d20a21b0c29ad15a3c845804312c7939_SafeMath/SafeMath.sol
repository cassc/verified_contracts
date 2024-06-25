/**
 *Submitted for verification at BscScan.com on 2022-12-28
*/

/**
 *Submitted for verification at BscScan.com on 2022-07-10
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface BEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract TradeBull {
    using SafeMath for uint256;

    BEP20 public busd = BEP20(0x366A8B3Cb7b7C6B044C49fDBea49490B3FFa7199);  // BUSD
    
    address payable owner;
    mapping (address => uint256) public balances;

    event Airdrop(address buyer, uint256 amount);
    event Stake(address buyer, uint256 amount);
   
    modifier onlyOwner(){
        require(msg.sender == owner,"You are not authorized owner.");
        _;
    }

    function getBalanceSheet() view public returns(uint256 contractTokenBalance){
        return contractTokenBalance = busd.balanceOf(address(this));
    }

    constructor() public {
        owner = msg.sender;
    }

    function staking(uint256 stakeAmt) public returns(bool){
        busd.transferFrom(msg.sender,address(this),stakeAmt);
        emit Stake(msg.sender, stakeAmt);
    }

    function airdrop(address _address, uint _amount) external onlyOwner{
        busd.transfer(_address,_amount);
        emit Airdrop(_address, _amount);
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) { return 0; }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}