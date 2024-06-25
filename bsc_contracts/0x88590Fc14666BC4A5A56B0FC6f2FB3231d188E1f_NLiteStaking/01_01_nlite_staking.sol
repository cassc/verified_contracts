// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

library TransferHelper {
    function safeTransfer(address token, address to, uint256 value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FAILED"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FROM_FAILED"
        );
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
}

interface StakeInfo {
    // 每个用户的信息。
    struct UserInfo {
        uint256 stakedOf; // 用户提供了多少 LP 代币。
        uint256 rewardOf; // 用户已经获取的奖励
        uint256 duration; //质押周期
        uint256 lastDepositAt; //最后质押时间
        uint256 lastRewardAt; //最后领奖时间
        uint256 userReward; //用户奖励
    }

    // 每个池的信息。
    struct PoolInfo {
        uint256 totalStaked; // 总股份
        address lpToken; // LP 代币合约地址。
        uint256 duration; //质押周期
        uint256 allocPoint; // 分配给此池的分配点数。
        uint256 accPerShare; // 质押一个LPToken的全局收益
    }
}

contract NLiteStaking is StakeInfo {
    address public immutable tokenAddress; // token合约地址
    address public owner; // 合约所有者

    uint256 public bonusDay = 30; //20 d
    uint256 public constant bonusDuration = 1 days; // 奖励周期 86400
    uint256 public unstakeDuration = 1 days; // 活期解压周期 86400
    uint256 public autoDelay = 3 * bonusDuration; // 过期3个分红周期(3d),自动延期

    bool public isStaking = true; // 是否开启质押
    bool public closeUnstake; // 关闭的池子允许直接解押
    bool public isBonus; // 是否开启奖励
    uint256 public totalAllocPoint; // 总分配点数。 必须是所有池中所有分配点的总和。

    uint256 public poolLength;
    mapping(address => mapping(uint256 => bool)) public isPool;
    mapping(address => mapping(uint256 => uint256)) public poolId; // token=>duration=>pid
    mapping(uint256 => PoolInfo) public poolInfo; //质押池详情 pid => info
    mapping(uint256 => mapping(address => UserInfo)) public userInfo; // 用户信息 pid=>user=>user

    uint256 public totalReward; //总奖励
    uint256 public totalUsedReward; //总分红奖励
    uint256 public totalPendingReward; //总分红待领奖励
    uint256 public lastBonusEpoch; //上一次分红时间
    uint256 public lastBonusToken; //待分红的USD

    constructor(address token_) {
        tokenAddress = token_;
        owner = msg.sender;
    }

    // 质押事件
    event Staked(
        address indexed from,
        address indexed lpToken,
        uint256 _duration,
        uint256 amount
    );
    // 取消质押事件
    event Unstaked(
        address indexed to,
        address indexed lpToken,
        uint256 _duration,
        uint256 amount
    );
    // 领取奖励事件
    event Reward(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function setBonusDay(uint256 day) external onlyOwner {
        bonusDay = day;
    }

    function setUnstakeDuration(uint256 _duration) external onlyOwner {
        unstakeDuration = _duration;
    }

    function setStaking(bool _isStaking) external onlyOwner {
        isStaking = _isStaking;
    }

    function setCloseUnstake(bool value) external onlyOwner {
        closeUnstake = value;
    }

    function setIsBonus(bool value) external onlyOwner {
        isBonus = value;
    }

    function setAutoDelay(uint256 value) external onlyOwner {
        autoDelay = value;
    }

    function getPool(
        uint256 pid
    ) external view returns (PoolInfo memory _pool) {
        return poolInfo[pid];
    }

    function withdrawToken(
        address token_,
        address to_,
        uint256 amount_
    ) external onlyOwner {
        TransferHelper.safeTransfer(token_, to_, amount_);
    }

    // 添加新的周期池
    function addPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) external onlyOwner {
        _addPool(_lpToken, _duration, _allocPoint);
    }

    function _addPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) private {
        require(_lpToken != address(0), "invalid lp token");
        require(!isPool[_lpToken][_duration], "pool is exist"); //避免重复添加池

        totalAllocPoint += _allocPoint;
        uint256 pid = poolLength;
        poolLength += 1;

        isPool[_lpToken][_duration] = true;
        poolId[_lpToken][_duration] = pid;
        poolInfo[pid] = PoolInfo({
            totalStaked: 0,
            lpToken: _lpToken,
            duration: _duration,
            allocPoint: _allocPoint,
            accPerShare: 0
        });
    }

    // 更新周期分红权重
    function setPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) external onlyOwner {
        require(isPool[_lpToken][_duration], "pool is not exist");

        uint256 pid = poolId[_lpToken][_duration];
        totalAllocPoint =
            totalAllocPoint -
            poolInfo[pid].allocPoint +
            _allocPoint;
        poolInfo[pid].allocPoint = _allocPoint;
    }

    //存入奖励
    function depositReward(uint256 amount_) external {
        uint balanceBefore = IERC20(tokenAddress).balanceOf(address(this)); //兼容有手续费的代币
        TransferHelper.safeTransferFrom(
            tokenAddress,
            msg.sender,
            address(this),
            amount_
        );

        uint balanceAdd = IERC20(tokenAddress).balanceOf(address(this)) -
            balanceBefore; //兼容有手续费的代币
        totalReward += balanceAdd;
    }

    // 获取下一次待分红的奖励
    function getPendingReward() public view returns (uint256) {
        return (totalReward - totalUsedReward) / bonusDay;
    }

    // 更新分红奖励
    function bonusReward() external {
        require(isBonus, "Bonus is not enabled");
        require(totalAllocPoint > 0, "No pool");
        uint256 _epoch_day = block.timestamp / bonusDuration;
        require(_epoch_day > lastBonusEpoch, "Error: lastBonusEpoch");

        _bonusReward();
    }

    function _bonusReward() private {
        if (isBonus && totalAllocPoint > 0) {
            uint256 _epoch_day = block.timestamp / bonusDuration;
            if (_epoch_day > lastBonusEpoch) {
                lastBonusEpoch = _epoch_day;
                lastBonusToken = getPendingReward(); //本次可分红数量
                if (lastBonusToken > 0) {
                    for (uint256 pid = 0; pid < poolLength; ++pid) {
                        _updatePool(pid);
                    }
                }
            }
        }
    }

    function _updatePool(uint256 pid) private {
        if (poolInfo[pid].allocPoint > 0 && poolInfo[pid].totalStaked > 0) {
            uint256 _reward = (lastBonusToken * poolInfo[pid].allocPoint) /
                totalAllocPoint;

            poolInfo[pid].accPerShare +=
                (_reward * 1e12) /
                poolInfo[pid].totalStaked;

            //记录总分红
            totalUsedReward += _reward;
            totalPendingReward += _reward;
        }
    }

    // 质押
    function stake(uint256 pid, uint256 amount) external returns (bool) {
        require(isStaking, "Staking is not enabled");
        require(amount > 0, "stake must be integer multiple of 1 USD.");
        require(poolInfo[pid].allocPoint > 0, "stake pool is closed");

        _bonusReward(); //更新分红奖励
        UserInfo storage user = userInfo[pid][msg.sender];
        if (user.stakedOf > 0) {
            // 领取之前的奖励
            uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) /
                1e12) - user.rewardOf;
            safeTransfer(pid, msg.sender, pending);
        }

        uint balanceBefore = IERC20(poolInfo[pid].lpToken).balanceOf(
            address(this)
        ); //兼容有手续费的代币
        //转入质押
        TransferHelper.safeTransferFrom(
            poolInfo[pid].lpToken,
            msg.sender,
            address(this),
            amount
        );
        uint balanceAdd = IERC20(poolInfo[pid].lpToken).balanceOf(
            address(this)
        ) - balanceBefore; //兼容有手续费的代币

        user.duration = poolInfo[pid].duration;
        user.lastDepositAt = block.timestamp;
        // 更新用户质押的数量
        user.stakedOf += balanceAdd;
        // 更新已经领取的奖励
        user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;
        // 更新池子总票数
        poolInfo[pid].totalStaked += balanceAdd;

        // emit event
        emit Staked(
            msg.sender,
            poolInfo[pid].lpToken,
            poolInfo[pid].duration,
            balanceAdd
        );

        return true;
    }

    /**
     * 提取质押物
     */
    function unstake(
        uint256 pid,
        uint256 _amount
    ) external virtual returns (bool) {
        _bonusReward(); //更新分红奖励

        UserInfo storage user = userInfo[pid][msg.sender];
        require(
            user.stakedOf >= _amount,
            "The inserted amount is greater than the current user's stake"
        );
        require(_amount > 0, "The inserted amount must be greater than zero");

        // 领取之前的奖励
        uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) / 1e12) -
            user.rewardOf; // 关闭的池子允许直接解押
        if (pending > 0) {
            _takeReward(pid, msg.sender, pending);
        }

        // 关闭的池子允许直接解押
        if (poolInfo[pid].allocPoint == 0 && closeUnstake) {} else {
            require(
                block.timestamp - user.lastDepositAt >= unstakeDuration,
                "The time passed since the last deposit is less than unstakeDuration"
            ); //活期

            require(
                block.timestamp - user.lastDepositAt >= user.duration,
                "The time passed since the last deposit is less than user.duration"
            ); // 定期
        }

        _unstake(pid, _amount);
        return true;
    }

    function _unstake(uint256 pid, uint256 _amount) private {
        UserInfo storage user = userInfo[pid][msg.sender];
        if (_amount > user.stakedOf) {
            _amount = user.stakedOf;
        }

        poolInfo[pid].totalStaked -= _amount;
        // 更新用户质押的数量
        user.stakedOf -= _amount;
        // 更新已经领取的奖励
        user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;

        TransferHelper.safeTransfer(poolInfo[pid].lpToken, msg.sender, _amount);

        emit Unstaked(
            msg.sender,
            poolInfo[pid].lpToken,
            poolInfo[pid].duration,
            _amount
        );
    }

    function rewardAmount(
        address _account,
        uint256 pid
    ) external view returns (uint256) {
        uint256 pending;
        UserInfo memory _user = userInfo[pid][_account];
        if (_user.stakedOf > 0) {
            uint256 _accPerShare = poolInfo[pid].accPerShare;
            uint256 _epoch_day = block.timestamp / bonusDuration;
            if (
                isBonus &&
                _epoch_day > lastBonusEpoch &&
                poolInfo[pid].allocPoint > 0
            ) {
                uint256 _reward = (getPendingReward() *
                    poolInfo[pid].allocPoint) / totalAllocPoint;
                _accPerShare += (_reward * 1e12) / poolInfo[pid].totalStaked;
            }
            pending = ((_user.stakedOf * _accPerShare) / 1e12) - _user.rewardOf;
        }

        return pending;
    }

    function predictReward(
        address _account,
        uint256 pid
    ) external view returns (uint256) {
        uint256 pending;
        UserInfo memory _user = userInfo[pid][_account];
        if (_user.stakedOf > 0) {
            uint256 _accPerShare = poolInfo[pid].accPerShare;
            if (isBonus && poolInfo[pid].allocPoint > 0) {
                _accPerShare +=
                    (getPendingReward() * 1e12) /
                    poolInfo[pid].totalStaked;
            }
            pending = ((_user.stakedOf * _accPerShare) / 1e12) - _user.rewardOf;
        }
        return pending;
    }

    function _takeReward(
        uint256 pid,
        address _account,
        uint256 pending
    ) private {
        UserInfo storage user = userInfo[pid][_account];

        uint256 userDepositDuration = user.lastDepositAt + user.duration;
        //自动延期
        if (block.timestamp > autoDelay + userDepositDuration) {
            user.lastDepositAt = block.timestamp;
        }

        safeTransfer(pid, _account, pending);
    }

    // 直接领取收益
    function takeReward(uint256 pid) external {
        _bonusReward(); //更新分红奖励

        UserInfo storage user = userInfo[pid][msg.sender];
        require(user.stakedOf > 0, "Staking: out of staked");
        uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) / 1e12) -
            user.rewardOf;
        require(pending > 0, "Staking: no pending reward");

        _takeReward(pid, msg.sender, pending);
        if (
            user.duration > 0 &&
            (block.timestamp - user.lastDepositAt >= user.duration)
        ) {
            _unstake(pid, user.stakedOf);
        } else {
            user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;
        }
    }

    // 安全的转账功能，以防万一如果舍入错误导致池没有足够的奖励。
    function safeTransfer(
        uint256 pid,
        address _account,
        uint256 _amount
    ) private {
        if (_amount > 0) {
            if (_amount > totalPendingReward) {
                _amount = totalPendingReward;
            }

            UserInfo storage user = userInfo[pid][_account];
            totalPendingReward -= _amount;
            user.userReward += _amount;
            TransferHelper.safeTransfer(tokenAddress, _account, _amount);
            emit Reward(_account, _amount);
        }
    }
}