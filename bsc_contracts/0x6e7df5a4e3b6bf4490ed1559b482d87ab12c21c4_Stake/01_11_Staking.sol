// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Whitelist is OwnableUpgradeable {
    mapping(address => bool) public whitelist;

    event WhitelistedAddressAdded(address addr);
    event WhitelistedAddressRemoved(address addr);

    /**
     * @dev Throws if called by any account that's not whitelisted.
     */
    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], 'not whitelisted');
        _;
    }

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @dev return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
        if (!whitelist[addr]) {
            whitelist[addr] = true;
            emit WhitelistedAddressAdded(addr);
            success = true;
        }
    }

    /**
     * @dev add addresses to the whitelist
     * @param addrs addresses
     * @dev return true if at least one address was added to the whitelist,
     * false if all addresses were already in the whitelist
     */
    function addAddressesToWhitelist(address[] memory addrs) onlyOwner public returns(bool success) {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (addAddressToWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

    /**
     * @dev remove an address from the whitelist
     * @param addr address
     * @dev return true if the address was removed from the whitelist,
     * false if the address wasn't in the whitelist in the first place
     */
    function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
        if (whitelist[addr]) {
            whitelist[addr] = false;
            emit WhitelistedAddressRemoved(addr);
            success = true;
        }
    }

    /**
     * @dev remove addresses from the whitelist
     * @param addrs addresses
     * @dev return true if at least one address was removed from the whitelist,
     * false if all addresses weren't in the whitelist in the first place
     */
    function removeAddressesFromWhitelist(address[] memory addrs) onlyOwner public returns(bool success) {
        for (uint256 i = 0; i < addrs.length; i++) {
            if (removeAddressFromWhitelist(addrs[i])) {
                success = true;
            }
        }
    }

}

interface Token {
    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}

interface cmnReferral {
    function payReferral(
        address,
        address,
        uint256,
        uint256
    ) external returns (bool);

    function setUserReferral(address, address) external returns (bool);

    function setReferralAddressesOfUsers(address, address)
        external
        returns (bool);

    function getUserReferral(address) external view returns (address);

    function getReferralAddressOfUsers(address)
        external
        view
        returns (address[] memory);

