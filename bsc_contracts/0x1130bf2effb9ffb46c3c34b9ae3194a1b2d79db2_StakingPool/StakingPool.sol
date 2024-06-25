/**
 *Submitted for verification at BscScan.com on 2022-12-21
*/

// File: @openzeppelin/contracts/utils/Context.sol


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

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/staking.sol


pragma solidity ^0.8.15;





interface IPEXONFTService {
    function saleNFT(address _buyer, uint256 seedType, bool genZero, uint256 quantity) external returns (uint256[] memory);
}

contract StakingPool is ReentrancyGuard, Ownable, Pausable {
    address public NFT_SERVICE_CONTRACT = 0x28edEe099dED2bb925586fEfdcEB4264CDCB2e70;
    address public PEXO_TOKEN = 0x76b5ea2A75E96f629d739537e152062B4B89eeE9;
    uint256 public TOTAL_SALE_1 = 2000;
    uint256 public TOTAL_SALE_2 = 2000;
    uint256 public TOTAL_SALE_3 = 2000;
    uint256 public STARTED_AT;
    uint256 public FINISHED_AT;
    address public PAYMENT_TOKEN = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address public TOP_UP_ADDRESS = 0x23580022C0b2dDcb900466c05A3b87bAF166FCd5;

    uint256 public TOTAL_AMOUNT; // sold nft: total money
    uint256 public TOTAL_NFT_SOLD;

    uint256 public REMAIN_1 = TOTAL_SALE_1;
    uint256 public REMAIN_2 = TOTAL_SALE_2;
    uint256 public REMAIN_3 = TOTAL_SALE_3;

    uint256 public TOTAL_STAKED_AMOUNT = 0;
    uint256 public LOCK_DURATION = 30 * 60; // 30 minutes

    struct UserInfo {
        uint256 amount; // How many staked tokens the user has provided
        uint256 totalSeedBought;
        uint256 lastStakedAt;
    }

    mapping(address => UserInfo) public userInfo;
    mapping(address => bool) private _admins;

    event AdminsChanged(address indexed account, bool allowance);
    event MarketSeedSale(uint256 indexed totalPaid, uint256 indexed quantity, address indexed buyer);
    event Deposit(address indexed user, uint256 indexed amount);
    event ClaimStakedToken(address indexed user, uint256 indexed amount);

    modifier onlyAdmins() {
        require(_admins[_msgSender()], "Caller must be the admin.");
        _;
    }

    constructor() {
        _admins[_msgSender()] = true;
    }

    function initialize(
        address _stakedToken,
        uint256 _startedAt,
        uint256 _finishedAt,
        uint256 _lockDuration,
        address _nftServiceContract,
        uint256 _totalSale1,
        uint256 _totalSale2,
        uint256 _totalSale3,
        address _paymentToken,
        address _topUpAddress,
        address _admin
    ) external onlyOwner {
        PEXO_TOKEN = _stakedToken;
        STARTED_AT = _startedAt;
        FINISHED_AT = _finishedAt;
        LOCK_DURATION = _lockDuration;
        NFT_SERVICE_CONTRACT = _nftServiceContract;
        TOTAL_SALE_1 = _totalSale1;
        TOTAL_SALE_2 = _totalSale2;
        TOTAL_SALE_3 = _totalSale3;
        PAYMENT_TOKEN = _paymentToken;
        TOP_UP_ADDRESS = _topUpAddress;
        // Transfer ownership to the admin address who becomes owner of the contract
        transferOwnership(_admin);
    }

    function setSaleTime(uint256 _startedAt, uint256 _finishedAt) external onlyAdmins {
        STARTED_AT = _startedAt;
        FINISHED_AT = _finishedAt;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setAdmin(address account, bool allowance) external onlyOwner {
        _admins[account] = allowance;
        emit AdminsChanged(account, allowance);
    }

    function isAdmin(address account) external view returns (bool) {
        return (_admins[account]);
    }

    function getRemaining() external view returns (uint256, uint256, uint256) {
        return (REMAIN_1, REMAIN_2, REMAIN_3);
    }

    function deposit(uint256 _amount) external payable nonReentrant whenNotPaused {
        if (STARTED_AT > 0) {
            require(block.timestamp >= STARTED_AT, "Can not stake at this time");
        }

        if (FINISHED_AT > 0) {
            require(block.timestamp <= FINISHED_AT, "Can not stake at this time");
        }

        require(
            IERC20(PEXO_TOKEN).transferFrom(payable(_msgSender()), TOP_UP_ADDRESS, _amount),
            "Staked token transfer error."
        );

        UserInfo storage user = userInfo[_msgSender()];

        user.amount = user.amount + _amount;
        user.lastStakedAt = block.timestamp;

        TOTAL_STAKED_AMOUNT = TOTAL_STAKED_AMOUNT + _amount;
        emit Deposit(_msgSender(), _amount);
    }

    function withdraw() external nonReentrant whenNotPaused {
        UserInfo storage user = userInfo[_msgSender()];
        require(user.amount > 0, "Amount to withdraw too low");
        require(block.timestamp >= user.lastStakedAt + LOCK_DURATION, "Can not withdraw at this time");

        uint256 amountToTransfer = user.amount;
        user.amount = 0;

        require(
            IERC20(PEXO_TOKEN).transfer(_msgSender(), amountToTransfer),
            "Transfer staked token to address error"
        );

        emit ClaimStakedToken(_msgSender(), amountToTransfer);
    }

    function createMarketSale(
        uint256 q1,
        uint256 q2,
        uint256 q3
    ) external payable nonReentrant whenNotPaused {
        if (STARTED_AT > 0) {
            require(block.timestamp >= STARTED_AT, "This event will occur soon");
        }

        if (FINISHED_AT > 0) {
            require(block.timestamp <= FINISHED_AT, "This event ended");
        }

        uint256 quantity = q1 + q2 + q3;
        require(quantity == 1 || quantity == 3 || quantity == 5, "Invalid package");
        require(quantity <= REMAIN_1 + REMAIN_2 + REMAIN_3, "Not enough seed to sale");

        UserInfo storage user = userInfo[_msgSender()];
        require(user.totalSeedBought + quantity <= 6, "Can not buy more nft");
        require(user.amount >= 5000 * 10 ** 18, "Stake more pexo to buy nft");

        user.totalSeedBought = user.totalSeedBought + quantity;

        uint256 price;
        if (quantity == 1) {
            price = 1 * 10 ** 18;
        } else if (quantity == 3) {
            price = 3 * 10 ** 18;
        } else {
            price = 5 * 10 ** 18;
        }

        uint256 totalPaid = quantity * price;

        require(
            IERC20(PAYMENT_TOKEN).transferFrom(payable(_msgSender()), TOP_UP_ADDRESS, totalPaid),
            "Payment token transfer error."
        );

        uint256 adjustQ1;
        uint256 adjustQ2;
        uint256 adjustQ3;
        uint256 noneAllocation;

        if (q1 <= REMAIN_1) {
            adjustQ1 = q1;
        } else {
            adjustQ1 = REMAIN_1;
            noneAllocation = noneAllocation + (q1 - REMAIN_1);
        }

        if (q2 <= REMAIN_2) {
            adjustQ2 = q2;
        } else {
            adjustQ2 = REMAIN_2;
            noneAllocation = noneAllocation + (q2 - REMAIN_2);
        }

        if (q3 <= REMAIN_3) {
            adjustQ3 = q3;
        } else {
            adjustQ3 = REMAIN_3;
            noneAllocation = noneAllocation + (q3 - REMAIN_3);
        }

        REMAIN_1 = REMAIN_1 - adjustQ1;
        REMAIN_2 = REMAIN_2 - adjustQ2;
        REMAIN_3 = REMAIN_3 - adjustQ3;

        uint256 i;
        for (i = 0; i < noneAllocation; i++) {
            if (REMAIN_1 >= 1) {
                adjustQ1 = adjustQ1 + 1;
                REMAIN_1 = REMAIN_1 - 1;
            } else if (REMAIN_2 >= 1) {
                adjustQ2 = adjustQ2 + 1;
                REMAIN_2 = REMAIN_2 - 1;
            } else if (REMAIN_3 > 1) {
                adjustQ3 = adjustQ3 + 1;
                REMAIN_3 = REMAIN_3 - 1;
            }
        }

        if (adjustQ1 > 0) {
            IPEXONFTService(NFT_SERVICE_CONTRACT).saleNFT(_msgSender(), 1, true, adjustQ1);
        }

        if (adjustQ2 > 0){
            IPEXONFTService(NFT_SERVICE_CONTRACT).saleNFT(_msgSender(), 2, true, adjustQ2);
        }

        if (adjustQ3 > 0) {
            IPEXONFTService(NFT_SERVICE_CONTRACT).saleNFT(_msgSender(), 3, true, adjustQ3);
        }

        TOTAL_NFT_SOLD = TOTAL_NFT_SOLD + quantity;

        emit MarketSeedSale(totalPaid, quantity, _msgSender());
    }

    function unClaimedReward(address _user) public view returns (uint256) {
        return 0;
    }

    function limitStaked() external view returns (uint256) {
        return 5000 * 6000 * 10 ** 18;
    }

    function transferAnyBEP20Token(address _tokenAddress, uint256 _amount) external onlyAdmins {
        IERC20(_tokenAddress).transfer(owner(), _amount);
    }
}