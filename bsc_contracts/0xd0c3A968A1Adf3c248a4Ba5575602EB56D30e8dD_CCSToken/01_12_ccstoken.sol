// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "./ERC20.sol";
import "./SafeMath.sol";
import "./SafeMathUint.sol";
import "./SafeMathInt.sol";
import "./Context.sol";
import "./Ownable.sol";
import "./IUniswapV2Pair.sol";
import "./IUniswapV2Router.sol";
import "./IUniswapV2Factory.sol";

contract CCSToken is ERC20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint) public wards;
    function rely(address usr) external  auth { wards[usr] = 1; }
    function deny(address usr) external  auth { wards[usr] = 0; }
    modifier auth {
        require(wards[msg.sender] == 1, "ccs/not-authorized");
        _;
    }
    address public nftaddress = 0x4Af9eFA447De9d7Db377e06284E4a1d93663B564;
    address public usdt = 0x55d398326f99059fF775485246999027B3197955;
    address public operationAddress = 0x854fc106c59EBd06BFcf14722dBcc9dF6FB9A38A;
    address public uniswapV2Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    uint256 public swapTokensAtAmount = 5000 * 1E18;
    bool private swapping;

    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);
   
    constructor() public ERC20("Cosmic Stars", "CCS") {
        wards[msg.sender] = 1;
        address _uniswapV2Pair = IUniswapV2Factory(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73).createPair(address(this), usdt);
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
        excludeFromFees(operationAddress, true);
        excludeFromFees(nftaddress, true);
        _mint(operationAddress, 1690000 * 1e18);
    }
	function setOperation(address ust) external auth{
        operationAddress = ust;
	}
	function setNftaddress(address ust) external auth{
        nftaddress = ust;
	}
    function setSwapTokensAtAmount(uint wad) external auth{
        swapTokensAtAmount = wad;
	}
    function excludeFromFees(address account, bool excluded) public auth {
        require(_isExcludedFromFees[account] != excluded, "ccs: Account is already the value of 'excluded'");
        _isExcludedFromFees[account] = excluded;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) public auth {
        require(automatedMarketMakerPairs[pair] != value, "ccs: Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(address from,address to,uint256 amount) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount <= 1E15) {
            super._transfer(from, to, amount);
            return;
        }

        if(automatedMarketMakerPairs[to] && balanceOf(to) ==0) require(_isExcludedFromFees[from], "ccs: 1");
		uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
        if(canSwap && !swapping && !automatedMarketMakerPairs[from] && from != owner() && to != owner()) {
            swapping = true;
            uint256 nftamount = contractTokenBalance.mul(3).div(5);
            super._transfer(address(this),nftaddress,nftamount);
            swapAndLiquify();
            swapping = false;
        }

        if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
        	uint256 fees = amount.mul(5).div(100);
            super._transfer(from, address(this), fees);
            amount = amount.sub(fees);
        }
        super._transfer(from, to, amount);       
    }

    function init() public {
        IERC20(address(this)).approve(uniswapV2Router, ~uint256(0));
        IERC20(usdt).approve(uniswapV2Router, ~uint256(0));
    }

    function swapAndLiquify() internal {
        uint256 tokens = balanceOf(address(this));
        uint256 half = tokens.div(2);
        swapTokensForUsdt(half);
        uint256 usdtamount = IERC20(usdt).balanceOf(operationAddress); 
        IERC20(usdt).transferFrom(operationAddress,address(this),usdtamount);
        IUniswapV2Router(uniswapV2Router).addLiquidity(
            address(this),
            usdt,
            balanceOf(address(this)),
            IERC20(usdt).balanceOf(address(this)),
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            operationAddress,
            block.timestamp
        );
    }

    function swapTokensForUsdt(uint256 tokenAmount) internal{
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        IUniswapV2Router(uniswapV2Router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            operationAddress,
            block.timestamp
        );
    }

    function withdraw(address asses, uint256 amount, address ust) public auth {
        IERC20(asses).transfer(ust, amount);
    }

}
