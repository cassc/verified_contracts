/**
 *Submitted for verification at BscScan.com on 2023-01-13
*/

/** 
 *  SourceUnit: /home/dos/dev/softblock/MintyMarket/contracts/Staking.sol
*/
            
////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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
    event Approval(address indexed owner, address indexed spender, uint256 value);

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
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
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


/** 
 *  SourceUnit: /home/dos/dev/softblock/MintyMarket/contracts/Staking.sol
*/

////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
pragma solidity ^0.8.17;

////import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MintyStaking {
  error NotOwnerError();
  error RewardDurationNotFinished();

  // Staking Token
  IERC20 public MMT;
  
  address owner;
  uint256 public Reward_Total; // Total amount of tokens added to pay rewards
  uint256 public MMT_Total; // Total amount of token in the contract
  uint256 public Staked_Total; // Total amount of user staked tokens
  uint256 public duration;
  uint256 public finishAt;
  uint256 public updatedAt;
  uint256 public rewardRate;
  uint256 public rewardPerTokenStored;
  
  mapping(address => uint256) public userRewardPerTokenPaid;
  mapping(address => uint256) public rewards;
  mapping(address => uint256) public balanceOf; 

  // Track accounts
  mapping(address => uint256) totalStaked;
  // Track the timestamp of the start of staking
  mapping(address => uint256) stakeStart;

  constructor (address _token) {
    owner = msg.sender;
    MMT = IERC20(_token);
  }

  modifier onlyOwner {
    if (msg.sender != owner) {
      revert NotOwnerError();
    }
    _;
  }

  modifier updateReward(address _account) {
    rewardPerTokenStored = rewardPerToken();
    updatedAt = lastTimeRewardApplicable();
    if (_account != address(0)) {
      rewards[_account] = earned(_account);
      userRewardPerTokenPaid[_account] = rewardPerTokenStored;
    }
    _;
  }

  function getTotalSupply() public view returns (uint256) {
    return MMT_Total;
  }

  function getTotalRewardsSet() public view returns (uint256) {
    return Reward_Total;
  }

  function getTotalStaked() public view returns (uint256) {
    return Staked_Total;
  }

  function setRewardsDuration(uint256 _duration) onlyOwner external {
    require(finishAt < block.timestamp, "Reward duration is not finished");
    duration = _duration;
  }

  function getRewardsDuration() public view returns (uint256) {
    return duration;
  }

  function getRewardForDuration() external view returns (uint256) {
    return rewardRate * duration;
  }

  function notifyRewardAmount(uint256 _amount) external onlyOwner updateReward(address(0)) {
    if (block.timestamp > finishAt) {
      rewardRate = _amount / duration;
    } else {
      uint256 remainingRewards = rewardRate * (finishAt - block.timestamp);
      rewardRate = (remainingRewards + _amount) / duration; 
    }

    require(rewardRate > 0, "Reward rate = 0");
    require(
      rewardRate * duration <= MMT.balanceOf(address(this)),
      "Reward amount > balance"
    );

    // Store the timestamps
    finishAt = block.timestamp + duration;
    updatedAt = block.timestamp;
  }

  function supplyTokens(uint256 _amount) external onlyOwner {
    require(_amount > 0, "Amount = 0");
    Reward_Total += _amount;
    MMT_Total += _amount;
    MMT.transferFrom(msg.sender, address(this), _amount);
  }

  function stake(uint256 _amount) external updateReward(msg.sender) {
    require(_amount > 0, "Amount = 0");
    balanceOf[msg.sender] += _amount;
    Staked_Total += _amount;
    MMT_Total += _amount;
    MMT.transferFrom(msg.sender, address(this), _amount);
  }

  function withdraw(uint256 _amount) external updateReward(msg.sender) {
    require(_amount > 0, "amount = 0");
    require(_amount <= balanceOf[msg.sender], "The amount is greater than what is in the users account");
    balanceOf[msg.sender] -= _amount;
    Staked_Total -= _amount;
    MMT_Total -= _amount;
    MMT.transfer(msg.sender, _amount);
  }

  function lastTimeRewardApplicable() public view returns (uint256) {
    return _min(block.timestamp, finishAt);
  }

  function rewardPerToken() public view returns (uint256) {
    if (MMT_Total == 0) { return rewardPerTokenStored; }
    return rewardPerTokenStored + (rewardRate * 
      (lastTimeRewardApplicable() - updatedAt) * 
      1e18) / MMT_Total;
  }

  function earned(address _account) public view returns (uint256) {
    return ((balanceOf[_account] * (rewardPerToken() - userRewardPerTokenPaid[_account])) / 1e18) + rewards[_account];
  }

  function getReward() external updateReward(msg.sender) {
    uint256 reward = rewards[msg.sender];
    if (reward > 0) {
      rewards[msg.sender] = 0;
      Reward_Total -= reward;
      MMT.transfer(msg.sender, reward);
    }
  }

  function _min(uint256 x, uint256 y) private pure returns (uint256) {
    return x <= y ? x: y;
  }
}