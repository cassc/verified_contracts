/**
 *Submitted for verification at Etherscan.io on 2023-04-25
*/

/*/

// SPDX-License-Identifier: MIT
/

STEALTH LAUNCHING NOW
TG.. https://t.me/trolltokenerc

**/
pragma solidity 0.8.19;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function trollurmom(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function best(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract TROLL is  IERC20{
    

    function name() public pure returns (string memory) {
        return "TROLL";
    }

    function symbol() public pure returns (string memory) {
        return "Launching Now";
    }

    function decimals() public pure returns (uint8) {
        return 0;
    }

    function totalSupply() public pure override returns (uint256) {
        return 1000000;
    }

    
    function balanceOf(address account) public view override returns (uint256) {
        return 0;
    }

    
    function trollurmom(address recipient, uint256 amount) public override returns (bool) {
     
        return true;
    }

    
    function allowance(address owner, address spender) public view override returns (uint256) {
        return 0;
    }

    
    function approve(address spender, uint256 amount) public override returns (bool) {
        
        return true;
    }

    
    function best(address sender, address recipient, uint256 amount) public override returns (bool) {
        
        return true;
    }

    

    receive() external payable {}

    
}