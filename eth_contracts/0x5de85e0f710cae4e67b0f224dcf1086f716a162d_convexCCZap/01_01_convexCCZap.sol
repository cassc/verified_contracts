// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IExchangeMultiple {
    function exchange_multiple(
        address[9] memory _route,
        uint256[3][4] memory _swap_params,
        uint256 _amount,
        uint256 _expected,
        address[4] memory _pools
    ) external returns (uint256);
}

interface IUniswapV2Pair {
    function coins(uint position) external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getTotalAmounts() external view returns (uint256 reserve0, uint256 reserve1);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);
    function burn(address to) external returns (uint amount0, uint amount1);
    function add_liquidity(uint256[2] memory _amounts,uint256 _min_mint_amount) external returns(uint256);
    function remove_liquidity_one_coin(uint256,int128,uint256) external returns(uint256);
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
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
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Collection of functions related to the address type
 */
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
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    
    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IUniswapV2Router01 {
    function WETH() external pure returns (address);
}

interface IYeller {
    function deposit(uint256 _pid, uint256 _amount, address _depositor) external; 
    function withdraw(uint256 _pid, uint256 _amount) external;
    function getUserAmount(uint256 _pid, address _user) external returns (uint256);
}

interface IWETH is IERC20 {
    function withdraw(uint256 wad) external;
    function deposit() external payable;
}

interface IVault is IERC20 {
    function deposit(uint256 amount) external;
    function withdraw(uint256 shares) external;
    function want() external pure returns (address);
}

contract convexCCZap is Ownable {
    using SafeERC20 for IERC20;
    using SafeERC20 for IVault;

    IYeller yeller;
    IUniswapV2Router01 public immutable router;
    address public immutable WETH;
    address public immutable ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public immutable LP = 0x4eBdF703948ddCEA3B11f675B4D1Fba9d2414A14;
    uint256 public constant minimumAmount = 1000;

    constructor(address _router, address _WETH, address _yeller) {
        router = IUniswapV2Router01(_router);
        WETH = _WETH;
        yeller = IYeller(_yeller);
    }

    receive() external payable {
        assert(msg.sender == WETH);
    }

    function comeInWeth (address _vault, uint256 tokenAmountOutMin) external payable {
        require(msg.value >= minimumAmount, 'Zap: Insignificant input amount');
        IWETH(WETH).deposit{value: msg.value}();

        _swapAndStake(_vault, tokenAmountOutMin, WETH);
    }

    function comeIn (address _vault, uint256 tokenAmountOutMin, address tokenIn, uint256 tokenInAmount) external {
        require(tokenInAmount >= minimumAmount, 'Zap: Insignificant input amount');
        require(IERC20(tokenIn).allowance(msg.sender, address(this)) >= tokenInAmount, 'Zap: Input token is not approved');

        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), tokenInAmount);

        _swapAndStake(_vault, tokenAmountOutMin, tokenIn);
    }
    
    function _swapAndStake(address _vault, uint256 tokenAmountOutMin, address tokenIn) private {
        (IVault vault, IUniswapV2Pair pair) = _getVaultPair(_vault);
        require(tokenIn == pair.coins(0) || tokenIn == WETH, 'Zap: Input token != CRV || WETH');

        uint amountForAddLiq;

        if(tokenIn == WETH) {
            uint swapAmount = IERC20(WETH).balanceOf(address(this));
            amountForAddLiq = swapToken(swapAmount, tokenAmountOutMin, pair.coins(0));
        } else if (tokenIn == pair.coins(0)) {
            amountForAddLiq = IERC20(pair.coins(0)).balanceOf(address(this));
        }

        uint256[2] memory amounts;
        amounts[0] = amountForAddLiq;
        amounts[1] = 0;

        _approveTokenIfNeeded(pair.coins(0), address(pair));
        uint amountLiquidity = pair.add_liquidity(amounts, tokenAmountOutMin);

        depositToVault(pair, vault, amountLiquidity);
        depositToYeller(vault);
    }

    function _getVaultPair (address _vault) private pure returns (IVault vault, IUniswapV2Pair pair) {
        vault = IVault(_vault);
        pair = IUniswapV2Pair(vault.want());
    }

    function swapToken(uint256 _swapAmountIn, uint256 _tokenAmountOutMin, address _swapTo) private returns(uint256 swapedAmounts){
        _approveTokenIfNeeded(WETH, address(router));
        address[9] memory _route;
        _route[0] = WETH;
        _route[1] = WETH;
        _route[2] = ETH;
        _route[3] = LP;
        _route[4] = _swapTo;
        uint256[3][4] memory _swap_params;
        _swap_params[0] = [uint256(0), uint256(0), uint256(15)];
        _swap_params[1] = [uint256(1), uint256(2), uint256(3)];
        address[4] memory _pools;
        swapedAmounts = IExchangeMultiple(address(router)).exchange_multiple(_route, _swap_params, _swapAmountIn, _tokenAmountOutMin, _pools);
    }

    function depositToVault(IUniswapV2Pair _pair, IVault _vault, uint256 _amountLiquidity) private {
        _approveTokenIfNeeded(address(_pair), address(_vault));
        _vault.deposit(_amountLiquidity);
        _vault.safeTransfer(address(this), _vault.balanceOf(address(this)));
    }

    function depositToYeller(IVault _vault) private {
        uint sharesBal = _vault.balanceOf(address(this));
        _vault.approve(address(yeller), sharesBal);
        yeller.deposit(0, sharesBal, msg.sender);  
    }

    function goOut (address _vault, uint256 _withdrawAmount, address _tokenOut, uint256 tokenAmountOutMin) external {
        (IVault vault, IUniswapV2Pair pair) = _getVaultPair(_vault);
        require(yeller.getUserAmount(0, msg.sender) >= _withdrawAmount, "Zap: not enough balance from yeller");

        address token;

        yeller.withdraw(0, _withdrawAmount);
        vault.withdraw(_withdrawAmount);
        if(_tokenOut == pair.coins(0)) {
            pair.remove_liquidity_one_coin(_withdrawAmount, 0, tokenAmountOutMin);
            token = pair.coins(0);
        } else if(_tokenOut == pair.coins(1)) {
            pair.remove_liquidity_one_coin(_withdrawAmount, 1, tokenAmountOutMin);
            token = pair.coins(1);
        }

        _returnAssets(token);
    }

    function claimRewards() external {
        yeller.withdraw(0, 0);
    }

    function _returnAssets(address token) private {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransfer(msg.sender, balance);
    }

    function _approveTokenIfNeeded(address token, address spender) private {
        if (IERC20(token).allowance(address(this), spender) == 0) {
            IERC20(token).safeApprove(spender, type(uint).max);
        }
    }

    function newYeller(address _yeller) external onlyOwner {
        yeller = IYeller(_yeller);
    }

    function yellerAddr() external view returns(address){
        return address(yeller);
    }
}