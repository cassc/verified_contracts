//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;
// Imported OZ helper contracts
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
// Inherited allowing for ownership of contract
import "@openzeppelin/contracts/access/Ownable.sol";
// Allows for intergration with ChainLink VRF
import "./interfaces/IRandomNumberGenerator.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";
import "ApeSwap-AMM-Periphery/contracts/interfaces/IApePair.sol";
import "ApeSwap-AMM-Periphery/contracts/interfaces/IApeRouter02.sol";


// Allows for time manipulation. Set to 0x address on test/mainnet deploy

contract Lottery is Ownable {
    // Libraries
    using SafeMath for uint256;
    // Safe ERC20
    using SafeERC20 for IERC20;
    // Address functionality
    using Address for address;

    // State variables
    // Instance of Cake token (collateral currency for lotto)
    IERC20 public token;
    // Storing of the randomness generator
    IRandomNumberGenerator internal randomGenerator_;
    // Request ID for random number
    bytes32 internal requestId_;
    // Counter for lottery IDs
    uint256 private lotteryIdCounter_;
    AggregatorInterface public priceFeed;
    IApePair public pair;
    IApeRouter02 public router;
    // TODO check
    address private constant WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
    address public burnReserve;
    address public liquidityReserve;
    address public treasury;

    mapping(uint256 => uint16) public currentTicket;
    mapping(address => mapping(uint256 => uint16[])) public usersTickets;
    mapping(address => mapping(uint256 => bool)) public alreadyClaimed;

    // Represents the status of the lottery
    enum Status {
        NotStarted, // The lottery has not started yet
        Open, // The lottery is open for ticket purchases
        Closed, // The lottery is no longer open for ticket purchases
        Completed // The lottery has been closed and the numbers drawn
    }
    // All the needed info around a lottery
    struct LottoInfo {
        uint256 lotteryID; // ID for lotto
        Status lotteryStatus; // Status for lotto
        uint16[] prizeDistributionPercents; // The distribution percents for prize money
        uint256 startBlock; // Block number for start of lotto
        uint256 ticketPrice;
        uint16 ticketsCount;
        uint16 ticketsSold;
        uint16[] winningNumbers; // The winning numbers
    }
    // Lottery ID's to info
    mapping(uint256 => LottoInfo) internal allLotteries_;
    // LotteryId to rendomNumber
    mapping(uint256 => uint256) public rendomNumbers;

    //-------------------------------------------------------------------------
    // EVENTS
    //-------------------------------------------------------------------------

    event RequestNumbers(uint256 lotteryId, bytes32 requestId);

    event UpdatedSizeOfLottery(address admin, uint16 newLotterySize);

    event UpdatedMaxRange(address admin, uint16 newMaxRange);

    event LotteryOpen(uint256 lotteryId, uint256 ticketSupply);

    event LotteryClose(uint256 lotteryId, uint256 ticketSupply);

    //-------------------------------------------------------------------------
    // MODIFIERS
    //-------------------------------------------------------------------------

    modifier onlyRandomGenerator() {
        require(msg.sender == address(randomGenerator_), "Only random generator");
        _;
    }

    modifier notContract() {
        require(!address(msg.sender).isContract(), "contract not allowed");
        require(msg.sender == tx.origin, "proxy contract not allowed");
        _;
    }

    constructor(
        IERC20 token_,
        address priceFeed_,
        IApePair pair_,
        IApeRouter02 router_,
        address burnReserve_,
        address liquidityReserve_,
        address treasury_
    ) {
        require(address(router_) != address(0), "Lottery: Router can't be address zero");
        require(address(token_) != address(0), "Lottery: Pair can't be address zero");
        require(treasury_ != address(0), "Lottery: Treasury can't be address zero");
        require(liquidityReserve_ != address(0), "Lottery: LiquidityReserve can't be address zero");
        require(burnReserve_ != address(0), "Lottery: BurnReserve can't be address zero");
        require(priceFeed_ != address(0), "Lottery: PriceFeed can't be address zero");
        require(address(pair_) != address(0), "Lottery: Pair can't be address zero");
        token = token_;
        priceFeed = AggregatorInterface(priceFeed_);
        pair = pair_;
        burnReserve = burnReserve_;
        liquidityReserve = liquidityReserve_;
        treasury = treasury_;
        router = router_;
    }

    function getBasicLottoInfo(uint256 lotteryId_) public view returns (LottoInfo memory) {
        return (allLotteries_[lotteryId_]);
    }

    function setRendomGenerator(address randomNumberGenerator_) external onlyOwner {
        require(randomNumberGenerator_ != address(0), "Contracts cannot be 0 address");
        randomGenerator_ = IRandomNumberGenerator(randomNumberGenerator_);
    }

    function drawWinningNumbers(uint256 lotteryId_) external onlyOwner {
        // Checks that the all tickets are sold
        // require(
        //     allLotteries_[lotteryId_].ticketsSold == allLotteries_[lotteryId_].ticketsCount,
        //     "Lottery: Cannot set winning numbers during lottery"
        // ); 
        // // Checks lottery numbers have not already been drawn
        // require(
        //     allLotteries_[lotteryId_].lotteryStatus == Status.Open ||
        //         allLotteries_[lotteryId_].lotteryStatus == Status.NotStarted,
        //     "Lottery: State incorrect for draw"
        // );
        // Sets lottery status to closed
        allLotteries_[lotteryId_].lotteryStatus = Status.Closed;
        // Requests a random number from the generator
        requestId_ = randomGenerator_.getRandomNumber(lotteryId_);
        uint256 amount = (getTokenAmountForCurrentPrice(allLotteries_[lotteryId_].ticketPrice) *
            1e18 *
            allLotteries_[lotteryId_].ticketsCount) / 2;
        token.transfer(burnReserve, amount);
        swap(amount);
        // Emits that random number has been requested
        emit RequestNumbers(lotteryId_, requestId_);
    }

    function numbersDrawn(
        uint256 lotteryId_,
        bytes32 _requestId,
        uint256 _randomNumber
    ) external onlyRandomGenerator {
        require(allLotteries_[lotteryId_].lotteryStatus == Status.Closed, "Lottery: Draw numbers first");
        rendomNumbers[lotteryId_] = _randomNumber;
        if (requestId_ == _requestId) {
            allLotteries_[lotteryId_].lotteryStatus = Status.Completed;
            // allLotteries_[lotteryId_].winningNumbers = _split(lotteryId_);
        }
        // TODO fix
        // emit LotteryClose( lotteryId_, nft_.getTotalSupply());
    }
    function getWiningNumbers(uint256 _lotteryId) external {
        require(allLotteries_[_lotteryId].lotteryStatus == Status.Completed, "Draw numbers first");
        allLotteries_[_lotteryId].winningNumbers = _split(_lotteryId);
    }

    /**
     * @param   startBlock_ The block number for the beginning of the
     *          lottery.
     */
    function createNewLotto(
        uint16[] calldata prizeDistributionPercents_,
        uint256 startBlock_,
        uint256 ticketPrice_,
        uint16 ticketsCount_
    ) external onlyOwner returns (uint256 lotteryId) {
        require(ticketPrice_ > 0, "Lottery: Ticket price can't be zero");
        require(ticketsCount_ > 0, "Lottery: Tickets count can't be zero");
        require(startBlock_ >= block.number, "Lottery: Too late");
        uint256 sumOfPrizePercents;
        for (uint8 i; i <= 2; i++) {
            sumOfPrizePercents += prizeDistributionPercents_[i];
        }
        require(sumOfPrizePercents == 5000, "Lottery: Incorrect percents for prize distribution");
        // Incrementing lottery ID
        lotteryIdCounter_++;
        lotteryId = lotteryIdCounter_;
        uint16[] memory winningNumbers;
        Status lotteryStatus;
        if (startBlock_ == block.number) {
            lotteryStatus = Status.Open;
        } else {
            lotteryStatus = Status.NotStarted;
        }
        // Saving data in struct
        LottoInfo memory newLottery = LottoInfo(
            lotteryId,
            lotteryStatus,
            prizeDistributionPercents_,
            startBlock_,
            ticketPrice_,
            ticketsCount_,
            0,
            winningNumbers
        );
        allLotteries_[lotteryId] = newLottery;
        currentTicket[lotteryId] = 1;
        // TODO fix
        // emit LotteryOpen(
        //     lotteryId,
        //     nft_.getTotalSupply()
        // );
    }

    function claimReward(uint256 lotteryId_) external notContract {
        // Checks the lottery winning numbers are available
        require(allLotteries_[lotteryId_].lotteryStatus == Status.Completed, "Lottery: Winning Numbers not chosen yet");
        require(getWonAmount(msg.sender, lotteryId_) > 0, "Lottery: Nothing to claim");
        require(!alreadyClaimed[msg.sender][lotteryId_], "Lottery: User have already claimed his rewards");
        alreadyClaimed[msg.sender][lotteryId_] = true;
        // Transfering the user their winnings
        uint256 amount = getWonAmount(msg.sender, lotteryId_);
        if(getWonAmount(msg.sender, lotteryId_) > token.balanceOf(address(this))){
            amount = token.balanceOf(address(this));
        }
        token.safeTransfer(msg.sender, amount);
    }

    function getWonAmount(address user_, uint256 lotteryId_) public view returns (uint256 amount) {
        uint16[] memory matchingNumbers = new uint16[](3);
        uint16[] memory winningNumbers = new uint16[](3);
        winningNumbers = getBasicLottoInfo(lotteryId_).winningNumbers;
        matchingNumbers = getNumberOfMatching(usersTickets[user_][lotteryId_], winningNumbers);
        if (matchingNumbers[0] == 0) {
            return 0;
        }
        for (uint256 i; i <= 2; i++) {
            if (matchingNumbers[i] > 0) {
                for (uint256 j; j <= 2; j++) {
                    if ((allLotteries_[lotteryId_].winningNumbers)[j] == matchingNumbers[i]) {
                        amount +=
                            (allLotteries_[lotteryId_].prizeDistributionPercents[j] *
                                getTokenAmountForCurrentPrice(allLotteries_[lotteryId_].ticketPrice) *
                                1e18 *
                                allLotteries_[lotteryId_].ticketsCount) /
                            10000;
                    }
                }
            }
        }
        return amount;
    }

    function getNumberOfMatching(uint16[] memory usersNumbers_, uint16[] memory winningNumbers_)
        public
        pure
        returns (uint16[] memory wonNumbers)
    {
        wonNumbers = new uint16[](3);
        // Loops through all wimming numbers
        for (uint256 i = 0; i < winningNumbers_.length; i++) {
            // If the winning numbers and user numbers match
            for (uint256 j; j < usersNumbers_.length; j++) {
                if (usersNumbers_[j] == winningNumbers_[i]) {
                    // The number of matching numbers incrases
                    for (uint256 k; k < 3; k++) {
                        if (wonNumbers[k] == 0) {
                            wonNumbers[k] = usersNumbers_[j];
                            break;
                        }
                    }
                }
            }
        }
    }

    function _split(uint256 lotteryId_) public returns (uint16[] memory) {
        uint16[] memory winningNumbers = new uint16[](3); 
        uint256 i;
        // count of unique numbers we have already got
        uint256 numbersCount;
        while (numbersCount < 3) {
            // Encodes the random number with its position in loop
            bytes32 hashOfRandom = keccak256(abi.encodePacked(rendomNumbers[lotteryId_], i));
            // Casts random number hash into uint256
            uint256 numberRepresentation = uint256(hashOfRandom);
            if (uint16(numberRepresentation.mod(allLotteries_[lotteryId_].ticketsCount)) > 0) {
                uint256 duplicates;
                if (winningNumbers[0] == 0) {
                    winningNumbers[0] = uint16(numberRepresentation.mod(allLotteries_[lotteryId_].ticketsCount));
                    numbersCount++;
                }
                for (uint8 j; j < winningNumbers.length; j++) {
                    if (uint16(numberRepresentation.mod(allLotteries_[lotteryId_].ticketsCount)) == winningNumbers[j]) {
                        duplicates++;
                    }
                }
                if (duplicates == 0) {
                    winningNumbers[numbersCount] = uint16(
                        numberRepresentation.mod(allLotteries_[lotteryId_].ticketsCount)
                    );
                    numbersCount++;
                }
            }
            i++;
        }
        allLotteries_[lotteryId_].winningNumbers = winningNumbers;
        return winningNumbers;
    }

    function buyTicket(uint256 lotteryId_) external {
        require(allLotteries_[lotteryId_].startBlock <= block.number, "Lottery: Not started yet");
        require(
            allLotteries_[lotteryId_].ticketsSold < allLotteries_[lotteryId_].ticketsCount,
            "Lottery: No available tickets"
        );
        usersTickets[msg.sender][lotteryId_].push(currentTicket[lotteryId_]);
        currentTicket[lotteryId_]++;
        allLotteries_[lotteryId_].ticketsSold++;
        token.safeTransferFrom(
            msg.sender,
            address(this),
            getTokenAmountForCurrentPrice(allLotteries_[lotteryId_].ticketPrice) * 1e18
        );
    }

    function getTokenAmountForCurrentPrice(uint256 price_) public view returns (uint256) {
        uint256 bnbPrice = uint256(priceFeed.latestAnswer());
        uint256 tokenBalance = token.balanceOf(address(pair));
        uint256 bnbBalance = IERC20(WBNB).balanceOf(address(pair));
        uint256 tokenPrice = bnbPrice / (tokenBalance / bnbBalance);
        return (price_ * 1e8) / tokenPrice;
    }

    function getUsersTickets(address user_, uint256 lotteryId_) public view returns (uint16[] memory) {
        return usersTickets[user_][lotteryId_];
    }

    function swap(uint256 amount) public {
        uint256 amountForLiquidity = (amount * 6000) / 10000;
        address[] memory path = new address[](2);

        path[0] = address(token);
        path[1] = WBNB;
        if (token.balanceOf(liquidityReserve) >= amountForLiquidity) {
            token.transferFrom(liquidityReserve, address(this), amountForLiquidity);
            token.approve(address(router), amountForLiquidity);
            router.swapExactTokensForETH(amountForLiquidity, 0, path, treasury, block.timestamp + 1000);
        }
    }
}