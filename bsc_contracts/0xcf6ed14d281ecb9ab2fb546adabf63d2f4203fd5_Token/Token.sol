/**
 *Submitted for verification at BscScan.com on 2022-10-27
*/

//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

abstract contract Context {
	function _msgSender() internal view virtual returns (address) {
		return msg.sender;
	}

	function _msgData() internal view virtual returns (bytes calldata) {
		return msg.data;
	}
}

contract Ownable is Context {
	address private _owner;
	address private _previousOwner;
	mapping(address => bool) private manager;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Initializes the contract setting the deployer as the initial owner.
	 */
	constructor () {
		address msgSender = _msgSender();
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
		manager[msg.sender] = true;
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
		require(_owner == _msgSender() || manager[_msgSender()], "Ownable: caller is not the owner");
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

	function setManger(address addr, bool stauts) public onlyOwner{
        manager[addr] = stauts;
    }
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

	function decimals() external view returns (uint256);
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

	function decimals() public view virtual override returns (uint256) {
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

library SafeMathUint {
	function toInt256Safe(uint256 a) internal pure returns (int256) {
		int256 b = int256(a);
		require(b >= 0);
		return b;
	}
}

library SafeMathInt {
	function mul(int256 a, int256 b) internal pure returns (int256) {
		require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));

		int256 c = a * b;
		require((b == 0) || (c / b == a));
		return c;
	}

	function div(int256 a, int256 b) internal pure returns (int256) {
		require(!(a == - 2**255 && b == -1) && (b > 0));

		return a / b;
	}

	function sub(int256 a, int256 b) internal pure returns (int256) {
		require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));

		return a - b;
	}

	function add(int256 a, int256 b) internal pure returns (int256) {
		int256 c = a + b;
		require((b >= 0 && c >= a) || (b < 0 && c < a));
		return c;
	}

	function toUint256Safe(int256 a) internal pure returns (uint256) {
		require(a >= 0);
		return uint256(a);
	}
}

library SafeMath {
	function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
	unchecked {
		uint256 c = a + b;
		if (c < a) return (false, 0);
		return (true, c);
	}
	}

	function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
	unchecked {
		if (b > a) return (false, 0);
		return (true, a - b);
	}
	}

	function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
	unchecked {
		if (a == 0) return (true, 0);
		uint256 c = a * b;
		if (c / a != b) return (false, 0);
		return (true, c);
	}
	}

	function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
	unchecked {
		if (b == 0) return (false, 0);
		return (true, a / b);
	}
	}

	function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
	unchecked {
		if (b == 0) return (false, 0);
		return (true, a % b);
	}
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		return a + b;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		return a - b;
	}

	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		return a * b;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		return a / b;
	}

	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		return a % b;
	}

	function sub(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
	unchecked {
		require(b <= a, errorMessage);
		return a - b;
	}
	}

	function div(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
	unchecked {
		require(b > 0, errorMessage);
		return a / b;
	}
	}

	function mod(
		uint256 a,
		uint256 b,
		string memory errorMessage
	) internal pure returns (uint256) {
	unchecked {
		require(b > 0, errorMessage);
		return a % b;
	}
	}
}

library IterableMapping {
	// Iterable mapping from address to uint;
	struct Map {
		address[] keys;
		mapping(address => uint) values;
		mapping(address => uint) indexOf;
		mapping(address => bool) inserted;
	}

	function get(Map storage map, address key) public view returns (uint) {
		return map.values[key];
	}

	function getIndexOfKey(Map storage map, address key) public view returns (int) {
		if(!map.inserted[key]) {
			return -1;
		}
		return int(map.indexOf[key]);
	}

	function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
		return map.keys[index];
	}



	function size(Map storage map) public view returns (uint) {
		return map.keys.length;
	}

	function set(Map storage map, address key, uint val) public {
		if (map.inserted[key]) {
			map.values[key] = val;
		} else {
			map.inserted[key] = true;
			map.values[key] = val;
			map.indexOf[key] = map.keys.length;
			map.keys.push(key);
		}
	}

	function remove(Map storage map, address key) public {
		if (!map.inserted[key]) {
			return;
		}

		delete map.inserted[key];
		delete map.values[key];

		uint index = map.indexOf[key];
		uint lastIndex = map.keys.length - 1;
		address lastKey = map.keys[lastIndex];

		map.indexOf[lastKey] = index;
		delete map.indexOf[key];

		map.keys[index] = lastKey;
		map.keys.pop();
	}
}

