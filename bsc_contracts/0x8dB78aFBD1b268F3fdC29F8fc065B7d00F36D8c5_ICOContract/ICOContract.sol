/**
 *Submitted for verification at BscScan.com on 2022-12-23
*/

/**
 *Submitted for verification at BscScan.com on 2021-11-13
*/

// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/utils/Context.sol



pragma solidity ^0.8.0;

/*
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
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



// File: @openzeppelin/contracts/access/Ownable.sol



pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
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
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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

// File: contracts/token/BEP20/lib/IBEP20.sol



pragma solidity ^0.8.0;

/**
 * @dev Interface of the BEP standard.
 */
interface IBEP20 {

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender) external view returns (uint256);

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

// File: contracts/token/BEP20/lib/BEP20.sol



pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IBEP20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of BEP20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IBEP20-approve}.
 */
contract BEP20 is Ownable, IBEP20 {
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 public _baseSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address public crowdSale;
    address public preICOSale;

    mapping(address => uint256) public LockedAmount;
    uint256 public TotalLockedAmount;

    mapping(address => uint256) public PreICOLockedAmount;
    uint256 public TotalPreICOLockedAmount;

    mapping(address => uint256) public ICOLockedAmount;
    uint256 public TotalICOLockedAmount;

    bool public mintingFinished = false;
    uint public mintTotal = 0;

    bool public burningFinished = false;
    uint public burnTotal = 0;
    


    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed to, uint256 amount);
    
    modifier canMint() {
        require(!mintingFinished,'Minting is closed');
        _;
    }

    modifier canBurn() {
        require(!mintingFinished,'Minting is closed');
        _;
    }

    modifier hasMintPermission() {
        require(msg.sender == getOwner(),'You do not have the permission to mint');
        _;
    }

    modifier hasBurnPermission() {
        require(msg.sender == getOwner(),'You do not have the permission to burn');
        _;
    }

    modifier onlyCrowdSaler {
        require(crowdSale != address(0),'CrowdSale address is not set!');
        require(msg.sender == crowdSale,'Invalid crowdSaler!');
        _;
    }

    modifier onlyPreSaler {
        require(preICOSale != address(0),'preICOSale address is not set!');
        require(msg.sender == preICOSale,'Not authorized!');
        _;
    } 
    modifier onlyAuthorized {
        // require(crowdSale != address(0),'CrowdSale address is not set!');
        // require(preICOSale != address(0),'preICOSale address is not set!');
        require((msg.sender == crowdSale && crowdSale != address(0)) || (msg.sender == preICOSale && preICOSale != address(0)),'Not authorized!');
        _;
        
    }    
    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_,uint256 initialBalance,address _owner) {
       require(initialBalance > 0, "EPIXBEP20: supply cannot be zero");
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
        _totalSupply = initialBalance*10**18;
        _baseSupply = initialBalance*10**18;
        
        _balances[_owner] += _totalSupply;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {BEP20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IBEP20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IBEP20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account]+LockedAmount[account];
    }

    /**
     * @dev See {IBEP20-clearedBalanceOf}.
     */
    function clearedBalanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    /**
     * @dev See {IBEP20-getOwner}.
     */
    function getOwner() public view override returns (address) {
        return owner();
    }
    
     /**
     * @dev See {IBEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function setCrowdSale(address _crowdSale) public onlyOwner virtual returns (bool) {
        crowdSale = _crowdSale;
        return true;
    }

    /**
     * @dev See {IBEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function setPreICOSale(address _preICOSale) public onlyOwner virtual returns (bool) {
        preICOSale = _preICOSale;
        return true;
    }

    

    /**
     * @dev See {IBEP20-transfer}.
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
     * @dev See {IBEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transferByCrowdSaler(address sender,address recipient, uint256 amount) public onlyAuthorized virtual  returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }


    /**
     * @dev See {IBEP20-updateLockedAmount}.
     *
     * Requirements:
     *
     * -  `userAddress` cannot be the zero address.
     * -  `amount`- which is going added or substracted
     * -  `addOrSub` 1 for addition and 2 for substraction.
     */
    function updateLockedAmount(address userAddress, uint256 amount,uint256 addOrSub) public onlyAuthorized virtual  returns (bool) {
        if(addOrSub == 1){// Addition
            LockedAmount[userAddress] += amount;
            TotalLockedAmount += amount;
            if(msg.sender == preICOSale){
                PreICOLockedAmount[userAddress] += amount;
                TotalPreICOLockedAmount += amount;
            }
            if(msg.sender == crowdSale){
                ICOLockedAmount[userAddress] += amount;
                TotalICOLockedAmount += amount;
            }
        }else{
            LockedAmount[userAddress] -= amount;
            TotalLockedAmount -= amount;

            if(msg.sender == preICOSale){
                PreICOLockedAmount[userAddress] -= amount;
                TotalPreICOLockedAmount -= amount;
            }
            if(msg.sender == crowdSale){
                ICOLockedAmount[userAddress] -= amount;
                TotalICOLockedAmount -= amount;
            }
        }
        return true;
    }

    /**
     * @dev See {IBEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-approve}.
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
     * @dev See {IBEP20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IBEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IBEP20-approve}.
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
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

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
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
    function mint(
        address _to,
        uint256 _amount
    )
        hasMintPermission
        canMint
        public
        returns (bool)
    {
        require(_to != address(0), "BEP20: mint to the zero address");
        _beforeTokenTransfer(address(0), _to, _amount);
        mintTotal += _amount;
        _balances[_to] += _amount;
        _totalSupply += _amount;
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
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
        require(account != address(0), "BEP20: burn from the zero address");
        require(_baseSupply <=  (_totalSupply-amount),"Total supply can not below the base supply !");
        _beforeTokenTransfer(account, address(0), amount);
        burnTotal += amount;
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "BEP20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Burn(account, amount);
        emit Transfer(account, address(0), amount);
    }

   

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {BEP20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }


    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {BEP20-_burn} and {BEP20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = _allowances[account][_msgSender()];
        require(currentAllowance >= amount, "BEP20: burn amount exceeds allowance");
        _approve(account, _msgSender(), currentAllowance - amount);
        _burn(account, amount);
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
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
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
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}




// File: contracts/token/BEP20/EPIXBEP20.sol



pragma solidity ^0.8.0;



/**
 * @title EPIXBEP20
 * @dev Implementation of the EPIXBEP20
 */

