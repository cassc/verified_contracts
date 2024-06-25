/**
 *Submitted for verification at BscScan.com on 2022-11-16
*/

// Sources flattened with hardhat v2.12.2 https://hardhat.org

// File contracts/Addons/Context.sol

pragma solidity ^0.8.17;

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

// File contracts/Addons/Ownable.sol

pragma solidity ^0.8.17;

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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
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

// File contracts/Addons/MaxTxLimit.sol

pragma solidity ^0.8.17;

error AddressNotFound(address);

contract MaxTxLimit is Ownable {
    uint private _maxTxLimit;

    mapping(address => bool) internal _isExcludedFromMxTxLimit;

    /// @dev See {MaxTxAmount}

    function maxTxLimit() public view returns (uint) {
        return _maxTxLimit;
    }

    /**
     * @dev set {MaxTxLimit}
     *
     * Requirements:
     *
     *
     * - Only Owner can set or reset the txlimit
     *
     */

    function setMaxTxLimit(uint _limit) public virtual onlyOwner {
        _maxTxLimit = _limit;
    }

    /**
     * @dev Exclude {MaxtxLimit} on address
     *
     * Requirements:
     *
     * - Address cannot be zero
     * - Only Owner can set or reset the txlimit
     *
     */

    function ExcludeFromMaxTxLimit(address _address) public virtual onlyOwner {
        require(_address != address(0), "ERROR: Address cannot be zero");
        _isExcludedFromMxTxLimit[_address] = true;
    }

    /**
     * @dev Remove {MaxtxLimit} on address
     *
     * Requirements:
     *
     * - address cannot be zero
     * - Only Owner can set or reset the tx limit
     *
     */

    function IncludeInMaxTxLimit(address _address) public virtual onlyOwner {
        require(_address != address(0), "ERROR: Address cannot be zero");
        if (_isExcludedFromMxTxLimit[_address] == true) {
            _isExcludedFromMxTxLimit[_address] = false;
        } else {
            revert AddressNotFound(_address);
        }
    }
}

// File contracts/Addons/Pausable.sol

pragma solidity ^0.8.17;

contract Pausable is Ownable {
    bool private pause;

    constructor() {
        pause = false;
    }

    function isPaused() public view returns (bool) {
        return pause;
    }

    function setPaused(bool status_) public onlyOwner returns (bool) {
        pause = status_;
        return true;
    }
}

// File contracts/Addons/SafeMath.sol

pragma solidity ^0.8.17;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
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

// File: gist-71572af562f01852a1e328dba89471fe/skippy/Context.sol

// OpenZeppelin Contracts v4.3.2 (utils/Context.sol)

// File contracts/Addons/TaxOptions.sol

pragma solidity ^0.8.17;

error addressNotFound(address);

contract TaxOptions is Ownable {
    using SafeMath for uint256;
    uint256 public _burnTax = 20;
    uint256 public _TeamTax = 20;
    uint256 public _liquidityTax = 20;
    uint256 public _rAndDTax = 20;
    uint256 public _marketingTax = 20;

    address internal rAndDAddress;
    address internal MarketingAddress;
    address internal TeamAddress;

    struct Tvalues {
        uint tTransferAmount;
        uint burnTax;
        uint TeamTax;
        uint liquidityTax;
        uint rAndDTax;
        uint marketingTax;
    }

    mapping(address => bool) public isExcludeFromTax;

    /// @dev `Exclude` address from the tax

    function excludeFromTax(address address_) public onlyOwner {
        require(address_ != address(0), "ERROR: Address cannot be zero");
        isExcludeFromTax[address_] = true;
    }

    /// @dev if an address is excluded from the tax, owner can use this function to include.

    function includeInTax(address address_) public onlyOwner {
        require(address_ != address(0), "ERROR: Address cannot be zero");
        if (isExcludeFromTax[address_] == true) {
            isExcludeFromTax[address_] = false;
        } else {
            revert addressNotFound(address_);
        }
    }

    /// @dev `set` {Burn} tax using this function

    function setBurnTax(uint value) public onlyOwner {
        _burnTax = value;
    }

    /// @dev `set` {Burn} tax using this function

    function setTeamTax(uint value) public onlyOwner {
        _TeamTax = value;
    }

    /// @dev `set {Liquidity} tax

    function setLiquidtyTax(uint value) public onlyOwner {
        _liquidityTax = value;
    }

    /// @dev `set` {_rAndDTax} tax

    function setrAndDTax(uint value) public onlyOwner {
        _rAndDTax = value;
    }

    /// @dev `set` {_marketingTax} tax

    function setMarketingTax(uint value) public onlyOwner {
        _marketingTax = value;
    }

    // @dev `get` {amount} with taxes and remaining amounts.

    function _getTValues(uint256 tAmount)
        private
        view
        returns (Tvalues memory)
    {
        Tvalues memory tValues;
        tValues.burnTax = tAmount.mul(_burnTax).div(10**3);
        tValues.TeamTax = tAmount.mul(_TeamTax).div(10**3);
        tValues.liquidityTax = tAmount.mul(_liquidityTax).div(10**3);
        tValues.rAndDTax = tAmount.mul(_rAndDTax).div(10**3);
        tValues.marketingTax = tAmount.mul(_marketingTax).div(10**3);
        tValues.tTransferAmount = tAmount
            .sub(tValues.burnTax)
            .sub(tValues.TeamTax)
            .sub(tValues.liquidityTax)
            .sub(tValues.rAndDTax)
            .sub(tValues.marketingTax);
        return tValues;
    }

    /// @dev `internal` function to inherit the function to core contract

    function _getValues(uint256 tAmount)
        internal
        view
        returns (Tvalues memory)
    {
        Tvalues memory tValues = _getTValues(tAmount);
        return tValues;
    }

    /// @dev `Set` teamTax account address

    function setTeamAddress(address address_) public onlyOwner {
        require(address_ != address(0), "Address cannnot be zero");
        TeamAddress = address_;
    }

    /// @dev `Set` Marketingaddress account address

    function setMarketingAddress(address address_) public onlyOwner {
        require(address_ != address(0), "Address cannnot be zero");
        MarketingAddress = address_;
    }

    /// @dev `Set` RandD account address

    function setRAndD(address address_) public onlyOwner {
        require(address_ != address(0), "Address cannnot be zero");
        rAndDAddress = address_;
    }
}