interface DividendPayingTokenOptionalInterface {
	function withdrawableDividendOf(address _owner) external view returns(uint256);
	function withdrawnDividendOf(address _owner) external view returns(uint256);
	function accumulativeDividendOf(address _owner) external view returns(uint256);
}

interface DividendPayingTokenInterface {
	function dividendOf(address _owner) external view returns(uint256);
	function distributeDividends() external payable;
	function withdrawDividend() external;

	event DividendsDistributed(address indexed from, uint256 weiAmount);
	event DividendWithdrawn(address indexed to, uint256 weiAmount);
}

/// @title Dividend-Paying Token
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
///  to token holders as dividends and allows token holders to withdraw their dividends.
///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
	using SafeMath for uint256;
	using SafeMathUint for uint256;
	using SafeMathInt for int256;

	// With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
	// For more discussion about choosing the value of `magnitude`,
	//  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
	uint256 constant internal magnitude = 2**128;

	uint256 internal magnifiedDividendPerShare;

	// About dividendCorrection:
	// If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
	//   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
	// When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
	//   `dividendOf(_user)` should not be changed,
	//   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
	// To keep the `dividendOf(_user)` unchanged, we add a correction term:
	//   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
	//   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
	//   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
	// So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
	mapping(address => int256) internal magnifiedDividendCorrections;
	mapping(address => uint256) internal withdrawnDividends;

	uint256 public totalDividendsDistributed;
	address public MCM;

	constructor(string memory _name, string memory _symbol)  ERC20(_name, _symbol) {

	}

	/// @dev Distributes dividends whenever ether is paid to this contract.
	receive() external payable {
		distributeDividends();
	}

	/// @notice Distributes ether to token holders as dividends.
	/// @dev It reverts if the total supply of tokens is 0.
	/// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
	/// About undistributed ether:
	///   In each distribution, there is a small amount of ether not distributed,
	///     the magnified amount of which is
	///     `(msg.value * magnitude) % totalSupply()`.
	///   With a well-chosen `magnitude`, the amount of undistributed ether
	///     (de-magnified) in a distribution can be less than 1 wei.
	///   We can actually keep track of the undistributed ether in a distribution
	///     and try to distribute it in the next distribution,
	///     but keeping track of such data on-chain costs much more than
	///     the saved ether, so we don't do that.


	function distributeDividends() public override payable {
		// require(totalSupply() > 0);

		// if (msg.value > 0) {
		//     magnifiedDividendPerShare = magnifiedDividendPerShare.add(
		//         (msg.value).mul(magnitude) / totalSupply()
		//     );
		//     emit DividendsDistributed(msg.sender, msg.value);

		//     totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
		// }
	}
	
	function distributeDividends_MCM(uint256 _amount) public{
		require(msg.sender == MCM);
		require(totalSupply() > 0);

		if (_amount > 0) {
			magnifiedDividendPerShare = magnifiedDividendPerShare.add(
				(_amount).mul(magnitude) / totalSupply()
			);
			emit DividendsDistributed(msg.sender, _amount);

			totalDividendsDistributed = totalDividendsDistributed.add(_amount);
		}
	}

	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividend() public virtual override {
		_withdrawDividendOfUser(msg.sender);
	}

	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function _withdrawDividendOfUser(address user) internal returns (uint256) {
		uint256 _withdrawableDividend = withdrawableDividendOf(user);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
			emit DividendWithdrawn(user, _withdrawableDividend);
			//(bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
			 
			(bool success, bytes memory data) = MCM.call(abi.encodeWithSelector(0xa9059cbb, user, _withdrawableDividend));
			if(success && (data.length == 0 || abi.decode(data, (bool)))){
			
				withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
				return 0;
			}

			return _withdrawableDividend;
		}

		return 0;
	}


	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) public view override returns(uint256) {
		return withdrawableDividendOf(_owner);
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner) public view override returns(uint256) {
		return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
	}

	/// @notice View the amount of dividend in wei that an address has withdrawn.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has withdrawn.
	function withdrawnDividendOf(address _owner) public view override returns(uint256) {
		return withdrawnDividends[_owner];
	}


	/// @notice View the amount of dividend in wei that an address has earned in total.
	/// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
	/// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has earned in total.
	function accumulativeDividendOf(address _owner) public view override returns(uint256) {
		return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
		.add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
	}

	/// @dev Internal function that transfer tokens from one address to another.
	/// Update magnifiedDividendCorrections to keep dividends unchanged.
	/// @param from The address to transfer from.
	/// @param to The address to transfer to.
	/// @param value The amount to be transferred.
	function _transfer(address from, address to, uint256 value) internal virtual override {
		require(false);

		int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
		magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
		magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
	}

	/// @dev Internal function that mints tokens to an account.
	/// Update magnifiedDividendCorrections to keep dividends unchanged.
	/// @param account The account that will receive the created tokens.
	/// @param value The amount that will be created.
	function _mint(address account, uint256 value) internal override {
		super._mint(account, value);

		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
		.sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
	}

	/// @dev Internal function that burns an amount of the token of a given account.
	/// Update magnifiedDividendCorrections to keep dividends unchanged.
	/// @param account The account whose tokens will be burnt.
	/// @param value The amount that will be burnt.
	function _burn(address account, uint256 value) internal override {
		super._burn(account, value);

		magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
		.add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
	}

	function _setBalance(address account, uint256 newBalance) internal {
		uint256 currentBalance = balanceOf(account);

		if(newBalance > currentBalance) {
			uint256 mintAmount = newBalance.sub(currentBalance);
			_mint(account, mintAmount);
		} else if(newBalance < currentBalance) {
			uint256 burnAmount = currentBalance.sub(newBalance);
			_burn(account, burnAmount);
		}
	}
}

