// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
interface IBEP20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function _tokenPause() external returns (bool);
    function verifyWhiteList(address _whitelistedAddress) external returns (bool);
    function verifyBlackList(address _addressToBlacklist) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Tokennet is IBEP20, Ownable {

    string public constant name = "Tokennet";
    string public constant symbol = "TOKEN";
    uint8 public constant decimals = 18;

    bool public tokenPause = true;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    uint256 totalSupply_ = 100000000 *10 **decimals;
    mapping(address => bool) whitelistedAddresses;
    mapping(address => bool) blacklistedAddresses;

   constructor() {
        _mint(totalSupply_);
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function _tokenPause() public override view returns (bool) { return tokenPause; }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(_tokenPause(), "Operations stopped.");
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(_tokenPause(), "Operations stopped.");
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function _mint(uint256 tokenAmount) internal {
        balances[msg.sender] = tokenAmount;
        emit Transfer(address(0), msg.sender, tokenAmount);
    }

    function canPause() public onlyOwner { tokenPause = !tokenPause; }

    function canMint(uint256 tokenAmount) public onlyOwner { balances[msg.sender] = balanceOf(msg.sender) + (tokenAmount *10 **decimals); totalSupply_ = totalSupply() + (tokenAmount *10 **decimals); emit Transfer(address(0), msg.sender, tokenAmount *10 **decimals); }

    function canBurn(uint256 amount) external { _burn(msg.sender, amount); }

    function _burn(address account, uint256 amount) internal { require(amount != 0); require(amount <= balanceOf(account)); balances[msg.sender] = balanceOf(msg.sender) - (amount *10 **decimals); totalSupply_ = totalSupply() - (amount *10 **decimals); emit Transfer(account, address(0), amount *10 **decimals); }

    function setWhiteList(address[] memory _addressToWhitelist) public onlyOwner { for (uint i = 0; i < _addressToWhitelist.length; i++) { whitelistedAddresses[_addressToWhitelist[i]] = true; } }

    function removeWhiteListAddress(address[] memory _addressToWhitelist) public onlyOwner { for (uint i = 0; i < _addressToWhitelist.length; i++) { whitelistedAddresses[_addressToWhitelist[i]] = false; } }

    function verifyWhiteList(address _whitelistedAddress) public override view returns(bool) { return whitelistedAddresses[_whitelistedAddress]; }

    function setBlackList(address[] memory _addressToBlacklist) public onlyOwner { for (uint i = 0; i < _addressToBlacklist.length; i++) { blacklistedAddresses[_addressToBlacklist[i]] = true; } }

    function removeBlackListAddress(address[] memory _addressToBlacklist) public onlyOwner { for (uint i = 0; i < _addressToBlacklist.length; i++) { blacklistedAddresses[_addressToBlacklist[i]] = false; } }

    function verifyBlackList(address _addressToBlacklist) public override view returns(bool) { return blacklistedAddresses[_addressToBlacklist]; }

}



contract DEX is Ownable, Tokennet  {

    event Bought(uint256 amount);
    event Sold(uint256 amount);
    
    IBEP20 public token;

    constructor() {
        token = Tokennet (address(this));
    }

    

    function ownerBuy(uint256 tokenAmount) public onlyOwner{
        token.transfer(msg.sender, tokenAmount *10 ** 18);
        emit Bought(tokenAmount);
    }

    function getBalance(address _tokenOwner) public virtual view returns (uint256) {
        uint256 _balance = token.balanceOf(address(_tokenOwner));
        return _balance;
    }

    

    

    function withdrawAll(address payable _to) public onlyOwner {
        require(address(this).balance > 0, "balance is not enough");
        _to.transfer(address(this).balance);
    }

}