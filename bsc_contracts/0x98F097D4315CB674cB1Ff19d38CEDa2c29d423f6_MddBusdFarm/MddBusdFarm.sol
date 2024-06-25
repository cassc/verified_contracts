/**
 *Submitted for verification at BscScan.com on 2023-04-18
*/

// 
// ██████╗░███████╗░██████╗░███████╗███╗░░██╗  ██████╗░░█████╗░███╗░░██╗░█████╗░██╗░░░░░██████╗░░██████╗
// ██╔══██╗██╔════╝██╔════╝░██╔════╝████╗░██║  ██╔══██╗██╔══██╗████╗░██║██╔══██╗██║░░░░░██╔══██╗██╔════╝
// ██║░░██║█████╗░░██║░░██╗░█████╗░░██╔██╗██║  ██║░░██║██║░░██║██╔██╗██║███████║██║░░░░░██║░░██║╚█████╗░
// ██║░░██║██╔══╝░░██║░░╚██╗██╔══╝░░██║╚████║  ██║░░██║██║░░██║██║╚████║██╔══██║██║░░░░░██║░░██║░╚═══██╗
// ██████╔╝███████╗╚██████╔╝███████╗██║░╚███║  ██████╔╝╚█████╔╝██║░╚███║██║░░██║███████╗██████╔╝██████╔╝
// ╚═════╝░╚══════╝░╚═════╝░╚══════╝╚═╝░░╚══╝  ╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░ 
// 
// Website: https://degendonalds.ai
// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
	
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
	
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
	
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
	
    function owner() public view virtual returns (address) {
        return _owner;
    }
	
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
	
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }
	
    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
	function transfer(address recipient, uint256 amount) external returns (bool);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
	
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
  
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
   
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
	
    function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeBEP20 {
    using Address for address;
	
    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
	
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

contract MddBusdFarm is Ownable, ReentrancyGuard{

    using SafeBEP20 for IBEP20;
	
    uint256 public minStaking = 1 * 10**18;
	uint256 public APR = 577984 * 10**16;
	uint256 public poolFee;
	uint256 public totalStaked;

    address _lpToken = 0xF44f3cc1dEfacc086A805592D4f7B299ea62bd9B; // CakeLP Token
    address _rewardToken = 0xD9e0adeB9a8d384315a14e3703C77131FeEf4E34; // MDD Token
	
    IBEP20 public lpToken = IBEP20(_lpToken);
	IBEP20 public rewardToken = IBEP20(_rewardToken);
	
    mapping(address => UserInfo) internal userInfo;
	uint256 constant TIME_STEP = 365 days;
	
	bool public paused = false;
	
	modifier whenNotPaused() {
		require(!paused, "Contract is paused");
		_;
	}
	
	modifier whenPaused() {
		require(paused, "Contract is unpaused");
		_;
	}
	
    struct UserInfo {
        uint256 amount; 
		uint256 rewardRemaining;
		uint256 rewardWithdrawal;
        uint256 startTime;
        uint256 startTimeLock;
    }
	
    event MigrateTokens(address tokenRecovered, uint256 amount);
    event Deposit(address indexed user, uint256 amount);
    event NewAPR(uint256 APR);
    event MinStakePerUser(uint256 minStakePerUser);
    event Withdraw(address indexed user, uint256 amount);
	event NewPoolFee(uint256 newFee);
    event NewLPToken(address _lpToken);
    event NewRewardToken(address _rewardToken);
	event Pause();
    event Unpause();
	
    constructor() {}
	
    function deposit(uint256 amount) external nonReentrant{
	    UserInfo storage user = userInfo[msg.sender];
		
		require(!paused, "Deposit is paused");
		require(lpToken.balanceOf(msg.sender) >= amount, "Balance not available for staking");
		require(amount >= minStaking, "Amount is less than minimum staking amount");
		
		uint256 pending = pendingreward(msg.sender);

        if(user.amount < 1 * 10**18){
            user.startTimeLock = block.timestamp + 7 days;
        }
		
		user.amount = user.amount + amount;
		user.rewardRemaining = user.rewardRemaining + pending;
		user.startTime = block.timestamp;
		
		totalStaked = totalStaked + amount;
		
		lpToken.safeTransferFrom(address(msg.sender), address(this), amount);
        emit Deposit(msg.sender, amount);
    }
	
    function withdraw() external nonReentrant{
	    UserInfo storage user = userInfo[msg.sender];
		require(user.amount > 0, "Amount is not staked");
		
		uint256 amount   = user.amount;
		uint256 pending  = pendingreward(msg.sender);
		uint256 reward   = user.rewardRemaining + pending;
		uint256 fee      = (reward * poolFee) / 10000;
		
		require(lpToken.balanceOf(address(this)) >= amount, "Token balance not available for withdraw");
		totalStaked = totalStaked - amount;
		
		user.amount = 0;

		if(user.startTimeLock <= block.timestamp){
            if(rewardToken.balanceOf(address(this)) >= reward - fee)
            {
                user.rewardRemaining = 0;
                user.rewardWithdrawal = 0;
                rewardToken.safeTransfer(address(msg.sender), reward-fee);
            }
            else
            {
                user.rewardRemaining = reward;
            }
        }else{
            user.rewardRemaining = 0;
            user.rewardWithdrawal = 0;
            user.startTime = 0;
        }
		
		lpToken.safeTransfer(address(msg.sender), amount);
		emit Withdraw(msg.sender, amount);
    }
	
	function withdrawReward() external nonReentrant{
		UserInfo storage user = userInfo[msg.sender];
        
        require(user.startTimeLock <= block.timestamp, "Timestamp not available for withdraw");
		
		uint256 pending = pendingreward(msg.sender);
		uint256 reward  = user.rewardRemaining + pending;
		uint256 fee     = (reward * poolFee) / 10000;
		
		require(reward > 0, "Reward amount is zero");
		require(rewardToken.balanceOf(address(this)) >= reward - fee, "Token balance not available for withdraw");
		
		if(user.amount > 0)
		{
		    user.rewardWithdrawal = user.rewardWithdrawal + reward;
		    user.rewardRemaining  = 0;
		    user.startTime        = block.timestamp;
		}
		else
		{
		    user.rewardWithdrawal = 0;
		    user.rewardRemaining  = 0;
		}
		rewardToken.safeTransfer(address(msg.sender), reward-fee);
		emit Withdraw(msg.sender, reward);
    }
	
	function pendingreward(address _user) public view returns (uint256) {
        UserInfo storage user = userInfo[_user];
		if(user.amount > 0)
		{
			uint256 sTime  = user.startTime;
			uint256 eTime  = block.timestamp;
			uint256 reward = (uint(user.amount)*(APR)*(eTime-sTime)) / (TIME_STEP * 1 * 10**18);
			return reward;
		}
		else
		{
		    return 0;
		}
    }
	
	function getUserInfo(address userAddress) public view returns (uint256, uint256, uint256, uint256, uint256) {
        UserInfo storage user = userInfo[userAddress];
        return (user.amount, user.rewardRemaining, user.rewardWithdrawal, user.startTime, user.startTimeLock);
    }
	
	function migrateTokens(address receiver, address tokenAddress, uint256 tokenAmount) external onlyOwner nonReentrant{
       require(receiver != address(0), "zero-address not allowed");
	   
	   IBEP20(tokenAddress).safeTransfer(address(receiver), tokenAmount);
       emit MigrateTokens(tokenAddress, tokenAmount);
    }
	
	function updateMinStaking(uint256 minStakingAmount) external onlyOwner {
	    require(lpToken.totalSupply() > minStakingAmount, "Total supply is less than minimum staking amount");
		require(minStakingAmount >= 1 * 10**18, "Minimum staking amount is less than `0.00000001` token");
		
        minStaking = minStakingAmount;
        emit MinStakePerUser(minStakingAmount);
    }
	
	function updateAPR(uint256 newAPR) external onlyOwner {
	    require(newAPR >= 1 * 10**10, "APR is less than `0.00000001` token");
		require(rewardToken.totalSupply() > newAPR, "Total supply is less than APR");
		
        APR = newAPR;
        emit NewAPR(newAPR);
    }

	function uzlaimStuckTokens(address token) external onlyOwner {
        require(token != _lpToken, "Token Address not valid");
        require(token != _rewardToken, "Token Address not valid");

        if (token == address(0x0)) {
            payable(msg.sender).transfer(address(this).balance);
            return;
        }

        IBEP20 ERC20token = IBEP20(token);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.transfer(msg.sender, balance);
    }

	function updatePoolFee(uint256 newFee) external onlyOwner {
		require(newFee <= 1000, "Fee is greater than `10%`");
		
        poolFee = newFee;
        emit NewPoolFee(newFee);
    }

    function updateTokens(address _lp, address _reward) external onlyOwner{
        require(_lp != address(this),"You cannot use address");
        require(_reward != address(this),"You cannot use address");

        address lpContract = _lp;
        address rewardContract = _reward;

        emit NewLPToken(lpContract);
        emit NewRewardToken(rewardContract);
    }
	
	function pause() whenNotPaused external onlyOwner{
		paused = true;
		emit Pause();
	}
	
	function unpause() whenPaused external onlyOwner{
		paused = false;
		emit Unpause();
	}
}