// File contracts/interfaces/IBEP165.sol

pragma solidity ^0.8.17;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IBEP165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File contracts/interfaces/IBEP721.sol

pragma solidity ^0.8.17;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IBEP721 is IBEP165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

// File contracts/interfaces/IUniswapV2Factory.sol

pragma solidity ^0.8.17;

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

// File contracts/Addons/Whitelisting.sol

pragma solidity ^0.8.17;

contract WhiteListing is Ownable {
    /// @dev NFT contract address we are checking
    address private NFTAddress;

    /// @dev mapping to exclude the address from whitelisting
    mapping(address => bool) internal _ExcludeFromWhiteListing;

    /// @dev `see` {NFT Contract address}
    function NftAddress() public view returns (address) {
        return NFTAddress;
    }

    /// @dev `set` {NFT Contract address}
    /// @dev requirements: - address cannot be zero and onlyOwner can set the address

    function setNftAddress(address address_)
        public
        onlyOwner
        returns (address)
    {
        require(address_ != address(0), "ERROR: Address cannot be zero");
        NFTAddress = address_;
        return NftAddress();
    }

    /**
     * @dev `Exclude` address from {White listing}
     *
     * requirements -
     * - Address cannot be zero
     * - Only Owner can excute this function
     */

    function ExcludeFromWhitelisting(address _address) public onlyOwner {
        require(_address != address(0), "Address cannot be zero");
        _ExcludeFromWhiteListing[_address] = true;
    }

    /**
     * @dev `Include` address In {White listing} in case an address is excluded.
     *
     * requirements -
     * - Address cannot be zero
     * - Only Owner can excute this function
     */

    function IncludeInWhitelisting(address _address) public onlyOwner {
        require(_address != address(0), "Address cannot be zero");
        _ExcludeFromWhiteListing[_address] = false;
    }

    /// @dev `check` whether the address is whitelisted or not

    function isWhiteListed(address address_) public view returns (bool) {
        uint holdings = IBEP721(NFTAddress).balanceOf(address_);
        if (holdings > 0 || _ExcludeFromWhiteListing[address_]) {
            return true;
        } else {
            return false;
        }
    }
}

// File contracts/interfaces/IBEP20.sol

pragma solidity ^0.8.17;

/**
 * @dev Interface of the BEP20 standard as defined in the EIP.
 */
