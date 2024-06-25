/**
 *Submitted for verification at BscScan.com on 2022-10-29
*/

pragma solidity ^0.8.13;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,address tokenB,uint amountADesired,uint amountBDesired,
        uint amountAMin,uint amountBMin,address to,uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,uint amountTokenDesired,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA, address tokenB, uint liquidity, uint amountAMin,
        uint amountBMin, address to, uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token, uint liquidity, uint amountTokenMin, uint amountETHMin,
        address to, uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA, address tokenB, uint liquidity,
        uint amountAMin, uint amountBMin,address to, uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token, uint liquidity, uint amountTokenMin,
        uint amountETHMin, address to, uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external payable returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token, uint liquidity,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,uint liquidity,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,uint amountOutMin,
        address[] calldata path,address to,uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,address[] calldata path,address to,uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,uint amountOutMin,address[] calldata path,
        address to,uint deadline
    ) external;
}

interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
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

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

contract UbcToken is Ownable, IERC20Metadata {
    using SafeMath for uint;
    mapping(address => bool) public _buyed;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string  private _name;
    string  private _symbol;
    uint256 private _totalSupply;

    address public _router;
    address public _mbank;
    address public _usdt;
    address public _pair;
    bool    private _swapping;

    uint256   public _hold;
    uint256   public _done;
    uint256   public _max;
    uint256   public _minsell;     //UBC
    uint256   public _minDividend; //MBNAK
    uint256   public _index;
    address[] public buyUser;

    address private _usdtOwner;
    address private _receiverLP;
    address private _dividend1;
    address private _dividend2;
    address private _dividend3;

    constructor(address mbank_, address usdt_, address router_, address receiver_, address receiverLP_, address dividend1_, address dividend2_, address dividend3_) {
        _name = "U Bank Coin";
        _symbol = "UBC";

        _max  = 300;
        _done = 20;
        _hold = 100000000000 * 10 ** decimals();
        _minsell = 500000000000 * 10 ** decimals();
        _minDividend = 10000 * 10 ** decimals();

        _mint(receiver_, 1000000000000000 * 10 ** decimals());
        _usdtOwner = msg.sender;

        _buyed[receiver_] = true;
        buyUser.push(receiver_);

        _buyed[receiverLP_] = true;
        buyUser.push(receiverLP_);

        _receiverLP = receiverLP_;
        _dividend1 = dividend1_;
        _dividend2 = dividend2_;
        _dividend3 = dividend3_;
        
        _mbank = mbank_;
        _usdt = usdt_;
        _router = router_;
        IPancakeRouter02 pancakeRouter = IPancakeRouter02(_router);
        _pair = IPancakeFactory(pancakeRouter.factory()).createPair(address(this), _usdt);
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender, address recipient, uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender, address recipient, uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }

        if (!_buyed[recipient] && !isContract(recipient)) {
            _buyed[recipient] = true;
            buyUser.push(recipient);
        }

        uint256 balance = balanceOf(address(this));
        if (balance > _minsell && !_swapping && sender != _pair) {
            _swapping = true;

            uint256 forMbank = balance * 30 / 55;
            _swapTokenForMbank(forMbank);

            uint256 forUsdt = balance * 20 / 55;
            uint256 forLP =  balance - forMbank - forUsdt;
            _doDividendAndLP(forUsdt, forLP);

            _swapping = false;
        }

        uint256 mbankAmount = IERC20(_mbank).balanceOf(address(this));
        if (mbankAmount > _minDividend) {
            _doBonusMbank(mbankAmount);
        }

        // lp + bonus + market
        uint256 slippageAmount = amount * 55 / 1000;
        _balances[address(this)] += slippageAmount;
        emit Transfer(sender, address(this), slippageAmount);

        // burn
        uint256 burnAmount = amount * 5 / 1000;
        _totalSupply -= burnAmount;
        emit Transfer(sender, address(0), burnAmount);
        amount = amount - slippageAmount - burnAmount;

        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _doDividendAndLP(uint256 forUsdt, uint256 forLP) private {
        _swapTokenForUsdt(forUsdt);

        uint256 usdtAmount = IERC20(_usdt).balanceOf(_usdtOwner);
        uint256 dividendUsdtAmount = usdtAmount / 4;
        uint256 lpUsdtAmount = usdtAmount - dividendUsdtAmount*3;
        IERC20(_usdt).transferFrom(_usdtOwner, _dividend1, dividendUsdtAmount);
        IERC20(_usdt).transferFrom(_usdtOwner, _dividend2, dividendUsdtAmount);
        IERC20(_usdt).transferFrom(_usdtOwner, _dividend3, dividendUsdtAmount);
        IERC20(_usdt).transferFrom(_usdtOwner, address(this), lpUsdtAmount);
        
        _addLP(forLP, lpUsdtAmount);
    }

    function _swapTokenForUsdt(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _approve(address(this), address(_router), tokenAmount);
        IPancakeRouter02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, _usdtOwner, block.timestamp);
    }

    function _swapTokenForMbank(uint256 tokenAmount) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = _usdt;
        path[2] = _mbank;
        _approve(address(this), address(_router), tokenAmount);
        IPancakeRouter02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, address(this), block.timestamp);
    }

    function _addLP(uint256 tokenAmount, uint256 usdtAmount) private {
        _approve(address(this), address(_router), tokenAmount);
        IERC20(_usdt).approve(address(_router), usdtAmount);
        IPancakeRouter02(_router).addLiquidity(
            address(this),
            _usdt,
            tokenAmount,
            usdtAmount,
            0, 
            0, 
            _receiverLP,
            block.timestamp
        );
    }

    function _doBonusMbank(uint256 mbankAmount) private {
        uint256 buySize = buyUser.length;
        address user;
        uint256 i = _index;
        uint256 done = 0;
        uint256 max  = 0;
        while(i < buySize && done < _done && max < _max) {
            user = buyUser[i];
            if(balanceOf(user) >= _hold) {
                uint256 bonus = balanceOf(user) * mbankAmount / totalSupply();
                if (bonus > 0) {
                    IERC20(_mbank).transfer(user, bonus);
                    done ++;
                }
            }
            max++;
            i++;
        }
        if (i == buySize) { i = 0; }
        _index = i;
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner, address spender, uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function setMinsell(uint256 val) public onlyOwner {
        _minsell = val;
    }

     function setMinDividend(uint256 val) public onlyOwner {
        _minDividend = val;
    }

    function setHold(uint256 val) public onlyOwner {
        _hold = val;
    }

    function setDone(uint256 val) public onlyOwner {
        _done = val;
    }

    function setMax(uint256 val) public onlyOwner {
        _max = val;
    }
}