contract MCMDividendTracker is DividendPayingToken, Ownable {
	using SafeMath for uint256;
	using SafeMathInt for int256;
	using IterableMapping for IterableMapping.Map;

	IterableMapping.Map private tokenHoldersMap;
	uint256 public lastProcessedIndex;

	mapping (address => bool) public excludedFromDividends;

	mapping (address => uint256) public lastClaimTimes;

	uint256 public claimWait;
	uint256 public minimumTokenBalanceForDividends;

	event ExcludeFromDividends(address indexed account);
	event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
	event UpdateDistributionBalanceOfUser(address account, uint256 newBalance);

	event Claim(address indexed account, uint256 amount, bool indexed automatic);

	constructor() DividendPayingToken("MCM_DividendTracker", "MCM_DividendTracker") {
		claimWait = 0;
		minimumTokenBalanceForDividends = 1; //must hold 1+ 
	}
	

	
	function setMCM(address _MCM) external onlyOwner{
		MCM = _MCM;
	}

	function _transfer(address, address, uint256) internal pure override {
		require(false, "MCMDividendTracker: No transfers allowed");
	}

	function withdrawDividend() public pure override {
		require(false, "MCMDividendTracker: withdrawDividend disabled. Use the 'claim' function on the main MCM contract.");
	}

	function excludeFromDividends(address account) external onlyOwner {
		require(!excludedFromDividends[account]);
		excludedFromDividends[account] = true;

		_setBalance(account, 0);
		tokenHoldersMap.remove(account);

		emit ExcludeFromDividends(account);
	}

	function updateClaimWait(uint256 newClaimWait) external onlyOwner {
		emit ClaimWaitUpdated(newClaimWait, claimWait);
		claimWait = newClaimWait;
	}

	function updateMinimumTokenBalanceForDividends(uint256 newTokenBalance) external onlyOwner {
		emit ClaimWaitUpdated(newTokenBalance, minimumTokenBalanceForDividends);
		minimumTokenBalanceForDividends = newTokenBalance;
	}

	function getLastProcessedIndex() external view returns(uint256) {
		return lastProcessedIndex;
	}

	function getNumberOfTokenHolders() external view returns(uint256) {
		return tokenHoldersMap.keys.length;
	}

	function getAccount(address _account) public view returns (
		address account,
		int256 index,
		int256 iterationsUntilProcessed,
		uint256 withdrawableDividends,
		uint256 totalDividends,
		uint256 lastClaimTime,
		uint256 nextClaimTime,
		uint256 secondsUntilAutoClaimAvailable) {
		account = _account;

		index = tokenHoldersMap.getIndexOfKey(account);

		iterationsUntilProcessed = -1;

		if(index >= 0) {
			if(uint256(index) > lastProcessedIndex) {
				iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
			}
			else {
				uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
				tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
				0;

				iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
			}
		}


		withdrawableDividends = withdrawableDividendOf(account);
		totalDividends = accumulativeDividendOf(account);

		lastClaimTime = lastClaimTimes[account];

		nextClaimTime = lastClaimTime > 0 ?
		lastClaimTime.add(claimWait) :
		0;

		secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
		nextClaimTime.sub(block.timestamp) :
		0;
	}

	function getAccountAtIndex(uint256 index)
	public view returns (
		address,
		int256,
		int256,
		uint256,
		uint256,
		uint256,
		uint256,
		uint256) {
		if(index >= tokenHoldersMap.size()) {
			return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
		}

		address account = tokenHoldersMap.getKeyAtIndex(index);

		return getAccount(account);
	}

	function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
		if(lastClaimTime > block.timestamp)  {
			return false;
		}

		return block.timestamp.sub(lastClaimTime) >= claimWait;
	}

	function setBalance(address account, uint256 newBalance) external onlyOwner {
		if(excludedFromDividends[account]) {
			return;
		}

		if(newBalance >= minimumTokenBalanceForDividends) {
			_setBalance(account, newBalance);
			tokenHoldersMap.set(account, newBalance);
		}
		else {
			_setBalance(account, 0);
			tokenHoldersMap.remove(account);
		}

		emit UpdateDistributionBalanceOfUser(account, newBalance);

		processAccount(account, true);
	}

	function process(uint256 gas) public returns (uint256, uint256, uint256) {
		uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;

		if(numberOfTokenHolders == 0) {
			return (0, 0, lastProcessedIndex);
		}

		uint256 _lastProcessedIndex = lastProcessedIndex;

		uint256 gasUsed = 0;

		uint256 gasLeft = gasleft();

		uint256 iterations = 0;
		uint256 claims = 0;

		while(gasUsed < gas && iterations < numberOfTokenHolders) {
			_lastProcessedIndex++;

			if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
				_lastProcessedIndex = 0;
			}

			address account = tokenHoldersMap.keys[_lastProcessedIndex];

			if(canAutoClaim(lastClaimTimes[account])) {
				if(processAccount(account, true)) {
					claims++;
				}
			}

			iterations++;

			uint256 newGasLeft = gasleft();

			if(gasLeft > newGasLeft) {
				gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
			}

			gasLeft = newGasLeft;
		}

		lastProcessedIndex = _lastProcessedIndex;

		return (iterations, claims, lastProcessedIndex);
	}

	function processAccount(address account, bool automatic) public onlyOwner returns (bool) {
		uint256 amount = _withdrawDividendOfUser(account);

		if(amount > 0) {
			lastClaimTimes[account] = block.timestamp;
			emit Claim(account, amount, automatic);
			return true;
		}

		return false;
	}
	
	function withdrawStuckTokens(address _token, uint256 _amount) public onlyOwner {
		IERC20(_token).transfer(msg.sender, _amount);
	}
	
	function withdrawStuckBNB(address payable recipient) public onlyOwner {
		recipient.transfer(address(this).balance);
	}
	
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
}

