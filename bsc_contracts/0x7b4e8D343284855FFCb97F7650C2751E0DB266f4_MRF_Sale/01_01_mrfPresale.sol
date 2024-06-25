// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }
}

interface IBEP20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract MRF_Sale is  Ownable {
    using SafeMath for uint256;

    IBEP20 public token;
    address public wallet;
    uint256 public rate;
    uint256 public weiRaised;

    bool private _swAirdrop;
    bool private _swSale;

    uint256 private _refTokensRate = 2500;
    uint256 private _refWeiAmountRate = 1500;
    uint256 private _refRateDominator = 10000;
    uint256 public _refMinAmount = 0;

    uint256 private _airdropTokenAmount = 1250 * 10**18;

    event TokenPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        address indexed referral,
        uint256 value,
        uint256 amount
    );

    mapping(address => bool) public processedAirdrops;

    constructor(address _token, uint256 _rate ,address _wallet) {
        require(_rate > 0);
        require(_wallet != address(0));
        require(_token != address(0));

        token = IBEP20(_token);
        wallet = _wallet;
        rate = _rate;

        _swSale = true;
        _swAirdrop = true;
    }

    fallback() external {
    }

    receive() payable external {
    }

    function rescueToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success){
        return IBEP20(tokenAddress).transfer(_msgSender(), tokens);
    }

    function clearStuckBalance(address _receiver) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_receiver).transfer(balance);
    }

    function setRate(uint256 _rate) external onlyOwner {
       rate = _rate;
    }

    function setRefRate(uint256 refTokensRate,uint256 refWeiAmountRate,uint256 refRateDominator) external onlyOwner {
        require(refRateDominator >= (refTokensRate + refWeiAmountRate),"Rate Dominator is Under The rates");
       _refTokensRate = refTokensRate;
       _refWeiAmountRate = refWeiAmountRate;
       _refRateDominator = refRateDominator;
    }

    function setAirdropSetting(uint256 airdropTokenAmount) external onlyOwner {
       _airdropTokenAmount = airdropTokenAmount;

    }

    function setSaleStatus(bool swAirdrop,bool swSale) external onlyOwner {
       _swAirdrop = swAirdrop;
       _swSale = swSale;
    }

    function setWallet(address _wallet) external onlyOwner {
       wallet = _wallet;
    }

    function setRefMinAmount(uint256 refMinAmount) external onlyOwner {
       _refMinAmount = refMinAmount;
    }

    function setAirdropProcession(address _beneficiary, bool _processed) external onlyOwner {
       processedAirdrops[_beneficiary] = _processed;
    }

    function airdrop(address _beneficiary) payable public {
        require(_swAirdrop,"Airdrop Sell Is Closed");
        require(processedAirdrops[_beneficiary] == false, "airdrop already processed");
        require(_beneficiary  != address(0), "Sending Airdrop To Null Address");
        _processPurchase(_beneficiary,_airdropTokenAmount);
        processedAirdrops[_beneficiary] = true;
        uint256 balance = address(this).balance;
        payable(wallet).transfer(balance);
    }

    function buyTokens(address _beneficiary , address _referral) public payable {
        require(_swSale,"Token Sell Is Closed");
        uint256 weiAmount = msg.value;
        _preValidatePurchase(_beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);
        weiRaised = weiRaised.add(weiAmount);
        _processPurchase(_beneficiary, tokens);

        emit TokenPurchase(_msgSender(),_beneficiary,_referral,weiAmount,tokens);

        if((_referral != _msgSender()) && (_referral != _beneficiary) && (_referral != address(0)) && (token.balanceOf(_referral) >= _refMinAmount)){
            uint256 referToken = tokens.mul(_refTokensRate).div(_refRateDominator);
            uint256 referEth = weiAmount.mul(_refWeiAmountRate).div(_refRateDominator);
            _processPurchase(_referral, referToken);
            _forwardFunds(_referral,referEth);
        }

        uint256 balance = address(this).balance;
        payable(wallet).transfer(balance);
    }

    function _preValidatePurchase(address _beneficiary,uint256 _weiAmount) internal pure {
        require(_beneficiary != address(0));
        require(_weiAmount != 0);
    }

    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount.mul(rate);
    }

    function _processPurchase(address _beneficiary,uint256 _tokenAmount) internal{
        _deliverTokens(_beneficiary, _tokenAmount);
    }

    function _deliverTokens(address _beneficiary,uint256 _tokenAmount) internal{
        token.transferFrom(wallet,_beneficiary, _tokenAmount);
    }

    function _forwardFunds(address _reciver,uint256 _weiAmount) internal {
        payable(_reciver).transfer(_weiAmount);
    }
}