/**
 *Submitted for verification at BscScan.com on 2023-02-26
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
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
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
   
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

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
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

interface IPinkAntiBot {
  function setTokenOwner(address owner) external;

  function onPreTransferCheck(
    address from,
    address to,
    uint256 amount
  ) external;
}

contract TateCoin is ERC20, Ownable {
    using Address for address payable;

    IPinkAntiBot public pinkAntiBot;
    bool public antiBotEnabled;

    IUniswapV2Router02 public uniswapV2Router;
    address public  uniswapV2Pair;

    mapping (address => bool) private _isExcludedFromFees;

    uint256 public  buybackFeeOnBuy;
    uint256 public  buybackFeeOnSell;

    uint256 public  treasuryFeeOnBuy;
    uint256 public  treasuryFeeOnSell;

    uint256 private _swapFeesOnBuy;
    uint256 private _swapFeesOnSell;

    uint256 public  walletToWalletTransferFee;

    address public  treasuryWallet;

    uint256 public  swapTokensAtAmount;
    bool    private swapping;

    uint256 public buybackTokens;
    uint256 public bnbValueForBuyBurn;
    uint256 public accumulatedBuybackBNB;

    bool    public sellLimitEnabled;
    uint256 public sellLimitPercent;
    /// @notice Address to epoch to amount sold mapping
    /// @dev Epoch will be updated every 4 hours for gas efficiency
    mapping (address => mapping(uint256 => uint256)) public sells;
    mapping (address => bool) private _isExcludedFromSellLimit;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event TreasuryWalletChanged(address treasuryWallet);
    event UpdateBuyFees(uint256 developmentFeeOnBuy, uint256 treasuryFeeOnBuy);
    event UpdateSellFees(uint256 developmentFeeOnSell, uint256 treasuryFeeOnSell);
    event UpdateWalletToWalletTransferFee(uint256 walletToWalletTransferFee);
    event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
    event BuyBackAndBurn(uint256 value, uint256 tokensBurned);

    constructor () ERC20("Tate Coin", "$ T8") 
    {   
        transferOwnership(0x0D41e0ee70Ba15F4B1131CBf25A0d8e355289fD1);

        address router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC PancakeSwap Router
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair   = _uniswapV2Pair;

        _approve(address(this), address(uniswapV2Router), type(uint256).max);

        pinkAntiBot = IPinkAntiBot(0x8EFDb3b642eb2a20607ffe0A56CFefF6a95Df002);
        pinkAntiBot.setTokenOwner(owner());
        antiBotEnabled = true;

        buybackFeeOnBuy  = 1;
        buybackFeeOnSell = 1;

        treasuryFeeOnBuy  = 1;
        treasuryFeeOnSell = 1;
        
        _swapFeesOnBuy    = buybackFeeOnBuy  + treasuryFeeOnBuy;
        _swapFeesOnSell   = treasuryFeeOnBuy + treasuryFeeOnSell;

        walletToWalletTransferFee = 10;

        treasuryWallet = 0x3e49532a5b0e90f72CDaE07D30e7E0862B42854e; 

        bnbValueForBuyBurn = 3e17; // 0.3 BNB

        sellLimitEnabled = true;
        sellLimitPercent = 10;

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(0xdead)] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[treasuryWallet] = true;

        _isExcludedFromSellLimit[owner()] = true;
        _isExcludedFromSellLimit[address(this)] = true;
        _isExcludedFromSellLimit[treasuryWallet] = true;

        _mint(owner(), 5e5 * (10 ** decimals()));
        swapTokensAtAmount = totalSupply() / 5000;
    }

    receive() external payable {

  	}

    function claimStuckTokens(address token) external onlyOwner {
        require(token != address(this), "Owner cannot claim native tokens");
        if ( token == address(0x0) ) {
            uint256 bnbBalance = address(this).balance - accumulatedBuybackBNB;
            payable(msg.sender).transfer(bnbBalance);
            return;
        }
        IERC20 ERC20token = IERC20(token);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.transfer(msg.sender, balance);
    }

    function excludeFromFees(address account, bool excluded) external onlyOwner{
        require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function excludeFromSellLimit(address account, bool excluded) external onlyOwner{
        require(_isExcludedFromSellLimit[account] != excluded,"Account is already the value of 'excluded'");
        _isExcludedFromSellLimit[account] = excluded;
    }

    function isExcludedFromSellLimit(address account) public view returns(bool) {
        return _isExcludedFromSellLimit[account];
    }

    function updateBuyFees(uint256 _buybackFeeOnBuy, uint256 _treasuryFeeOnBuy) external onlyOwner {
        require(_buybackFeeOnBuy + _treasuryFeeOnBuy <= 10, "Buy Fees cannot be more than 10%");
        buybackFeeOnBuy  = _buybackFeeOnBuy;
        treasuryFeeOnBuy = _treasuryFeeOnBuy;
        _swapFeesOnBuy   = buybackFeeOnBuy + treasuryFeeOnBuy;
        emit UpdateBuyFees(buybackFeeOnBuy, treasuryFeeOnBuy);
    }

    function updateSellFees(uint256 _buybackFeeOnSell, uint256 _treasuryFeeOnSell) external onlyOwner {
        require(_buybackFeeOnSell + _treasuryFeeOnSell <= 10, "Sell Fees cannot be more than 10%");
        buybackFeeOnSell  = _buybackFeeOnSell;
        treasuryFeeOnSell = _treasuryFeeOnSell;
        _swapFeesOnSell   = buybackFeeOnSell + treasuryFeeOnSell;
        emit UpdateSellFees(buybackFeeOnSell, treasuryFeeOnSell);
    }

    function updateWalletToWalletTransferFee(uint256 _walletToWalletTransferFee) external onlyOwner {
        require(_walletToWalletTransferFee <= 10, "Wallet to Wallet Transfer Fee cannot be more than 10%");
        walletToWalletTransferFee = _walletToWalletTransferFee;
        emit UpdateWalletToWalletTransferFee(walletToWalletTransferFee);
    }

    function changeTreasuryWallet(address _treasuryWallet) external onlyOwner{
        require(_treasuryWallet != treasuryWallet,"Treasury wallet is already that address");
        require(_treasuryWallet != address(0),"Treasury wallet cannot be the zero address");
        treasuryWallet = _treasuryWallet;
        emit TreasuryWalletChanged(treasuryWallet);
    }

    function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
        require(newAmount > totalSupply() / 1000000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
        swapTokensAtAmount = newAmount;
        emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
    }

    function setSellLimitEnabled(bool _enabled) external onlyOwner {
        require(sellLimitEnabled != _enabled, "Sell Limit Enabled is already that value");
        sellLimitEnabled = _enabled;
    }

    function setSellLimitPercent(uint8 _percent) external onlyOwner {
        require(_percent <= 100, "Sell Limit Percent cannot be more than 100%");
        sellLimitPercent = _percent;
    }

    function setBNBValueForBuyBurn(uint value) public onlyOwner {
        require(value >= 1 * (10**17), "'BNBValueForBuyBurn' must be greater than 0.1");
        bnbValueForBuyBurn = value;
    }

    function setEnableAntiBot(bool _enable) external onlyOwner {
        antiBotEnabled = _enable;
    }

    function _transfer(address from, address to, uint256 amount) internal  override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (antiBotEnabled) { pinkAntiBot.onPreTransferCheck(from, to, amount); }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (sellLimitEnabled && to == uniswapV2Pair && !_isExcludedFromSellLimit[from]) {
            _checkSellLimit(from, amount);
        }

		uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (canSwap &&
            !swapping &&
            to == uniswapV2Pair &&
            _swapFeesOnBuy + _swapFeesOnSell > 0
        ) {
            swapping = true;

            uint256 initialBalance = address(this).balance;

            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = uniswapV2Router.WETH();

            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                contractTokenBalance,
                0,
                path,
                address(this),
                block.timestamp);

            uint256 newBalance = address(this).balance - initialBalance;

            uint256 buybackBNB = (newBalance * buybackTokens) / contractTokenBalance;
            uint256 treasuryBNB = newBalance - buybackBNB;

            if (treasuryBNB > 0) {
                payable(treasuryWallet).sendValue(treasuryBNB);
            }

            if (buybackBNB > 0) {
                accumulatedBuybackBNB += buybackBNB;
                if (accumulatedBuybackBNB > bnbValueForBuyBurn) {
                    if (address(this).balance >= accumulatedBuybackBNB) {
                        buyback(accumulatedBuybackBNB);
                    } else {
                        buyback(address(this).balance);
                    }
                    accumulatedBuybackBNB = 0;
                }
            }   
            buybackTokens = 0;
            swapping = false;
        }

        uint256 _swapFees;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
            _swapFees = 0;
        } else if (from == uniswapV2Pair) {
            _swapFees = _swapFeesOnBuy;
            buybackTokens += amount * buybackFeeOnBuy / 100;
        } else if (to == uniswapV2Pair) {
            _swapFees = _swapFeesOnSell;
            buybackTokens += amount * buybackFeeOnSell / 100;
        } else {
            _swapFees = walletToWalletTransferFee;
        }

        if (_swapFees > 0) {
            uint256 fees = (amount * _swapFees) / 100;
            amount = amount - fees;
            super._transfer(from, address(this), fees);
        }

        super._transfer(from, to, amount);
    }

    function _checkSellLimit(address from, uint256 amount) internal {
        uint256 _sells;
        uint256 currentEpoch = block.timestamp / 4 hours;
        for (uint256 i = currentEpoch - 5; i <= currentEpoch; i++) {
            _sells += sells[from][i];
        }
        uint256 sellLimit = (balanceOf(from) + _sells) * sellLimitPercent / 100;
        require(_sells + amount <= sellLimit, "Sell limit exceeded");
        sells[from][currentEpoch] += amount;
    }

    function sellsInLast24Hours(address from) external view returns (uint256) {
        uint256 _sells;
        uint256 currentEpoch = block.timestamp / 4 hours;
        for (uint256 i = currentEpoch - 5; i <= currentEpoch; i++) {
            _sells += sells[from][i];
        }
        return _sells;
    }

    function buyback(uint256 amount) internal {
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(this);

        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: amount
        }(0, path, address(0xdead), block.timestamp);    
    }
}