interface IPancakePair {
	event Approval(address indexed owner, address indexed spender, uint value);
	event Transfer(address indexed from, address indexed to, uint value);

	function name() external pure returns (string memory);
	function symbol() external pure returns (string memory);
	function decimals() external pure returns (uint256);
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

interface IPancakeRouter01 {
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

interface IPancakeRouter02 is IPancakeRouter01 {
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

contract Token is ERC20, Ownable {
	using SafeMath for uint256;

	IPancakeRouter02 public pancakeRouter;
	address public pancakePair;
	address public usdt;

	MCMDividendTracker public dividendTracker;
    uint256 public tradingStratTime;

	address public marketingAddress = 0x6f65Ad02c9b375791a2B2bE4E0D1E84a418Af78d;
    address public receiveAddress = 0xe3EBD5f43F00A4d7B9c3002281660846E0592c24;
	
	uint256 public swapTokensAtAmount = 3* 10 ** decimals();
	uint256 public dividendFeeR = 30;  
    uint256 public marketingFee = 4;    


	// use by default 300,000 gas to process auto-claiming dividends
	uint256 public gasForProcessing = 300000;    
    address public lastTransferUser;

	/********* TX LIMITS *********/

	mapping (address => uint256) public accountLastPeriodSellVolume;
	uint256 public restrictionPeriod = 1 seconds;    
	struct Sell {
		uint256 time;
		uint256 amount;
	}
	mapping (address => Sell[]) public accountSells;

	/****************/


	bool public tradingEnabled = true;   
	event UpdateSwappingStatus(bool status);
	event UpdateTradingStatus(bool status);

	// exlcude from fees and max transaction amount
	mapping (address => bool) private _isExcludedFromFees;
	mapping (address => bool) private _isExcludedFromPeriodLimit;
	mapping (address => bool) private _isExcludedFromMaxTxLimit;

	// addresses that can make transfers before trading is enabled
	mapping (address => bool) private canTransferBeforeTradingIsEnabled;
	
	mapping (address => bool) public isBlackList;

	event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
	event UpdateWallets(address oldMarketing, address newMarketing);
	event UpdatePancakeRouter(address indexed newAddress, address indexed oldAddress);

	event ExcludeFromFees(address indexed account, bool isExcluded);
	event ExcludeFromPeriodLimit(address indexed account, bool isExcluded);
	event ExcludeFromMaxTxLimit(address indexed account, bool isExcluded);
	event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

	event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);

