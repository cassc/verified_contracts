/**
 *Submitted for verification at BscScan.com on 2022-10-31
*/

/**
 *Submitted for verification at Etherscan.io on 2022-07-10
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

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
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    mapping(address => bool) public addressAdmin;

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
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    function addAdmin(address _address) external onlyOwner {
        addressAdmin[_address] = true;
    }

    function removeAdmin(address _address) external onlyOwner {
        addressAdmin[_address] = false;
    }

    modifier admin() {
        require(addressAdmin[msg.sender] == true, "You are not an admin");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(
            owner() == _msgSender() || addressAdmin[msg.sender] == true,
            "Ownable: caller is not the owner"
        );
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
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
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
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
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
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
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
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
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
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

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

abstract contract Manager is Ownable {
    using SafeERC20 for IERC20;
    IHouse house;
    IVRFManager VRFManager;

    uint256 public constant MODULO = 6;

    // Variables
    bool public gameIsLive;
    uint256 public minBetAmount = 1 ether;
    uint256 public maxBetAmount = 300 ether;
    address public VRFManagerAddress;

    struct Bet {
        uint8 rollUnder;
        uint40 choice;
        uint40 outcome;
        uint168 placeBlockNumber;
        uint128 amount;
        uint128 winAmount;
        address player;
        bool isSettled;
    }

    Bet[] public bets;
    mapping(uint256 => uint256[]) public betMap;
    mapping(address => uint256[]) public userBetMap;
    uint256[] public validBetAmount;

    modifier isVRFManager() {
        require(VRFManagerAddress == msg.sender, "You are not allowed");
        _;
    }

    function betsLength() external view returns (uint256) {
        return bets.length;
    }

    // Events
    event BetPlaced(
        uint256 indexed betId,
        address indexed player,
        uint256 amount,
        uint256 indexed rollUnder,
        uint256 choice
    );
    event BetSettled(
        uint256 indexed betId,
        address indexed player,
        uint256 amount,
        uint256 indexed rollUnder,
        uint256 choice,
        uint256 outcome,
        uint256 winAmount
    );
    event BetRefunded(
        uint256 indexed betId,
        address indexed player,
        uint256 amount
    );

    // Setter

    function setMinBetAmount(uint256 _minBetAmount) external onlyOwner {
        require(
            _minBetAmount < maxBetAmount,
            "Min amount must be less than max amount"
        );
        minBetAmount = _minBetAmount;
    }

    function setMaxBetAmount(uint256 _maxBetAmount) external onlyOwner {
        require(
            _maxBetAmount > minBetAmount,
            "Max amount must be greater than min amount"
        );
        maxBetAmount = _maxBetAmount;
    }

    function toggleGameIsLive() external onlyOwner {
        gameIsLive = !gameIsLive;
    }

    // Methods
    function initializeHouse(address _address) external onlyOwner {
        require(gameIsLive == false, "Bets in pending");
        house = IHouse(_address);
    }

    function initializeVRFManager(address _address) external onlyOwner {
        require(gameIsLive == false, "Bets in pending");
        VRFManager = IVRFManager(_address);
        VRFManagerAddress = _address;
    }

    function withdrawCustomTokenFunds(
        address beneficiary,
        uint256 withdrawAmount,
        address token
    ) external onlyOwner {
        require(
            withdrawAmount <= IERC20(token).balanceOf(address(this)),
            "Withdrawal exceeds limit"
        );
        IERC20(token).safeTransfer(beneficiary, withdrawAmount);
    }

    function setBetAmount(uint256[] memory _array) external onlyOwner {
        uint256[] memory vba = new uint256[](_array.length);
        for (uint256 i = 0; i < _array.length; i++) {
            vba[i] = _array[i] + (_array[i] * house.getHouseEdgeBP()) / 10000;
        }
        validBetAmount = vba;
    }

    function getBetAmountLength() external view returns (uint256) {
        return validBetAmount.length;
    }

    function getUserBetMap(uint256 _checkNumbers)
        external
        view
        returns (uint256[] memory betList)
    {
        uint256 length = userBetMap[msg.sender].length;
        _checkNumbers = _checkNumbers > length ? length : _checkNumbers;
        uint256[] memory vba = new uint256[](_checkNumbers);
        uint256 j;
        for (uint256 i = length; i > (length - _checkNumbers); i--) {
            vba[j] = userBetMap[msg.sender][i - 1];
            j++;
        }
        return vba;
    }

    function betAmountValid(uint256 amount) internal view returns (bool) {
        for (uint256 i = 0; i < validBetAmount.length; i++) {
            if (amount == validBetAmount[i]) {
                return true;
            }
        }
        return false;
    }
}

interface IHouse {
    function placeBet(
        address player,
        uint256 amount,
        uint256 rollUnder,
        uint256 modulo,
        address refAddr
    ) external payable;

    function settleBet(
        address player,
        uint256 winnableAmount,
        bool win
    ) external;

    function refundBet(
        address player,
        uint256 amount,
        uint256 winnableAmount
    ) external;

    function amountToWinnableAmount(
        uint256 _amount,
        uint256 rollUnder,
        uint256 MODULO
    ) external view returns (uint256);

    function amountToBettableAmountConverter(uint256 amount)
        external
        view
        returns (uint256);

    function getHouseEdgeBP() external view returns (uint256);
}

interface IGame {
    function settleBet(uint256 requestId, uint256[] memory expandedValues)
        external;
}

interface IVRFManager {
    function sendRequestRandomness() external returns (uint256);
}

/**
 *Function list:
 *1:Registor & Login and update user info (including referral addr, profile pic link ...)
 *2:OG mint, WL mint, Public mint
 *3:Place bet, settle bet, refund bet
 */
