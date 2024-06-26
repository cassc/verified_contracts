//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV2V3Interface.sol";

import "./interfaces/IRoundIdFetcher.sol";

error AlreadyInitialized();
error InvalidAddress();
error EthTransferFailed();
error InsufficientAmount();
error NegativeTokenPrice();
error RoundIncomplete();

/// @title BartrrBase
/// @dev Contains the shared code between ConditionalWager.sol and FixedWager.sol
contract BartrrBase is Ownable, ReentrancyGuard {
    struct RefundableTimestamp {
        uint256 refundable;
        uint256 nonrefundable;
    }

    address public feeAddress;
    IRoundIdFetcher public roundIdFetcher;
    uint256 public constant MIN_WAGER_DURATION = 1 days;
    uint32 public constant MIN_WAGER_AMOUNT = 995_000; // $9.95
    uint32 public constant MIN_WAGER_AMOUNT_FACTOR = 100_000;
    uint32 public constant MIN_FEE_AMOUNT = 250_000_000; // $2.50 (8 decimals)
    uint256 public idCounter; // Counter for the wager id
    bool public isInitialized;

    mapping(uint256 => uint256) public createdTimes; // mapping of contract creation times
    mapping(uint256 => uint256) public endTimes; // mapping of end times
    mapping(address => RefundableTimestamp) public refundableTimestamp; // mapping of timestamps for refundable token switch
    mapping(uint256 => bool) public refundUserA; // Marked true when userA calls refundWager()
    mapping(uint256 => bool) public refundUserB; // Marked true when userB calls refundWager()

    mapping(address => bool) public wagerTokens; // Tokens to be wagered on
    mapping(address => bool) public paymentTokens; // Tokens to be paid with

    mapping(address => address) public oracles; // Store the chainlink oracle for the token

    /// @notice Emitted when a wager is cancelled
    /// @param wagerId The wager id
    /// @param user The user who cancelled the wager
    event WagerCancelled(uint256 indexed wagerId, address indexed user);

    /// @notice Emitted when a wager is redeemed
    /// @param wagerId The wager id
    /// @param winner The winner of the wager
    /// @param paymentToken The token used to pay for the wager
    /// @param winningSum The amount of paymentTokens won
    event WagerRedeemed(
        uint256 indexed wagerId,
        address indexed winner,
        address paymentToken,
        uint256 winningSum
    );

    /// @notice Emitted when a wager is refunded
    /// @param wagerId The wager id
    /// @param user The user refunding the wager
    /// @param paymentToken The token being refunded
    /// @param amount The amount of paymentToken being refunded
    event WagerRefunded(
        uint256 indexed wagerId,
        address indexed user,
        address paymentToken,
        uint256 amount
    );

    /// @notice Emitted when an array of wager tokens is updated
    /// @param tokens Array of wager tokens
    /// @param oracles Array of oracles for the wager tokens
    /// @param update Whether the wager token is added (true) or removed (false)
    event WagerTokensUpdated(
        address[] indexed tokens,
        address[] indexed oracles,
        bool update
    );

    /// @notice Emitted when an array of payment tokens is updated
    /// @param tokens Array of payment tokens
    /// @param oracles Array of oracles
    /// @param update Whether the array of payment tokens is added (true) or removed (false)
    event PaymentTokensUpdated(
        address[] indexed tokens,
        address[] indexed oracles,
        bool update
    );

    /// @notice Called if an error is detected in the chainlink oracle
    /// @param _token address of the token whose wagers need to be refunded
    function oracleMalfunction(address _token) external onlyOwner {
        refundableTimestamp[_token].refundable = block.timestamp;
    }

    /// @notice Called when there is working update for the chainlink oracle
    /// @param _token address of the token whose wagers need to be refunded
    function oracleRecovery(address _token) external onlyOwner {
        refundableTimestamp[_token].nonrefundable = block.timestamp;
    }

    /// @param _feeAddress address of the fee recipient
    function init(
        address _feeAddress,
        address _owner,
        address _roundIdFetcher
    ) external onlyOwner {
        if (isInitialized) revert AlreadyInitialized();
        if (_feeAddress == address(0)) revert InvalidAddress();
        feeAddress = _feeAddress;
        roundIdFetcher = IRoundIdFetcher(_roundIdFetcher);
        _transferOwnership(_owner);
        isInitialized = true;
    }

    /// @param _wagerTokens array of wager token addresses
    /// @param _oracles array of oracles for the wager tokens
    /// @param _update true if the tokens are being added, false if they are being removed
    function updateWagerTokens(
        address[] memory _wagerTokens,
        address[] memory _oracles,
        bool _update
    ) external onlyOwner {
        for (uint256 i = 0; i < _wagerTokens.length; i++) {
            wagerTokens[_wagerTokens[i]] = _update;
            oracles[_wagerTokens[i]] = _oracles[i];
        }
        emit WagerTokensUpdated(_wagerTokens, _oracles, _update);
    }

    /// @param _paymentTokens array of payment token addresses
    /// @param _oracles array of oracles for the payment tokens
    /// @param _update true if the tokens are being added, false if they are being removed
    function updatePaymentTokens(
        address[] memory _paymentTokens,
        address[] memory _oracles,
        bool _update
    ) external onlyOwner {
        for (uint256 i = 0; i < _paymentTokens.length; i++) {
            paymentTokens[_paymentTokens[i]] = _update;
            oracles[_paymentTokens[i]] = _oracles[i];
        }
        emit PaymentTokensUpdated(_paymentTokens, _oracles, _update);
    }

    /// @notice Function to transfer Ether from this contract to address from input
    /// @param _to address of transfer recipient
    /// @param _amount amount of ether to be transferred
    function _transfer(address payable _to, uint256 _amount) internal {
        (bool success, ) = _to.call{value: _amount}("");
        if (!success) {
            revert EthTransferFailed();
        }
    }

    /// @param _roundId Chainlink roundId corresponding to the wager deadline
    /// @param _token address of the token whose price is being queried
    function _getHistoricalPrice(uint80 _roundId, address _token)
        internal
        view
        returns (
            int256,
            uint256,
            uint256
        )
    {
        (
            ,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,

        ) = AggregatorV2V3Interface(oracles[_token]).getRoundData(_roundId);
        if (timeStamp <= 0) revert RoundIncomplete();
        return (price, startedAt, timeStamp);
    }

    /// @param _token address of the token whose price is being queried
    function _getLatestPrice(address _token)
        internal
        view
        returns (int256, uint8)
    {
        address aggregator = oracles[_token];
        (, int256 answer, , uint256 updatedAt, ) = AggregatorV2V3Interface(
            aggregator
        ).latestRoundData();
        if (updatedAt <= 0) revert RoundIncomplete();
        uint8 decimals = AggregatorV2V3Interface(aggregator).decimals();
        return (answer, decimals);
    }

    /// @param _amount amount of the wager
    /// @param _paymentToken address of the payment token
    function _calculateFee(uint256 _amount, address _paymentToken)
        internal
        view
        returns (uint256 fee)
    {
        (int256 tokenPrice, uint8 oracleDecimals) = _getLatestPrice(
            _paymentToken
        );

        // Protection against negative prices
        if (tokenPrice <= 0) {
            revert NegativeTokenPrice();
        } else {
            uint256 usdPrice = uint256(tokenPrice);
            uint8 decimals;
            if (
                _paymentToken ==
                address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
            ) {
                decimals = 18;
            } else {
                decimals = IERC20Metadata(_paymentToken).decimals();
            }

            uint256 dollarAmount = (((_amount * usdPrice) *
                MIN_WAGER_AMOUNT_FACTOR) / (10**decimals)) /
                (10**oracleDecimals);

            if (dollarAmount < MIN_WAGER_AMOUNT) revert InsufficientAmount();
            fee = (_amount * 5) / 1000; // .5% fee
            if (((fee * usdPrice) / (10**decimals)) < MIN_FEE_AMOUNT) {
                fee = (MIN_FEE_AMOUNT * (10**decimals)) / usdPrice; // $5 fee
            }
        }
        return fee;
    }
}