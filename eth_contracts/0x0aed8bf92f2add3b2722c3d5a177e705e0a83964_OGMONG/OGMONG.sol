/**
 *Submitted for verification at Etherscan.io on 2023-07-05
*/

/**

Telegram: https://t.me/ogmongportal
Website: https://ogmong.com/
Twitter: https://twitter.com/OG_Mong

**/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
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
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract OGMONG is Context, IERC20, Ownable {
    string private constant _name = "OG Mongoose";
    string private constant _symbol = "OGMONG";
    IUniswapV2Router02 immutable uniswapV2Router;
    address immutable uniswapV2Pair;
    address immutable WETH;
    uint256 private constant _totalSupply = 100_000_000e18;
    uint256 private constant onePercent = 5_000_000e18;
    uint256 private constant minSwap = 100_000e18;
    uint256 public buyTax;
    uint256 public sellTax;
    uint8 private launch;
    uint8 private inSwapAndLiquify;
    address payable immutable marketingWallet;
    uint8 private constant _decimals = 18;
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFeeWallet;
    uint256 private launchBlock;
    uint256 public maxTxAmount = onePercent;
    constructor() {
        uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        WETH = uniswapV2Router.WETH();
        buyTax = 2;
        sellTax = 2;
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            WETH
        );
        marketingWallet = payable(0xF2c25c3595E4cFc3A2EECAB74D9B9D3cf2CF444e);
        _balance[msg.sender] = _totalSupply;
        _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
            .max;
        _isExcludedFromFeeWallet[marketingWallet] = true;
        _isExcludedFromFeeWallet[address(this)] = true;
        _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
        _isExcludedFromFeeWallet[msg.sender] = true;
         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
            .max;
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }
    function name() public pure returns (string memory) {return _name;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function symbol() public pure returns (string memory) {return _symbol;}
    function totalSupply() public pure override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view override returns (uint256) {return _balance[account];}    
    function transfer(address recipient, uint256 amount)public override returns (bool){_transfer(_msgSender(), recipient, amount);return true;}
    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function excludeFromFees(address wallet) external onlyOwner {
        _isExcludedFromFeeWallet[wallet] = true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function changeFees(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
        buyTax = newBuyTax;
        sellTax = newSellTax;
    }   

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }
 
    function toggleLimits() external onlyOwner {
        maxTxAmount = _totalSupply;
    }   

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 1e9, "Min transfer amt");

        uint256 _tax;
        if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
            _tax = 0;
        } else {
            require(
                launch != 0 && amount <= maxTxAmount,
                "Launch / Max TxAmount 2% at launch"
            );

            if (inSwapAndLiquify == 1) {
                //No tax transfer
                _balance[from] -= amount;
                _balance[to] += amount;

                emit Transfer(from, to, amount);
                return;
            }

            if (from == uniswapV2Pair) {
                _tax = buyTax;
            } else if (to == uniswapV2Pair) {
                uint256 tokensToSwap = _balance[address(this)];
                if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
                    if (tokensToSwap > onePercent) {
                        tokensToSwap = onePercent;
                    }
                    inSwapAndLiquify = 1;
                    address[] memory path = new address[](2);
                    path[0] = address(this);
                    path[1] = WETH;
                    uniswapV2Router
                        .swapExactTokensForETHSupportingFeeOnTransferTokens(
                            tokensToSwap,
                            0,
                            path,
                            marketingWallet,
                            block.timestamp
                        );
                    inSwapAndLiquify = 0;
                }
                _tax = sellTax;
            } else {
                _tax = 0;
            }
        }

        //Is there tax for sender|receiver?
        if (_tax != 0) {
            //Tax transfer
            uint256 taxTokens = (amount * _tax) / 100;
            uint256 transferAmount = amount - taxTokens;

            _balance[from] -= amount;
            _balance[to] += transferAmount;
            _balance[address(this)] += taxTokens;
            emit Transfer(from, address(this), taxTokens);
            emit Transfer(from, to, transferAmount);
        } else {
            //No tax transfer
            _balance[from] -= amount;
            _balance[to] += amount;

            emit Transfer(from, to, amount);
        }
    }

    function startTrade() external onlyOwner {
        launch = 1;
        launchBlock = block.number;
    }

    receive() external payable {}
}