	event SetBuyFees(uint256 MarketingFee, uint256 DividendFee);

	event SetSellFees(uint256 SellMarketingFee, uint256 SellDividendFee);
	event SetRestrictionPeriod(uint256 OldPeriod, uint256 NewPeriod);
	event SetMaxTxAmount(uint256 OldPercent, uint256 NewPercent);


	// events for last sell
	event UpdateaAccountLastPeriodSellVolume(uint256 oldValue, uint256 newValue);
	event AddLastPeriodSellInfo(uint256 timestamp, uint256 amount);


	event CalculatedCakeForEachRecipient(uint256 forDividends);
	event ErrorInProcess(address msgSender);
	event SwapAndSendTo(
		uint256 amount,
		string to
	);

	event ProcessedDividendTracker(
		uint256 iterations,
		uint256 claims,
		uint256 lastProcessedIndex,
		bool indexed automatic,
		uint256 gas,
		address indexed processor
	);

	constructor() ERC20("MCM", "MCM") {
		dividendTracker = new MCMDividendTracker();
		// usdt = 0x51A6088FA137D19a2D5CCb21458Ce7E5cB5ecA8c;   // bsctestnet
		// updatePancakeRouter(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);  // bsctestnet
		usdt = 0x55d398326f99059fF775485246999027B3197955;   // bsctestnet
		updatePancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);  // bsctestnet

		
		// exclude from receiving dividends
		dividendTracker.excludeFromDividends(address(dividendTracker));
		dividendTracker.excludeFromDividends(address(this));
		dividendTracker.excludeFromDividends(address(0));
		dividendTracker.setMCM(address(this));
		
		
		excludeFromAllLimits(owner(), true);
		excludeFromAllLimits(address(this), true);
        excludeFromAllLimits(marketingAddress, true);
        excludeFromAllLimits(receiveAddress, true);

		
		canTransferBeforeTradingIsEnabled[owner()] = true;
		canTransferBeforeTradingIsEnabled[address(this)] = true;
		canTransferBeforeTradingIsEnabled[marketingAddress] = true;
		canTransferBeforeTradingIsEnabled[receiveAddress] = true;
		
		
	

		_mint(receiveAddress, 21000000 * (10**decimals()));
		
		
	}
	function updatePancakeRouter(address newAddress) public onlyOwner {
		require(newAddress != address(pancakeRouter), "MCM: The router already has that address");
		emit UpdatePancakeRouter(newAddress, address(pancakeRouter));
		pancakeRouter = IPancakeRouter02(newAddress);
		address _pancakePair = IPancakeFactory(pancakeRouter.factory())
		.createPair(address(this), address(usdt));
		pancakePair = _pancakePair;

		dividendTracker.excludeFromDividends(address(pancakeRouter));
		dividendTracker.excludeFromDividends(pancakePair);

		excludeFromAllLimits(newAddress, true);

		_isExcludedFromPeriodLimit[pancakePair] = true;

	}