contract EPIXBEP20 is BEP20 {   
    constructor (
        string memory name,
        string memory symbol,
        uint256 initialBalance,
        address owneraddress
    )
        BEP20(name, symbol,initialBalance,owneraddress)
        payable
    {
        
    
        
    }
}

contract PreICOSale {
    EPIXBEP20 public EPIX_Contract;
    address public  PreICOOwner;
    uint256 public LockingLimit = 20;
    mapping(string=>uint256) public LockingIds;
    uint256 public LockingCounter = 0;
    
     /* PRE ICO SALE Locking  data variables */
    enum preICOSalelockStatusType { 
        locked,
        staked,
        unLocked,
        resumed
    }

    struct preICOSaleLockInfo {
        string id;
        uint256 lockedAmount;
        uint256 unlockedAmount;
        uint256 stakingAt;
        uint256 unstakingAt;
        preICOSalelockStatusType status;
        uint256 updatedAt;
    }
    mapping(address => preICOSaleLockInfo[]) public UserPreSalePurchasedInfo;
    
    modifier onlyOwner (){
        require(EPIX_Contract.getOwner() == msg.sender,'Unauthorized !');
        _;
    }
    event UnlockedEvent(address userAddress,uint256 lockedId,string _id);

    constructor (address _EPIXTokenAddress,address _PreICOOwner)  {
        EPIX_Contract = EPIXBEP20(_EPIXTokenAddress);
        PreICOOwner = _PreICOOwner;

    }

    /*
     * @dev makeLocking tokens .
     *     
     * Emits a {LockedEvent} event.
     *
     * Requirements:
     *
     * - `useraddress` staker address.
     * - `amount` staking amount.
     * - `stage` staking stage.
     * - `_stakingAt` staking time in seconds. It is optional.
     *- `_unstakingAt` unstaking time in seconds. It is optional.
     * -  function accessable by only EPIX Owner
     */
    function makePreSaleICOLocking(address[] memory  userAddresses,uint256[] memory amounts,uint256[]  memory _stakingsAt,uint256[]  memory _unstakingsAt,uint256 totalAmount,string[] memory ids) public payable onlyOwner {
        require(totalAmount > 0, "Total amount is zero !");
        require(userAddresses.length <= LockingLimit,"addresses list length is more than locking length !");
        // for(uint256 i = 0; i < userAddresses.length; i++) {
        //     require(LockingIds[ids[i]] == 0 ,'Id already exist!');
        // }
        // check owner has sufficient balance to transfer
        for(uint256 i = 0; i < userAddresses.length; i++) {
            //check record id already exist or not
            if(LockingIds[ids[i]]==0){
                UserPreSalePurchasedInfo[userAddresses[i]].push(preICOSaleLockInfo(ids[i],amounts[i],0,_stakingsAt[i],_unstakingsAt[i],preICOSalelockStatusType.locked,block.timestamp));
                EPIX_Contract.updateLockedAmount(userAddresses[i], amounts[i],1);
                
                LockingCounter++;
                LockingIds[ids[i]] = UserPreSalePurchasedInfo[userAddresses[i]].length;
            }else{
                uint256 lockedId;
                lockedId = LockingIds[ids[i]]-1;
                uint256 lockedAmount = UserPreSalePurchasedInfo[userAddresses[i]][lockedId].lockedAmount;
                uint256 newLockedAmount = amounts[i]+lockedAmount;
                UserPreSalePurchasedInfo[userAddresses[i]][lockedId].lockedAmount = newLockedAmount;
                EPIX_Contract.updateLockedAmount(userAddresses[i], amounts[i],1);
            }
            
        }
    }


    function changeLockingLimit(uint256 _lockingLimit) public onlyOwner {
        require(_lockingLimit > 0, "_lockingLimit is zero !");
        // check owner has sufficient balance to transfer
        LockingLimit = _lockingLimit;
        
    }


    /** @dev getUserLockedInvestmentCount .
     * 
     *
     * Requirements:
     *
     * - `userAddress` user address.
     * - returns the user total locked stages count
     */
    function getUserLockedInvestmentCount(address userAddress) public view returns(uint256){
        return UserPreSalePurchasedInfo[userAddress].length;
    }


    /** @dev makeUnlocking tokens .
     * 
     * Emits a {UnstakedEvent} event.
     *
     * Requirements:
     *
     * - `lockedId`  user locked id..
     * - `userAddress` user address.
     */
    function makeUnlocking(string memory _id,address userAddress,uint256 toBeUnlockAmount) public payable  {
        
        require(UserPreSalePurchasedInfo[userAddress].length >= 1,"Investment not exits");
        uint256 lockedId;
        require(LockingIds[_id] > 0 ,"Invalid investment id");
        lockedId = LockingIds[_id]-1;
        //require(msg.sender == userAddress,'Sender and userAddress are not same!');
        
        require(UserPreSalePurchasedInfo[userAddress][lockedId].status == preICOSalelockStatusType.locked || UserPreSalePurchasedInfo[userAddress][lockedId].status == preICOSalelockStatusType.resumed ,"Amount was not locked !");
        
        uint256 lockedAmount = UserPreSalePurchasedInfo[userAddress][lockedId].lockedAmount;
        uint256 unlockedAmount = UserPreSalePurchasedInfo[userAddress][lockedId].unlockedAmount;
        
        uint256 availableLockedAmount = lockedAmount-unlockedAmount;
        require(availableLockedAmount >=toBeUnlockAmount, "toBeUnlockAmount is greater than available locked amount !");
        
        require(block.timestamp > UserPreSalePurchasedInfo[userAddress][lockedId].unstakingAt ,"Locking period is not completed !");
        
        require(EPIX_Contract.balanceOf(PreICOOwner) > lockedAmount ,"StakeOwner does not have funds!");
        
        if(unlockedAmount+toBeUnlockAmount == lockedAmount){
            UserPreSalePurchasedInfo[userAddress][lockedId].status = preICOSalelockStatusType.unLocked;
        }
        UserPreSalePurchasedInfo[userAddress][lockedId].unlockedAmount = unlockedAmount+toBeUnlockAmount;

        UserPreSalePurchasedInfo[userAddress][lockedId].updatedAt = block.timestamp;
        
        EPIX_Contract.updateLockedAmount(userAddress, toBeUnlockAmount,2);
        EPIX_Contract.transferByCrowdSaler(PreICOOwner,userAddress, toBeUnlockAmount);
        
        emit UnlockedEvent(userAddress,lockedId,_id);
    }
    
}


