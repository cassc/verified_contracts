/**
 *Submitted for verification at BscScan.com on 2023-02-16
*/

/**
 *Submitted for verification at BscScan.com on 2023-02-02
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;
    address public _creator;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
        _creator = _msgSender();
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract iknow is Context, Ownable, IERC20, IERC20Metadata {
    using SafeMath for uint256;
    string private _name = "iknow";
    string private _symbol = "iknow";
    uint8 private _decimals = 9;
    uint256 private _totalSupply;
    uint256 public _taxSell = 7;
    uint256 public _taxBuy = 7;
    uint256 public _taxDivider = 100;
    address public _recipientFee;
    uint256 public _taxRFI = 1;
    bool public tradingEnabled;
    bool public swapEnabled;
    mapping(address => bool) private _isBot;

    function setTax(uint256 taxSell_, uint256 taxBuy_) public onlyOwner {
        _taxSell = taxSell_;
        _taxBuy = taxBuy_;
    }

    function setTaxDivider(uint256 input_) public onlyOwner {
        _taxDivider = input_;
    }

    function setTransferFeeAddress(address account) public onlyOwner {
        require(account != address(0), "Zero Address.");
        _recipientFee = account;
    }

    function setAntibot(address account, bool _bot) external onlyOwner {
        require(_isBot[account] != _bot, "Value already set");
        _isBot[account] = _bot;
    }

    function setRFI(uint256 percent_) public onlyOwner {
        _taxRFI = percent_;
    }

    function isBot(address account) public view returns (bool) {
        return _isBot[account];
    }

    function startTrading() external onlyOwner {
        tradingEnabled = true;
        swapEnabled = true;
        emit TradingEnabled(block.timestamp);
    }

    address DEAD = 0x000000000000000000000000000000000000dEaD;

    //mainnet
     address ZERO = address(0);
     address ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
     address FACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
     address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    //testnet
    //address ZERO = address(0);
    //address ROUTER = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    //address FACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    //address WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;

    address public _pair;
    IRouter public _router;
    bool public inSwap;
    event TradingEnabled(uint256 startDate);
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public _excludedBuyFee;
    mapping(address => bool) public _excludedSellFee;

    function changeExcludeBuyFee(address account) public onlyOwner {
        _excludedBuyFee[account] = !_excludedBuyFee[account];
    }

    function changeExcludeSellFee(address account) public onlyOwner {
        _excludedSellFee[account] = !_excludedSellFee[account];
    }

    constructor() {
        emit OwnershipTransferred(address(0), _msgSender());
        _router = IRouter(ROUTER);
        _pair = IFactory(_router.factory()).createPair(WBNB, address(this));
        _excludedSellFee[owner()] = true;
        _excludedSellFee[address(this)] = true;
        _excludedSellFee[DEAD] = true;
        _excludedBuyFee[owner()] = true;
        _excludedBuyFee[address(this)] = true;
        _excludedBuyFee[DEAD] = true;
        _allowances[address(this)][address(_router)] = ~uint256(0);
        _mint(_msgSender(), 100000000 * 10**uint256(_decimals));
    }

    receive() external payable {}

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function currentBalance() public view returns (uint256) {
        return balanceOf(address(this));
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        uint256 newAmount = amount - 100;
        _transferFee(_msgSender(), recipient, newAmount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 newAmount = amount - 100;
        if (_allowances[sender][_msgSender()] != ~uint256(0)) {
            _allowances[sender][_msgSender()] = _allowances[sender][
                _msgSender()
            ].sub(newAmount, "Insufficient allowance.");
        }

        _transferFee(sender, recipient, newAmount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "makdev -_- : decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual returns (bool) {
        require(!_isBot[sender] && !_isBot[recipient], "Anti Bots");

        if (
            !_excludedBuyFee[sender] &&
            !_excludedBuyFee[recipient] &&
            !_excludedSellFee[sender] &&
            !_excludedSellFee[recipient]
        ) {
            require(tradingEnabled, "Trading is not enabled yet");
        }

        require(
            sender != address(0),
            "makdev -_-: transfer from the zero address"
        );
        require(
            recipient != address(0),
            "makdev -_-: transfer to the zero address"
        );
        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "makdev -_-: transfer amount exceeds balance"
        );

        unchecked {
            _balances[sender] = senderBalance - amount;
        }

        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _transferFee(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if (inSwap) return _transfer(sender, recipient, amount);

        uint256 amountReceived = amount;

        if (sender == _pair) {
            _balances[sender] = _balances[sender].sub(
                amount,
                "Insufficient Balance"
            );
            if (!_excludedBuyFee[recipient]) {
                amountReceived = takeBuyFee(amount);
            }
        } else if (recipient == _pair) {
            if (!_excludedSellFee[sender]) {
                uint256 rfi = _taxRFI.mul(amount).div(100000);
                uint256 _amount = amount - rfi;
                _balances[sender] = _balances[sender].sub(
                    _amount,
                    "Insufficient Balance"
                );
                amountReceived = takeSellFee(_amount);
                distributeFee();
            } else {
                _balances[sender] = _balances[sender].sub(
                    amount,
                    "Insufficient Balance"
                );
            }
        } else {
            _transfer(sender, recipient, amount);
            return true;
        }
        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function takeSellFee(uint256 amount_) private returns (uint256) {
        uint256 fee = _taxSell.mul(amount_).div(_taxDivider);
        _balances[address(this)] = _balances[address(this)].add(fee);
        return amount_.sub(fee);
    }

    function takeBuyFee(uint256 amount_) private returns (uint256) {
        uint256 fee = _taxBuy.mul(amount_).div(_taxDivider);
        _balances[address(this)] = _balances[address(this)].add(fee);
        return amount_.sub(fee);
    }

    function distributeFee() private swapping {
        uint256 swapAmount = _balances[address(this)];

        if (_balances[address(this)] > 0) {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = address(WBNB);

            uint256 currentBNBBalance = address(this).balance;
            try
                _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                    swapAmount,
                    0,
                    path,
                    address(this),
                    block.timestamp
                )
            {
                uint256 amountBNB = address(this).balance.sub(
                    currentBNBBalance
                );
                (bool sent, ) = payable(_recipientFee).call{
                    value: amountBNB,
                    gas: 30000
                }("");
                require(sent, "Transfer error.");
            } catch Error(string memory e) {
                emit DistributeFailed(e);
            }
        }
    }

    event DistributeFailed(string message);

    function _mint(address account, uint256 amount) internal virtual {
        require(
            account != address(0),
            "makdev -_-: mint to the zero address"
        );

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(
            account != address(0),
            "makdev -_-: burn from the zero address"
        );

        uint256 accountBalance = _balances[account];
        require(
            accountBalance >= amount,
            "makdev -_-: burn amount exceeds balance"
        );
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(
            owner != address(0),
            "makdev -_-: approve from the zero address"
        );
        require(
            spender != address(0),
            "makdev -_-: approve to the zero address"
        );

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}