contract Dice is ReentrancyGuard, Manager, IGame {
    uint256 constant POPCNT_MULT =
        0x0000000000002000000000100000000008000000000400000000020000000001;
    uint256 constant POPCNT_MASK =
        0x0001041041041041041041041041041041041041041041041041041041041041;
    uint256 constant POPCNT_MODULO = 0x3F;
    uint256 refundBlock = 400;

    function placeBet(
        uint256 betChoice,
        address refAddr,
        uint256 betTimes
    ) external payable nonReentrant {
        require(gameIsLive, "Game is not live");
        require(
            betChoice > 0 && betChoice < 2**MODULO - 1,
            "Bet mask not in range"
        );
        require(betTimes > 0, "Bet times can not be Zero");

        uint256 amount = msg.value / betTimes;
        require(betAmountValid(amount), "Not a valid amount");
        require(
            amount >= minBetAmount && amount <= maxBetAmount,
            "Bet amount not within range"
        );

        uint256 rollUnder = ((betChoice * POPCNT_MULT) & POPCNT_MASK) %
            POPCNT_MODULO;
        for (uint256 i = 0; i < betTimes; i++) {
            house.placeBet{value: amount}(
                msg.sender,
                amount,
                rollUnder,
                MODULO,
                refAddr
            );

            uint256 betId = bets.length;
            betMap[VRFManager.sendRequestRandomness()].push(betId);
            userBetMap[msg.sender].push(betId);

            emit BetPlaced(betId, msg.sender, amount, rollUnder, betChoice);
            bets.push(
                Bet({
                    rollUnder: uint8(rollUnder),
                    choice: uint40(betChoice),
                    outcome: 0,
                    placeBlockNumber: uint168(block.number),
                    amount: uint128(amount),
                    winAmount: 0,
                    player: msg.sender,
                    isSettled: false
                })
            );
        }
    }

    function settleBet(uint256 requestId, uint256[] memory expandedValues)
        external
        isVRFManager
    {
        emit BetSettled(requestId, address(0), expandedValues[0], 1, 1, 1, 1);
    }

    function _settleBet(uint256 betId, uint256 randomNumber)
        private
        nonReentrant
    {
        Bet storage bet = bets[betId];

        uint256 amount = bet.amount;
        if (amount == 0 || bet.isSettled == true) {
            return;
        }

        address player = bet.player;
        uint256 choice = bet.choice;
        uint256 rollUnder = bet.rollUnder;

        uint256 outcome = randomNumber % MODULO;
        uint256 winnableAmount = house.amountToWinnableAmount(
            amount,
            rollUnder,
            MODULO
        );
        uint256 winAmount = (2**outcome) & choice != 0 ? winnableAmount : 0;

        bet.isSettled = true;
        bet.winAmount = uint128(winAmount);
        bet.outcome = uint40(outcome);

        house.settleBet(player, winnableAmount, winAmount > 0);
        emit BetSettled(
            betId,
            player,
            amount,
            rollUnder,
            choice,
            outcome,
            winAmount
        );
    }

    function refundBet(uint256 betId) external nonReentrant {
        require(gameIsLive, "Game is not live");
        Bet storage bet = bets[betId];
        uint256 amount = bet.amount;

        require(amount > 0, "Bet does not exist");
        require(bet.isSettled == false, "Bet is settled already");
        require(
            block.number > bet.placeBlockNumber + refundBlock,
            "Wait before requesting refund"
        );

        uint256 winnableAmount = house.amountToWinnableAmount(
            amount,
            bet.rollUnder,
            MODULO
        );
        uint256 bettedAmount = house.amountToBettableAmountConverter(amount);

        bet.isSettled = true;
        bet.winAmount = uint128(bettedAmount);

        house.refundBet(bet.player, bettedAmount, winnableAmount);
        emit BetRefunded(betId, bet.player, bettedAmount);
    }

    function changeRefundBlock(uint256 _num) external onlyOwner nonReentrant {
        refundBlock = _num;
    }
}