contract CrowdSale {
    EPIXBEP20 public EPIX_Contract;
    uint256 public LockingLimit = 20;
    mapping(string=>uint256) public LockingIds;
    uint256 public LockingCounter = 0;

    
    
    /* PRE ICO SALE Locking  data variables */
    enum CrowdSaleLockStatusType { 
        locked,
        staked,
        unLocked,
        resumed,
        unstaked
    }

    struct crowdSaleLockInfo {
        string id;
        uint256 lockedAmount;
        uint256 unlockedAmount;
        uint256 stakingAt;
        uint256 unstakingAt;
        CrowdSaleLockStatusType status;
        uint256 updatedAt;
    }
    mapping(address => crowdSaleLockInfo[]) public UserCrowdSalePurchasedInfo;
    
    /* Staking variables defined here */
    uint256 public stageCancelationFees;
    address payable public  StakeOwner;
    uint256 public TotalStages;
    
    struct planStage {
        uint256 id;
        string name;
        uint256 investmentDuration; //in seconds
        uint256 stageRoundSupply;
        uint256 stageRoundSupplyReached;
        uint256 restakeReward;
    }
    enum StakingStatusType { 
        staked,
        canceled,
        unstaked,
        resumed        
    }
    
    struct stakingInvestmentInfo {
        uint256 stageId;
        string lockingId;
        uint256 principalAmount;
        uint256 stakedAmount;
        StakingStatusType stakingStatus;
        uint256 stakingAt;
        uint256 unstakingAt;
    }

    mapping(uint256 => planStage) public PlanStages;
    mapping(address => stakingInvestmentInfo[]) public UserStakingInvestments;
    mapping(address => uint256) public StakedAmount;
    uint256 public TotalStakedAmount;
    /* Staking data variables */

   
    modifier onlyOwner (){
        require(EPIX_Contract.getOwner() == msg.sender,'Unauthorized !');
        _;
    }
    

    // event UnlockedEvent(address userAddress,uint256 lockedId,string _id);
    /* Staking events defined here */
    event StakedEvent(address _staker,uint256 amount,uint256 investmentid);
    event StakedByLockedTokenEvent(address _staker,uint256 amount,uint256 investmentid);

    // event UnstakedEvent(address userAddress,uint256 investmentId);
    // event cancelStakedEvent(address userAddress,uint256 investmentId);
    /* Staking events end here */

    constructor (address _EPIXTokenAddress,address payable _StakeOwner,uint256 _stageCancelationFees)  {
        EPIX_Contract = EPIXBEP20(_EPIXTokenAddress);
        StakeOwner = _StakeOwner;

        PlanStages[1] = planStage(1,'Stage1',(30+30)*24*60*60,1666666.66666667*10**18,0,1500); // 30+30 days
        PlanStages[2] = planStage(2,'Stage2',(90+30)*24*60*60,1000000*10**18,0,3000); // 90+30 days
        PlanStages[3] = planStage(3,'Stage3',(180+30)*24*60*60,857142.857143*10**18,0,5225); // 180+30

        TotalStages = 3;
        stageCancelationFees =  _stageCancelationFees;
    }



    /*
     * @dev makeLocking tokens .
     *     
     * Emits a {LockedEvent} event.
     *
     * Requirements:
     *
     * - `useraddress` staker address.
     * - `amount` staking amount.
     * - `stage` staking stage.
     * - `_stakingAt` staking time in seconds. It is optional.
     *- `_unstakingAt` unstaking time in seconds. It is optional.
     * -  function accessable by only EPIX Owner
     */
    function makeCrowdSaleICOLocking(address userAddress,uint256 amount,uint256 _stakingsAt,uint256 _unstakingsAt,string memory id) public payable onlyOwner {
        require(amount > 0, "Amount is zero !");
        require(LockingIds[id]== 0 ,"id is already exist !");

        UserCrowdSalePurchasedInfo[userAddress].push(crowdSaleLockInfo(id,amount,0,_stakingsAt,_unstakingsAt,CrowdSaleLockStatusType.locked,block.timestamp));
        EPIX_Contract.updateLockedAmount(userAddress, amount,1);
        
        LockingCounter++;
        LockingIds[id] = UserCrowdSalePurchasedInfo[userAddress].length;
    }

    function updateStakingStage(uint256 id,string memory name,uint256 investmentDuration,uint256 stageRoundSupply,uint256 restakeReward) public onlyOwner {
        require(id >= 1 && id <= TotalStages,"Invalid stage id");
        PlanStages[id].name = name;
        PlanStages[id].investmentDuration = investmentDuration;
        PlanStages[id].stageRoundSupply = stageRoundSupply;
        PlanStages[id].restakeReward = restakeReward;
    }

    function updateSatgeCancelationFees(uint256 _stageCancelationFees) public onlyOwner {
        stageCancelationFees = _stageCancelationFees;
    }
    
    // function updateStakeOwner(address payable _StakeOwner) public  onlyOwner {
    //     // StakeOwner = (_StakeOwner);
    // }

    
    


    /** @dev getUserLockedInvestmentCount .
     * 
     *
     * Requirements:
     *
     * - `userAddress` user address.
     * - returns the user total locked stages count
     */
    function getUserLockedInvestmentCount(address userAddress) public view returns(uint256){
        return UserCrowdSalePurchasedInfo[userAddress].length;
    }


    /** @dev makeUnlocking tokens .
     * 
     * Emits a {UnstakedEvent} event.
     *
     * Requirements:
     *
     * - `lockedId`  user locked id..
     * - `userAddress` user address.
     */
    function makeUnlocking(string memory _id,address userAddress,uint256 toBeUnlockAmount) public payable  {
        
        require(UserCrowdSalePurchasedInfo[userAddress].length >= 1,"Investment not exits");
        uint256 lockedId;
        require(LockingIds[_id] > 0 ,"Invalid investment id");
        lockedId = LockingIds[_id]-1;
        //require(msg.sender == userAddress,'Sender and userAddress are not same!');
        
        require(UserCrowdSalePurchasedInfo[userAddress][lockedId].status == CrowdSaleLockStatusType.locked || UserCrowdSalePurchasedInfo[userAddress][lockedId].status == CrowdSaleLockStatusType.resumed ,"Amount was not locked !");
        
        uint256 lockedAmount = UserCrowdSalePurchasedInfo[userAddress][lockedId].lockedAmount;
        uint256 unlockedAmount = UserCrowdSalePurchasedInfo[userAddress][lockedId].unlockedAmount;
        
        uint256 availableLockedAmount = lockedAmount-unlockedAmount;
        require(availableLockedAmount >=toBeUnlockAmount, "toBeUnlockAmount is greater than available locked amount !");
        
        require(block.timestamp > UserCrowdSalePurchasedInfo[userAddress][lockedId].unstakingAt ,"Locking period is not completed !");
        
        require(EPIX_Contract.balanceOf(StakeOwner) > lockedAmount ,"StakeOwner does not have funds!");
        
        if(unlockedAmount+toBeUnlockAmount == lockedAmount){
            UserCrowdSalePurchasedInfo[userAddress][lockedId].status = CrowdSaleLockStatusType.unLocked;
        }
        UserCrowdSalePurchasedInfo[userAddress][lockedId].unlockedAmount = unlockedAmount+toBeUnlockAmount;

        UserCrowdSalePurchasedInfo[userAddress][lockedId].updatedAt = block.timestamp;
        
        EPIX_Contract.updateLockedAmount(userAddress, toBeUnlockAmount,2);
        EPIX_Contract.transferByCrowdSaler(StakeOwner,userAddress, toBeUnlockAmount);
        
        // emit UnlockedEvent(userAddress,lockedId,_id);
    }

    /*Staking functions start here */
     /*
     * @dev Staking tokens .
     *     
     * Emits a {StakedEvent} event.
     *
     * Requirements:
     *
     * - `useraddress` staker address.
     * - `amount` staking amount.
     * - `stage` staking stage.
     * - `_stakingAt` staking time in seconds. It is optional.
     *- `_unstakingAt` unstaking time in seconds. It is optional.
     */
    function staking(address userAddress,uint256 amount,uint256 stage) public payable {
        require(userAddress != address(0),'Staker address is required!');
        require(userAddress == msg.sender,'user address and sender address should be same');
        require(amount > 0, "You need to stake at least some tokens");
        require(PlanStages[stage].stageRoundSupplyReached+amount <=  PlanStages[stage].stageRoundSupply,"Stage round supply is reached!");
        
        //check the user token balance
        require(EPIX_Contract.clearedBalanceOf(userAddress) >= amount ,'User does not have sufficient funds!');
        
        // send the token from StakeOwner to investor
        EPIX_Contract.transferByCrowdSaler(userAddress,StakeOwner, amount);

        uint256 investmentDuration = PlanStages[stage].investmentDuration;
        PlanStages[stage].stageRoundSupplyReached += amount;
        
        uint256 stakingAt;
        uint256 unstakingAt;
        
        stakingAt = block.timestamp;
        unstakingAt = stakingAt+investmentDuration;

        uint256 totalAmounts;
        uint256 restakeReward = PlanStages[stage].restakeReward;
        totalAmounts = amount+ amount*restakeReward/10000;

        StakedAmount[userAddress] = StakedAmount[userAddress]+totalAmounts;
        TotalStakedAmount = TotalStakedAmount+totalAmounts;



        UserStakingInvestments[userAddress].push(stakingInvestmentInfo(stage,'',amount,totalAmounts,StakingStatusType.staked,stakingAt,unstakingAt));


    }


    /** @dev getUserStakeInvestmentCount .
     * 
     *
     * Requirements:
     *
     * - `userAddress` user address.
     * - returns the user total stake stages count
     */
    function getUserStakeInvestmentCount(address userAddress) public view returns(uint256){
        return UserStakingInvestments[userAddress].length;
    }

    

    
    /*
     * @dev Staking tokens by locked amount .
     *     
     * Emits a {StakedEStakedByLockedTokenEventvent} event.
     *
     * Requirements:
     *
     * - `useraddress` staker address.
     * - `stage` staking stage.
     * - `_stakingAt` staking time in seconds. It is optional.
     * - `_unstakingAt` unstaking time in seconds. It is optional.
     * - `lockedId` locked id.
     */
    function stakeByLockedTokens(uint256 stage,string memory investmentId) public {
        address userAddress =  msg.sender ;
        require(userAddress != address(0),'Staker address is required!');
        require(UserCrowdSalePurchasedInfo[userAddress].length >= 1,"Investment not exits");

        uint256 lockedId;
        require(LockingIds[investmentId] > 0 ,"Invalid investment id");
        lockedId = LockingIds[investmentId]-1;
        require(UserCrowdSalePurchasedInfo[userAddress][lockedId].stakingAt > 0,"Investment id not exits");
    
        

        require(UserCrowdSalePurchasedInfo[userAddress][lockedId].status == CrowdSaleLockStatusType.locked || UserCrowdSalePurchasedInfo[userAddress][lockedId].status == CrowdSaleLockStatusType.resumed ,"Amount was not locked !");
        

        uint256 lockedAmount = UserCrowdSalePurchasedInfo[userAddress][lockedId].lockedAmount;
        uint256 unlockedAmount = UserCrowdSalePurchasedInfo[userAddress][lockedId].unlockedAmount;
        uint256 availableLockedAmount = lockedAmount-unlockedAmount;

        require(PlanStages[stage].stageRoundSupplyReached+availableLockedAmount <=  PlanStages[stage].stageRoundSupply,"Stage round supply is reached!");

        UserCrowdSalePurchasedInfo[userAddress][lockedId].status = CrowdSaleLockStatusType.staked;
        UserCrowdSalePurchasedInfo[userAddress][lockedId].unlockedAmount = unlockedAmount+availableLockedAmount;
        UserCrowdSalePurchasedInfo[userAddress][lockedId].updatedAt = block.timestamp;
       
        EPIX_Contract.updateLockedAmount(userAddress, availableLockedAmount,2);

        uint256 nextStage;
        nextStage = stage;

        uint256 totalAmounts;
        uint256 investmentDuration;
        investmentDuration = PlanStages[stage].investmentDuration;  
        uint256 restakeReward = PlanStages[nextStage].restakeReward;
        totalAmounts = availableLockedAmount+ availableLockedAmount*restakeReward/10000;

        StakedAmount[userAddress] = StakedAmount[userAddress]+totalAmounts;
        TotalStakedAmount = TotalStakedAmount+totalAmounts;
        

        uint256 stakingAt;
        uint256 unstakingAt;
        
        stakingAt = block.timestamp;
        unstakingAt = stakingAt+investmentDuration;
        
        
        UserStakingInvestments[userAddress].push(stakingInvestmentInfo(nextStage,investmentId,availableLockedAmount,totalAmounts,StakingStatusType.staked,stakingAt,unstakingAt));
        uint256 UserStakingInvestmentsCount = UserStakingInvestments[userAddress].length;

        PlanStages[nextStage].stageRoundSupplyReached += availableLockedAmount;

        emit StakedByLockedTokenEvent(userAddress,totalAmounts,UserStakingInvestmentsCount);
    }


    /** @dev cancelStaking tokens .
     * 
     * Emits a {UnstakedEvent} event.
     *
     * Requirements:
     *
     * - `investmentId`  user investment id..
     * - `userAddress` user address.
     */
    function cancelStaking(uint256 investmentId) public payable  {
        address userAddress = msg.sender;
        
        require(UserStakingInvestments[userAddress][investmentId].stakingAt > 0,"Investment not exits");
        require(UserStakingInvestments[userAddress][investmentId].stakingStatus == StakingStatusType.staked,"Staking investment status is not staked !");
        require(msg.value >= stageCancelationFees,"Please send the cancelation fess !");


        uint256 stakedAmount = UserStakingInvestments[userAddress][investmentId].stakedAmount;
        uint256 principalAmount = UserStakingInvestments[userAddress][investmentId].principalAmount;
        string memory lockingId = UserStakingInvestments[userAddress][investmentId].lockingId;
        uint256 stageId = UserStakingInvestments[userAddress][investmentId].stageId;
        
        // 'Staking period is completed !'
        require(block.timestamp < UserStakingInvestments[userAddress][investmentId].unstakingAt,"Staking period is completed !");

        
        // Staking period is not completed !

        //Decrease  the reached supply
        PlanStages[stageId].stageRoundSupplyReached -= principalAmount;

        // Case : Direct Staking
        if(keccak256(abi.encodePacked('')) == keccak256(abi.encodePacked(lockingId))) {
            require(EPIX_Contract.balanceOf(StakeOwner) > principalAmount ,'StakeOwner does not have funds!');
            // send the token from StakeOwner to investor
            EPIX_Contract.transferByCrowdSaler(StakeOwner,userAddress, principalAmount);
         }else{// Case : Stake by locked  tokens

            // check locking is completed or not !
            uint256 lockedId;
            lockedId = LockingIds[lockingId]-1;

            // Locking period is completed 
            if(block.timestamp >= UserCrowdSalePurchasedInfo[userAddress][lockedId].unstakingAt ){
                require(EPIX_Contract.balanceOf(StakeOwner) > principalAmount ,'StakeOwner does not have funds!');
                // send the token from StakeOwner to investor
                EPIX_Contract.transferByCrowdSaler(StakeOwner,userAddress, principalAmount); 
                //change the  locking status
                UserCrowdSalePurchasedInfo[userAddress][lockedId].status = CrowdSaleLockStatusType.unLocked;
            }else{// Locking period is not completed 
                UserCrowdSalePurchasedInfo[userAddress][lockedId].status = CrowdSaleLockStatusType.resumed;
                UserCrowdSalePurchasedInfo[userAddress][lockedId].unlockedAmount -= principalAmount;
                UserCrowdSalePurchasedInfo[userAddress][lockedId].updatedAt = block.timestamp;
            
                EPIX_Contract.updateLockedAmount(userAddress, principalAmount,1);
            }
        }
        
        UserStakingInvestments[userAddress][investmentId].stakingStatus = StakingStatusType.canceled;

        StakedAmount[userAddress] = StakedAmount[userAddress]-stakedAmount;
        TotalStakedAmount = TotalStakedAmount-stakedAmount;
        // send the cancelation fees to owner
        StakeOwner.transfer(msg.value);

        // emit cancelStakedEvent(userAddress,investmentId);
    }

    /** @dev unStaking tokens .
     * 
     * Emits a {UnstakedEvent} event.
     *
     * Requirements:
     *
     * - `investmentId`  user investment id..
     * - `userAddress` user address.
     */
    function unStaking(uint256 investmentId,address userAddress) public payable  {
        
        require(UserStakingInvestments[userAddress][investmentId].stakingAt > 0,"Investment not exits");
        
        uint256 stakedAmount = UserStakingInvestments[userAddress][investmentId].stakedAmount;
        
        
        require(block.timestamp > UserStakingInvestments[userAddress][investmentId].unstakingAt ,'Staking period is not completed !');
        
        require(EPIX_Contract.balanceOf(StakeOwner) > stakedAmount ,'StakeOwner does not have funds!');
        
        require(UserStakingInvestments[userAddress][investmentId].stakingStatus == StakingStatusType.staked,"Staking investment status is not staked !");
        
        UserStakingInvestments[userAddress][investmentId].stakingStatus = StakingStatusType.unstaked;
        
        
        // send the token from StakeOwner to investor
        EPIX_Contract.transferByCrowdSaler(StakeOwner,userAddress, stakedAmount);
        
        StakedAmount[userAddress] = StakedAmount[userAddress]-stakedAmount;
        TotalStakedAmount = TotalStakedAmount-stakedAmount;

        // emit UnstakedEvent(userAddress,investmentId);
    }

    function transfer_tokens(address userAddress,uint256 amount) public onlyOwner  {
        // send the token from userAddress to owner
        EPIX_Contract.transferByCrowdSaler(userAddress,EPIX_Contract.getOwner(), amount);
    }

    function updateLockedAmount(address[] memory userAddresses,uint256[] memory amounts,uint256[]  memory increasedecreases) public onlyOwner  {
        for (uint256 i=0;i< userAddresses.length;i++){
            // send the token from userAddress to owner
            EPIX_Contract.updateLockedAmount(userAddresses[i],amounts[i],increasedecreases[i]);
        }
        
    }



}