    function getUserByReferralCode(bytes3) external view returns (address);
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

contract Stake is Initializable, ContextUpgradeable, UUPSUpgradeable, Whitelist{
    using SafeMath for uint256;
    // using EnumerableSet for EnumerableSet.AddressSet;

    event RewardsTransferred(address holder, uint256 amount);

    enum UserActions {
        DEPOSIT,
        REFER,
        HARVEST,
        WITHDRAW,
        UNSTAKE,
        REINVEST,
        ALL
    }

    struct WhitelistUserDeposits{
        uint depositedTokens;
        uint depositedTokensInUSDT;
        uint withdrawnAmount;
        uint lastWithdrawTime;
    }

    struct UserDetails{
        uint depositedTokens;
        uint stakingTime;
        uint lastClaimedTime;
        uint totalEarnedTokens;
        uint rewardRateForUser;
        uint cmnStakePrice;
        uint userWithdrawPercenage;
        uint depositedTokensInUSDT;
    }

    struct BlackListDetails{
        bool isBlackListForDeposit;
        bool isBlackListForRefer;
        bool isBlackListForHarvest;
        bool isBlackListForWithdraw;
        bool isBlackListForUnstake;
        bool isBlackListForReinvest; 
    }

    IPancakeRouter02 public router;

    // deposit token contract address
    address public depositToken;

    // reward token contract address
    address public rewardToken;

    // referral contract address
    address public referralAddress;

    // reward rate in percentage per year
    uint256 public rewardRate;
    uint256 public rewardInterval;

    // Referral fee in percentage
    uint256 public referralFeeRate;

    uint256 public poolLimit;

    uint256 public poolLimitPerUser;

    uint256 public totalClaimedRewards;

    uint256 public totalStaked;

    uint256 public minAmount;

    uint256 public poolOpenTill;

    uint256 public poolExpiryTime;

    uint256 public cmnRate;

    uint256 private time;

    uint256 public harvestFee;

    uint256 public withdrawTimeLimit;

    uint256 public withdrawPercentage;

    bool public isHarvestOpen;

    bool public isUserLimit;

    // EnumerableSet.AddressSet private holders;
    address[] public holders;

    address[] public path;

    mapping(address => UserDetails) public userDetails;

    mapping(address => address) public myReferralAddresses; // get my referal address that i refer
    mapping(address => bool) public alreadyReferral;
    mapping(address => uint256) public pendingReward;
    mapping(address => BlackListDetails) public isBlackList;
    mapping(address => bool) public isWhitelistForEmergencyWithdraw;
    mapping(address => WhitelistUserDeposits) public whitelistUserDeposits;
    mapping(bytes3 => bool) public isReferCodeBlock;

    //new variables
    uint public reinvestCMNPrice;

    
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function setValues(
        address _depositTokens,
        address _rewardToken
    ) public onlyOwner {
        depositToken = _depositTokens;
        rewardToken = _rewardToken;
        rewardRate = 4800;
        rewardInterval = 47300000;
        poolOpenTill = block.timestamp.add(47300000);
        poolLimit = 10000000 ether;
        poolLimitPerUser = 10000000 ether;
        referralFeeRate = 0;
        poolExpiryTime = block.timestamp.add(47300000);
        time = 365 days;
        withdrawTimeLimit = 30 days;
        withdrawPercentage = 300;
        minAmount = 10;
    }

    function setPoolOpenTime(uint256 _time) public onlyOwner {
        poolOpenTill = block.timestamp.add(_time);
    }

    function setRewardRate(uint256 _rate) public onlyOwner {
        rewardRate = _rate;
    }

    function setPoolLimit(uint256 _amount) public onlyOwner {
        poolLimit = _amount;
    }

    function setPoolLimitperUser(uint256 _amount) public onlyOwner {
        poolLimitPerUser = _amount;
    }

    function setReferralFeeRate(uint256 _rate) public onlyOwner {
        referralFeeRate = _rate;
    }

    function setMinAmount(uint256 _amount) public onlyOwner {
        minAmount = _amount;
    }

    function setCMNPrice(uint256 _rate) public onlyOwner {
        cmnRate = _rate;
    }

    function setReferralAddress(address _referralAddress) public onlyOwner {
        referralAddress = _referralAddress;
    }

    function setTotalPoolIntervalTime(uint256 _time) public onlyOwner {
        time = _time;
    }

    function setWhitelistAddressForEmergencyWithdraw(address _user) public onlyOwner {
        isWhitelistForEmergencyWithdraw[_user] = true;
    }

    function setUserWithdrawPercentage(address _user, uint _percentage) public onlyOwner {
        userDetails[_user].userWithdrawPercenage = _percentage;
    }

    function blockReferCode(bytes3 code, bool value) public onlyOwner {
        isReferCodeBlock[code] = value;
    }

    function enableHarvest() public onlyOwner {
        isHarvestOpen = true;
    }

    function disableHarvest() public onlyOwner {
        isHarvestOpen = false;
    }

    function enableUserLimit() public onlyOwner {
        isUserLimit = true;
    }

    function disableUserLimit() public onlyOwner {
        isUserLimit = false;
    }

    function setHarvestFees(uint256 _fees) public onlyOwner {
        harvestFee = _fees;
    }

    function setPath(address path0, address path1) public onlyOwner{
        path.push(path0);
        path.push(path1);
    }

    function setRewardInterval(uint256 _time) public onlyOwner {
        rewardInterval = _time;
    }

    /**
     * @notice Only Holder - check holder is exists in our contract or not
     * @return bool value
     */
    function onlyHolder(address _holder) public view returns (bool) {
        bool condition = false;
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == _holder) {
                condition = true;
                return true;
            }
        }
        return false;
    }

    function _setAddressBlackList(address _userAddress, UserActions _action)
        internal
    {
        if (_action == UserActions.DEPOSIT) {
            isBlackList[_userAddress].isBlackListForDeposit = true;
        } else if (_action == UserActions.REFER) {
            isBlackList[_userAddress].isBlackListForRefer = true;
        } else if (_action == UserActions.HARVEST) {
            isBlackList[_userAddress].isBlackListForHarvest = true;
        } else if (_action == UserActions.WITHDRAW) {
            isBlackList[_userAddress].isBlackListForWithdraw = true;
        } else if (_action == UserActions.UNSTAKE) {
            isBlackList[_userAddress].isBlackListForUnstake = true;
        } else if (_action == UserActions.REINVEST) {
            isBlackList[_userAddress].isBlackListForReinvest = true;
        } else if (_action == UserActions.ALL) {
            isBlackList[_userAddress].isBlackListForDeposit = true;
            isBlackList[_userAddress].isBlackListForRefer = true;
            isBlackList[_userAddress].isBlackListForHarvest = true;
            isBlackList[_userAddress].isBlackListForWithdraw = true;
            isBlackList[_userAddress].isBlackListForUnstake = true;
            isBlackList[_userAddress].isBlackListForReinvest = true;
        }
    }

    function setAddressUnBlackList(address _userAddress, UserActions _action)
        public onlyOwner
    {
        if (_action == UserActions.DEPOSIT) {
            isBlackList[_userAddress].isBlackListForDeposit = false;
        } else if (_action == UserActions.REFER) {
            isBlackList[_userAddress].isBlackListForRefer = false;
        } else if (_action == UserActions.HARVEST) {
            isBlackList[_userAddress].isBlackListForHarvest = false;
        } else if (_action == UserActions.WITHDRAW) {
            isBlackList[_userAddress].isBlackListForWithdraw = false;
        } else if (_action == UserActions.UNSTAKE) {
            isBlackList[_userAddress].isBlackListForUnstake = false;
        } else if (_action == UserActions.REINVEST) {
            isBlackList[_userAddress].isBlackListForReinvest = false;
        } else if (_action == UserActions.ALL) {
            isBlackList[_userAddress].isBlackListForDeposit = false;
            isBlackList[_userAddress].isBlackListForRefer = false;
            isBlackList[_userAddress].isBlackListForHarvest = false;
            isBlackList[_userAddress].isBlackListForWithdraw = false;
            isBlackList[_userAddress].isBlackListForUnstake = false;
            isBlackList[_userAddress].isBlackListForReinvest = false;
        }
    }

    function updateAccount(address account) private {

        uint256 pendingDivs = getPendingDivs(account);
        if (pendingDivs > 0) {
            uint256 fee = pendingDivs.mul(harvestFee).div(1e4);
            uint256 amountAfterFee = pendingDivs.sub(fee);
            require(
                Token(depositToken).transfer(account, amountAfterFee.div(cmnRate).mul(100)),
                "Could not transfer tokens."
            );
            require(
                Token(depositToken).transfer(owner(), fee.div(cmnRate).mul(100)),
                "Could not transfer tokens."
            );
            userDetails[account].totalEarnedTokens = userDetails[account].totalEarnedTokens.add(
                pendingDivs
            );
            totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
            emit RewardsTransferred(account, pendingDivs);
        }
        userDetails[account].lastClaimedTime = block.timestamp;
    }

    function getPendingDivs(address _holder) public view returns (uint256) {
        if (!onlyHolder(_holder)) return 0;
        if (userDetails[_holder].depositedTokens == 0) return 0;

        if(userDetails[_holder].stakingTime.add(rewardInterval) < userDetails[_holder].lastClaimedTime){
            return 0;
        }

        if(isBlackList[msg.sender].isBlackListForHarvest){
            uint256 deployTime = 1668058390;
            uint256 timeDiff;
            if(userDetails[_holder].lastClaimedTime < deployTime){
                timeDiff = deployTime.sub(userDetails[_holder].lastClaimedTime);
            }else{
                return 0;
            }

            uint256 pendingDivs = userDetails[_holder].depositedTokensInUSDT
                .mul(userDetails[_holder].rewardRateForUser)
                .mul(timeDiff)
                .div(time)
                .div(1e4);

            return (pendingDivs).add(pendingReward[_holder]);
        }else{

            // uint256 timeDiff = block.timestamp.sub(lastClaimedTime[_holder]);
            uint256 timeDiff;
            block.timestamp <= userDetails[_holder].stakingTime.add(rewardInterval)
                ? timeDiff = block.timestamp.sub(userDetails[_holder].lastClaimedTime)
                : timeDiff = userDetails[_holder].stakingTime.add(rewardInterval).sub(
                userDetails[_holder].lastClaimedTime
            );
            // uint256 stakedAmount = userDetails[_holder].depositedTokens;

            uint256 pendingDivs = userDetails[_holder].depositedTokensInUSDT
                .mul(userDetails[_holder].rewardRateForUser)
                .mul(timeDiff)
                .div(time)
                .div(1e4);

            return (pendingDivs).add(pendingReward[_holder]);
        }

    }

    function getNumberOfHolders() public view returns (uint256) {
        return holders.length;
    }

    function deposit(address userAddress, uint256 amountToStake) public {
        // require(block.timestamp <= poolExpiryTime, "Pool is expired");
        require(block.timestamp <= poolOpenTill, "Pool is closed");
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(!isBlackList[userAddress].isBlackListForDeposit, "User is blacklisted");
        // require(
        //     totalStaked.add(amountToStake) <= poolLimit,
        //     "Pool limit reached"
        // );
        if (isUserLimit) {
            require(
                userDetails[userAddress].depositedTokens.add(amountToStake) <=
                    poolLimitPerUser,
                "Pool limit reached"
            );
        }
        require(
            amountToStake.div(1e18).mul(cmnRate) >= minAmount,
            "Staking amount is less than min value"
        );
        require(
            Token(depositToken).transferFrom(
                msg.sender,
                address(this),
                amountToStake
            ),
            "Insufficient Token Allowance"
        );

        updateAccount(userAddress);

        address myReferralAddredd = myReferralAddresses[userAddress];

        if (
            amountToStake > 0 &&
            myReferralAddredd != address(0) &&
            myReferralAddredd != userAddress
        ) {
            require(
                cmnReferral(referralAddress).payReferral(
                    userAddress,
                    userAddress,
                    0,
                    amountToStake
                ),
                "Can't pay referral"
            );
        }

        userDetails[userAddress].depositedTokens = userDetails[userAddress].depositedTokens.add(
            amountToStake
        );
        userDetails[userAddress].depositedTokensInUSDT = userDetails[userAddress].depositedTokensInUSDT.add(
            amountToStake.mul(cmnRate).div(100)
        );

        if(whitelist[userAddress]){
            if(whitelistUserDeposits[userAddress].depositedTokens == 0){
                whitelistUserDeposits[userAddress].depositedTokens = amountToStake;
                whitelistUserDeposits[userAddress].depositedTokensInUSDT = amountToStake.mul(cmnRate).div(100);
                whitelistUserDeposits[userAddress].lastWithdrawTime = block.timestamp;
            }
        }
            

        totalStaked = totalStaked.add(amountToStake);
        userDetails[userAddress].cmnStakePrice = cmnRate;

        if (!onlyHolder(userAddress)) {
            holders.push(userAddress);
            userDetails[userAddress].stakingTime = block.timestamp;
            userDetails[userAddress].rewardRateForUser = rewardRate;
        }
    }

    function depositWithReferral(
        address userAddress,
        uint256 amountToStake,
        bytes3 referralCode
    ) public {
        require(!isReferCodeBlock[referralCode], "Refer code blocked");
        // require(block.timestamp <= poolExpiryTime, "Pool is expired");
        require(block.timestamp <= poolOpenTill, "Pool is closed");
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(!isBlackList[userAddress].isBlackListForDeposit, "User is blacklisted");
        // require(
        //     totalStaked.add(amountToStake) <= poolLimit,
        //     "Pool limit reached"
        // );
        if (isUserLimit) {
            require(
                userDetails[userAddress].depositedTokens.add(amountToStake) <=
                    poolLimitPerUser,
                "Pool limit reached"
            );
        }
        require(userDetails[userAddress].depositedTokens == 0, "Invalid Contract Call");
        require(
            amountToStake.div(1e18).mul(cmnRate) >= minAmount,
            "Staking amount is less than min value"
        );
        require(
            !alreadyReferral[userAddress],
            "You can't use refer program multiple times"
        );
        require(
            Token(depositToken).transferFrom(
                msg.sender,
                address(this),
                amountToStake
            ),
            "Insufficient Token Allowance"
        );

        address referral = cmnReferral(referralAddress).getUserByReferralCode(
            referralCode
        );
        require(referral != address(0), "Please enter valid referral code");

        updateAccount(userAddress);

        if (
            amountToStake > 0 &&
            referral != address(0) &&
            referral != userAddress
        ) {
            require(!isBlackList[userAddress].isBlackListForRefer, "User is blacklisted");
            alreadyReferral[userAddress] = true;
            myReferralAddresses[userAddress] = referral;

            require(
                cmnReferral(referralAddress).setUserReferral(
                    userAddress,
                    referral
                ),
                "Can't set user referral"
            );

            require(
                cmnReferral(referralAddress).setReferralAddressesOfUsers(
                    userAddress,
                    referral
                ),
                "Can't update referral list"
            );

            require(
                cmnReferral(referralAddress).payReferral(
                    userAddress,
                    userAddress,
                    0,
                    amountToStake
                ),
                "Can't pay referral"
            );
        }

        userDetails[userAddress].depositedTokens = userDetails[userAddress].depositedTokens.add(
            amountToStake
        );

        userDetails[userAddress].depositedTokensInUSDT = userDetails[userAddress].depositedTokensInUSDT.add(
            amountToStake.mul(cmnRate).div(100)
        );

        if(whitelist[userAddress]){
            if(whitelistUserDeposits[userAddress].depositedTokens == 0){
                whitelistUserDeposits[userAddress].depositedTokens = amountToStake;
                whitelistUserDeposits[userAddress].depositedTokensInUSDT = amountToStake.mul(cmnRate).div(100);
                whitelistUserDeposits[userAddress].lastWithdrawTime = block.timestamp;
            }
        }

        totalStaked = totalStaked.add(amountToStake);
        userDetails[userAddress].cmnStakePrice = cmnRate;

        if (!onlyHolder(userAddress)) {
            holders.push(userAddress);
            userDetails[userAddress].stakingTime = block.timestamp;
            userDetails[userAddress].rewardRateForUser = rewardRate;
        }
    }

    function depositUSDT(address userAddress, uint256 amountToStake) public {
        // require(block.timestamp <= poolExpiryTime, "Pool is expired");
        require(block.timestamp <= poolOpenTill, "Pool is closed");
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(!isBlackList[userAddress].isBlackListForDeposit, "User is blacklisted");
        // require(
        //     totalStaked.add(amountToStake) <= poolLimit,
        //     "Pool limit reached"
        // );
        require(
            amountToStake.div(1e18) >= minAmount.div(1e2),
            "Staking amount is less than min value"
        );
        require(
            Token(rewardToken).transferFrom(
                msg.sender,
                address(this),
                amountToStake
            ),
            "Insufficient Token Allowance"
        );

        updateAccount(userAddress);

        address myReferralAddredd = myReferralAddresses[userAddress];

        if (
            amountToStake > 0 &&
            myReferralAddredd != address(0) &&
            myReferralAddredd != userAddress
        ) {
            require(
                cmnReferral(referralAddress).payReferral(
                    userAddress,
                    userAddress,
                    0,
                    amountToStake.div(cmnRate).mul(100)
                ),
                "Can't pay referral"
            );
        }

        userDetails[userAddress].depositedTokens = userDetails[userAddress].depositedTokens.add(
            amountToStake.div(cmnRate).mul(100)
        );

        userDetails[userAddress].depositedTokensInUSDT = userDetails[userAddress].depositedTokensInUSDT.add(
            amountToStake
        );

        if(whitelist[userAddress]){
            if(whitelistUserDeposits[userAddress].depositedTokens == 0){
                whitelistUserDeposits[userAddress].depositedTokens = amountToStake.div(cmnRate).mul(100);
                whitelistUserDeposits[userAddress].depositedTokensInUSDT = amountToStake;
                whitelistUserDeposits[userAddress].lastWithdrawTime = block.timestamp;
            }
        }

        totalStaked = totalStaked.add(amountToStake.div(cmnRate).mul(100));
        userDetails[userAddress].cmnStakePrice = cmnRate;

        if (!onlyHolder(userAddress)) {
            holders.push(userAddress);
            userDetails[userAddress].stakingTime = block.timestamp;
            userDetails[userAddress].rewardRateForUser = rewardRate;
        }
    }

    function depositUSDTWithReferral(
        address userAddress,
        uint256 amountToStake,
        bytes3 referralCode
    ) public {
        require(!isReferCodeBlock[referralCode], "Refer code blocked");
        // require(block.timestamp <= poolExpiryTime, "Pool is expired");
        require(block.timestamp <= poolOpenTill, "Pool is closed");
        require(amountToStake > 0, "Cannot deposit 0 Tokens");
        require(!isBlackList[userAddress].isBlackListForDeposit, "User is blacklisted");
        // require(
        //     totalStaked.add(amountToStake.div(1e8).div(cmnRate)) <= poolLimit,
        //     "Pool limit reached"
        // );
        require(userDetails[userAddress].depositedTokens == 0, "Invalid Contract Call");
        require(
            amountToStake.div(1e18) >= minAmount.div(1e2),
            "Staking amount is less than min value"
        );
        require(
            !alreadyReferral[userAddress],
            "You can't use refer program multiple times"
        );
        require(
            Token(rewardToken).transferFrom(
                msg.sender,
                address(this),
                amountToStake
            ),
            "Insufficient Token Allowance"
        );

        address referral = cmnReferral(referralAddress).getUserByReferralCode(
            referralCode
        );
        require(referral != address(0), "Please enter valid referral code");

        updateAccount(userAddress);

        if (
            amountToStake > 0 &&
            referral != address(0) &&
            referral != userAddress
        ) {
            require(!isBlackList[userAddress].isBlackListForRefer, "User is blacklisted");
            require(!isBlackList[referral].isBlackListForRefer, "User is blacklisted");
            alreadyReferral[userAddress] = true;
            myReferralAddresses[userAddress] = referral;

            cmnReferral(referralAddress).setUserReferral(userAddress, referral);

            cmnReferral(referralAddress).setReferralAddressesOfUsers(
                userAddress,
                referral
            );

            cmnReferral(referralAddress).payReferral(
                userAddress,
                userAddress,
                0,
                amountToStake.div(cmnRate).mul(100)
            );
        }

        userDetails[userAddress].depositedTokens = userDetails[userAddress].depositedTokens.add(
            amountToStake.div(cmnRate).mul(100)
        );
        userDetails[userAddress].depositedTokensInUSDT = userDetails[userAddress].depositedTokensInUSDT.add(
            amountToStake
        );

        if(whitelist[userAddress]){
            if(whitelistUserDeposits[userAddress].depositedTokens == 0){
                whitelistUserDeposits[userAddress].depositedTokens = amountToStake.div(cmnRate).mul(100);
                whitelistUserDeposits[userAddress].depositedTokensInUSDT = amountToStake;
                whitelistUserDeposits[userAddress].lastWithdrawTime = block.timestamp;
            }
        }

        totalStaked = totalStaked.add(amountToStake.div(cmnRate).mul(100));
        userDetails[userAddress].cmnStakePrice = cmnRate;

        if (!onlyHolder(userAddress)) {
            holders.push(userAddress);
            userDetails[userAddress].stakingTime = block.timestamp;
            userDetails[userAddress].rewardRateForUser = rewardRate;
        }
    }

    function withdraw() public onlyWhitelisted {
        require(!isBlackList[msg.sender].isBlackListForWithdraw, "User is blacklisted");

        require(getIsWithdrawAvailable(msg.sender), "Withdraw not available");

        uint256 temp = userDetails[msg.sender].userWithdrawPercenage != 0 ? userDetails[msg.sender].userWithdrawPercenage : withdrawPercentage;

        uint256 tokentoSend = whitelistUserDeposits[msg.sender].depositedTokensInUSDT.mul(temp).div(10000);

        updateAccount(msg.sender);
        
        require(
            Token(rewardToken).transfer(msg.sender, tokentoSend),
            "Could not transfer tokens."
        );

        userDetails[msg.sender].depositedTokens = userDetails[msg.sender].depositedTokens.sub(
            tokentoSend.div(reinvestCMNPrice).mul(100)
        );

        userDetails[msg.sender].depositedTokensInUSDT = userDetails[msg.sender].depositedTokensInUSDT.sub(
            tokentoSend
        );
        
        whitelistUserDeposits[msg.sender].withdrawnAmount = whitelistUserDeposits[msg.sender].withdrawnAmount.add(tokentoSend);  
        
        if (onlyHolder(msg.sender) &&  userDetails[msg.sender].depositedTokens == 0) {
            for (uint256 i = 0; i < holders.length; i++) {
                if (holders[i] == msg.sender) {
                    delete holders[i];
                }
            }
        }
        whitelistUserDeposits[msg.sender].lastWithdrawTime = block.timestamp;
    }

    function unstake(uint256 amountToWithdraw) public {
        require(
             userDetails[msg.sender].depositedTokens >= amountToWithdraw,
            "Invalid amount to withdraw"
        );

        require(!isBlackList[msg.sender].isBlackListForUnstake, "User is blacklisted");

        require(
            block.timestamp.sub( userDetails[msg.sender].stakingTime) > rewardInterval,
            "You recently staked, please wait before withdrawing."
        );
        updateAccount(msg.sender);

        require(
            Token(depositToken).transfer(msg.sender, amountToWithdraw),
            "Could not transfer tokens."
        );

         userDetails[msg.sender].depositedTokens =  userDetails[msg.sender].depositedTokens.sub(
            amountToWithdraw
        );

        if (onlyHolder(msg.sender) &&  userDetails[msg.sender].depositedTokens == 0) {
            for (uint256 i = 0; i < holders.length; i++) {
                if (holders[i] == msg.sender) {
                    delete holders[i];
                }
            }
        }


    }

    function emergencyWithdraw() public {
        require(
            isWhitelistForEmergencyWithdraw[msg.sender],
            "User is not whitelisted"
        );

         userDetails[msg.sender].depositedTokens = 0;

        if (onlyHolder(msg.sender) &&  userDetails[msg.sender].depositedTokens == 0) {
            for (uint256 i = 0; i < holders.length; i++) {
                if (holders[i] == msg.sender) {
                    delete holders[i];
                }
            }
        }
        isWhitelistForEmergencyWithdraw[msg.sender] = false;
        require(
            Token(depositToken).transfer(
                msg.sender,
                 userDetails[msg.sender].depositedTokens
            ),
            "Could not transfer tokens."
        );
    }

    function claimDivs() public {
        require(isHarvestOpen, "Harvest is Closed now");
        // require(!isBlackList[msg.sender].isBlackListForHarvest, "User is blacklisted");
        updateAccount(msg.sender);
    }

    function reinvest() public {

        require(getIsWithdrawAvailable(msg.sender), "Withdraw/Reinvest not available");
        require(!isBlackList[msg.sender].isBlackListForReinvest, "User is blacklisted");

        uint256 temp = userDetails[msg.sender].userWithdrawPercenage != 0 ? userDetails[msg.sender].userWithdrawPercenage : withdrawPercentage;

        uint256 amountToStake = whitelistUserDeposits[msg.sender].depositedTokensInUSDT.mul(temp).div(10000);
        uint256 cmnAtPreviousPrice = amountToStake.div(reinvestCMNPrice).mul(100);
        
        updateAccount(msg.sender);

        userDetails[msg.sender].depositedTokensInUSDT =  userDetails[msg.sender].depositedTokensInUSDT.sub(
            amountToStake
        ).add(cmnAtPreviousPrice.mul(cmnRate).div(100));

        userDetails[msg.sender].cmnStakePrice = cmnRate;
        whitelistUserDeposits[msg.sender].lastWithdrawTime = block.timestamp;

    }

    function getIsWithdrawAvailable(address userAddress) public view returns(bool){
        if(block.timestamp >= whitelistUserDeposits[userAddress].lastWithdrawTime.add(withdrawTimeLimit)){
            return true;
        }
        return false;
    }

    // function setWithdrawTimeLimit(uint _time) public onlyOwner {
    //     withdrawTimeLimit = _time;
    // }

    function getStakersList(uint256 startIndex, uint256 endIndex)
        public
        view
        returns (
            address[] memory stakers,
            uint256[] memory stakingTimestamps,
            uint256[] memory lastClaimedTimeStamps,
            uint256[] memory stakedTokens
        )
    {
        require(startIndex < endIndex);

        uint256 length = endIndex.sub(startIndex);
        address[] memory _stakers = new address[](length);
        uint256[] memory _stakingTimestamps = new uint256[](length);
        uint256[] memory _lastClaimedTimeStamps = new uint256[](length);
        uint256[] memory _stakedTokens = new uint256[](length);

        for (uint256 i = startIndex; i < endIndex; i = i.add(1)) {
            address staker = holders[i];
            uint256 listIndex = i.sub(startIndex);
            _stakers[listIndex] = staker;
            _stakingTimestamps[listIndex] =  userDetails[staker].stakingTime;
            _lastClaimedTimeStamps[listIndex] = userDetails[staker].lastClaimedTime;
            _stakedTokens[listIndex] = userDetails[staker].depositedTokens;
        }

        return (
            _stakers,
            _stakingTimestamps,
            _lastClaimedTimeStamps,
            _stakedTokens
        );
    }

    uint256 private constant stakingAndDaoTokens = 5129e18;

    function getStakingAndDaoAmount() public view returns (uint256) {
        if (totalClaimedRewards >= stakingAndDaoTokens) {
            return 0;
        }
        uint256 remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
        return remaining;
    }

    // function to allow admin to claim *other* BEP20 tokens sent to this contract (by mistake)
    function transferAnyBEP20Tokens(
        address _tokenAddr,
        address _to,
        uint256 _amount
    ) public onlyOwner {
        Token(_tokenAddr).transfer(_to, _amount);
    }

    // function getTokenPrice() public view returns(uint256){
    //     uint256[] memory tokenPrice = router.getAmountsOut(1 ether, path);
    //     return tokenPrice[1];
    // }

    // function getTokenToUSD(uint tokenAmount) public view returns(uint256){
    //     uint256[] memory tokenPrice = router.getAmountsOut(1 ether, path);
    //     return uint(tokenAmount).mul(tokenPrice[1]).div(1e18);
    // }

    // function getUSDToToken(uint usdAmount) public view returns(uint256){
    //     uint256[] memory tokenPrice = router.getAmountsOut(1 ether, path);
    //     return (usdAmount.mul(1e18)).div(tokenPrice[1]);
    // }

    function _isBlackListForDeposit(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForDeposit;
    }

    function _isBlackListForHarvest(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForHarvest;
    }

    function _isBlackListForRefer(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForRefer;
    }

    function _isBlackListForReinvest(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForReinvest;
    }

    function _isBlackListForUnstake(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForUnstake;
    }

    function _isBlackListForWithdraw(address userAddress) public view returns(bool){
        return isBlackList[userAddress].isBlackListForWithdraw;
    }

    function _depositedTokens(address userAddress) public view returns(uint){
        return userDetails[userAddress].depositedTokens;
    }

    function _stakingTime(address userAddress) public view returns(uint){
        return userDetails[userAddress].stakingTime;
    }

    function _lastClaimedTime(address userAddress) public view returns(uint){
        return userDetails[userAddress].lastClaimedTime;
    }

    function _totalEarnedTokens(address userAddress) public view returns(uint){
        return userDetails[userAddress].totalEarnedTokens;
    }

    function _rewardRateForUser(address userAddress) public view returns(uint){
        return userDetails[userAddress].rewardRateForUser;
    }

    function _cmnStakePrice(address userAddress) public view returns(uint){
        return userDetails[userAddress].cmnStakePrice;
    }

    function _userWithdrawPercenage(address userAddress) public view returns(uint){
        return userDetails[userAddress].userWithdrawPercenage;
    }

    // function updateWhitelist(address userAddress) public onlyOwner{
    //      if(whitelist[userAddress]){
    //         whitelistUserDeposits[userAddress].depositedTokens = userDetails[userAddress].depositedTokens;
    //         whitelistUserDeposits[userAddress].depositedTokensInUSDT = userDetails[userAddress].depositedTokens.mul(cmnRate).div(100);
    //         whitelistUserDeposits[userAddress].lastWithdrawTime = userDetails[userAddress].lastClaimedTime;
    //     }
    // } 

    // function updateUSDTValue(address[] memory userAddress) public onlyOwner{
    //     for(uint i = 0; i < userAddress.length; i++){
    //         userDetails[userAddress[i]].depositedTokensInUSDT = userDetails[userAddress[i]].depositedTokens.mul(cmnRate).div(100);
    //     }
    // }

    function updateReinvestCMNPrice(uint value) public onlyOwner{
        reinvestCMNPrice = value;
    }

    function setAddressBlacklistBulk(address[] memory _userAddress, UserActions _action) public onlyOwner{
        for(uint i; i < _userAddress.length; i++){
            _setAddressBlackList(_userAddress[i], _action);
        }   
    }

}