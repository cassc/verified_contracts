// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/IBEP20Token.sol";

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */

interface ITRADERFACTORY {

    function AllowedTokens(address) external view returns (bool);

    function athLevelFee(uint8) external view returns (uint8);

    function referrerFeeFromLevel(uint8) external view returns (uint8);

    function traderFee() external view returns (uint8);

}
// Link to bep20 token smart contract

// Link to AthSatking contract
interface IATHLEVEL {
    // Returns ath level of given address
    function athLevel(address user) external view returns (uint256 level);
}

// Link to router contract
interface IROUTER {
    // Swap tokens
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}


// Link to short Order Contract
interface IShortOrder {
    function lendToken(address _token, uint256 _amount) external;

    function releaseLendedToken(address _token, uint256 _amount, bool _fullRelease) external;

    function borrowToken(address _token, uint256 _amount) external;

    function repayBorrowToken(address _token, uint256 _amount, bool _fullRepay) external;

    function transferTokenToTraderContract(address _token, uint256 _amount) external;

    function underlying(address _token) external view returns (address);
}

interface IERC20ORDERROUTER {
    function depositToken(
        uint256 _amount,
        address _module,
        address _inputToken,
        address payable _owner,
        address _witness,
        bytes calldata _data,
        bytes32 _secret
    ) external;

}

interface IGELATOCORE {
    function cancelOrder(
        address _module,
        address _inputToken,
        address payable _owner,
        address _witness,
        bytes calldata _data
    ) external;

    function vaultOfOrder(
        address _module,
        address _inputToken,
        address payable _owner,
        address _witness,
        bytes memory _data
    ) external view returns (address);
}

/**
 * @title AthenaBank trader contract Version 1.0
 *
 * @author AthenaBank
 */
