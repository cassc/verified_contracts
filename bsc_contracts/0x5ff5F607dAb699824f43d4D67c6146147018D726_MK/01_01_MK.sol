pragma solidity ^0.8.6;

// SPDX-License-Identifier: Unlicensed
interface IERC20 {
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Ownable {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface IUniswapV2Factory {
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

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

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

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

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
}

contract MK is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping (address => bool) isDividendExempt;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _updated;

    // mapping(address => bool) private _isBlacklist;
    mapping(address => bool) private _isSenderBlacklist;
    mapping(address => bool) private _isRecipientBlacklist;
    mapping(address => bool) private _isSupermanlist;
   

    uint256 private _tFeeTotal;

    uint256 private _tLPFeeTotal;

    uint256 private _tFounderFeeTotal;

    string private _name = "MK";
    string private _symbol = "MK";
    uint8 private _decimals = 18;

    uint256 public _burnFee = 0;
    uint256 private _previousburnFee;

    uint256 public _LPFee = 0;
    uint256 private _previousLPFee;

    uint256 public _marketFee = 500;
    uint256 private _previousMarketFee;

    uint256 public _founderFee = 0;
    uint256 private _previousFounderFee;

    uint256 currentIndex;  
    uint256 private _tTotal = 210000 * 10**18;
    uint256 distributorGas = 500000;
    // uint256 public minPeriod = 20 minutes;
    // uint256 public LPFeefenhong;
    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address private fromAddress;
    address public marketAddress;
    address public founderAddress;
    address public lpAddress;
    address public usdtAddress;
    address private toAddress;
    uint256 private constant MAX = ~uint256(0);
    address _baseToken = address(0x55d398326f99059fF775485246999027B3197955); //bsc
    // address _baseToken = address(0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684); //bsctest

    address public pinkSaleAddr =
        address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE);

    address public pinkSaleChangeAddr =
        address(0xFeF021CC92943b15fef091d2444a87e02733e56c);

    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;

    address[] public partners;

    bool public amountLimit = false;
    

    constructor() {
        _tOwned[msg.sender] = _tTotal;
       
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );

        // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
        //     0xD99D1c33F9fC3444f8101754aBC46c52416550D1
        // );

        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), address(_baseToken));
        // uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        //     .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        marketAddress = address(0x4987A882C81F31A44AE0b71EEC8bA87e7aa49664);
        founderAddress = address(0x6ACaBa5e83E1a4495624A012901033049B4D4118);
        lpAddress = address(0x434EC49ac5086D4e4dF664d343eDF5788c3094cd);
        usdtAddress = address(0x55d398326f99059fF775485246999027B3197955); //bsc
        // usdtAddress = address(0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684); //bsctest

        // _approve(address(this), address(uniswapV2Router), MAX);
        _allowances[address(this)][address(_uniswapV2Router)] = MAX;
        IERC20(usdtAddress).approve(address(_uniswapV2Router), MAX);
        IERC20(_uniswapV2Router.WETH()).approve(address(_uniswapV2Router), MAX);

        //exclude owner and this contract from fee
        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[address(0)] = true;
        
        emit Transfer(address(0), msg.sender, _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

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
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

   function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    //supermanList
    function isSupermanlist(address account) public view returns (bool) {
        return _isSupermanlist[account];
    }
    function includeInSupermanlist(address account) public onlyOwner {
        _isSupermanlist[account] = true;
    }

    function excludeFromSupermanlist(address account) public onlyOwner {
        _isSupermanlist[account] = false;
    }
    
    //senderBlacklist
    function isSenderBlacklist(address account) public view returns (bool) {
        return _isSenderBlacklist[account];
    }
    function includeInSenderBlacklist(address account) public onlyOwner {
        _isSenderBlacklist[account] = true;
    }

    function excludeFromSenderBlacklist(address account) public onlyOwner {
        _isSenderBlacklist[account] = false;
    }
    //recipientBlacklist
    function isRecipientBlacklist(address account) public view returns (bool) {
        return _isRecipientBlacklist[account];
    }
    function includeInRecipientBlacklist(address account) public onlyOwner {
        _isRecipientBlacklist[account] = true;
    }

    function excludeFromRecipientBlacklist(address account) public onlyOwner {
        _isRecipientBlacklist[account] = false;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function removeAllFee() private {
        _previousburnFee = _burnFee;
        _previousLPFee = _LPFee;
        _previousMarketFee = _marketFee;
        _previousFounderFee = _founderFee;

        _burnFee = 0;
        _LPFee = 0;
        _marketFee = 0;
        _founderFee = 0;

    }

    function restoreAllFee() private {
        _burnFee = _previousburnFee;
        _LPFee = _previousLPFee;
        _marketFee = _previousMarketFee;
        _founderFee = _previousFounderFee;
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

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (_isSupermanlist[from] ||  _isSupermanlist[to]) {
            require(_isSupermanlist[from] || _isSupermanlist[to], "you are not the superman");
        } else {
            //senderBlacklist
            if (_isSenderBlacklist[from]) {
                require(!_isSenderBlacklist[from], "the sender address is blacklist");
            }
            //toBlacklist
            if (_isRecipientBlacklist[to]) {
                require(!_isRecipientBlacklist[to], "the recipient address is blacklist");
            }
        }

        // if (from == uniswapV2Pair) {
        //     require(amount <= 50 * 10**18 || amountLimit, "buy must less than 50!");
        // }

        //indicates if fee should be deducted from transfer
        bool takeFee = false;

        if (from == uniswapV2Pair || to == uniswapV2Pair) {
            takeFee = true;
        }
        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);

        
        if(fromAddress == address(0) )fromAddress = from;
        if(toAddress == address(0) )toAddress = to;  
        if(!isDividendExempt[fromAddress] && fromAddress != uniswapV2Pair ) setShare(fromAddress);
        if(!isDividendExempt[toAddress] && toAddress != uniswapV2Pair ) setShare(toAddress);
        
        fromAddress = from;
        toAddress = to;  
        // if(balanceOf(address(this)) > 0 && from !=address(this) && LPFeefenhong.add(minPeriod) <= block.timestamp) {
        //      process(distributorGas) ;
        //      LPFeefenhong = block.timestamp;
        // }
    }
    
    function process(uint256 gas) private {
        uint256 shareholderCount = shareholders.length;

        if (shareholderCount == 0) return;
        uint256 nowbanance = _tLPFeeTotal;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }

            uint256 amount = nowbanance
                .mul(
                    IERC20(uniswapV2Pair).balanceOf(shareholders[currentIndex])
                )
                .div(
                    IERC20(uniswapV2Pair).totalSupply()
                );
            if (amount < 1 * 10**8) {
                currentIndex++;
                iterations++;
                return;
            }
            if (balanceOf(address(this)) < amount) return;

            distributeDividend(shareholders[currentIndex], amount);

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }

   

    function distributeDividend(address shareholder, uint256 amount) internal {
        _tOwned[address(this)] = _tOwned[address(this)].sub(amount);

        if (shareholder == pinkSaleAddr) {
            shareholder = pinkSaleChangeAddr;
        }
        _tOwned[shareholder] = _tOwned[shareholder].add(amount);

         if (_tLPFeeTotal > amount) {
            _tLPFeeTotal = _tLPFeeTotal.sub(amount);
         } else {
            _tLPFeeTotal = 0;
         }
        
        emit Transfer(address(this), shareholder, amount);
    }

    function setShare(address shareholder) private {
        if(_updated[shareholder] ){      
            if(IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) quitShare(shareholder);              
            return;  
        }
        if(IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) return;  
        addShareholder(shareholder);
        _updated[shareholder] = true;
        
    }

    function addShare(address shareholder) public onlyOwner {
        if(_updated[shareholder] ){      
            if(IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) quitShare(shareholder);              
            return;  
        }
        if(IERC20(uniswapV2Pair).balanceOf(shareholder) == 0) return;  
        addShareholder(shareholder);
        _updated[shareholder] = true;
        
    }
    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }
    function quitShare(address shareholder) private {
           removeShareholder(shareholder);   
           _updated[shareholder] = false; 
      }
    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) removeAllFee();

        _transferStandard(sender, recipient, amount);

        if (!takeFee) restoreAllFee();
    }

    function _takeburnFee(
        address sender,
        uint256 tAmount
    ) private {
        if (_burnFee == 0) return;
        _tOwned[address(0)] = _tOwned[address(0)].add(tAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
        emit Transfer(sender, address(0), tAmount);
    }

    function _takeLPFee(address sender,uint256 tAmount) private {
        if (_LPFee == 0 ) return;
        _tOwned[lpAddress] = _tOwned[lpAddress].add(tAmount);
        _tLPFeeTotal = _tLPFeeTotal.add(tAmount);
        // emit Transfer(sender, address(this), tAmount);
    }

    function _takeMarketFee(address sender,uint256 tAmount) private {
        if (_marketFee ==0) return;
        _tOwned[marketAddress] = _tOwned[marketAddress].add(tAmount);
        emit Transfer(sender, marketAddress, tAmount);
    }

    function _takeFounderFee(address sender,uint256 tAmount) private {
        if (_founderFee ==0) return;
        _tOwned[founderAddress] = _tOwned[founderAddress].add(tAmount);
        // emit Transfer(sender, address(this), tAmount);
    }


    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
       
        _takeburnFee(sender, tAmount.div(10000).mul(_burnFee));      
    
        _takeMarketFee(sender, tAmount.div(10000).mul(_marketFee));
        
        _takeFounderFee(sender, tAmount.div(10000).mul(_founderFee));

        _takeLPFee(sender, tAmount.div(10000).mul(_LPFee));

       
        uint256 recipientRate = 10000 -
            _burnFee -
            _LPFee -
            _marketFee -
            _founderFee;
        _tOwned[recipient] = _tOwned[recipient].add(
            tAmount.div(10000).mul(recipientRate)
        );
        emit Transfer(sender, recipient, tAmount.div(10000).mul(recipientRate));
    }  

    function setAmountLimit(bool boolAmountLimit) public onlyOwner {
        amountLimit = boolAmountLimit;
    }

    function setMarket(address account) public onlyOwner {
        marketAddress = account;
    }

    function setFounder(address account) public onlyOwner {
        founderAddress = account;
    }

    function setLP(address account) public onlyOwner {
        lpAddress = account;
    }

    function setPartners(address[] memory newPartners) public onlyOwner {
        partners = newPartners;
    }

    function pushPartners(address newPartner) public onlyOwner {
        partners.push(newPartner);
    }

    function popPartners() public onlyOwner {
        partners.pop();
    }

    function getPartners() public view returns (address[] memory) {
        return partners;
    }

    // function setPinkSaleAddr(address newpinkSaleAddr) public onlyOwner {
    //     pinkSaleAddr = newpinkSaleAddr;
    // }

    // function setPinkSaleChangeAddr(address newpinkSaleChangeAddr) public onlyOwner {
    //     pinkSaleChangeAddr = newpinkSaleChangeAddr;
    // }

    function modifyBurnFee(uint256 fee) public onlyOwner {
        _burnFee = fee;
    }

    function modifyLPFee(uint256 fee) public onlyOwner {
        _LPFee = fee;
    }

    function modifyMarketFee(uint256 fee) public onlyOwner {
        _marketFee = fee;
    }

    function modifyFounderFee(uint256 fee) public onlyOwner {
        _founderFee = fee;
    }

    function rescueToken(
        address token,
        address recipient,
        uint256 amount
    ) public onlyOwner {
        IERC20(token).transfer(recipient, amount);
    }
}