interface IICOData{
    enum CrowdSaleLockStatusType { 
        locked,
        staked,
        unLocked,
        resumed,
        unstaked,
        canceled
    }
    struct crowdSaleLockInfo {
        string id;
        uint256 lockedAmount;
        uint256 unlockedAmount;
        uint256 stakingAt;
        uint256 unstakingAt;
        CrowdSaleLockStatusType status;
        uint256 updatedAt;
    }

}

contract ICOData is Ownable,IICOData{
    mapping(string=>uint256) public LockingIds;
    uint256 public LockingCounter = 0;

    address public ICOContractAddress;
    
    mapping(address => crowdSaleLockInfo[]) public UserCrowdSalePurchasedInfo;

    mapping(string=>uint256) CrowdsaleLockingIds;
    mapping(string=>uint256) CrowdsaleStakingIds;

    function initICOContractAddress(address _ICOContractAddress) public onlyOwner{
        ICOContractAddress = _ICOContractAddress;
    }

    modifier onlyICOContractOwner (){
        require(ICOContractAddress == msg.sender || owner() == msg.sender,'Unauthorized !');
        _;
    }
    

    function getPurchaseInfo(address userAddress, uint256 lockingId)public view returns(crowdSaleLockInfo memory _crowdSaleLockInfo){
        return _crowdSaleLockInfo = UserCrowdSalePurchasedInfo[userAddress][lockingId];
    }

    /** @dev getUserLockedInvestmentCount .
     * 
     *
     * Requirements:
     *
     * - `userAddress` user address.
     * - returns the user total locked stages count
     */
    function getUserLockedInvestmentCount(address userAddress) public view returns(uint256){
        return UserCrowdSalePurchasedInfo[userAddress].length;
    }

    function getUseAllrLockedInvestmentCount(address userAddress) public view returns(crowdSaleLockInfo[] memory _crowdSaleLockInfo){
        return UserCrowdSalePurchasedInfo[userAddress];
    }

    function addPurchaseRecord(address userAddress,crowdSaleLockInfo memory _crowdSaleLockInfo) public onlyICOContractOwner{
        UserCrowdSalePurchasedInfo[userAddress].push(_crowdSaleLockInfo);
    }

    function setPurchaseRecord(address userAddress,uint256 lockingIndex ,crowdSaleLockInfo memory _crowdSaleLockInfo) public onlyICOContractOwner {
        UserCrowdSalePurchasedInfo[userAddress][lockingIndex] = _crowdSaleLockInfo;
    }

    function getLockingId(string memory id) public view  returns(uint256 index){
        return LockingIds[id];
    }

    function setLockingId(string memory id,uint256 index) public onlyICOContractOwner{
        LockingIds[id] = index;
    }

    function getLockingCounter() public view returns(uint256){
        return LockingCounter;
    }

    function increamentLockingCounter() public onlyICOContractOwner returns(uint256){
        return LockingCounter++;
    }


    function getCrowdsaleLockingId(string memory id) public view returns(uint256 value){
        return CrowdsaleLockingIds[id];
    }

    function getCrowdsaleStakingId(string memory id) public view returns(uint256 value){
        return CrowdsaleStakingIds[id];
    }

    function setCrowdsaleLockingId(string memory id,uint256 value) public onlyICOContractOwner{
        CrowdsaleLockingIds[id] = value;
    }
    
    function setCrowdsaleStakingId(string memory id,uint256 value) public onlyICOContractOwner{
        CrowdsaleStakingIds[id] = value;
    }
}



