// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./utils/Initializable.sol";

import "./interface/IBentCVX.sol";
import "./interface/IERC20.sol";
import "./interface/IBentCVXStaking.sol";
import "./interface/IBentCVXRewarderV2.sol";
import "./vlBCVX3.sol";
import "./ReentrancyGuard.sol";

contract ConvexCDP is Initializable, ReentrancyGuardUpgradeable {
    address public admin;
    address public cvxAddress; // CVX Token Address
    address public bentCvxAddress; // bentCVX Token Address - Use this Address to Mint bentCVX Address
    address public vlBCVX3Address; // vlBCVX Token Address
    address public bentCVXStaker; // BentCVXRewarder - To Stake Reward
    address public bentCVXRewarder; // BentCVXRewarder - To Collect the reward
    uint256 public depositors;
    uint256 public totalSupply;

    struct PoolData {
        address rewardToken;
        uint256 accRewardPerShare; // Accumulated Rewards per share, times 1e36. See below.
        uint256 rewardRate;
        uint256 reserves;
    }
    mapping(address => uint256) internal userRewardDebt;
    mapping(address => uint256) internal userPendingRewards;

    mapping(address => uint256) public totalBalances;

    PoolData poolData;
    event Deposit(address indexed _from, uint _value);
    event Withdraw(address indexed _from, uint _value);
    event ClaimAll(address indexed _from, uint _value);
    event userClaim(address indexed _from, uint _amount);

    uint256 public windowLength; // amount of blocks where we assume around 12 sec per block
    // uint256 public minWindowLength = 7200; // minimum amount of blocks where 7200 = 1 day
    uint256 public endRewardBlock; // end block of rewards stream
    uint256 public lastRewardBlock; // last block of rewards streamed
    uint256 public harvesterFee; // percentage fee to onReward caller where 100 = 1%

    modifier onlyAdmin() {
        require(msg.sender == admin, "Invalid Admin");
        _;
    }

    function initialize(
        address _cvxAddress,
        address _bentCvxAddress,
        address _bentCVXStaker,
        address _bentCVXRewarder,
        address _vlBCVX3Address
    ) external initializer {
        admin = msg.sender;
        cvxAddress = _cvxAddress;
        bentCvxAddress = _bentCvxAddress;
        bentCVXStaker = _bentCVXStaker;
        vlBCVX3Address = _vlBCVX3Address;
        bentCVXRewarder = _bentCVXRewarder;
        poolData.rewardToken = _cvxAddress;
        windowLength = 7200;
        totalSupply = 0;
        harvesterFee = 0;
    }

    /**
     * @notice set Reward Harvest Fee.
     * @param _fee The Fee to Charge 1 = 1%;
     **/
    function setHarvesterFee(uint256 _fee) public onlyAdmin {
        //require(_fee <= 100, Errors.EXCEED_MAX_HARVESTER_FEE);
        harvesterFee = _fee;
    }

    /**
     * @notice set Window Length.
     * @param _windowLength Number of Blocks. 7200 =  1 day ;
     **/
    function setWindowLength(uint256 _windowLength) public onlyAdmin {
        // require(_windowLength >= minWindowLength, Errors.INVALID_WINDOW_LENGTH);
        windowLength = _windowLength;
    }

    /**
     * @notice set CVX Address
     * @param _address CVX Address
     **/
    function setCVXTokenAddress(address _address) public onlyAdmin {
        cvxAddress = _address;
    }

    /**
     * @notice set Bent Address
     * @param _address Bent Address
     **/
    function setBentCvxAddress(address _address) public onlyAdmin {
        bentCvxAddress = _address;
    }

    /**
     * @notice set 3vlBCVX Address
     * @param _address 3vlBCVX Address
     **/
    function setvlBCVX3Address(address _address) public onlyAdmin {
        vlBCVX3Address = _address;
    }

    function onTransfer(address user, address newOwner) external nonReentrant {
        require(msg.sender == vlBCVX3Address, "No Right To Call Transfer");
        uint256 userBalance = totalBalances[user];
        totalBalances[user] = 0;
        totalBalances[newOwner] = userBalance;
    }

    /**
     * @notice User Pending Reward
     **/
    function pendingReward(
        address user
    ) external view returns (uint256 pending) {
        if (pending != 0) {
            PoolData memory pool = poolData;

            uint256 addedRewards = _calcAddedRewards();
            uint256 newAccRewardPerShare = pool.accRewardPerShare +
                ((addedRewards * 1e36) / totalSupply);
            pending =
                userPendingRewards[user] +
                ((totalBalances[user] * newAccRewardPerShare) / 1e36) -
                userRewardDebt[user];
        }
    }

    /**
     * @notice Deposit CVX to Get 3vlBCVX
     * @param _amount Amount to deposit. 1 CVX for 1 3vlCVX
     **/
    function depositCVX(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Zero Amount is not acceptable");
        IERC20 cvxContract = IERC20(cvxAddress);
        IERC20 bentCvxContract = IERC20(bentCvxAddress);
        IBentCVX BentCVXContract = IBentCVX(bentCvxAddress);
        require(
            cvxContract.balanceOf(msg.sender) > 0 ||
                bentCvxContract.balanceOf(msg.sender) > 0,
            "Not Enough Balance"
        );
        _updateAccPerShare(true, msg.sender);
        BentCVXContract.approve(bentCVXStaker, _amount);
        if (bentCvxContract.balanceOf(msg.sender) >= _amount) {
            bentCvxContract.transferFrom(msg.sender, address(this), _amount);
            IBentCVXStaking(bentCVXStaker).deposit(_amount);
        } else if (cvxContract.balanceOf(msg.sender) >= _amount) {
            cvxContract.transferFrom(msg.sender, address(this), _amount);
            cvxContract.approve(bentCvxAddress, _amount);
            BentCVXContract.deposit(_amount);
            IBentCVXStaking(bentCVXStaker).deposit(_amount);
        }

        vlBCVX3 vlBCVX3Contract = vlBCVX3(vlBCVX3Address);
        vlBCVX3Contract.mintRequest(msg.sender, _amount);

        uint256 userAmount = totalBalances[msg.sender];
        if (userAmount == 0) depositors = depositors + 1;
        totalBalances[msg.sender] = userAmount + (_amount);
        totalSupply += _amount;
        _updateUserRewardDebt(msg.sender);
        emit Deposit(msg.sender, _amount);
    }

    /**
     * @notice withdraw CVX to Get 3vlBCVX
     * @param _amount Amount to Withdraw. 1 CVX for 1 3vlCVX
     **/
    function withdrawCVX(uint256 _amount) external nonReentrant {
        require(_amount > 0, "Zero Amount is not acceptable");
        require(
            totalBalances[msg.sender] >= _amount,
            "Sender have no enough Deposit"
        );
        _updateAccPerShare(true, msg.sender);

        vlBCVX3 vlBCVX3Contract = vlBCVX3(vlBCVX3Address);
        vlBCVX3Contract.burnRequest(msg.sender, _amount);
        IBentCVXStaking(bentCVXStaker).withdraw(_amount);
        IERC20 bentCvxContract = IERC20(bentCvxAddress);
        bentCvxContract.transfer(msg.sender, _amount);
        totalBalances[msg.sender] = totalBalances[msg.sender] - (_amount);
        totalSupply -= _amount;

        _updateUserRewardDebt(msg.sender);
        emit Withdraw(msg.sender, _amount);
    }

    /**
     * @notice Claim User Reward
     **/
    function claim() external nonReentrant {
        _updateAccPerShare(true, msg.sender);
        _claim(msg.sender);
        _updateUserRewardDebt(msg.sender);
    }

    function updateReserve() external nonReentrant onlyAdmin {
        poolData.reserves = IERC20(poolData.rewardToken).balanceOf(
            address(this)
        );
    }

    function change_admin(address _address) external onlyAdmin {
        require(address(0) != _address, "Can not Set Zero Address");
        admin = _address;
    }

    /**
     * @notice withdraw Any Token By Owner of Contract
     * @param _token token Address to withdraw
     * @param _amount Amount of token to withdraw
     **/
    function withdraw_admin(
        address _token,
        uint256 _amount
    ) external nonReentrant onlyAdmin {
        IERC20(_token).transfer(admin, _amount);
    }

    function _updateAccPerShare(bool withdrawReward, address user) internal {
        uint256 addedRewards = _calcAddedRewards();
        PoolData storage pool = poolData;
        if (totalSupply == 0) {
            pool.accRewardPerShare = block.number;
        } else {
            pool.accRewardPerShare += (addedRewards * (1e36)) / totalSupply;
        }

        if (withdrawReward) {
            uint256 pending = ((totalBalances[user] * pool.accRewardPerShare) /
                1e36) - userRewardDebt[user];

            if (pending > 0) {
                userPendingRewards[user] += pending;
            }
        }

        lastRewardBlock = block.number;
    }

    function _updateUserRewardDebt(address user) internal {
        userRewardDebt[user] =
            (totalBalances[user] * poolData.accRewardPerShare) /
            1e36;
    }

    function onReward() external nonReentrant {
        _updateAccPerShare(false, address(0));
        IBentCVXRewarderV2 bentCvxRewarderContract = IBentCVXRewarderV2(
            bentCVXRewarder
        );
        bentCvxRewarderContract.claimAll(address(this));
        bool newRewardsAvailable = false;
        PoolData storage pool = poolData;
        uint256 newRewards = IERC20(pool.rewardToken).balanceOf(address(this)) -
            pool.reserves;
        uint256 newRewardsFees = (newRewards * harvesterFee) / 10000;
        uint256 newRewardsFinal = newRewards - newRewardsFees;

        if (newRewardsFinal > 0) {
            newRewardsAvailable = true;
        }

        if (endRewardBlock > lastRewardBlock) {
            pool.rewardRate =
                (pool.rewardRate *
                    (endRewardBlock - lastRewardBlock) +
                    newRewardsFinal *
                    1e36) /
                windowLength;
        } else {
            pool.rewardRate = (newRewardsFinal * 1e36) / windowLength;
        }
        pool.reserves += newRewardsFinal;
        if (newRewardsFees > 0) {
            IERC20(pool.rewardToken).transfer(msg.sender, newRewardsFees);
        }

        require(newRewardsAvailable, "No Reward");
        endRewardBlock = lastRewardBlock + windowLength;
    }

    function _claim(address user) internal returns (uint256 claimAmount) {
        if (poolData.rewardToken == address(0)) {
            return 0;
        }
        claimAmount = userPendingRewards[user];
        if (claimAmount > 0) {
            IERC20(poolData.rewardToken).transfer(user, claimAmount);
            poolData.reserves -= claimAmount;
            userPendingRewards[user] = 0;
        }
    }

    function _calcAddedRewards() internal view returns (uint256 addedRewards) {
        uint256 startBlock = endRewardBlock > lastRewardBlock + windowLength
            ? endRewardBlock - windowLength
            : lastRewardBlock;
        uint256 endBlock = block.number > endRewardBlock
            ? endRewardBlock
            : block.number;
        uint256 duration = endBlock > startBlock ? endBlock - startBlock : 0;
        addedRewards = (poolData.rewardRate * duration) / 1e36;
    }
}