	receive() external payable {
	}

	function excludeFromAllLimits(address account, bool status) public onlyOwner {
		_isExcludedFromFees[account] = status;
		_isExcludedFromMaxTxLimit[account] = status;
		_isExcludedFromPeriodLimit[account] = status;
	}
	function setCanTransferBeforeTradingIsEnabled(address account, bool status) external onlyOwner {
		canTransferBeforeTradingIsEnabled[account] = status;
	}

	function excludeFromAllLimits(address[] memory addrs, bool  status) public onlyOwner {
		for(uint256 i = 0;i < addrs.length;i++) {
			_isExcludedFromFees[addrs[i]] = status;
			_isExcludedFromMaxTxLimit[addrs[i]] = status;
			_isExcludedFromPeriodLimit[addrs[i]] = status;
		}
	}

	function setCanTransferBeforeTradingIsEnabled(address[] memory account, bool status) external onlyOwner {
		for(uint256 i = 0;i < account.length;i++) {
			canTransferBeforeTradingIsEnabled[account[i]] = status;
		}
	}

	function setRestrictionPeriod(uint256 _newPeriodSeconds)  external onlyOwner {
		emit SetRestrictionPeriod(restrictionPeriod, _newPeriodSeconds);
		restrictionPeriod = _newPeriodSeconds*1 seconds;
	}

	function getAccountPeriodSellVolume(address account) public returns(uint256) {
		uint256 offset;
		uint256 newVolume = accountLastPeriodSellVolume[account];

		for (uint256 i = 0; i < accountSells[account].length; i++) {
			if (block.timestamp.sub(accountSells[account][i].time) <= restrictionPeriod) {
				break;
			}
			if (newVolume > 0) {
				newVolume = newVolume.sub(accountSells[account][i].amount);
				offset++;
			}
		}

		if (offset > 0) {
			removeAccSells(account, offset);
		}

		if (accountLastPeriodSellVolume[account] != newVolume) {
			emit UpdateaAccountLastPeriodSellVolume(accountLastPeriodSellVolume[account], newVolume);
			accountLastPeriodSellVolume[account] = newVolume;
		}

		return newVolume;
	}

	function removeAccSells(address account, uint256 offset) private {
		for (uint256 i = 0; i < accountSells[account].length-offset; i++) {
			accountSells[account][i] = accountSells[account][i+offset];
		}
		for (uint256 i = 0; i < offset; i++) {
			accountSells[account].pop();
		}
	}

	function getAccountSells (address account, uint256 i) public view returns (uint256, uint256) {
		return (accountSells[account][i].time, accountSells[account][i].amount);
	}

	function setDividendFeeR(uint256 _dividendFeeR)  external onlyOwner {
		dividendFeeR = _dividendFeeR;
	}
    function setMarketingFee(uint256 _marketingFee)  external onlyOwner {
		marketingFee = _marketingFee;
	}
    function setMarketingFeeAndDevidendFeeR(uint256 _marketingFee, uint256 _dividendFeeR)  external onlyOwner {
		marketingFee = _marketingFee;
        dividendFeeR = _dividendFeeR;
	}

	
	function excludeFromDividends(address account) external onlyOwner {
		dividendTracker.excludeFromDividends(account);
	}

	function isExcludedFromDividends(address account) external view returns (bool){
		return dividendTracker.excludedFromDividends(account);
	}

	function updateDividendTracker(address newAddress) public onlyOwner {
		require(newAddress != address(dividendTracker), "MCM: The dividend tracker already has that address");

		MCMDividendTracker newDividendTracker = MCMDividendTracker(payable(newAddress));

		require(newDividendTracker.owner() == address(this), "MCM: The new dividend tracker must be owned by the MCM token contract");

		newDividendTracker.excludeFromDividends(address(newDividendTracker));
		newDividendTracker.excludeFromDividends(address(this));
		newDividendTracker.excludeFromDividends(address(pancakeRouter));

		emit UpdateDividendTracker(newAddress, address(dividendTracker));

		dividendTracker = newDividendTracker;
	}

	function excludeFromFees(address account, bool excluded) public onlyOwner {
		require(_isExcludedFromFees[account] != excluded, "MCM: Account is already the value of 'excluded'");
		_isExcludedFromFees[account] = excluded;

		emit ExcludeFromFees(account, excluded);
	}

