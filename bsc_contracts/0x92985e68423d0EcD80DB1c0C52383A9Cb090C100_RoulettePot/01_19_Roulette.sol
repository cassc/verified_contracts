/**
 *Submitted for verification at Etherscan.io on 2022-04-18
 */

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol';
import '../interfaces/IPancakePair.sol';
import '../interfaces/IPancakeFactory.sol';
import '../interfaces/IPancakeRouter.sol';
import '../interfaces/IBNBP.sol';
import '../interfaces/IPRC20.sol';
import '../interfaces/IVRFConsumer.sol';
import '../interfaces/IPegSwap.sol';
import '../interfaces/IPotContract.sol';

contract RoulettePot is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    uint256 public casinoCount;
    uint256 public betIds;
    mapping(uint256 => Casino) public tokenIdToCasino;
    mapping(address => bool) public isStable;
    mapping(address => mapping(uint256 => BetInfo)) public userLastBetInfo;

    address public casinoNFTAddress;
    address public BNBPAddress;
    address public consumerAddress;
    address public potAddress;

    address internal constant wbnbAddr = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // testnet: 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd, mainnet: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
    address internal constant busdAddr = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; // testnet: 0x4608Ea31fA832ce7DCF56d78b5434b49830E91B1, mainnet: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56
    address internal constant pancakeFactoryAddr = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73; // testnet: 0x6725F303b657a9451d8BA641348b6761A6CC7a17, mainnet: 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73
    address internal constant pancakeRouterAddr = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // testnet: 0xD99D1c33F9fC3444f8101754aBC46c52416550D1, mainnet: 0x10ED43C718714eb63d5aA57B78B54704E256024E
    address internal constant coordinatorAddr = 0xc587d9053cd1118f25F645F9E08BB98c9712A4EE; // testnet: 0x6A2AAd07396B36Fe02a22b33cf443582f682c82f, mainnet: 0xc587d9053cd1118f25F645F9E08BB98c9712A4EE
    address internal constant linkTokenAddr = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD; // testnet: 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06, mainnet: 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD
    address internal constant pegSwapAddr = 0x1FCc3B22955e76Ca48bF025f1A6993685975Bb9e;
    address internal constant link677TokenAddr = 0x404460C6A5EdE2D891e8297795264fDe62ADBB75;
    uint256 internal constant subscriptionId = 664; // testnet: 2102, mainnet: 664
    uint256 public linkPerBet = 30000000000000000; // 0.03 link token per request
    uint256 public linkSpent;

    struct Casino {
        address tokenAddress;
        string tokenName;
        uint256 liquidity;
        uint256 locked;
        uint256 initialMaxBet;
        uint256 maxBet;
        uint256 minBet;
        uint256 fee;
        int256 profit;
        uint256 lastSwapTime;
    }

    struct BetInfo {
        bool isPending;
        uint256 requestId;
        Bet[] bets;
        uint256 tokenPrice;
    }

    struct Bet {
        /* 5: number, 4: even, odd, 3: 18s, 2: 12s, 1: row, 0: black, red */
        uint8 betType;
        uint8 number;
        uint240 amount;
    }

    event FinishedBet(
        uint256 tokenId,
        uint256 betId,
        address player,
        uint256 nonce,
        uint256 totalAmount,
        uint256 rewardAmount,
        uint256 totalUSD,
        uint256 rewardUSD,
        uint256 maximumReward
    );
    event TransferFailed(uint256 tokenId, address to, uint256 amount);
    event TokenSwapFailed(uint256 tokenId, uint256 balance, string reason, uint256 timestamp);
    event InitializedBet(uint256 tokenId, address player, uint256 amount);
    event AddedLiquidity(uint256 tokenId, address owner, uint256 amount);
    event RemovedLiquidity(uint256 tokenId, address owner, uint256 amount);
    event UpdatedMaxBet(uint256 tokenId, address owner, uint256 value);
    event UpdatedMinBet(uint256 tokenId, address owner, uint256 value);
    event LiquidityChanged(uint256 tokenId, uint256 value);
    event SuppliedBNBP(uint256 amount);
    event SuppliedLink(uint256 amount);

    constructor(
        address nftAddr,
        address _BNBPAddress,
        address _consumerAddress,
        address _potAddress
    ) {
        address BNBPPair = IPancakeFactory(pancakeFactoryAddr).getPair(wbnbAddr, _BNBPAddress);
        require(BNBPPair != address(0), 'No liquidity with BNBP and BNB');

        casinoNFTAddress = nftAddr;
        BNBPAddress = _BNBPAddress;
        consumerAddress = _consumerAddress;
        potAddress = _potAddress;
    }

    modifier onlyCasinoOwner(uint256 tokenId) {
        require(IERC721(casinoNFTAddress).ownerOf(tokenId) == msg.sender, 'Not Casino Owner');
        _;
    }

    /**
     * @dev sets token is stable or not
     */
    function setTokenStable(address tokenAddr, bool _isStable) external onlyOwner {
        isStable[tokenAddr] = _isStable;
    }

    /**
     * @dev set how much link token will be consumed per bet
     */
    function setLinkPerBet(uint256 value) external onlyOwner {
        linkPerBet = value;
    }

    /**
     * @dev returns list of casinos minted
     */
    function getCasinoList()
        external
        view
        returns (
            Casino[] memory casinos,
            address[] memory owners,
            uint256[] memory prices
        )
    {
        uint256 length = casinoCount;
        casinos = new Casino[](length);
        owners = new address[](length);
        prices = new uint256[](length);
        IERC721 nftContract = IERC721(casinoNFTAddress);

        for (uint256 i = 1; i <= length; i++) {
            casinos[i - 1] = tokenIdToCasino[i];
            owners[i - 1] = nftContract.ownerOf(i);
            if (casinos[i - 1].tokenAddress == address(0)) {
                prices[i - 1] = getBNBPrice();
            } else {
                prices[i - 1] = _getTokenUsdPrice(casinos[i - 1].tokenAddress);
            }
        }
    }

    /**
     * @dev adds a new casino
     */
    function addCasino(
        uint256 tokenId,
        address tokenAddress,
        string calldata tokenName,
        uint256 maxBet,
        uint256 minBet,
        uint256 fee
    ) external {
        require(msg.sender == casinoNFTAddress, 'Only casino nft contract can call');

        Casino storage newCasino = tokenIdToCasino[tokenId];
        newCasino.tokenAddress = tokenAddress;
        newCasino.tokenName = tokenName;
        newCasino.initialMaxBet = maxBet;
        newCasino.maxBet = maxBet;
        newCasino.minBet = minBet;
        newCasino.fee = fee;
        newCasino.liquidity = 0;

        casinoCount++;
    }

    /**
     * @dev set max bet limit for casino
     */
    function setMaxBet(uint256 tokenId, uint256 newMaxBet) external onlyCasinoOwner(tokenId) {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        require(newMaxBet <= casinoInfo.initialMaxBet, "Can't exceed initial max bet");

        casinoInfo.maxBet = newMaxBet;
        emit UpdatedMaxBet(tokenId, msg.sender, newMaxBet);
    }

    /**
     * @dev set min bet limit for casino
     */
    function setMinBet(uint256 tokenId, uint256 newMinBet) external onlyCasinoOwner(tokenId) {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        require(newMinBet <= casinoInfo.maxBet, 'min >= max');
        require(newMinBet > 0, 'min = 0');

        casinoInfo.minBet = newMinBet;
        emit UpdatedMaxBet(tokenId, msg.sender, newMinBet);
    }

    /**
     * @dev returns maximum reward amount for given bets
     */
    function getMaximumReward(Bet[] memory bets) public pure returns (uint256) {
        uint256 maxReward;
        uint8[6] memory betRewards = [2, 3, 3, 2, 2, 36];

        for (uint256 i = 0; i <= 37; i++) {
            uint256 reward;

            for (uint256 j = 0; j < bets.length; j++) {
                if (_isInBet(bets[j], i)) {
                    reward += bets[j].amount * betRewards[bets[j].betType];
                }
            }
            if (maxReward < reward) {
                maxReward = reward;
            }
        }
        return maxReward;
    }

    /**
     * @dev returns whbnb Bet `b` covers the `number` or not
     */
    function _isInBet(Bet memory b, uint256 number) public pure returns (bool) {
        require(b.betType <= 5, 'Invalid bet type');
        require(b.number <= 37, 'Invalid betting number');

        if (number == 0 || number == 37) {
            if (b.betType == 5) {
                return b.number == number;
            } else {
                return false;
            }
        }

        if (b.betType == 5) {
            return (b.number == number); /* bet on number */
        } else if (b.betType == 4) {
            if (b.number == 0) return (number % 2 == 0); /* bet on even */
            if (b.number == 1) return (number % 2 == 1); /* bet on odd */
        } else if (b.betType == 3) {
            if (b.number == 0) return (number <= 18); /* bet on low 18s */
            if (b.number == 1) return (number >= 19); /* bet on high 18s */
        } else if (b.betType == 2) {
            if (b.number == 0) return (number <= 12); /* bet on 1st dozen */
            if (b.number == 1) return (number > 12 && number <= 24); /* bet on 2nd dozen */
            if (b.number == 2) return (number > 24); /* bet on 3rd dozen */
        } else if (b.betType == 1) {
            if (b.number == 0) return (number % 3 == 0); /* bet on top row */
            if (b.number == 1) return (number % 3 == 1); /* bet on middle row */
            if (b.number == 2) return (number % 3 == 2); /* bet on bottom row */
        } else if (b.betType == 0) {
            if (b.number == 0) {
                /* bet on black */
                if (number <= 10 || (number >= 19 && number <= 28)) {
                    return (number % 2 == 0);
                } else {
                    return (number % 2 == 1);
                }
            } else {
                /* bet on red */
                if (number <= 10 || (number >= 19 && number <= 28)) {
                    return (number % 2 == 1);
                } else {
                    return (number % 2 == 0);
                }
            }
        }
        return false;
    }

    /**
     * @dev returns total bet amount
     */
    function _getTotalBetAmount(Bet[] memory bets) internal pure returns (uint256) {
        /* 5: number, 4: even, odd, 3: 18s, 2: 12s, 1: row, 0: black, red */
        uint256[5] memory betCount;
        uint256 totalBetAmount;
        for (uint256 i = 0; i < bets.length; i++) {
            require(bets[i].betType <= 5, 'Invalid bet type');

            totalBetAmount += bets[i].amount;
            if (bets[i].betType < 5) {
                betCount[bets[i].betType]++;
            }
        }
        require(
            betCount[0] < 2 && betCount[1] < 3 && betCount[2] < 3 && betCount[3] < 2 && betCount[4] < 2,
            'Bet Restriction'
        );

        return totalBetAmount;
    }

    /**
     * @dev calculate total rewards with a given nonce
     */
    function _spinWheel(Bet[] memory bets, uint256 nonce) internal pure returns (uint256, uint256) {
        uint256 totalReward;
        uint8[6] memory betRewards = [2, 3, 3, 2, 2, 36];

        for (uint256 i = 0; i < bets.length; i++) {
            if (_isInBet(bets[i], nonce)) {
                totalReward += betRewards[bets[i].betType] * bets[i].amount;
            }
        }
        return (nonce, totalReward);
    }

    /**
     * @dev initialize user bet info to pending status
     */
    function _initializeBetInfo(
        uint256 tokenId,
        uint256 requestId,
        Bet[] calldata bets,
        uint256 tokenPrice
    ) internal {
        BetInfo storage info = userLastBetInfo[msg.sender][tokenId];

        delete info.bets;
        info.requestId = requestId;
        info.isPending = true;
        info.tokenPrice = tokenPrice;
        for (uint256 i = 0; i < bets.length; i++) {
            Bet memory bet = bets[i];
            info.bets.push(bet);
        }
    }

    /**
     * @dev initialize bet and request nonce to VRF
     *
     * NOTE this function only accepts erc20 tokens
     *      Bet type should be less than 6, otherwise will revert
     * @param tokenId tokenId of the Casino
     * @param bets array of bets
     */
    function initializeTokenBet(uint256 tokenId, Bet[] calldata bets) external nonReentrant returns (uint256) {
        require(userLastBetInfo[msg.sender][tokenId].isPending == false, 'Bet not finished');

        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        require(casinoInfo.tokenAddress != address(0), "This casino doesn't support tokens");

        IPRC20 token = IPRC20(casinoInfo.tokenAddress);
        uint256 approvedAmount = token.allowance(msg.sender, address(this));
        uint256 totalBetAmount = _getTotalBetAmount(bets);
        uint256 maxReward = getMaximumReward(bets);
        uint256 tokenPrice = isStable[casinoInfo.tokenAddress] ? 10**18 : _getTokenUsdPrice(casinoInfo.tokenAddress);
        uint256 totalUSDValue = (totalBetAmount * tokenPrice) / 10**token.decimals();

        require(token.balanceOf(msg.sender) >= totalBetAmount, 'Not enough balance');
        require(totalBetAmount <= approvedAmount, 'Not enough allowance');
        require(maxReward <= casinoInfo.liquidity + totalBetAmount, 'Not enough liquidity');
        require(totalUSDValue <= casinoInfo.maxBet * 10**18, "Can't exceed max bet limit");
        require(totalUSDValue >= casinoInfo.minBet * 10**18, "Can't be lower than min bet limit");

        token.transferFrom(msg.sender, address(this), totalBetAmount);
        casinoInfo.liquidity -= (maxReward - totalBetAmount);
        casinoInfo.locked += maxReward;

        IVRFv2Consumer vrfConsumer = IVRFv2Consumer(consumerAddress);
        uint256 requestId = vrfConsumer.requestRandomWords();
        _initializeBetInfo(tokenId, requestId, bets, tokenPrice);

        linkSpent += linkPerBet;

        emit InitializedBet(tokenId, msg.sender, totalBetAmount);
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
        return requestId;
    }

    /**
     * @dev initialize bet and request nonce to VRF
     *
     * NOTE this function only accepts bnb
     *      Bet type should be less than 6, otherwise will revert
     * @param tokenId tokenId of the Casino
     * @param bets array of bets
     */
    function initializeEthBet(uint256 tokenId, Bet[] calldata bets) external payable returns (uint256) {
        BetInfo storage info = userLastBetInfo[msg.sender][tokenId];
        require(info.isPending == false, 'Bet not finished');

        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        require(casinoInfo.tokenAddress == address(0), 'This casino only support bnb');

        IPRC20 busdToken = IPRC20(busdAddr);
        uint256 totalBetAmount = _getTotalBetAmount(bets);
        uint256 maxReward = getMaximumReward(bets);
        uint256 bnbPrice = getBNBPrice();
        uint256 totalUSDValue = (bnbPrice * totalBetAmount) / 10**18;

        require(msg.value == totalBetAmount, 'Not correct bet amount');
        require(maxReward <= casinoInfo.liquidity + totalBetAmount, 'Not enough liquidity');
        require(totalUSDValue <= casinoInfo.maxBet * 10**busdToken.decimals(), "Can't exceed max bet limit");
        require(totalUSDValue >= casinoInfo.minBet * 10**busdToken.decimals(), "Can't be lower than min bet limit");

        casinoInfo.liquidity -= (maxReward - totalBetAmount);
        casinoInfo.locked += maxReward;

        IVRFv2Consumer vrfConsumer = IVRFv2Consumer(consumerAddress);
        uint256 requestId = vrfConsumer.requestRandomWords();
        _initializeBetInfo(tokenId, requestId, bets, bnbPrice);

        linkSpent += linkPerBet;

        emit InitializedBet(tokenId, msg.sender, totalBetAmount);
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
        return requestId;
    }

    /**
     * @dev retrieve nonce and spin the wheel, return reward if user wins
     *
     * @param tokenId tokenId of the Casino
     */
    function finishBet(uint256 tokenId) external nonReentrant {
        BetInfo storage betInfo = userLastBetInfo[msg.sender][tokenId];
        require(betInfo.isPending == true, 'Bet not pending');

        (bool fulfilled, uint256[] memory nonces) = IVRFv2Consumer(consumerAddress).getRequestStatus(betInfo.requestId);
        require(fulfilled == true, 'not yet fulfilled');

        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        uint256 decimal = casinoInfo.tokenAddress == address(0) ? 18 : IPRC20(casinoInfo.tokenAddress).decimals();
        (uint256 nonce, uint256 totalReward) = _spinWheel(betInfo.bets, nonces[0] % 38);
        uint256 totalBetAmount = _getTotalBetAmount(betInfo.bets);
        uint256 maxReward = getMaximumReward(betInfo.bets);
        uint256 totalUSDValue = (totalBetAmount * betInfo.tokenPrice) / 10**decimal;
        uint256 totalRewardUSD = (totalReward * betInfo.tokenPrice) / 10**decimal;

        betIds++;
        betInfo.isPending = false;

        if (totalReward > 0) {
            if (casinoInfo.tokenAddress != address(0)) {
                IPRC20(casinoInfo.tokenAddress).transfer(msg.sender, totalReward);
            } else {
                bool sent = payable(msg.sender).send(totalReward);
                require(sent, 'send fail');
            }
        }
        casinoInfo.liquidity = casinoInfo.liquidity + maxReward - totalReward;
        casinoInfo.locked -= maxReward;
        casinoInfo.profit = casinoInfo.profit + int256(totalBetAmount) - int256(totalReward);

        emit FinishedBet(
            tokenId,
            betIds,
            msg.sender,
            nonce,
            totalBetAmount,
            totalReward,
            totalUSDValue,
            totalRewardUSD,
            maxReward
        );
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
    }

    /**
     * @dev returns VRF nonce status for bet
     */
    function getBetResult(uint256 tokenId, address user) public view returns (bool, uint256) {
        BetInfo storage info = userLastBetInfo[user][tokenId];
        IVRFv2Consumer consumer = IVRFv2Consumer(consumerAddress);
        (bool fulfilled, uint256[] memory nonces) = consumer.getRequestStatus(info.requestId);
        return (fulfilled, nonces[0]);
    }

    /**
     * @dev adds liquidity to the casino pool
     * NOTE this is only for casinos that uses tokens
     */
    function addLiquidityWithTokens(uint256 tokenId, uint256 amount) external onlyCasinoOwner(tokenId) {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        require(casinoInfo.tokenAddress != address(0), "This casino doesn't support tokens");

        IERC20 token = IERC20(casinoInfo.tokenAddress);
        token.safeTransferFrom(msg.sender, address(this), amount);
        casinoInfo.liquidity += amount;
        emit AddedLiquidity(tokenId, msg.sender, amount);
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
    }

    /**
     * @dev adds liquidity to the casino pool
     * NOTE this is only for casinos that uses bnb
     */
    function addLiquidityWithEth(uint256 tokenId) external payable onlyCasinoOwner(tokenId) {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];

        require(casinoInfo.tokenAddress == address(0), "This casino doesn't supports bnb");
        casinoInfo.liquidity += msg.value;
        emit AddedLiquidity(tokenId, msg.sender, msg.value);
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
    }

    /**
     * @dev removes liquidity from the casino pool
     */
    function removeLiquidity(uint256 tokenId, uint256 amount) external onlyCasinoOwner(tokenId) {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        uint256 liquidity = casinoInfo.liquidity;

        require(int256(liquidity - amount) >= casinoInfo.profit, 'Cannot withdraw profit before it is fee taken');
        require(liquidity >= amount, 'Not enough liquidity');

        unchecked {
            casinoInfo.liquidity -= amount;
        }
        if (casinoInfo.tokenAddress != address(0)) {
            IERC20 token = IERC20(casinoInfo.tokenAddress);
            token.safeTransfer(msg.sender, amount);
        } else {
            bool sent = payable(msg.sender).send(amount);
            require(sent, 'Failed Transfer');
        }
        emit RemovedLiquidity(tokenId, msg.sender, amount);
        emit LiquidityChanged(tokenId, casinoInfo.liquidity);
    }

    /**
     * @dev update casino's current profit and liquidity.
     */
    function _updateProfitInfo(
        uint256 tokenId,
        uint256 fee,
        uint256 calculatedProfit
    ) internal {
        Casino storage casinoInfo = tokenIdToCasino[tokenId];
        casinoInfo.liquidity -= fee;
        casinoInfo.profit -= int256(calculatedProfit);
        casinoInfo.lastSwapTime = block.timestamp;
    }

    /**
     * @dev get usd price of a token by usdt
     */
    function _getTokenUsdPrice(address tokenAddress) internal view returns (uint256) {
        if (isStable[tokenAddress]) return 10**18;

        IPancakeRouter02 router = IPancakeRouter02(pancakeRouterAddr);
        IPRC20 token = IPRC20(tokenAddress);

        address[] memory path = new address[](3);
        path[0] = tokenAddress;
        path[1] = wbnbAddr;
        path[2] = busdAddr;
        uint256 usdValue = router.getAmountsOut(10**token.decimals(), path)[2];

        return usdValue;
    }

    /**
     * @dev Gets current pulse price in comparison with BNB and USDT
     */
    function getBNBPrice() public view returns (uint256 price) {
        IPancakeRouter02 router = IPancakeRouter02(pancakeRouterAddr);
        address[] memory path = new address[](2);
        path[0] = wbnbAddr;
        path[1] = busdAddr;
        uint256[] memory amounts = router.getAmountsOut(10**18, path);
        return amounts[1];
    }

    /**
     * @dev calculates value after applying slippage percent
     */
    function _calcSlippage(uint256 amount, uint256 slippage) internal pure returns (uint256 value) {
        return (amount * (100 - slippage)) / 100;
    }

    /**
     * @dev swaps profit fees of casinos into BNBP
     */
    function swapProfitFees() external {
        IPancakeRouter02 router = IPancakeRouter02(pancakeRouterAddr);

        address[] memory path = new address[](2);
        uint256 totalBNBFee;
        uint256 BNBPPool = 0;
        uint256 length = casinoCount;
        uint256[] memory amountsOut;
        uint256 slippage = 5;

        // Swap each token to BNB
        for (uint256 i = 1; i <= length; i++) {
            Casino memory casinoInfo = tokenIdToCasino[i];
            IERC20 token = IERC20(casinoInfo.tokenAddress);

            if (casinoInfo.profit <= 0 || casinoInfo.liquidity == 0) continue;

            uint256 availableProfit = uint256(casinoInfo.profit);
            if (casinoInfo.liquidity < availableProfit) {
                availableProfit = casinoInfo.liquidity;
            }

            uint256 balance = (availableProfit * casinoInfo.fee) / 100;

            if (casinoInfo.tokenAddress == address(0)) {
                totalBNBFee += uint256(balance);
                _updateProfitInfo(i, uint256(balance), availableProfit);
                continue;
            }
            if (casinoInfo.tokenAddress == BNBPAddress) {
                BNBPPool += uint256(balance);
                _updateProfitInfo(i, uint256(balance), availableProfit);
                continue;
            }

            path[0] = casinoInfo.tokenAddress;
            path[1] = wbnbAddr;

            token.approve(address(router), balance);
            amountsOut = router.getAmountsOut(balance, path);
            try
                router.swapExactTokensForETH(
                    balance,
                    _calcSlippage(amountsOut[1], slippage),
                    path,
                    address(this),
                    block.timestamp + 10000
                )
            returns (uint256[] memory swappedAmounts) {
                _updateProfitInfo(i, uint256(swappedAmounts[0]), availableProfit);
                totalBNBFee += swappedAmounts[1];
            } catch Error(string memory reason) {
                emit TokenSwapFailed(i, balance, reason, block.timestamp);
            } catch (bytes memory reason) {
                emit TokenSwapFailed(i, balance, string(reason), block.timestamp);
            }
        }

        if (totalBNBFee > 0) {
            // Convert to LINK
            path[0] = wbnbAddr;
            path[1] = linkTokenAddr;

            uint256 bnbForLink = router.getAmountsIn(linkSpent, path)[0];

            // If BNB fee is not enough for funding link, swap bnbp to supply more.
            if (bnbForLink > totalBNBFee) {
                if (BNBPPool > 0) {
                    path[0] = BNBPAddress;
                    path[1] = wbnbAddr;
                    uint256 bnbpForLink = router.getAmountsIn(bnbForLink - totalBNBFee, path)[0];
                    if (bnbpForLink > BNBPPool) {
                        bnbpForLink = BNBPPool;
                    }

                    uint256 bnbAmountOut = router.getAmountsOut(bnbpForLink, path)[1];
                    IERC20(BNBPAddress).approve(address(router), bnbpForLink);
                    uint256 swappedBNB = router.swapExactTokensForETH(
                        bnbpForLink,
                        _calcSlippage(bnbAmountOut, slippage),
                        path,
                        address(this),
                        block.timestamp + 10000
                    )[1];

                    totalBNBFee += swappedBNB;
                    BNBPPool -= bnbpForLink;

                    path[0] = wbnbAddr;
                    path[1] = linkTokenAddr;
                }
                bnbForLink = totalBNBFee;
            }

            // Swap BNB into Link Token
            uint256 linkAmountOut = router.getAmountsOut(bnbForLink, path)[1];
            uint256 linkAmount = router.swapExactETHForTokens{ value: bnbForLink }(
                _calcSlippage(linkAmountOut, slippage),
                path,
                address(this),
                block.timestamp + 10000
            )[1];

            // Convert Link to ERC677 Link
            IERC20(linkTokenAddr).approve(pegSwapAddr, linkAmount);
            PegSwap(pegSwapAddr).swap(linkAmount, linkTokenAddr, link677TokenAddr);

            // Fund VRF subscription account
            LinkTokenInterface(link677TokenAddr).transferAndCall(
                coordinatorAddr,
                linkAmount,
                abi.encode(subscriptionId)
            );
            emit SuppliedLink(linkAmount);

            // Swap the rest of BNB to BNBP
            uint256 leftBnbAmount = totalBNBFee - bnbForLink;
            if (leftBnbAmount > 0) {
                path[1] = BNBPAddress;
                amountsOut = router.getAmountsOut(leftBnbAmount, path);
                uint256 swappedBNBP = router.swapExactETHForTokens{ value: leftBnbAmount }(
                    _calcSlippage(amountsOut[1], slippage),
                    path,
                    address(this),
                    block.timestamp + 10000
                )[1];
                BNBPPool += swappedBNBP;
            }
        }

        if (BNBPPool > 0) {
            // add BNBP to tokenomics pool
            IERC20(BNBPAddress).approve(potAddress, BNBPPool);
            IPotLottery(potAddress).addAdminTokenValue(BNBPPool);

            emit SuppliedBNBP(BNBPPool);
        }
    }

    receive() external payable {}
}