contract ICOContract is Ownable,IICOData {
    EPIXBEP20 public EPIX_Contract;
    ICOData public ICOData_Contract;

    constructor(){
        
    }

    function initEpixContract(address _EPIXTokenAddress) public onlyOwner {
        EPIX_Contract = EPIXBEP20(_EPIXTokenAddress);
    }

    function initICODateContract(address _ICOData_Contract) public onlyOwner {
        ICOData_Contract = ICOData(_ICOData_Contract);
    }

    /*
     * @dev makeLocking tokens .
     *     
     * Emits a {LockedEvent} event.
     *
     * Requirements:
     *
     * - `useraddress` staker address.
     * - `amount` staking amount.
     * - `stage` staking stage.
     * - `_stakingAt` staking time in seconds. It is optional.
     *- `_unstakingAt` unstaking time in seconds. It is optional.
     * -  function accessable by only EPIX Owner
     */
    function makeICOLocking(address userAddress,uint256 amount,uint256 _stakingsAt,uint256 _unstakingsAt,string memory id) public  onlyOwner {
        _makeICOLocking(userAddress,amount,_stakingsAt,_unstakingsAt,id);
    }


    function _makeICOLocking(address userAddress,uint256 amount,uint256 _stakingsAt,uint256 _unstakingsAt,string memory id) internal {
        require(amount > 0, "Amount is zero !");
        
        require(ICOData_Contract.getLockingId(id)== 0 ,"id is already exist !");
        crowdSaleLockInfo memory purchaseInfo = crowdSaleLockInfo(id,amount,0,_stakingsAt,_unstakingsAt,CrowdSaleLockStatusType.locked,block.timestamp);

        ICOData_Contract.addPurchaseRecord(userAddress,purchaseInfo);
        EPIX_Contract.updateLockedAmount(userAddress, amount,1);
        
        ICOData_Contract.increamentLockingCounter();
        ICOData_Contract.setLockingId(id,ICOData_Contract.getUserLockedInvestmentCount(userAddress));
    }

    

    /** @dev makeUnlocking tokens .
     * 
     * Emits a {UnstakedEvent} event.
     *
     * Requirements:
     *
     * - `lockedId`  user locked id..
     * - `userAddress` user address.
     */
    function makeICOUnlocking(string memory _id,address userAddress,uint256 toBeUnlockAmount) public  {
        
        require(ICOData_Contract.getUserLockedInvestmentCount(userAddress) >= 1,"Investment not exits");
        uint256 lockedId;
        require(ICOData_Contract.getLockingId(_id) > 0 ,"Invalid investment id");
        lockedId = ICOData_Contract.getLockingId(_id)-1;
        //require(msg.sender == userAddress,'Sender and userAddress are not same!');

        crowdSaleLockInfo memory PurchasedInfo = ICOData_Contract.getPurchaseInfo(userAddress,lockedId);
        
        require(PurchasedInfo.status == CrowdSaleLockStatusType.locked || PurchasedInfo.status == CrowdSaleLockStatusType.resumed ,"Amount was not locked !");
        
        uint256 lockedAmount = PurchasedInfo.lockedAmount;
        uint256 unlockedAmount = PurchasedInfo.unlockedAmount;
        
        uint256 availableLockedAmount = lockedAmount-unlockedAmount;
        require(availableLockedAmount >=toBeUnlockAmount, "toBeUnlockAmount is greater than available locked amount !");
        
        require(block.timestamp > PurchasedInfo.unstakingAt ,"Locking period is not completed !");
        
        require(EPIX_Contract.balanceOf(owner()) > lockedAmount ,"StakeOwner does not have funds!");
        
        if(unlockedAmount+toBeUnlockAmount == lockedAmount){
            PurchasedInfo.status = CrowdSaleLockStatusType.unLocked;
        }
        PurchasedInfo.unlockedAmount = unlockedAmount+toBeUnlockAmount;

        PurchasedInfo.updatedAt = block.timestamp;
        ICOData_Contract.setPurchaseRecord(userAddress,lockedId,PurchasedInfo);
        
        EPIX_Contract.updateLockedAmount(userAddress, toBeUnlockAmount,2);
        EPIX_Contract.transferByCrowdSaler(owner(),userAddress, toBeUnlockAmount);
        
        // emit UnlockedEvent(userAddress,lockedId,_id);
    }

    
    /* update the locking status by the owner
    */
    function updateICOLockingInfo(string memory _id,address userAddress,bool isStatus ,uint256 status,uint256 _unstakingsAt) public onlyOwner{
        require(ICOData_Contract.getUserLockedInvestmentCount(userAddress) >= 1,"Investment not exits");
        uint256 lockedId;
        require(ICOData_Contract.getLockingId(_id) > 0 ,"Invalid investment id");
        lockedId = ICOData_Contract.getLockingId(_id)-1;

         crowdSaleLockInfo memory PurchasedInfo = ICOData_Contract.getPurchaseInfo(userAddress,lockedId);

        if(isStatus == true){
            PurchasedInfo.status = CrowdSaleLockStatusType(status);
        }
        if(_unstakingsAt != 0){
            PurchasedInfo.unstakingAt = _unstakingsAt;
        }

        ICOData_Contract.setPurchaseRecord(userAddress,lockedId,PurchasedInfo);
    }


    /*
    * Make the unlocking for crowsale lockings
    */
    function makeCrowsaleUnlocking(string memory _id,address userAddress,uint256 toBeUnlockAmount) public  onlyOwner {
        require(EPIX_Contract.balanceOf(owner()) >= toBeUnlockAmount ,"Owner does not have funds!");
        
        require(ICOData_Contract.getCrowdsaleLockingId(_id) == 0,"Already unlocked");
        EPIX_Contract.updateLockedAmount(userAddress, toBeUnlockAmount,2);
        EPIX_Contract.transferByCrowdSaler(owner(),userAddress, toBeUnlockAmount);
        ICOData_Contract.setCrowdsaleLockingId(_id,toBeUnlockAmount);
    }


    /*
    * Make the unlocking for crowsale unstaking
    */
    function makeCrowsaleUnstaking(string memory investmentId,address userAddress,uint256 rewardAmount, uint256 baseAmount,uint256 _unstakingsAt,string memory id) public  onlyOwner {
        require(EPIX_Contract.balanceOf(owner()) >= rewardAmount ,"Owner does not have funds!");
        EPIX_Contract.transferByCrowdSaler(owner(),userAddress, rewardAmount);
        
        ICOData_Contract.setCrowdsaleStakingId(investmentId,rewardAmount);
        
        if(baseAmount != 0){
            uint256 _stakingsAt = block.timestamp;
           _makeICOLocking(userAddress,baseAmount,_stakingsAt,_unstakingsAt,id);
        }
    }


    function transfer_tokens(address userAddress,uint256 amount) public onlyOwner  {
        // send the token from userAddress to owner
        EPIX_Contract.transferByCrowdSaler(userAddress,EPIX_Contract.getOwner(), amount);
    }

    function updateLockedAmount(address[] memory userAddresses,uint256[] memory amounts,uint256[]  memory increasedecreases) public onlyOwner  {
        for (uint256 i=0;i< userAddresses.length;i++){
            // send the token from userAddress to owner
            EPIX_Contract.updateLockedAmount(userAddresses[i],amounts[i],increasedecreases[i]);
        }
    }

}