interface IBEP20 {
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

// File contracts/CoreToken.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Token is
    Context,
    IBEP20,
    Ownable,
    MaxTxLimit,
    TaxOptions,
    WhiteListing,
    Pausable
{
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;

    string private _symbol;

    uint8 private _decimals = 18;

    // MainNet BUSD: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56

    address public BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    address public immutable uniswapV2Pair;

    address public Factory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;

    address public Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */

    /// @dev Whitelists the address

    modifier Whitelist(address address_) {
        bool result = isWhiteListed(address_);
        require(result == true, "The address is not whitelisted");
        _;
    }

    /**
     * @dev Returns the name of the token.
     */

    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {BEP20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IBEP20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IBEP20-balanceOf}.
     */
    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    /**
     * @dev See {IBEP20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IBEP20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20}.
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
     * problems described in {IBEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
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
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "BEP20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
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
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual Whitelist(_msgSender()) {
        require(isPaused() == false, "Revert: The transactions are paused");
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount should be greater than zero");
        require(balanceOf(from) >= amount, "Insufficient token balance");

        if (from == address(uniswapV2Pair)) {
            require(isWhiteListed(to) == true, "ERROR: Not Whitelisted");
        }

        //Total transcation amount should be less than the maximum transcation limit
        if (!_isExcludedFromMxTxLimit[from]) {
            require(
                amount <= maxTxLimit(),
                "Amount exceeds maximum transcation limit!"
            );
        }

        bool takeFee = true;

        if (isExcludeFromTax[from] || isExcludeFromTax[to]) {
            takeFee = false;
        }

        if (!takeFee) {
            _beforeTokenTransfer(from, to, amount);
            unchecked {
                _balances[from] -= amount;
                // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
                // decrementing then incrementing.
                _balances[to] += amount;
            }
            _afterTokenTransfer(from, to, amount);
            emit Transfer(from, to, amount);
        } else {
            _distribution(from, to, amount);
        }
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
        require(account != address(0), "BEP20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     *
     * Only owner can call this function.
     *
     * Visibility: Public function so the compiler can reproduce the getter function.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - Should be the owner of the cotract
     */

    function Mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(_msgSender(), amount);
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

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "BEP20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Calls _burn function internally.
     *
     *Visibility: Public function so the compiler can reproduce the getter function.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     * - Should be the owner of the contract
     */

    function Burn(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        emit Transfer(_msgSender(), address(0), amount);
        return true;
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
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

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
            require(
                currentAllowance >= amount,
                "BEP20: insufficient allowance"
            );
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

    /// @dev A private function that does transfer with or without taxes

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        _distribution(sender, recipient, amount);
    }

    /// @dev sends liquidity to the address(this)

    function _takeLiquidity(address sender, uint256 tLiquidity) private {
        if (tLiquidity != 0) {
            _balances[sender] = _balances[sender].sub(tLiquidity);
            _balances[address(this)] = _balances[address(this)].add(tLiquidity);
            emit Transfer(sender, address(this), tLiquidity);
        }
    }

    /// @dev transfers the tax to respective account address

    function _rAndDTransfer(address sender, uint256 tRandD) internal {
        if (tRandD != 0) {
            _balances[sender] = _balances[sender].sub(tRandD);
            _balances[rAndDAddress] = _balances[rAndDAddress].add(tRandD);
            emit Transfer(sender, rAndDAddress, tRandD);
        }
    }

    /// @dev transfers the tax to respective account address

    function _marketingTransfer(address sender, uint256 tMarketing) internal {
        if (tMarketing != 0) {
            _balances[sender] = _balances[sender].sub(tMarketing);
            _balances[MarketingAddress] = _balances[MarketingAddress].add(
                tMarketing
            );
            emit Transfer(sender, MarketingAddress, tMarketing);
        }
    }

    /// @dev transfers the tax to respective account address

    function _teamTransfer(address sender, uint256 TeamTax) internal {
        if (TeamTax != 0) {
            _balances[sender] = _balances[sender].sub(TeamTax);
            _balances[TeamAddress] = _balances[TeamAddress].add(TeamTax);
            emit Transfer(sender, TeamAddress, TeamTax);
        }
    }

    /// @dev distributes the taxes and transfers the amount

    function _distribution(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        Tvalues memory tValues = _getValues(tAmount);
        _beforeTokenTransfer(sender, recipient, tValues.tTransferAmount);
        _balances[sender] = _balances[sender].sub(tValues.tTransferAmount);
        _balances[recipient] = _balances[recipient].add(
            tValues.tTransferAmount
        );
        _burn(sender, tValues.burnTax);
        _takeLiquidity(sender, tValues.liquidityTax);
        _marketingTransfer(sender, tValues.marketingTax);
        _rAndDTransfer(sender, tValues.rAndDTax);
        _teamTransfer(sender, tValues.TeamTax);
        _afterTokenTransfer(sender, recipient, tValues.tTransferAmount);
        emit Transfer(sender, recipient, tValues.tTransferAmount);
    }

    constructor(
        string memory name_,
        string memory symbol_,
        uint _amount,
        address rAndDAddress_,
        address MarketingAddress_,
        address TeamAddress_,
        address NftAddress_
    ) {
        uniswapV2Pair = IUniswapV2Factory(address(Factory)).createPair(
            address(this),
            BUSD
        );
        _name = name_;
        _symbol = symbol_;
        rAndDAddress = rAndDAddress_;
        MarketingAddress = MarketingAddress_;
        TeamAddress = TeamAddress_;
        uint supply = _amount.mul(10**18);
        _mint(owner(), supply);
        ExcludeFromMaxTxLimit(owner());
        ExcludeFromMaxTxLimit(address(this));
        setMaxTxLimit(_totalSupply.div(500));
        excludeFromTax(owner());
        excludeFromTax(address(this));
        excludeFromTax(rAndDAddress);
        excludeFromTax(MarketingAddress);
        excludeFromTax(TeamAddress);
        ExcludeFromWhitelisting(owner());
        ExcludeFromWhitelisting(address(this));
        ExcludeFromWhitelisting(address(rAndDAddress));
        ExcludeFromWhitelisting(address(MarketingAddress));
        ExcludeFromWhitelisting(address(TeamAddress));
        ExcludeFromWhitelisting(address(uniswapV2Pair));
        ExcludeFromWhitelisting(address(Router));
        setNftAddress(NftAddress_);
    }
}