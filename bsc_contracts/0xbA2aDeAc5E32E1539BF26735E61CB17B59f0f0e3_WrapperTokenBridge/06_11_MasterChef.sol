// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.9;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { FarmingCompound } from "./FarmingCompound.sol";
import { FarmingVolatile } from "./FarmingVolatile.sol";

contract MasterChef is Initializable, Ownable, ReentrancyGuard
{
	using SafeERC20 for IERC20;

	struct PoolInfo {
		address token;
		uint256 allocPoint;
		uint256 lastRewardTime;
		uint256 accRewardPerShare;
		uint256 amount;
		uint256 depositFee;
		uint256 withdrawalFee;
		uint256 epochAccRewardPerShare;
	}

	struct UserInfo {
		uint256 amount;
		uint256 rewardDebt;
	}

	address constant FURNACE = 0x000000000000000000000000000000000000dEaD;

	address constant DEFAULT_FAUCET = 0x392681Eaf8AD9BC65e74BE37Afe7503D92802b7d; // multisig
	address constant DEFAULT_BANKROLL = 0x392681Eaf8AD9BC65e74BE37Afe7503D92802b7d; // multisig

	uint256 constant DEFAULT_LAUNCH_TIME = 1663178400; // 2022-09-14 6PM UTC

	uint256[4] public defaultFees = [2.5e16, 5e16, 10e16, 20e16];
	uint256[4] public defaultAllocs = [11.25e16, 16.25e16, 26.25e16, 46.25e16];

	uint256 public epochPeriod = 1 weeks;
	uint256[6] public epochLengthPerPeriod = [24 hours, 20 hours, 16 hours, 12 hours, 8 hours, 6 hours];

	address public rewardToken;
	address public tokenBridge;

	address public farmingCompound;
	address public farmingVolatile;

	address public faucet = DEFAULT_FAUCET;
	address public bankroll = DEFAULT_BANKROLL;

	uint256 public launchTime = DEFAULT_LAUNCH_TIME;
	uint256 public nextEpoch = launchTime + epochLengthPerPeriod[0];

	uint256 public rewardPerSec = 0;
	uint256 public totalAllocPoint = 0;

	uint256 public allocReward = 0;

	PoolInfo[] public poolInfo;

	mapping(uint256 => mapping(address => UserInfo)) public userInfo;

	function poolLength() external view returns (uint256 _poolLength)
	{
		return poolInfo.length;
	}

	function epochLength(uint256 _when) public view returns (uint256 _epochLength)
	{
		if (_when < launchTime) _when = launchTime;
		uint256 _i = (_when - launchTime) / epochPeriod;
		if (_i > 5) _i = 5;
		return epochLengthPerPeriod[_i];
	}

	modifier hasLaunched()
	{
		require(block.timestamp >= launchTime, "unavailable");
		_;
	}

	constructor(address _rewardToken, address _tokenBridge, address _farmingCompound, address _farmingVolatile)
	{
		initialize(msg.sender, _rewardToken, _tokenBridge, _farmingCompound, _farmingVolatile);
	}

	function initialize(address _owner, address _rewardToken, address _tokenBridge, address _farmingCompound, address _farmingVolatile) public initializer
	{
		_transferOwnership(_owner);

		defaultFees = [2.5e16, 5e16, 10e16, 20e16];
		defaultAllocs = [11.25e16, 16.25e16, 26.25e16, 46.25e16];

		epochPeriod = 1 weeks;
		epochLengthPerPeriod = [24 hours, 20 hours, 16 hours, 12 hours, 8 hours, 6 hours];

		faucet = DEFAULT_FAUCET;
		bankroll = DEFAULT_BANKROLL;

		launchTime = DEFAULT_LAUNCH_TIME;
		nextEpoch = launchTime + epochLengthPerPeriod[0];

		rewardPerSec = 0;
		totalAllocPoint = 0;

		allocReward = 0;

		rewardToken = _rewardToken;
		tokenBridge = _tokenBridge;

		farmingCompound = _farmingCompound;
		farmingVolatile = _farmingVolatile;
	}

	function setFaucet(address _faucet) external onlyOwner
	{
		require(_faucet != address(0), "invalid address");
		faucet = _faucet;
	}

	function setBankroll(address _bankroll) external onlyOwner
	{
		require(_bankroll != address(0), "invalid address");
		bankroll = _bankroll;
	}

	function setLaunchTime(uint256 _launchTime) external onlyOwner
	{
		require(block.timestamp < launchTime, "unavailable");
		require(_launchTime >= block.timestamp, "invalid time");
		launchTime = _launchTime;
		nextEpoch = _launchTime + epochLengthPerPeriod[0];
		for (uint256 _pid = 0; _pid < poolInfo.length; _pid++) {
			PoolInfo storage _poolInfo = poolInfo[_pid];
			if (_poolInfo.lastRewardTime == _launchTime) {
				_poolInfo.lastRewardTime = _launchTime;
			}
		}
	}

	function updateEpochPeriod(uint256 _period) external onlyOwner
	{
		require(_period > 0, "invalid period");
		epochPeriod = _period;
	}

	function updateEpochLengthPerPeriod(uint256 _i, uint256 _length) external onlyOwner
	{
		require(_i < 6, "invalid index");
		require(_length > 0, "invalid length");
		epochLengthPerPeriod[_i] = _length;
		if (block.timestamp < launchTime && _i == 0) {
			nextEpoch = launchTime + epochLengthPerPeriod[0];
		}
	}

	function updateRewardPerSec(uint256 _rewardPerSec) external onlyOwner nonReentrant
	{
		_massUpdatePools();
		rewardPerSec = _rewardPerSec;
	}

	function addCluster(address _token, uint256 _allocPoint, uint256 _startTime) external onlyOwner nonReentrant
	{
		require(_token != address(0), "invalid address");
		require(_startTime >= launchTime && _startTime >= block.timestamp, "invalid timestamp");
		_massUpdatePools();
		totalAllocPoint += _allocPoint;
		for (uint256 _i = 0; _i < 4; _i++) {
			poolInfo.push(PoolInfo({
				token: _token,
				allocPoint: _allocPoint * defaultAllocs[_i] / 100e16,
				lastRewardTime: _startTime,
				accRewardPerShare: 0,
				amount: 0,
				depositFee: defaultFees[_i],
				withdrawalFee: defaultFees[_i],
				epochAccRewardPerShare: 0
			}));
		}
	}

	function updateClusterAllocPoints(uint256 _pid, uint256 _allocPoint) external onlyOwner nonReentrant
	{
		require(_pid % 4 == 0, "invalid pid");
		_massUpdatePools();
		for (uint256 _i = 0; _i < 4; _i++) {
			PoolInfo storage _poolInfo = poolInfo[_pid + _i];
			totalAllocPoint -= _poolInfo.allocPoint;
			_poolInfo.allocPoint = _allocPoint * defaultAllocs[_i] / 100e16;
			totalAllocPoint += _poolInfo.allocPoint;
		}
	}

	function recoverLostFunds(address _token) external onlyOwner nonReentrant
	{
		uint256 _amount = 0;
		for (uint256 _pid = 0; _pid < poolInfo.length; _pid++) {
			PoolInfo storage _poolInfo = poolInfo[_pid];
			if (_token == _poolInfo.token) {
				_amount += _poolInfo.amount;
			}
		}
		uint256 _balance = IERC20(_token).balanceOf(address(this));
		IERC20(_token).safeTransfer(msg.sender, _balance - _amount);
	}

	function massUpdatePools() external nonReentrant
	{
		_massUpdatePools();
	}

	function updatePool(uint256 _pid) external nonReentrant
	{
		_updatePool(_pid);
	}

	function updateEpoch() external nonReentrant
	{
		_updateEpoch();
	}

	function deposit(uint256 _pid, uint256 _amount) external returns (uint256 _reward)
	{
		return depositOnBehalfOf(_pid, _amount, msg.sender);
	}

	function depositOnBehalfOf(uint256 _pid, uint256 _amount, address _account) public nonReentrant hasLaunched returns (uint256 _reward)
	{
		require(msg.sender == _account || msg.sender == tokenBridge, "access denied");
		PoolInfo storage _poolInfo = poolInfo[_pid];
		UserInfo storage _userInfo = userInfo[_pid][_account];
		_updatePool(_pid);
		if (_userInfo.amount > 0) {
			{
				uint256 epochRewardDebt = _userInfo.amount * _poolInfo.epochAccRewardPerShare / 1e18;
				if (epochRewardDebt > _userInfo.rewardDebt) _userInfo.rewardDebt = epochRewardDebt;
			}
			_reward = _userInfo.amount * _poolInfo.accRewardPerShare / 1e18 - _userInfo.rewardDebt;
			if (_reward > 0) {
				allocReward -= _reward;
				IERC20(rewardToken).safeTransferFrom(faucet, _account, _reward);
			}
		}
		if (_amount > 0) {
			uint256 _feeAmount = _amount * _poolInfo.depositFee / 1e18;
			uint256 _netAmount = _amount - _feeAmount;
			_userInfo.amount += _netAmount;
			_poolInfo.amount += _netAmount;
			IERC20(_poolInfo.token).safeTransferFrom(msg.sender, address(this), _netAmount);
			if (_feeAmount > 0) {
				IERC20(_poolInfo.token).safeTransferFrom(msg.sender, bankroll, _feeAmount);
			}
		}
		_userInfo.rewardDebt = _userInfo.amount * _poolInfo.accRewardPerShare / 1e18;
		emit Deposit(_account, _pid, _amount);
		return _reward;
	}

	function withdraw(uint256 _pid, uint256 _amount) external returns (uint256 _reward)
	{
		return withdrawOnBehalfOf(_pid, _amount, msg.sender);
	}

	function withdrawOnBehalfOf(uint256 _pid, uint256 _amount, address _account) public nonReentrant returns (uint256 _reward)
	{
		require(msg.sender == _account || msg.sender == tokenBridge, "access denied");
		PoolInfo storage _poolInfo = poolInfo[_pid];
		UserInfo storage _userInfo = userInfo[_pid][_account];
		require(_amount <= _userInfo.amount, "insufficient balance");
		_updatePool(_pid);
		{
			uint256 epochRewardDebt = _userInfo.amount * _poolInfo.epochAccRewardPerShare / 1e18;
			if (epochRewardDebt > _userInfo.rewardDebt) _userInfo.rewardDebt = epochRewardDebt;
		}
		_reward = _userInfo.amount * _poolInfo.accRewardPerShare / 1e18 - _userInfo.rewardDebt;
		if (_reward > 0) {
			allocReward -= _reward;
			IERC20(rewardToken).safeTransferFrom(faucet, _account, _reward);
		}
		if (_amount > 0) {
			uint256 _feeAmount = _amount * _poolInfo.withdrawalFee / 1e18;
			uint256 _netAmount = _amount - _feeAmount;
			_userInfo.amount -= _amount;
			_poolInfo.amount -= _amount;
			IERC20(_poolInfo.token).safeTransfer(msg.sender, _netAmount);
			if (_feeAmount > 0) {
				IERC20(_poolInfo.token).safeTransfer(bankroll, _feeAmount);
			}
		}
		_userInfo.rewardDebt = _userInfo.amount * _poolInfo.accRewardPerShare / 1e18;
		emit Withdraw(_account, _pid, _amount);
		return _reward;
	}

	function emergencyWithdraw(uint256 _pid) external nonReentrant
	{
		PoolInfo storage _poolInfo = poolInfo[_pid];
		UserInfo storage _userInfo = userInfo[_pid][msg.sender];
		uint256 _amount = _userInfo.amount;
		_userInfo.amount = 0;
		_userInfo.rewardDebt = 0;
		_poolInfo.amount -= _amount;
		uint256 _feeAmount = _amount * _poolInfo.withdrawalFee / 1e18;
		uint256 _netAmount = _amount - _feeAmount;
		IERC20(_poolInfo.token).safeTransfer(msg.sender, _netAmount);
		if (_feeAmount > 0) {
			IERC20(_poolInfo.token).safeTransfer(bankroll, _feeAmount);
		}
		emit EmergencyWithdraw(msg.sender, _pid, _amount);
	}

	function _massUpdatePools() internal
	{
		_updateEpoch();
		_massUpdatePools(block.timestamp, false);
	}

	function _updatePool(uint256 _pid) internal
	{
		_updateEpoch();
		_updatePool(_pid, block.timestamp, false);
	}

	function _updateEpoch() internal
	{
		if (block.timestamp < nextEpoch) return;

		uint256 _lastEpoch;
		do {
			_lastEpoch = nextEpoch;
			nextEpoch += epochLength(_lastEpoch);
		} while (nextEpoch <= block.timestamp);

		_massUpdatePools(_lastEpoch, true);

		uint256 _expiredReward = allocReward;

		allocReward = 0;

		if (_expiredReward > 0) {
			uint256 _20percent = _expiredReward * 20e16 / 100e16;
			uint256 _40percent = _20percent + _20percent;

			IERC20(rewardToken).safeTransferFrom(faucet, FURNACE, _expiredReward - _40percent);
			IERC20(rewardToken).safeTransferFrom(faucet, address(this), _40percent);

			IERC20(rewardToken).approve(farmingCompound, _20percent);
			FarmingCompound(farmingCompound).donateDrip(_20percent);

			IERC20(rewardToken).approve(farmingVolatile, _20percent);
			FarmingVolatile(farmingVolatile).donateDrip(_20percent);
		}
	}

	function _massUpdatePools(uint256 _when, bool _epochReset) internal
	{
		for (uint256 _pid = 0; _pid < poolInfo.length; _pid++) {
			_updatePool(_pid, _when, _epochReset);
		}
	}

	function _updatePool(uint256 _pid, uint256 _when, bool _epochReset) internal
	{
		PoolInfo storage _poolInfo = poolInfo[_pid];
		if (_when > _poolInfo.lastRewardTime) {
			if (_poolInfo.amount > 0 && _poolInfo.allocPoint > 0) {
				uint256 _reward = (_when - _poolInfo.lastRewardTime) * rewardPerSec * _poolInfo.allocPoint / totalAllocPoint;
				if (_reward > 0) {
					_poolInfo.accRewardPerShare += _reward * 1e18 / _poolInfo.amount;
					allocReward += _reward;
				}
			}
			if (_epochReset) {
				_poolInfo.epochAccRewardPerShare = _poolInfo.accRewardPerShare;
			}
			_poolInfo.lastRewardTime = _when;
		}
	}

	event Deposit(address indexed _account, uint256 indexed _pid, uint256 _amount);
	event Withdraw(address indexed _account, uint256 indexed _pid, uint256 _amount);
	event EmergencyWithdraw(address indexed _account, uint256 indexed _pid, uint256 _amount);
}