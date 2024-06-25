/**
 *Submitted for verification at BscScan.com on 2023-01-16
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Sources flattened with hardhat v2.12.2 https://hardhat.org

// File common/IMFLocks.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;

interface IMFLocks {
    function addLock(
        address _investor,
        uint256 _amount,
        uint256 _dateStart,
        uint256 _duration
    ) external;

    function withdraw() external;
}


// File common/IDAOInvestors.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;

interface IDAOInvestors {
    function vestingDeposit(
        uint256 amount,
        address investor,
        uint256 vestingDuration,
        uint256 vestingStartDate
    ) external;
}


// File @openzeppelin/contracts/token/ERC20/[email protected]

// License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

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


// File common/IMFToken.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;
interface IMFToken is IERC20 {
    function mint(address to, uint256 amount) external;
}


// File common/IMFSwap.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;

interface IMFSwap {
    function swap(uint256 _amount, address _investor) external;
}


// File common/BaseDAO.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;
abstract contract BaseDAO {
    uint256 constant precision = 10 ** 4;

    function getProgress(
        uint256 _startDate,
        uint256 _duration
    ) public view returns (uint256) {
        if (_startDate > block.timestamp) return 0;

        uint256 dateDiff = block.timestamp - _startDate;
        if (dateDiff > _duration) {
            return precision;
        }

        uint256 progress = (dateDiff * precision) / _duration;
        return progress;
    }
}


// File @openzeppelin/contracts/utils/[email protected]

// License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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


// File @openzeppelin/contracts/access/[email protected]

// License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

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


// File common/BaseDAOContract.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;
abstract contract BaseDAOContract is BaseDAO, Ownable {}


// File contracts/MFSwap.sol

// License-Identifier: MIT
pragma solidity ^0.8.17;
contract MFSwap is BaseDAOContract {
    uint256 public vestingDuration;
    uint256 public vesingStartDate;
    uint256 public constant CBTDecimals = 10**14;

    IMFToken public immutable mf;
    IERC20 public immutable cbt;
    IMFLocks public mfLocks;
    IDAOInvestors public investorsDAO;

    constructor(
        address _mf,
        address _cbt,
        address _investorsDAO,
        uint256 _vestingDuration,
        uint256 _vesingStartDate
    ) {
        mf = IMFToken(_mf);
        cbt = IERC20(_cbt);
        investorsDAO = IDAOInvestors(_investorsDAO);
        vestingDuration = _vestingDuration;
        vesingStartDate = _vesingStartDate;
    }

    function swap(uint256 _amount, address _investor) public {
        cbt.transferFrom(msg.sender, address(0x000001), _amount);

        uint256 MfAmount = _amount * CBTDecimals;

        mf.mint(address(this), MfAmount);
        mf.approve(address(investorsDAO), MfAmount);

        investorsDAO.vestingDeposit(
            MfAmount,
            _investor,
            vestingDuration,
            vesingStartDate
        );
    }

    function swapWithoutInvest(
        uint256 _amount,
        address _to,
        uint256 _dateStart,
        uint256 _duration
    ) external onlyOwner {
        uint256 MfAmount = _amount * CBTDecimals;

        cbt.transferFrom(msg.sender, address(0x000001), _amount);
        mf.mint(address(mfLocks), MfAmount);
        mfLocks.addLock(_to, MfAmount, _dateStart, _duration);
    }

    function setVestingDuration(uint256 _duration) external onlyOwner {
        vestingDuration = _duration;
    }

    function setVestingStartDate(uint256 _dateStart) external onlyOwner {
        vesingStartDate = _dateStart;
    }

    function setInvestorsDAO(address _investorsDAO) external onlyOwner {
        investorsDAO = IDAOInvestors(_investorsDAO);
    }

    function setMFLocks(address _mfLocks) external onlyOwner {
        mfLocks = IMFLocks(_mfLocks);
    }
}