contract AthTrader {
    using SafeMath for uint256;

    // Address of AthTrader owner
    address public owner;

    // Address of AthStaking contract
    address public immutable athLevel;

    // Address of Gelato Core module
    address public immutable gelatoCore = 0x0c30D3d66bc7C73A83fdA929888c34dcb24FD599;

    // Address of Gelato for ERC20 swaps
    address  public immutable gelatoERC20Router = 0x64c7f3c2C19B41a6aD67bb5f4edc8EdbB3284F34;

    // Address of pancake Router contract
    address public immutable allowedRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;


    // Address of trader account
    address public trader;

    // Address of traderFactory
    address public traderFactory;


    // Address of ShortOrder contract
    address public shortOrderContract;

    // Trader fee defined in percentage
    uint8 public traderFee;

    // Status of emergency withdraw
    bool public isEmergencyWithdrawlEnabled;

    // Address of participation token contract
    address public participationToken;

    // Funding start time defined in timestamp
    uint256 public fundingStartTime;

    // Funding period defined in seconds
    uint256 public fundingPeriod;

    // Trading period defined in seconds
    uint256 public tradingPeriod;

    // Claiming period defined in seconds
    uint256 public claimingPeriod;

    // Benchmark for total funding amount
    uint256 public fundingCap;

    // Minimum contribution required to participate in funding round
    uint256 public minContribution;

    // Total invested amount of participated token
    uint256 public totalInvestment;

    // Total amount of participated token Post trading Period
    uint256 public concludedTotalAmount;

    // Reward rate for calculating harvested amount
    uint256 public rewardRate;

    // bool check to verify contract is concluded or not
    bool public isTradingContractConcluded;

    // traded token array
    address[] public tradedToken;



    /**
     * @dev array containing vaults of Gelato's orders
     */
    address[] public gelatoVaults;




    /**
     * @dev Returns true if given address is allowed for trading
     */
    mapping(address => bool) public allowedTokens;

    /**
     * @dev Returns invested amount for given address
     */
    mapping(address => uint256) public investedAmount;

    /**
     * @dev Returns claimed amount of given address
     */
    mapping(address => uint256) public userClaimedAmount;

    /**
     * @dev Returns traded Token index of array
     */
    mapping(address => uint256) public tradedTokenMap;

    /**
     * @dev Returns the token used in the given vault
     */
    mapping(address => address) public gelatoVaultToken;

    /**
     * @dev Returns referrer  of given address
     */
    mapping(address => address) public referrer;




    /**
	 * @dev Fired in transferOwnership() when ownership is transferred
	 *
	 * @param previousOwner an address of previous owner
	 * @param newOwner an address of new owner
	 */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
	 * @dev Fired in addToAllowed() and removeFromAllowed() when address is added into/removed from
     *      allowedTokens
	 *
	 * @param token  address
	 * @param isAllowed defines if address is added or removed
	 */
    event Allowed(address token, bool isAllowed);


    /**
	 * @dev Fired in recoverToken() when tokens are recovered by an owner
	 *
	 * @param token address of token to recover
	 * @param amount number of tokens to recover
	 */
    event Recover(address token, uint256 amount);

    /**
	 * @dev Fired in recoverContract() when contract value is recovered by an owner
	 *
	 * @param amount value of the contract recovered
	 */
    event RecoverValue(uint256 amount);

    /**
	 * @dev Fired in invest() when tokens are invested by user
	 *
	 * @param investor address of investor
	 * @param amount number of tokens invested
	 */
    event Investment(address indexed investor, uint256 amount);

    /**
	 * @dev Fired in withdraw() and emergencyWithdraw() when tokens are withdrawn by user
	 *
	 * @param investor address of an investor
	 * @param amount number of tokens withdrawn
     * @param isEmergencyWithdrawl true if fired in emergencyWithdraw()
	 */
    event WithdrawInvestment(address indexed investor, uint256 amount, bool isEmergencyWithdrawl);

    /**
	 * @dev Fired in swap() when tokens are swapped by a trader or binanceAPI
	 *
	 * @param executor address of an executor
	 * @param router address of router
     * @param path  of tokens to swap
     * @param amountIn amount of input tokens to send
     * @param amountOutMin minimum amount of output tokens that must be received
     * @param deadline unix timestamp after which the transaction will revert
	 */
    event Swap(address indexed executor, address router, address[] path, uint amountIn, uint amountOutMin, uint deadline);

    /**
	 * @dev Fired in harvestReward() tokens are harvested by user
	 *
	 * @param investor address of an investor
	 * @param amount number of tokens harvested
     * @param fee number of tokens paid as fee
	 */
    event Harvest(address indexed investor, uint256 amount, uint256 fee);

    /**
	 * @dev Fired in harvestReward() tokens are transferred to referrer
	 *
	 * @param referee address of an investor
	 * @param amount number of tokens transferred
     * @param referrer number of tokens paid as fee
	 */
    event ReferralPaid(address indexed referee, uint256 amount, address indexed referrer);


    /**
	 * @dev Creates/deploys AthenaBank trading contract Version 1.0
	 *
	 * @param athStaking_ address of AthStaking smart contract
	 * @param trader_ address of trader account
	 * @param owner_ address of owner
	 */
    constructor(address athStaking_, address owner_, address trader_) {
        // Setup smart contract internal state
        owner = owner_;
        athLevel = athStaking_;
        trader = trader_;
        traderFactory = msg.sender;
    }

    // To check if accessed by an owner
    modifier onlyOwner() {
        isOwner();
        _;
    }

    // To check if accessed by a trader
    modifier onlyTrader() {
        isTrader();
        _;
    }

    // To check if accessed by an owner or a tarder
    modifier traderOrOwner() {
        isTraderOrOwner();
        _;
    }


    /**
	 * @dev Transfer ownership to given address
	 *
	 * @notice restricted function, should be called by owner only
	 * @param newOwner_ address of new owner
	 */
    function transferOwnership(address newOwner_) external onlyOwner {
        // Update owner address
        owner = newOwner_;

        // Emit an event
        emit OwnershipTransferred(msg.sender, newOwner_);
    }

    /**
	 * @dev Initializes trading contract parameters
	 *
	 * @notice restricted function, should be called by owner only
     * @param startTime_ unix timestamp after which funding period will start
     * @param fundingPeriodInSeconds_ funding period defined in seconds
     * @param tradingPeriodInSeconds_ trading period defined in seconds
     * @param claimingPeriodInSeconds_ claiming Period defined in seconds
     * @param participationToken_ address of participation token contract
     * @param fundingCap_ benchmark for token amount to be raised
     * @param minContribution_ minimum contribution required to participate in funding round
	 */

    function initializeRound(
        uint256 startTime_,
        uint256 fundingPeriodInSeconds_,
        uint256 tradingPeriodInSeconds_,
        uint256 claimingPeriodInSeconds_,
        address participationToken_,
        uint256 fundingCap_,
        uint256 minContribution_
    ) external traderOrOwner {

        require(fundingStartTime == 0, "Active round");
        require(claimingPeriodInSeconds_ >= 60 days, "Invalid claiming period");
        require(allowedTokens[participationToken_], "participationToken not allowed");

        // Setup smart contract internal state
        fundingStartTime = startTime_;
        fundingPeriod = fundingPeriodInSeconds_;
        tradingPeriod = tradingPeriodInSeconds_;
        claimingPeriod = claimingPeriodInSeconds_;
        traderFee = ITRADERFACTORY(traderFactory).traderFee();
        participationToken = participationToken_;
        fundingCap = fundingCap_;
        minContribution = minContribution_;

    }


    /**
	 * @dev Adds tokens address to allowed list
	 *
	 * @notice restricted function, should be called by owner or trader only
	 * @param allowed_ address list of tokens
	 */

    function addToAllowed(
        address[] memory allowed_
    ) external traderOrOwner {
        require(fundingStartTime == 0, "Active round");
        for (uint8 i; i < allowed_.length; i++) {
            require(ITRADERFACTORY(traderFactory).AllowedTokens(allowed_[i]), "Token not allowed");
            // Add address to the list
            allowedTokens[allowed_[i]] = true;

            // Emit an event
            emit Allowed(allowed_[i], true);
        }
    }

    /**
	 * @dev Removes token address from allowed list
	 *
	 * @notice restricted function, should be called by owner or trader only
	 * @param notAllowed_ addresses of tokens to be removed
	 */

    function removeFromAllowed(
        address[] memory notAllowed_
    ) external traderOrOwner {
        require(fundingStartTime == 0, "Active round");
        for (uint8 i; i < notAllowed_.length; i++) {
            // Remove address from the list
            allowedTokens[notAllowed_[i]] = false;

            // Emit an event
            emit Allowed(notAllowed_[i], false);
        }
    }

    /**
	 * @dev Enables/disables emergency withdraw
	 *
	 * @notice restricted function, should be called by owner only
	 */
    function emergencyWithdrawSwitch() external onlyOwner {
        // Trigger emergency withdraw switch
        isEmergencyWithdrawlEnabled = !isEmergencyWithdrawlEnabled;
    }


    /**
	 * @dev Sets short order contract address
	 *
	 * @notice restricted function, should be called by owner or TraderFactory only
     * @param _addr short order contract address
	 */
    function setShortOrderContractAddr(
        address _addr
    ) external {
        require(msg.sender == traderFactory || msg.sender == owner, "Invalid access");
        require(_addr != address(0x0), "Invalid input!!");

        shortOrderContract = _addr;
    }

    /**
	 * @dev Recovers tokens from the contract
	 *
	 * @notice restricted function, should be called by owner only
	 * @param token_ address of token to recover
     * @param amount_ number of tokens to recover
	 */
    function recoverToken(address token_, uint256 amount_) external onlyOwner {

        require(block.timestamp > fundingStartTime + fundingPeriod + tradingPeriod + claimingPeriod, "Claiming Period is not yet over!!!");

        // Transfer tokens to the owner
        IBEP20Token(token_).transfer(msg.sender, amount_);

        // Emit an event
        emit Recover(token_, amount_);
    }

    /**
	 * @dev Recovers value from the contract
	 *
	 * @notice restricted function, should be called by owner only
	 */
    function recoverContract() external onlyOwner {

        require(block.timestamp > fundingStartTime + fundingPeriod + tradingPeriod + claimingPeriod, "Claiming Period is not yet over!!!");

        // Contract value to send
        uint256 _value = address(this).balance;

        // Verify balance is positive (non-zero)
        require(_value > 0, "zero balance");

        // Transfer value to the owner
        payable(msg.sender).transfer(_value);

        // Emit an event
        emit RecoverValue(_value);
    }


    /**
	 * @dev Ends funding period earlier if funding cap is reached
     *
     * @notice restricted function, should be called by owner or trader only
     */
    function concludeFundingPeriod() external traderOrOwner {
        require(isFundingActive(), "Inactive funding");

        require(totalInvestment >= fundingCap, "Cap not reached");

        // Decrease funding period time
        fundingPeriod = block.timestamp.sub(fundingStartTime);
    }

    /**
	 * @dev Ends trading contract and set reward rate
     *
     * @notice restricted function, should be called by owner or trader only
     * @param forceConclude pass true to forceConclude without verifing traded token conversion
     *                      only owner can forceConclude, trader can't
     */
    function concludeTradingContract(
        bool forceConclude
    ) external traderOrOwner {
        require(isRewardActive(), "Inactive reward");

        require(!isTradingContractConcluded, "Trading contract is already concluded!!!");

        require((owner == msg.sender && forceConclude) || (isTradedTokenConverted() && isOrdersClosed()), "Yet to convert traded token or close limit/stop orders");

        // set final concluded participation token amount
        concludedTotalAmount = IBEP20Token(participationToken).balanceOf(address(this));
        // Set reward rate based on participation token balance
        rewardRate = concludedTotalAmount.mul(1e9).div(totalInvestment);
        // conclude trading contract
        isTradingContractConcluded = true;
    }

    /**
	 * @dev Ends trading period earlier
     *
     * @notice restricted function, should be called by owner or trader only
     */
    function concludeTradingPeriod() external traderOrOwner {
        require(isTradingActive(), "Inactive trading");

        // Decrease trading period time
        tradingPeriod = block.timestamp.sub(fundingStartTime.add(fundingPeriod));
    }

    /**
	 * @dev Returns true if funding is active
	 */
    function isFundingActive() public view returns (bool) {
        return (block.timestamp >= fundingStartTime) &&
        (block.timestamp < fundingStartTime + fundingPeriod);
    }

    /**
	 * @dev Returns true if trading is active
	 */
    function isTradingActive() public view returns (bool) {
        return (block.timestamp >= fundingStartTime + fundingPeriod) &&
        (block.timestamp < fundingStartTime + fundingPeriod + tradingPeriod) &&
        totalInvestment >= fundingCap;
    }

    /**
	 * @dev Returns array of trader token
	 */
    function getTradedTokenList() external view returns (address[] memory) {
        return tradedToken;
    }

    /**
     * @return true if the contract is currently in claiming period and the funding cap is satisfied
	 */
    function isRewardActive() public view returns (bool) {
        return (block.timestamp > fundingStartTime + fundingPeriod + tradingPeriod) &&
        totalInvestment >= fundingCap;
    }

    /**
	 * @dev Returns true if all traded token is converted back to participation token
     *
     */
    function isTradedTokenConverted() public view returns (bool) {
        for (uint256 i = 0; i < tradedToken.length; i++) {
            // "10 ** (IBEP20Token(tradedToken[i]).decimals().sub(4))" is equivalent to 0.0001 token
            if (IBEP20Token(tradedToken[i]).balanceOf(address(this)) > 10 ** (IBEP20Token(tradedToken[i]).decimals().sub(4))) {
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Returns true if all limit/stop orders are closed
     *
     */
    function isOrdersClosed() public view returns (bool) {
        for (uint256 i = 0; i < gelatoVaults.length; i++) {
            if (IBEP20Token(gelatoVaultToken[gelatoVaults[i]]).balanceOf(gelatoVaults[i]) > 0) {
                return false;
            }
        }
        return true;
    }

    /**
	 * @dev Returns true if funding is active for given level
     *
     * @param level_ index of level
	 */
    function isFundingActiveForAthLevel(
        uint8 level_
    ) public view returns (bool) {
        uint256 lockPeriod = fundingPeriod.div(4);

        if (level_ == 0) {
            return (block.timestamp >= fundingStartTime.add(lockPeriod.mul(3)));
        } else if (level_ == 1) {
            return (block.timestamp >= fundingStartTime.add(lockPeriod.mul(2)));
        } else if (level_ == 2) {
            return (block.timestamp >= fundingStartTime + lockPeriod);
        } else if (level_ == 3) {
            return (block.timestamp >= fundingStartTime);
        } else {
            return false;
        }
    }

    /**
	 * @dev Invests participation tokens to the contract
     *
     * @param amount_ number of tokens to invest
     * @param referrer_ referrer wallet address
	 */
    function invest(
        uint256 amount_,
        address referrer_
    ) external {
        require(investedAmount[msg.sender] + amount_ >= minContribution, "Invalid amount");

        require(isFundingActive(), "Inactive funding");

        // Get level index
        uint8 _level = uint8(IATHLEVEL(athLevel).athLevel(msg.sender));

        require(trader == msg.sender || isFundingActiveForAthLevel(_level), "Inactive for level");

        // Transfer tokens to AthTrader contract
        IBEP20Token(participationToken).transferFrom(msg.sender, address(this), amount_);

        // Record invested amount of given address
        investedAmount[msg.sender] += amount_;

        // Record total investment amount
        totalInvestment += amount_;

        // record referrer address, if any
        if (referrer_ != address(0)) {
            referrer[msg.sender] = referrer_;
        }

        // Emit an event
        emit Investment(msg.sender, amount_);
    }

    /**
	 * @dev Allows to withdraw invested tokens if emergency withdraw is enabled by an owner
     */
    function emergencyWithdraw() external {
        require(isEmergencyWithdrawlEnabled, "Withdrawl disabled");

        require(userClaimedAmount[msg.sender] == 0, "Already Withdrawen!!");

        // Get invested amount of given address
        uint256 _amount = investedAmount[msg.sender];

        // update claimed amount
        userClaimedAmount[msg.sender] = _amount;

        // Transfer invested amount to given address
        IBEP20Token(participationToken).transfer(msg.sender, _amount);

        // Emit an event
        emit WithdrawInvestment(msg.sender, _amount, true);
    }

    /**
	 * @dev Allows to withdraw invested tokens if funding cap is not reached at the end of funding period
     */
    function withdraw() external {
        require(
            (block.timestamp >= fundingStartTime + fundingPeriod) && (totalInvestment < fundingCap),
            "Withdrawl disabled"
        );

        require(investedAmount[msg.sender] > 0, "No investment");

        // Get invested amount of given address
        uint256 _amount = investedAmount[msg.sender];

        // Transfer invested amount to given address
        IBEP20Token(participationToken).transfer(msg.sender, _amount);

        // Remove invested amount data for given address
        delete investedAmount[msg.sender];

        // Emit an event
        emit WithdrawInvestment(msg.sender, _amount, false);
    }

    /**
	 * @dev Harvests rewards after trading period gets over
     */
    function harvestReward() external {
        require(isRewardActive(), "Inactive reward");

        require(investedAmount[msg.sender] > 0, "No investment");

        require(userClaimedAmount[msg.sender] == 0, "Already Harvested!!");

        require(isTradingContractConcluded, "Trading contract is not concluded yet!!!");

        require(block.timestamp <= fundingStartTime + fundingPeriod + tradingPeriod + claimingPeriod, "Claiming Period is over!!!");

        // Calculate reward amount
        uint256 _rewardAmount = investedAmount[msg.sender].mul(rewardRate).div(1e9);

        // Calculate fee on profitable amount
        uint256 _fee = (_rewardAmount <= investedAmount[msg.sender]) ? 0
        : calculateFee(_rewardAmount.sub(investedAmount[msg.sender]));

        // fee is not applicable to trader wallet
        if (trader == msg.sender) {
            _fee = 0;
        }
        // Transfer harvested amount to given address
        IBEP20Token(participationToken).transfer(msg.sender, _rewardAmount.sub(_fee));

        // Check if fee is non zero
        if (_fee > 0) {

            // Initialize referrer fee
            uint256 _referrerFee = 0;

            // Calculate referral fee
            if (referrer[msg.sender] != address(0)) {
                _referrerFee = _fee.mul(ITRADERFACTORY(traderFactory).referrerFeeFromLevel(uint8(IATHLEVEL(athLevel).athLevel(referrer[msg.sender])))).div(100);
                // Transfer referral fee to referrer
                IBEP20Token(participationToken).transfer(referrer[msg.sender], _referrerFee);
                emit ReferralPaid(msg.sender, _referrerFee, referrer[msg.sender]);
            }

            // Calculate trader fee
            uint256 _traderFee = _fee.sub(_referrerFee).mul(traderFee).div(100);
            // Transfer owner share to owner account
            IBEP20Token(participationToken).transfer(owner, _fee.sub(_traderFee).sub(_referrerFee));

            // Transfer trader fee to trader account
            IBEP20Token(participationToken).transfer(trader, _traderFee);
        }

        // update claimed amount
        userClaimedAmount[msg.sender] = _rewardAmount.sub(_fee);


        // Emit an event
        emit Harvest(msg.sender, _rewardAmount, _fee);
    }

    /**
	 * @dev Swaps tokens invested in contract post trading period
     *
     * @notice restricted function, should be called by owner only
     * @param router_ address of router
     * @param route_ token path to swap
     * @param amountIn_ amount of input tokens to send
     * @param amountOutMin_ minimum amount of output tokens that must be received
     * @param deadline_ unix timestamp after which the transaction will revert
     */
    function ownableSwap(
        address router_,
        address[] memory route_,
        uint amountIn_,
        uint amountOutMin_,
        uint deadline_
    ) public onlyOwner {
        require(isRewardActive(), "Trading is still active!!");

        require(!isTradingContractConcluded, "swap is not allowed!!!");

        internalSwap(router_, route_, amountIn_, amountOutMin_, deadline_);
    }


    /**
	 * @dev Swaps tokens invested in contract
     *
     * @notice restricted function, should be called by trader or API only
     * @param router_ address of router
     * @param route_ token path to swap
     * @param amountIn_ amount of input tokens to send
     * @param amountOutMin_ minimum amount of output tokens that must be received
     * @param deadline_ unix timestamp after which the transaction will revert
     */

    function swap(
        address router_,
        address[] memory route_,
        uint amountIn_,
        uint amountOutMin_,
        uint deadline_
    ) public onlyTrader {
        require(isTradingActive(), "Inactive trading");

        internalSwap(router_, route_, amountIn_, amountOutMin_, deadline_);
    }


    /**
     * @dev calls the correct Gelato module to place both limit and stop orders
     * @notice restricted function, should be called by trader only
     * @param _amount amount of tokens to be swapped
     * @param _module module to be used for placing order (limit order or stop order)
     * @param _inputToken address of input token
     * @param _owner address of order Owner, in our case is always this contract
     * @param _witness address of order witness, used by Gelato
     * @param _data data to be passed to Gelato, contains outputToken
     * @param _secret key to generate witness, used by Gelato
     */
    function depositToken(
        uint256 _amount,
        address _module,
        address _inputToken,
        address payable _owner,
        address _witness,
        bytes calldata _data,
        bytes32 _secret
    ) external onlyTrader {
        address outputToken;
        address handlerAddress;
        uint256 minReturn;
        uint256 maxReturn;

        require(isTradingActive(), "Inactive trading");

        require(_owner == address(this), "Owner should be this contract");
        require(_module == 0xb7499a92fc36e9053a4324aFfae59d333635D9c3 || _module == 0xE912CD26C4A4cfffc175A297F1328aB23313a1a7, "Invalid module");

        // pancake_limit
        if (_module == 0xb7499a92fc36e9053a4324aFfae59d333635D9c3) {

            (outputToken, minReturn, handlerAddress) = abi.decode(
                _data,
                (address, uint256, address)
            );
            // pancake_stoplimit
        } else {
            (outputToken, minReturn, handlerAddress, maxReturn) = abi.decode(
                _data,
                (address, uint256, address, uint256)
            );
        }

        // check that both tokens are allowed
        require(allowedTokens[outputToken] == true, "Invalid output token");
        require(allowedTokens[_inputToken] == true, "Invalid input token");


        // place order through Gelato
        IBEP20Token(_inputToken).approve(gelatoERC20Router, _amount);
        IERC20ORDERROUTER(gelatoERC20Router).depositToken(_amount, _module, _inputToken, _owner, _witness, _data, _secret);

        // store order's vault and inputToken to later verify if order is still active
        address vault = IGELATOCORE(gelatoCore).vaultOfOrder(_module, _inputToken, _owner, _witness, _data);
        gelatoVaults.push(vault);
        gelatoVaultToken[vault] = _inputToken;


    }

    /**
     * @dev calls GelatoCore to cancel a specific order
     * @notice restricted function, should be called by trader or owner Only
     * @param _module module used for order (not needed, but used in Gelato's frontend lib)
     * @param _inputToken address of input token
     * @param _owner address of order Owner, in our case is always this contract
     * @param _witness address of order witness (not needed, but used in Gelato's frontend lib)
     * @param _data data used for order (not needed, but used in Gelato's frontend lib)
     */

    function CancelOrder(
        address _module,
        address _inputToken,
        address payable _owner,
        address _witness,
        bytes calldata _data
    ) external traderOrOwner {

        require(_owner == address(this), "Owner should be this contract");

        // cancel order through Gelato
        IGELATOCORE(gelatoCore).cancelOrder(_module, _inputToken, _owner, _witness, _data);

        // remove order's vault from array
        for (uint i = 0; i < gelatoVaults.length; i++) {
            if (gelatoVaults[i] == IGELATOCORE(gelatoCore).vaultOfOrder(_module, _inputToken, _owner, _witness, _data)) {
                gelatoVaults[i] = gelatoVaults[gelatoVaults.length - 1];
                gelatoVaults.pop();
                break;
            }
        }

    }



    /**
	 * @dev Lend token Venus Platform
     *
     * @notice restricted function, should be called by trader only
     * @param _token address of venus token address
     * @param _amount amount of underlying token you want to lend
     */
    function lendToken(
        address _token,
        uint256 _amount
    ) external onlyTrader {
        require(isTradingActive(), "Inactive trading");

        address underlyingToken = IShortOrder(shortOrderContract).underlying(_token);
        IBEP20Token(underlyingToken).transfer(shortOrderContract, _amount);

        IShortOrder(shortOrderContract).lendToken(_token, _amount);
    }

    /**
	 * @dev release lended token on venus platform
     *
     * @notice restricted function, should be called by trader only
     * @param _token address of venus token address
     * @param _amount amount of underlying token you want to release
     * @param _fullRelease bool flag, If you want to release full lended amount pass true else pass false.
     */
    function releaseLendedToken(
        address _token,
        uint256 _amount,
        bool _fullRelease
    ) external onlyTrader {
        require(isTradingActive(), "Inactive trading");

        IShortOrder(shortOrderContract).releaseLendedToken(_token, _amount, _fullRelease);
        address underlyingToken = IShortOrder(shortOrderContract).underlying(_token);

        IShortOrder(shortOrderContract).transferTokenToTraderContract(underlyingToken, _amount);
    }

    /**
	 * @dev function to borrow token from venus platform
     *
     * @notice restricted function, should be called by trader only
     * @param _token address of venus token address
     * @param _amount amount of underlying token you want to borrow from venus platform
     */
    function borrowToken(
        address _token,
        uint256 _amount
    ) external onlyTrader {
        require(isTradingActive(), "Inactive trading");

        IShortOrder(shortOrderContract).borrowToken(_token, _amount);

        address underlyingToken = IShortOrder(shortOrderContract).underlying(_token);
        IShortOrder(shortOrderContract).transferTokenToTraderContract(underlyingToken, _amount);
    }

    /**
	 * @dev function to repay borrowed token from venus platform
     *
     * @notice restricted function, should be called by trader  only
     * @param _token address of venus token address
     * @param _amount amount of underlying token you want to repay to venus platform
     * @param _fullRepay bool flag, If you want to repay full borrowed amount pass true else pass false.
     */
    function repayBorrowToken(
        address _token,
        uint256 _amount,
        bool _fullRepay
    ) external onlyTrader {
        require(isTradingActive(), "Inactive trading");

        if (_fullRepay) {
            IShortOrder(shortOrderContract).repayBorrowToken(_token, _amount, _fullRepay);
        } else {
            address underlyingToken = IShortOrder(shortOrderContract).underlying(_token);
            IBEP20Token(underlyingToken).transfer(shortOrderContract, _amount);

            IShortOrder(shortOrderContract).repayBorrowToken(_token, _amount, _fullRepay);
        }
    }

    /**
	 * @dev function to send ERC20 token to Short-order contract
     *
     * @notice restricted function, should be called by trader only
     * @param _token address of ERC20 token address, token must other then participation token
     * @param _amount amount of token want to send to Short-order contract
     */
    function transferTokenToSOContract(
        address _token,
        uint256 _amount
    ) external onlyTrader {

        IBEP20Token(_token).transfer(shortOrderContract, _amount);
    }

    /**
	 * @dev function to Collect/transfer ERC20 token from Short-order contract
     *
     * @notice restricted function, should be called by trader only
     * @param _token address of ERC20 token address
     * @param _amount amount of token want to recover/transfer from Short-order contract
     */
    function RecoverTokenFromSOContract(
        address _token,
        uint256 _amount
    ) external onlyTrader {
        IShortOrder(shortOrderContract).transferTokenToTraderContract(_token, _amount);
    }

    /**
	 * @dev Swaps tokens invested in contract
     *
     * @notice its internal function being calling by mutliple functions
     * @param router_ address of router
     * @param route_ token path to swap
     * @param amountIn_ amount of input tokens to send
     * @param amountOutMin_ minimum amount of output tokens that must be received
     * @param deadline_ unix timestamp after which the transaction will revert
     */
    function internalSwap(
        address router_,
        address[] memory route_,
        uint amountIn_,
        uint amountOutMin_,
        uint deadline_
    ) internal {
        require(router_ == allowedRouter, "Invalid router");

        require(allowedTokens[route_[0]] == true && allowedTokens[route_[route_.length - 1]] == true, "Invalid token in route");

        for (uint i = 1; i < route_.length - 1; i++) {
            require(ITRADERFACTORY(traderFactory).AllowedTokens(route_[i]) == true, "Invalid path token in route");
        }

        address _tokenIn = route_[0];
        address _tokenOut = route_[route_.length - 1];

        // Approve input tokens to router
        IBEP20Token(_tokenIn).approve(router_, amountIn_);

        // Execute swap function of given router
        IROUTER(router_).swapExactTokensForTokens(amountIn_, amountOutMin_, route_, address(this), deadline_);

        // register _tokenIn as traded token
        if (tradedTokenMap[_tokenIn] == 0 && _tokenIn != participationToken) {
            tradedToken.push(_tokenIn);
            tradedTokenMap[_tokenIn] = tradedToken.length;
        }

        // register _tokenOut as traded token
        if (tradedTokenMap[_tokenOut] == 0 && _tokenOut != participationToken) {
            tradedToken.push(_tokenOut);
            tradedTokenMap[_tokenOut] = tradedToken.length;
        }

        emit Swap(msg.sender, router_, route_, amountIn_, amountOutMin_, deadline_);
    }

    /**
	 * @dev Returns fee on surplus amount
     *
     * @param surPlus_ surplus amount of participation tokens
     */
    function calculateFee(
        uint256 surPlus_
    ) internal view returns (uint256) {
        return (ITRADERFACTORY(traderFactory).athLevelFee(uint8(IATHLEVEL(athLevel).athLevel(msg.sender))) * surPlus_) / 100;
    }

    /**
	 * @dev view function to check msg.sender is owner
     */
    function isOwner() internal view {
        require(owner == msg.sender, "Not an owner");
    }

    function isTrader() internal view {
        require(trader == msg.sender, "Not a trader");
    }

    function isTraderOrOwner() internal view {
        require(trader == msg.sender || owner == msg.sender, "Invalid access");
    }

    //TODO: function to modify traderFactory ?
}