/**
 *Submitted for verification at BscScan.com on 2022-12-05
*/

/**
 *Submitted for verification at BscScan.com on 2022-11-10
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Context {

    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) 
    
    {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract GTP_PRESALE is Ownable {
    using SafeMath for uint256;

    IBEP20 public token;
    address payable public mainWallet;
    uint256 public rewardTokenCount = 2500000000000000000000;

    bool public presaleStatus;

    mapping(address => uint256) public deposits;

    constructor(IBEP20 _token,address payable mainAddress)  {
        token = _token;
        mainWallet = mainAddress;
        presaleStatus = true;
    }

    receive() payable external {
        deposit();
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return token.balanceOf(account);
    }


    function getToken(uint256 value) public view returns(uint256)
    {
        return (rewardTokenCount*value)/1e18;
    }

    function deposit() public payable 
    {
        require(presaleStatus == true, "Presale : Presale is finished");
        require(msg.value >= 0, "Presale : Unsuitable Amount");
    
        uint256 tokenAmount = getToken(msg.value);
        
        token.transfer(msg.sender, tokenAmount);
        
        deposits[msg.sender] = deposits[msg.sender].add(msg.value);
        emit Deposited(msg.sender, msg.value);
    }


    
    function releaseFunds() external onlyOwner 
    {
        mainWallet.transfer(address(this).balance);
    }

function contractbalance() public view returns(uint256)
    {
        return address(this).balance;
    }


    function recoverBEP20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        IBEP20(tokenAddress).transfer(this.owner(), tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    function setWithdrawAddress(address payable _address) external onlyOwner {
        mainWallet = _address;
    }
    
    function setRewardTokenCount(uint256 _count) external onlyOwner {
        rewardTokenCount = _count;
    }
    



    function stopPresale() external onlyOwner {
        presaleStatus = false;
    }

    function resumePresale() external onlyOwner {
        presaleStatus = true;
    }
    

    event Deposited(address indexed user, uint256 amount);
    event Recovered(address token, uint256 amount);
}