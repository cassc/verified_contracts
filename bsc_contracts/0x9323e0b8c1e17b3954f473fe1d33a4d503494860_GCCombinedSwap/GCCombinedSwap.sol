/**
 *Submitted for verification at BscScan.com on 2022-12-13
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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
     * by making the `nonReentrant` function external, and make it call a
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

contract GCCombinedSwap is ReentrancyGuard, Ownable {
    //@notice XAU2USDExchangeRate, mmkP2PRate & mmkGovtRate are the base pairs and all calculations are based on their rates and are fetched from external APIs
    uint256 public XAU2USDExchangeRate; //XAU-USD conversion rate
    uint256 public mmkP2PRate; //MMK p2p conversion rate on binance
    uint256 public mmkGovtRate = 2100; //MMK price set by Myanmmar govt - periodically updated by the contract operator
    uint256 public GCS2USDTExchangeRate; //GCS-USDT conversion rate

    uint256 public lastUpdateTimeForBasePairs; //contract keeps track of the last update time for these pairs and if the last updated price is beyond 60 seconds, the swap won't go through
    //uint256 public lastUpdateTimeForExchangePairs; //block time for update of exchange pairs done by _calculatePriceForPairs()

    //@notice the below two pairs are the native tokens of GCS platform and are calculated using the price of abvoe pairs
    uint256 public XAUS2USDTExchangeRate; //XAUS-USDT conversion rate
    uint256 public GCS2USDMExchangeRate; //GCS-USDM conversion rate

    address public operator;
    uint8 public XAUSCoinMakingCharges = 10;
    uint256 public XAUSWeight = 425; // 0.425 gms
    uint256 public troyOunceToGms = 311035;
    uint256 public priceUpdateDuration = 1800;

    IERC20 public USDT;
    IERC20 public GCS;
    IERC20 public USDM;
    IERC20 public XAUS;

    uint8 public feesGCS2USDT = 5; //~ 0.5% (10 ~ 1%)
    uint8 public feesGCS2USDM = 5;
    uint8 public feesXAUS2USDT = 10;

    uint256 public feesCollectedGCS;
    uint256 public feesCollectedUSDT;
    uint256 public feesCollectedUSDM;
    uint256 public feesCollectedXAUS;

    uint256 public totalUSDTSwapped;
    uint256 public totalGCSSwapped;
    uint256 public totalXAUSSwapped;
    uint256 public totalUSDMSwapped;

    bool public swapActive;
    bool public gcsToUsdmPairActive;
    bool public xausToUsdtPairActive;

    event BasePairsUpdated(
        uint256 XAU2USDExchangeRate,
        uint256 mmkP2PRate,
        uint256 GCS2USDTExchangeRate
    );
    // event PairsPriceUpdated(
    //     uint256 XAUS2USDTExchangeRate,
    //     uint256 GCS2USDMExchangeRate,
    //     uint256 USDM2USDTExchangeRate
    // );
    event TokensUpdated(address USDT, address GCS, address USDM, address XAUS);
    event FeesUpdated(
        uint8 feesGCS2USDT,
        uint8 feesGCS2USDM,
        uint8 feesXAUS2USDT
    );
    event CoinMakingChargesUpdated(uint8 val);
    event MMKGovtRateUdpated(uint256 mmkGovtRate);
    event BNBRecovered(address beneficiary, uint256 amount);
    event TokenRecovered(address beneficiary, uint256 amount);
    event PriceUpdateDuration(uint256 newDuration);

    constructor(
        address _operator,
        address _GCS,
        address _USDM,
        address _XAUS,
        address _USDT
    ) {
        _transferOwnership(payable(msg.sender));
        operator = _operator;
        swapActive = true;
        gcsToUsdmPairActive = true;
        xausToUsdtPairActive = true;

        GCS = IERC20(_GCS);
        USDM = IERC20(_USDM);
        XAUS = IERC20(_XAUS);
        USDT = IERC20(_USDT);

        GCS.approve(address(this), GCS.totalSupply());
        USDM.approve(address(this), USDM.totalSupply());
        XAUS.approve(address(this), XAUS.totalSupply());
        USDT.approve(address(this), USDT.totalSupply());
    }

    //fallback
    receive() external payable {}

    /**
     * @dev Throws if called by any account other than the pperator.
     */
    modifier onlyOperator() {
        _checkOperator();
        _;
    }

    /**
     * @dev Throws if the sender is not the operator.
     */
    function _checkOperator() internal view virtual {
        require(
            operator == _msgSender(),
            "Ownable: caller is not the operator"
        );
    }

    //@dev sets tokens
    function _setTokens(
        address _USDT,
        address _GCS,
        address _USDM,
        address _XAUS
    ) external onlyOwner {
        require(
            _USDT != address(0) &&
                _GCS != address(0) &&
                _USDM != address(0) &&
                _XAUS != address(0),
            "Can't set zero address!"
        );

        USDT = IERC20(_USDT);
        GCS = IERC20(_GCS);
        USDM = IERC20(_USDM);
        XAUS = IERC20(_XAUS);

        emit TokensUpdated(_USDT, _GCS, _USDM, _XAUS);
    }

    function _setFees(
        uint8 _feesGCSTOUSDT,
        uint8 _feesGCS2USDM,
        uint8 _feesXAUS2USDT
    ) external onlyOwner {
        feesGCS2USDT = _feesGCSTOUSDT;
        feesGCS2USDM = _feesGCS2USDM;
        feesXAUS2USDT = _feesXAUS2USDT;

        emit FeesUpdated(_feesGCSTOUSDT, _feesGCS2USDM, _feesXAUS2USDT);
    }

    function _setOperator(address _operator) external onlyOwner {
        require(_operator != address(0) && _operator != operator, "Can't set zero address or existing operator as the new operator!");
        operator = _operator;
    }

    function _updateXAUSCoinMakingCharges(uint8 _val) external onlyOwner {
        XAUSCoinMakingCharges = _val;

        emit CoinMakingChargesUpdated(_val);
    }

    function _setMMKGovtRate(uint256 _mmkGovtRate) external onlyOwner {
        require(_mmkGovtRate > 0, "can't set 0 value!");
        mmkGovtRate = _mmkGovtRate;

        emit MMKGovtRateUdpated(_mmkGovtRate);
    }

    function _setUpdatePriceDuration(uint256 _newDuration) external onlyOwner {
        require(_newDuration >= 300, "Can't set duration below 5 mins!");

        priceUpdateDuration = _newDuration;

        emit PriceUpdateDuration(_newDuration);
    }

    function _setSwapStatus(bool _allActive, bool _gcs2usdmActive, bool _xaus2usdtActive) external onlyOwner {
        swapActive = _allActive;
        gcsToUsdmPairActive = _gcs2usdmActive;
        xausToUsdtPairActive = _xaus2usdtActive;
    }

    /* All values to be provided without decimals
        _XAU2USDExchangeRate = 175810 for 1758.10
        _mmkP2PRate = 3090 = 3090
        _GCS2USDTExchangeRate = 11735 for 11.735
    */
    function _updatePrices(
        uint256 _XAU2USDExchangeRate,
        uint256 _mmkP2PRate,
        uint256 _GCS2USDTExchangeRate
    ) external onlyOperator {
        require(
            _XAU2USDExchangeRate > 0 &&
                _mmkP2PRate >= mmkGovtRate &&
                _GCS2USDTExchangeRate > 0,
            "Base pair rates can't be set to 0 values."
        );

        XAU2USDExchangeRate = _XAU2USDExchangeRate;
        mmkP2PRate = _mmkP2PRate;
        GCS2USDTExchangeRate = _GCS2USDTExchangeRate;

        lastUpdateTimeForBasePairs = block.timestamp;

        emit BasePairsUpdated(
            _XAU2USDExchangeRate,
            _mmkP2PRate,
            _GCS2USDTExchangeRate
        );
    }

    // this calculator returns the exchange rate for 1 token in all pairs
    function _calculator()
        external
        nonReentrant
        returns (
            uint256 _GCS2USDT,
            uint256 _USDT2GCS,
            uint256 _GCS2USDM,
            uint256 _USDM2GCS,
            uint256 _XAUS2USDT,
            uint256 _USDT2XAUS
        )
    {
        uint256 _swapAmount = 1e18;
        uint256 calculatedGCS2USDMExchangeRate = (mmkP2PRate *
            GCS2USDTExchangeRate) / mmkGovtRate;
        GCS2USDMExchangeRate = calculatedGCS2USDMExchangeRate;

        uint256 calculatedXAUS2USDTExchangeRate = (XAU2USDExchangeRate *
            XAUSWeight *
            (100 + XAUSCoinMakingCharges)) / troyOunceToGms;
        XAUS2USDTExchangeRate = calculatedXAUS2USDTExchangeRate;

        uint256 GCS2USDT = (_swapAmount * GCS2USDTExchangeRate) / 1e3;
        uint256 USDT2GCS = (_swapAmount / GCS2USDTExchangeRate) * 1e3;
        uint256 GCS2USDM = (_swapAmount * GCS2USDMExchangeRate) / 1e3;
        uint256 USDM2GCS = (_swapAmount / GCS2USDMExchangeRate) * 1e3;
        uint256 XAUS2USDT = (_swapAmount * XAUS2USDTExchangeRate) / 1e3;
        uint256 USDT2XAUS = (_swapAmount / XAUS2USDTExchangeRate) * 1e3;

        return (GCS2USDT, USDT2GCS, GCS2USDM, USDM2GCS, XAUS2USDT, USDT2XAUS);
    }

    /* 
        Swap 1 - GCS=USDM pair
        GCS: 0x3d2bb1f7ab5d64C3917DbE03d37843421A42e0cD
        USDM: 0x08Ab7E5C08CC0D78589Fc506c35Ea9c2520A86bc
        price ratio to be used: GCS2USDMExchangeRate
        Fees applicable: feesGCS2USDM
        Other parameters:
        feesCollectedGCS, feesCollectedUSDM, totalGCSSwapped, totalUSDMSwapped
    */

    function _gcsUsdmSwap(address tokenA, uint256 amountTokenA)
        external
        nonReentrant
        returns (uint256 _exchangeAmount)
    {
        require(
            block.timestamp - lastUpdateTimeForBasePairs < priceUpdateDuration,
            "Price was not updated within required duration! Wait for price to be udpated."
        );
        require(swapActive, "Swap is not active!");

        uint256 calculatedGCS2USDMExchangeRate = (mmkP2PRate *
            GCS2USDTExchangeRate) / mmkGovtRate;
        GCS2USDMExchangeRate = calculatedGCS2USDMExchangeRate;

        // Condition 1 - Swapping GCS to USDM
        if (IERC20(tokenA) == GCS) {
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "GCS amount must be greater then zero");
            require(
                GCS.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA * GCS2USDMExchangeRate) / 1e3;
            uint256 feeDeduction = (exchangeA * feesGCS2USDM) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                USDM.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough USDM Tokens, please retry :=("
            );

            feesCollectedUSDM += feeDeduction;
            totalGCSSwapped += amountTokenA;

            GCS.transferFrom(msg.sender, address(this), amountTokenA);
            USDM.approve(address(msg.sender), exchangeAmount);
            USDM.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        } 
        // Condition 2 - Swapping USDM to GCS
        else {
            require(IERC20(tokenA) == USDM, "Can only swap GCS-USDM pair");
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "USDM amount must be greater then zero");
            require(
                USDM.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA / GCS2USDMExchangeRate) * 1e3;
            uint256 feeDeduction = (exchangeA * feesGCS2USDM) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                GCS.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough GCS Tokens, please retry :=("
            );

            feesCollectedGCS += feeDeduction;
            totalUSDMSwapped += amountTokenA;

            USDM.transferFrom(msg.sender, address(this), amountTokenA);
            GCS.approve(address(msg.sender), exchangeAmount);
            GCS.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        }
    }

    /* 
        Swap 2 - GCS=USDT pair
        GCS: 0x3d2bb1f7ab5d64C3917DbE03d37843421A42e0cD
        USDT: 0x55d398326f99059fF775485246999027B3197955
        price ratio to be used: GCS2USDTExchangeRate
        Fees applicable: feesGCS2USDT
        Other parameters:
        feesCollectedGCS, feesCollectedUSDT, totalGCSSwapped, totalUSDTSwapped
    */

    function _gcsUsdtSwap(address tokenA, uint256 amountTokenA)
        external
        nonReentrant
        returns (uint256 _exchangeAmount)
    {
        require(
            block.timestamp - lastUpdateTimeForBasePairs < priceUpdateDuration,
            "Price was not updated within required duration! Wait for price to be udpated."
        );
        require(swapActive, "Swap is not active!");
        require(gcsToUsdmPairActive, "GCS to USDT pair is non tradeable");

        // Condition 1 - Swapping GCS to USDT
        if (IERC20(tokenA) == GCS) {
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "GCS amount must be greater then zero");
            require(
                GCS.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA * GCS2USDTExchangeRate) / 1e3;
            uint256 feeDeduction = (exchangeA * feesGCS2USDT) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                USDT.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough USDT Tokens, please retry :=("
            );

            feesCollectedUSDT += feeDeduction;
            totalGCSSwapped += amountTokenA;

            GCS.transferFrom(msg.sender, address(this), amountTokenA);
            USDT.approve(address(msg.sender), exchangeAmount);
            USDT.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        } 
        // Condition 2 - Swapping USDT to GCS
        else {
            require(IERC20(tokenA) == USDT, "Can only swap GCS-USDT pair");
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "USDT amount must be greater then zero");
            require(
                USDT.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA / GCS2USDTExchangeRate) * 1e3;
            uint256 feeDeduction = (exchangeA * feesGCS2USDT) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                GCS.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough GCS Tokens, please retry :=("
            );

            feesCollectedGCS += feeDeduction;
            totalUSDTSwapped += amountTokenA;

            USDT.transferFrom(msg.sender, address(this), amountTokenA);
            GCS.approve(address(msg.sender), exchangeAmount);
            GCS.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        }
    }

    /* 
        Swap 3 - XAUS=USDT pair
        XAUS: 0x50ea0dfFE399A706EdC310f55c658e8B0eC27981
        USDT: 0x55d398326f99059fF775485246999027B3197955
        price ratio to be used: XAUS2USDTExchangeRate
        Fees applicable: feesXAUS2USDT
        Other parameters:
        feesCollectedXAUS, feesCollectedUSDT, totalXAUSSwapped, totalUSDTSwapped
    */

    function _xausUsdtSwap(address tokenA, uint256 amountTokenA)
        external
        nonReentrant
        returns (uint256 _exchangeAmount)
    {
        require(
            block.timestamp - lastUpdateTimeForBasePairs < priceUpdateDuration,
            "Price was not updated within required duration! Wait for price to be udpated."
        );
        require(swapActive, "Swap is not active!");
        require(xausToUsdtPairActive, "XAUS to USDT pair is non tradeable");

        uint256 calculatedXAUS2USDTExchangeRate = (XAU2USDExchangeRate *
            XAUSWeight *
            (100 + XAUSCoinMakingCharges)) / troyOunceToGms;
        XAUS2USDTExchangeRate = calculatedXAUS2USDTExchangeRate;

        // Condition 1 - Swapping XAUS to USDT
        if (IERC20(tokenA) == XAUS) {
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "XAUS amount must be greater then zero");
            require(
                XAUS.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA * XAUS2USDTExchangeRate) / 1e3;
            uint256 feeDeduction = (exchangeA * feesXAUS2USDT) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                USDT.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough USDT Tokens, please retry :=("
            );

            feesCollectedUSDT += feeDeduction;
            totalXAUSSwapped += amountTokenA;

            XAUS.transferFrom(msg.sender, address(this), amountTokenA);
            USDT.approve(address(msg.sender), exchangeAmount);
            USDT.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        }
        //Condition 2 - Swapping USDT to XAUS
        else {
            require(IERC20(tokenA) == USDT, "Can only swap XAUS-USDT pair");
            //check if amount given is not 0 and user has enough balance
            require(amountTokenA > 0, "USDT amount must be greater then zero");
            require(
                USDT.balanceOf(msg.sender) >= amountTokenA,
                "sender doesn't have enough Tokens"
            );

            uint256 exchangeA = (amountTokenA / XAUS2USDTExchangeRate) * 1e3;
            uint256 feeDeduction = (exchangeA * feesXAUS2USDT) / 1e3;
            uint256 exchangeAmount = exchangeA - feeDeduction;
            require(
                exchangeAmount > 0,
                "exchange Amount must be greater then zero"
            );

            // check if current contract has the necessary amout of Tokens to exchange
            require(
                XAUS.balanceOf(address(this)) > exchangeAmount,
                "currently the exchange doesnt have enough XAUS Tokens, please retry :=("
            );

            feesCollectedXAUS += feeDeduction;
            totalUSDTSwapped += amountTokenA;

            USDT.transferFrom(msg.sender, address(this), amountTokenA);
            XAUS.approve(address(msg.sender), exchangeAmount);
            XAUS.transferFrom(address(this), msg.sender, exchangeAmount);
            return exchangeAmount;
        }
    }

    function _recoverBNB() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);

        emit BNBRecovered(msg.sender, address(this).balance);
    }

    function _withdrawOtherTokens(address _token, uint256 amount)
        external
        onlyOwner
    {
        IERC20(_token).transfer(payable(msg.sender), amount);

        emit TokenRecovered(msg.sender, amount);
    }
}