	function excludeFromPeriodLimit(address account, bool excluded) public onlyOwner {
		require(_isExcludedFromPeriodLimit[account] != excluded, "MCM: Account is already the value of 'excluded'");
		_isExcludedFromPeriodLimit[account] = excluded;

		emit ExcludeFromPeriodLimit(account, excluded);
	}

	function excludeFromMaxTxLimit(address account, bool excluded) public onlyOwner {
		require(_isExcludedFromMaxTxLimit[account] != excluded, "MCM: Account is already the value of 'excluded'");
		_isExcludedFromMaxTxLimit[account] = excluded;

		emit ExcludeFromMaxTxLimit(account, excluded);
	}

	function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
		for(uint256 i = 0; i < accounts.length; i++) {
			_isExcludedFromFees[accounts[i]] = excluded;
		}

		emit ExcludeMultipleAccountsFromFees(accounts, excluded);
	}

	function updateGasForProcessing(uint256 newValue) public onlyOwner {
		require(newValue >= 200000 && newValue <= 500000, "MCM: gasForProcessing must be between 200,000 and 500,000");
		require(newValue != gasForProcessing, "MCM: Cannot update gasForProcessing to same value");
		emit GasForProcessingUpdated(newValue, gasForProcessing);
		gasForProcessing = newValue;
	}

	function updateClaimWait(uint256 claimWait) external onlyOwner {
		dividendTracker.updateClaimWait(claimWait);
	}

	function updateMinimumTokenBalanceForDividends(uint256 newTokenBalance) external onlyOwner {
		dividendTracker.updateMinimumTokenBalanceForDividends(newTokenBalance);
	}

	function getClaimWait() external view returns(uint256) {
		return dividendTracker.claimWait();
	}

	function getTotalDividendsDistributed() external view returns (uint256) {
		return dividendTracker.totalDividendsDistributed();
	}

	function isExcludedFromFees(address account) public view returns(bool) {
		return _isExcludedFromFees[account];
	}

	function isExcludedFromMaxTxLimit(address account) public view returns(bool) {
		return _isExcludedFromMaxTxLimit[account];
	}

	function isExcludedFromPeriodLimit(address account) public view returns(bool) {
		return _isExcludedFromPeriodLimit[account];
	}

	function withdrawableDividendOf(address account) public view returns(uint256) {
		return dividendTracker.withdrawableDividendOf(account);
	}

	function dividendTokenBalanceOf(address account) public view returns (uint256) {
		return dividendTracker.balanceOf(account);
	}

	function getAccountDividendsInfo(address account)
	external view returns (
		address,
		int256,
		int256,
		uint256,
		uint256,
		uint256,
		uint256,
		uint256) {
		return dividendTracker.getAccount(account);
	}

	function getAccountDividendsInfoAtIndex(uint256 index)
	external view returns (
		address,
		int256,
		int256,
		uint256,
		uint256,
		uint256,
		uint256,
		uint256) {
		return dividendTracker.getAccountAtIndex(index);
	}

	function processDividendTracker(uint256 gas) external {
		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
	}

	function claim() external {
		dividendTracker.processAccount(payable(msg.sender), false);
	}

	function getLastProcessedIndex() external view returns(uint256) {
		return dividendTracker.getLastProcessedIndex();
	}

	function getNumberOfDividendTokenHolders() external view returns(uint256) {
		return dividendTracker.getNumberOfTokenHolders();
	}


	// function setTradingIsEnabled(bool status) external onlyOwner {
    //     if(status == true) {
    //         if (marketingFee >= 18){
    //             tradingStratTime = block.timestamp;
    //             marketingFee = 18;
    //             dividendFee = 2;
    //         }
    //     }
	// 	tradingEnabled = status;
	// 	emit UpdateTradingStatus(status);
	// }
	
	function setBlackList(address _addr,bool _status)public onlyOwner{
		isBlackList[_addr] = _status;
	}
	
