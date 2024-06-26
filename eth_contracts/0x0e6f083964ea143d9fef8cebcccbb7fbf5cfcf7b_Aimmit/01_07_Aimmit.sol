// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./IERC20.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";
import "./Ownable.sol";

contract Aimmit is Ownable, IERC20 {

    //constant
    uint8 constant public decimals = 18;
    uint256 constant public MAX = ~uint256(0);
    address public immutable uniswapV2Pair;
    IUniswapV2Router02 public immutable uniswapV2Router;

    //attribute
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint256 public buyFee;
    uint256 public sellFee;
    uint256 public maxBuyAmount = 10000;
    address public feeAddress;
    bool private inSwap;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public blacklist;
    mapping(address => uint) public buyAmount;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply, uint256 _buyFee, uint256 _sellFee) {
        name = _name;
        symbol = _symbol;
        uint amount = _totalSupply * 1 ether;
        totalSupply = amount;
        balanceOf[msg.sender] = amount;
        buyFee = _buyFee;
        sellFee = _sellFee;
        feeAddress = owner();

        address currentRouter;
        if (block.chainid == 56) {
            currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; //BCS Router
        } else if (block.chainid == 97) {
            currentRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; //BCS Testnet
        } else if (block.chainid == 43114) {
            currentRouter = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4; //Avax Mainnet
        } else if (block.chainid == 137) {
            currentRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; //Polygon Ropsten
        } else if (block.chainid == 6066) {
            currentRouter = 0x4169Db906fcBFB8b12DbD20d98850Aee05B7D889; //Tres Leches Chain
        } else if (block.chainid == 250) {
            currentRouter = 0xF491e7B69E4244ad4002BC14e878a34207E38c29; //SpookySwap FTM
        } else if (block.chainid == 42161) {
            currentRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; //Arbitrum Sushi
        } else if (block.chainid == 1 || block.chainid == 5) {
            currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Mainnet
        } else {
            revert("You're not Blade");
        }

        uniswapV2Router = IUniswapV2Router02(currentRouter);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())   
            .createPair(address(this), uniswapV2Router.WETH());

        allowance[address(this)][currentRouter] = MAX;

        emit Transfer(address(0), msg.sender, amount);
    }

    function transfer(address to, uint256 amount) external virtual returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external virtual returns (bool success) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external virtual returns (bool success) {
        uint currentAllowance = allowance[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allownace");
        _approve(sender, msg.sender, currentAllowance - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer sender the zero address");
        require(recipient != address(0), "ERC20: transfer recipient the zero address");
        require(balanceOf[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(!blacklist[sender] && !blacklist[recipient], "black address");

        balanceOf[sender] -= amount;

        if(sender != feeAddress && recipient != feeAddress) {
            // 先換
            if (recipient == uniswapV2Pair && !inSwap) {
                uint256 contractTokenBalance = balanceOf[address(this)];
                if (contractTokenBalance > 0) {
                    uint256 numTokensSellToFund = amount;
                    numTokensSellToFund = numTokensSellToFund > contractTokenBalance ? contractTokenBalance : numTokensSellToFund;
                    swapTokenForETH(numTokensSellToFund);
                }
            }

            if (sender == uniswapV2Pair) {
                require(buyAmount[recipient] <= maxBuyAmount, "over buy");
                buyAmount[recipient] += amount;

                uint256 fee = amount * buyFee / 100;
                if (fee > 0) {
                    balanceOf[address(this)] += fee;
                    emit Transfer(sender, address(this), fee);
                }

                amount = amount - fee;
            }

            if (recipient == uniswapV2Pair) {
                if(sender != address(this)) {
                    uint256 fee = amount * sellFee / 100;
                    if (fee > 0) {
                        balanceOf[address(this)] += fee;
                        emit Transfer(sender, address(this), fee);
                    }

                    amount = amount - fee;
                }
            }
        }

        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function swapTokenForETH(uint256 amount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            feeAddress,
            block.timestamp
        );
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function updateData(uint256 _buyFee, uint256 _sellFee, address _feeAddress) external onlyOwner {
        require(_buyFee <= 25,"buy too high");
        require(_sellFee <= 25,"sell too high");

        buyFee = _buyFee;
        sellFee = _sellFee;
        feeAddress = _feeAddress;
    }

    function setBlacklist(address account, bool value) external onlyOwner {
        blacklist[account] = value;
    }

    function setBuyAmount(uint amount) external onlyOwner {
        maxBuyAmount = amount;
    }

    receive() external payable {}

}