/**
 *Submitted for verification at BscScan.com on 2022-12-30
*/

pragma solidity ^0.8.0;




/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}



/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
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
// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {

   

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }


}



interface DAOPoolDividend {
    function countDaoUsdtIn(uint256 usdtValue_) external ;
}

interface LpPoolDividend{
    function countLpUsdtIn(uint256 usdtValue_) external ;

}




contract Ownable is Context {
    address internal _owner;
 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    function owner() public view returns (address) {
        return _owner;
    }
 
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
 
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */

library SafeMath {
 
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
 
        return c;
    }
 
 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
 
 
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
 
 
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
 
 
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
 
 
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
 

contract ETCToken is Context, IERC20, IERC20Metadata ,  Ownable{
    mapping(address => uint256) private _balances;
    using SafeMath for uint256;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    IERC20 public usdtAddress =  IERC20(0x311bb5a90eA517529F6CE7e2aE19E9390ce35a0C);
    address public usdtDaoManager;
    address public usdtLpPoolManager;
    // address public fom3dAddress;
    address public marketAddress;

    bool inSwapAndLiquify;

    uint256 public totalUsdt;

    address public daoContractAddress;
    address public lpPoolContractAddress;

    string private _name;
    string private _symbol;

    uint256 public etcPrice = 300e18; // price decimal 1e18

    bool public initialPrice = false;


    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        address etp
        ) {
        _name = "ETC";
        _symbol = "ETC";
        _owner = msg.sender;

        
        usdtAddress =  IERC20(0x55d398326f99059fF775485246999027B3197955);

        
        //================= update ================
        marketAddress = 0x749F555Df4aDc2483EaC8b20A92B3b23d3A64e1D;

        usdtDaoManager = 0x749F555Df4aDc2483EaC8b20A92B3b23d3A64e1D; // doo pool usdt manager in
        
        usdtLpPoolManager = 0x749F555Df4aDc2483EaC8b20A92B3b23d3A64e1D;// lp pool usdt manager in
        

        // daoContractAddress = 0x49FA974C2767DdD3b00465401d01e02C652c532B;  //dao pool contract
        // lpPoolContractAddress = 0xb6E44c0aA36b4825fEfaA571C75D9322dbAE5A48; //lp pool contract
       
        
        //================= update ================

        
       ETPauthorize[etp] = true;
    }


    modifier lockTheSwap {
        require(!inSwapAndLiquify,"sell is locked");
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    //==============update first===========
    //1:dao dividend contract
    function setdaoContractAddress(address daoPoolContractAddress_) public onlyOwner{
        daoContractAddress = daoPoolContractAddress_;
    }
    //2：lp pool dividend contract
    function setlpPoolContractAddress(address lpPoolContractAddress_)public onlyOwner{
        lpPoolContractAddress = lpPoolContractAddress_;
    }
    //==============update===========

    function setusdtDaoManagerAddress(address usdtDaoManager_) public onlyOwner{
        usdtDaoManager = usdtDaoManager_;
    }

    function setmarketAddress(address marketAddress_) public onlyOwner{
        marketAddress = marketAddress_;
    }

    function setusdtLpPoolManager(address usdtLpPoolManager_)public onlyOwner{
        usdtLpPoolManager = usdtLpPoolManager_;

    }

    //============update========

    function setusdtAddress(address usdtAddress_) public onlyOwner{
        usdtAddress = IERC20(usdtAddress_);
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }


    function setEtcPrice(uint256 _price) public onlyOwner{

        etcPrice = _price;
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
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);

        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
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
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    mapping(address => bool) public ETPauthorize;


    function setETP(address _ETP) public onlyOwner{
        ETPauthorize[_ETP] = true;
    }

    event updateEtcPriceLog(address indexed addr,uint256 beforeEtcPrice,uint256 etcPrice);
    //更新价格
    function updateEtcPrice(address caller_) lockTheSwap private {
        uint256 beforeEtcPrice = etcPrice;
        uint256 usdtBalance =  usdtAddress.balanceOf(address(this));
        etcPrice =  usdtBalance.mul(1e18).div(_totalSupply);
        emit updateEtcPriceLog(caller_,beforeEtcPrice,etcPrice);

    }

    event casting_(uint256 taxes,address indexed _caller);
    //ETC铸币
    function casting(uint256 taxes,address _caller)  external returns(bool) {
        require(ETPauthorize[msg.sender], "unauthorized");
        if(etcPrice > 0){
            _mint(_caller,taxes.mul(1e18).div(etcPrice));
            updateEtcPrice(_caller);
            emit casting_(taxes,_caller);
        }
        totalUsdt += taxes;
        return true;
    }

    event sellEtc_(uint256 amount,address indexed user);
    //卖ETC
    function sellEtc(uint256 amount) external  returns(bool){
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        
        require( usdtAddress.balanceOf(address(this))> 0 ,"usdt isn't enough");
        if(etcPrice > 0){
            uint256 fromBalance = _balances[msg.sender];
            unchecked {
                _balances[msg.sender] = fromBalance - amount.mul(6).div(100);
            }
            _balances[marketAddress] += amount.mul(6).div(100);
            emit Transfer(msg.sender,marketAddress,amount.mul(6).div(100));
            _burn(msg.sender,amount.mul(94).div(100));
      
            uint256 usdtIncome = amount.mul(etcPrice).mul(80).div(100).div(1e18);
            uint256 daoUsdtIn =  amount.mul(etcPrice).mul(2).div(100).div(1e18);
            uint256 lpUsdtIn =  amount.mul(etcPrice).mul(2).div(100).div(1e18);

            uint256 marketUsdtIn = amount.mul(etcPrice).mul(6).div(100).div(1e18);
            uint256 totalUsdtOut = usdtIncome.add(daoUsdtIn).add(lpUsdtIn).add(marketUsdtIn);

            if( usdtAddress.balanceOf(address(this)) < totalUsdtOut){

                 usdtAddress.transfer(msg.sender, usdtAddress.balanceOf(address(this)));
                 if(totalUsdt>= usdtAddress.balanceOf(address(this))){
                     totalUsdt -= usdtAddress.balanceOf(address(this));
                 }
                 etcPrice = 0;
            }else{
                usdtAddress.transfer(msg.sender,usdtIncome);
                usdtAddress.transfer(usdtDaoManager,daoUsdtIn);
                usdtAddress.transfer(usdtLpPoolManager,lpUsdtIn);

                usdtAddress.transfer(marketAddress,marketUsdtIn);

//                LpPoolDividend(lpPoolContractAddress).countLpUsdtIn(lpUsdtIn);
//                DAOPoolDividend(daoContractAddress).countDaoUsdtIn(daoUsdtIn);

                if(totalUsdt >= totalUsdtOut ){
                    totalUsdt -= totalUsdtOut;
                }
  
                updateEtcPrice(msg.sender);
                emit sellEtc_(amount,msg.sender);

            }
       }
        return true;

    }




    


    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */


    mapping(address => bool) public whitelist;


    // function setwhitelist(address user_) public onlyOwner{
    //     whitelist[user_] = true;
    // }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
            uint256 fromBalance = _balances[from];
            require( fromBalance >= amount, "ERC20: transfer amount exceeds balance");
            //20%滑点
           if(!_isContract(from)){
                _burn(from,amount.mul(20).div(100));
           }
            unchecked {
                _balances[from] = fromBalance - amount.mul(80).div(100);
            }
            _balances[to] += amount.mul(80).div(100);
            updateEtcPrice(from);
            _afterTokenTransfer(from, to, amount);
            emit Transfer(from, to, amount);

           
  
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
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }


    function _isContract(address a) internal view returns(bool){
        uint256 size;
        assembly {size := extcodesize(a)}
        return size > 0;
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
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
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

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}


    //read
    function getEtcTokenInfo() public view returns(uint256 totalEtcSupply_,uint256 totalUsdtValue_,uint256 etcPrice_){
        totalEtcSupply_ =  totalSupply();
        totalUsdtValue_ =  usdtAddress.balanceOf(address(this));
        etcPrice_ =  etcPrice;
    }

    function safeTransfer(address token, address to, uint value) internal   {
         // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function donateDust(address addr, uint256 amount) external onlyOwner {
        safeTransfer(addr, _msgSender(), amount);
    }

    function donateEthDust(uint256 amount) external onlyOwner {
       payable(_msgSender()).transfer(amount);
    }
}