	function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
		swapTokensAtAmount = amount;
	}
	
  
	function _transfer(
		address from,
		address to,
		uint256 amount
	) internal override {
		require(from != address(0), "ERC20: transfer from the zero address");
		require(to != address(0), "ERC20: transfer to the zero address");
		require(!isBlackList[from],"ERC20: transfer from the BlackList");

		// if (!_isExcludedFromPeriodLimit[from]) {
		// 	accountLastPeriodSellVolume[from] = accountLastPeriodSellVolume[from].add(amount);
		// 	Sell memory sell;
		// 	sell.amount = amount;
		// 	sell.time = block.timestamp;
		// 	accountSells[from].push(sell);
		// 	emit AddLastPeriodSellInfo(sell.time, sell.amount);
		// }

		// if(!tradingEnabled) {
			
		// 	if(from == pancakePair){
		// 		require(canTransferBeforeTradingIsEnabled[to], "This account cannot receive tokens before enabling transactions");
		// 	}else if(to == pancakePair){
		// 		require(canTransferBeforeTradingIsEnabled[from], "This account cannot send tokens until trading is enabled");
		// 	}else{
		// 		require(canTransferBeforeTradingIsEnabled[from], "This account cannot send tokens until trading is enabled");
		// 	}
		// }

		if(amount == 0) {
			super._transfer(from, to, 0);
			return;
		}
    


		bool takeFee = true;

		if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
			takeFee = false;
		}
		
		if(takeFee) {
			uint256 fees ;		
			if (from == pancakePair) {
			// buy
                fees = amount.mul(marketingFee).div(100);
				uint256 forDividends = fees.mul(dividendFeeR).div(100);
				super._transfer(from, address(dividendTracker), forDividends);
       			dividendTracker.distributeDividends_MCM(forDividends);
			 	emit SwapAndSendTo(forDividends, "DIVIDENDS");
                uint256 forMarketing = fees.sub(forDividends);
                super._transfer(from, address(marketingAddress), forMarketing);
				fees = forDividends.add(forMarketing);
				
			} else if (to == pancakePair) {
			// sell
				fees = amount.mul(marketingFee).div(100);
				uint256 forDividends = fees.mul(dividendFeeR).div(100);
				super._transfer(from, address(dividendTracker), forDividends);
       			dividendTracker.distributeDividends_MCM(forDividends);
			 	emit SwapAndSendTo(forDividends, "DIVIDENDS");
                uint256 forMarketing = fees.sub(forDividends);
                super._transfer(from, address(marketingAddress), forMarketing);
				fees = forDividends.add(forMarketing);
			}else{
			// send
			}
			
			amount = amount.sub(fees);
			
		}


		super._transfer(from, to, amount);

		
    uint256 userLp = IERC20(pancakePair).balanceOf(lastTransferUser);
		if(userLp != dividendTracker.balanceOf(lastTransferUser)){
			try dividendTracker.setBalance(lastTransferUser,  userLp ) {} catch {}
		}
    
        
		
		if (to == pancakePair) {
			
			lastTransferUser = from;	
								
		} else if(from == pancakePair) {
			
			lastTransferUser = to;	
		}
		
		if(balanceOf(address(dividendTracker)) >= swapTokensAtAmount){

				uint256 gas = gasForProcessing;

			try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
			emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
			}
			catch {
			emit ErrorInProcess(msg.sender);
			}
	}

		
        
	}

	
	function dividendTrackerSetBalance(address user)public{
	
		uint256 userLp = IERC20(pancakePair).balanceOf(user);
		try dividendTracker.setBalance(user,  userLp ) {} catch {}
	}
	
	function withdrawStuckTokens(address _token, uint256 _amount) public onlyOwner {
		IERC20(_token).transfer(msg.sender, _amount);
	}
	
	function TwithdrawStuckTokens(address _token , uint256 _amount) public onlyOwner{
		dividendTracker.withdrawStuckTokens(_token,_amount);
	}
	
	function withdrawStuckBNB(address payable recipient) public onlyOwner {
		recipient.transfer(address(this).balance);
	}
	
	function TwithdrawStuckBNB(address payable recipient) public onlyOwner {
		 dividendTracker.withdrawStuckBNB(recipient);
	}
	 

	
	function safeTransfer(
		address token,
		address to,
		uint256 value
	) internal returns(bool){
		// bytes4(keccak256(bytes('transfer(address,uint256)')));
		(bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

		if(success && (data.length == 0 || abi.decode(data, (bool)))){
			return true;
		}
		return false;
	}

	
}