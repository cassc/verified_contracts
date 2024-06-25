/**
 *Submitted for verification at BscScan.com on 2022-11-20
*/

// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

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
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


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

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
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

// File: contracts/fBurnStake.sol





pragma solidity ^0.8.15;

interface IERC20 {
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}


interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function getTokenIds(address _owner) external view returns (uint256[] memory);
}

contract fBurnStake is Ownable, ReentrancyGuard {
    
    struct user{
        uint256 id;
        uint256 totalStakedBalance;
        uint256 totalClaimedRewards;
        uint256 createdTime;
    }

    struct stakePool{
        uint256 id;
        uint256 duration;
        uint256 withdrawalFee;
        uint256 unstakeFee;
        uint256 earlyUnstakePenalty;
        uint256 stakedTokens;
        uint256 claimedRewards;
        uint256 status; //1: created, 2: active, 3: cancelled
        uint256 createdTime;
    }

    stakePool[] public stakePoolArray;

    struct userStake{
        uint256 id;
        uint256 stakePoolId;
	    uint256 stakeBalance;
    	uint256 totalClaimedRewards;
    	uint256 lastClaimedTime;
        uint256 status; //0 : Unstaked, 1 : Staked
        address owner;
    	uint256 createdTime;
        uint256 lockedTime;
        uint256 unlockTime;
        uint256 lockDuration;
    }

    userStake[] public userStakeArray;


    mapping (uint256 => stakePool) public stakePoolsById;
    mapping (uint256 => userStake) public userStakesById;

    mapping (address => uint256[]) public userStakeIds;
    mapping (address => userStake[]) public userStakeLists;

    mapping (address => user) public users;

    mapping (uint256 => mapping(uint256 => uint256)) public apys;
    mapping (uint256 => uint256) public nftRarities;

    uint256 public maxStakableTokensPerNFT = 50*10**9;

    uint256 public totalInjectedRewardsSupply;
    uint256 public totalStakedBalance;
    uint256 public totalClaimedBalance;
  
    uint256 public magnitude = 100000000;

    uint256 public userIndex;
    uint256 public poolIndex;
    uint256 public stakeIndex;

    bool public isPaused;

    address nftTokenAddress = 0xDD20eE807aB685bEE7409914DFb3BE3D2eF6d386;

    IERC721 nftToken = IERC721(nftTokenAddress);

    address public baseTokenAddress;
    IERC20 stakeToken = IERC20(baseTokenAddress);

    address public rewardTokensAddress;
    IERC20 rewardToken = IERC20(rewardTokensAddress);
    

    modifier unpaused {
      require(isPaused == false);
      _;
    }

    modifier paused {
      require(isPaused == true);
      _;
    }

    uint256[] _durationArray = [1,14,30,60,90];
    uint256[] _withdrawalFeeArray = [0,0,0,0,0];
    uint256[] _unstakePenaltyArray = [0,80,80,80,80];
    
    
    constructor() {
        address _baseTokenAddress = 0x3b2CB8B2A9BaF200142456C550A328E6C45c176B; 
        address _rewardTokensAddress = 0x3b2CB8B2A9BaF200142456C550A328E6C45c176B;

        baseTokenAddress = _baseTokenAddress;
        rewardTokensAddress = _rewardTokensAddress;
        
        stakeToken = IERC20(baseTokenAddress);
        rewardToken = IERC20(rewardTokensAddress);

        for(uint256 i = 0; i < _durationArray.length; i++){
            addStakePool(
                _durationArray[i], // Duration in days
                _withdrawalFeeArray[i], // Withdrawal fees percentage
                _unstakePenaltyArray[i] // Early unstake penalty
            );
        }

        apys[1][1] = 300; //APY based on rarity,locked days
        apys[1][14] = 360; 
        apys[1][30] = 450;
        apys[1][60] = 600;
        apys[1][90] = 750;
        
        apys[2][1] = 450;
        apys[2][14] = 540;
        apys[2][30] = 675;
        apys[2][60] = 900;
        apys[2][90] = 1125;

        apys[3][1] = 900;
        apys[3][14] = 1080;
        apys[3][30] = 1350;
        apys[3][60] = 1800;
        apys[3][90] = 2250;

        apys[4][1] = 1500;
        apys[4][14] = 1800;
        apys[4][30] = 2250;
        apys[4][60] = 3000;
        apys[4][90] = 3750;
    }
    
    function addStakePool(uint256 _duration, uint256 _withdrawalFee, uint256 _unstakePenalty) public onlyOwner returns (bool){

        stakePool memory stakePoolDetails;
        
        stakePoolDetails.id = poolIndex;
        stakePoolDetails.duration = _duration;
        stakePoolDetails.withdrawalFee = _withdrawalFee;
        stakePoolDetails.earlyUnstakePenalty = _unstakePenalty;
        
        stakePoolDetails.createdTime = block.timestamp;
       
        stakePoolArray.push(stakePoolDetails);
        stakePoolsById[poolIndex++] = stakePoolDetails;

        return true;
    }

    function updateNFTRarity(uint256 _tokenId, uint256 _rarity) public {
        nftRarities[_tokenId] = _rarity;
    }

    function updateBulkNFTRarity(uint256[] calldata _tokenIds, uint256[] calldata _rarities) external onlyOwner {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            nftRarities[_tokenIds[i]] = _rarities[i];
        }
    }

    function getRarityToApply() public view returns(uint256){
        uint256[] memory tokenIds = nftToken.getTokenIds(msg.sender);
        uint256 temp_var;
       
        for (uint256 i = 0; i < tokenIds.length; i++) {
            if(temp_var < nftRarities[tokenIds[i]]){
               temp_var = nftRarities[tokenIds[i]];
            }
        }
        return temp_var;
    }

    function getNFTs() public view returns(uint256[] memory) {
        uint256[] memory tokenIds = nftToken.getTokenIds(msg.sender);
        return tokenIds;
    }

    function getMaxStakableTokens() public view returns(uint256) {
        return (maxStakableTokensPerNFT * nftToken.getTokenIds(msg.sender).length);
    }

    function getHoldingNFTRarities() public view returns(uint256[4] memory) {
        uint256[] memory tokenIds = nftToken.getTokenIds(msg.sender);

        uint256 legendary_count;
        uint256 rare_count;
        uint256 uncommon_count;
        uint256 common_count;
       
        for (uint256 i = 0; i < tokenIds.length; i++) {

            if(nftRarities[tokenIds[i]] == 4){
               legendary_count++;
            }else if(nftRarities[tokenIds[i]] == 3){
               rare_count++;
            }else if(nftRarities[tokenIds[i]] == 2){
               uncommon_count++;
            }else if(nftRarities[tokenIds[i]] == 1){
               common_count++;
            }
        }

        uint256[4] memory holdingNFTRarityCounts = [legendary_count,rare_count,uncommon_count,common_count];
        return (holdingNFTRarityCounts);
    }

    function getAPY(uint256 _rarity, uint256 _lockDuration) public view returns (uint256){
        return apys[_rarity][_lockDuration];
    }

    
    function getDPR(uint256 _rarity, uint256 _lockDuration) public view returns (uint256){
        uint256 apy = getAPY(_rarity,_lockDuration);
        uint256 dpr = (apy * magnitude) / 365;
        return dpr;
    }

    function getStakePoolDetailsById(uint256 _stakePoolId) public view returns(stakePool memory){
        return (stakePoolArray[_stakePoolId]);
    }

    function stake(uint256 _stakePoolId, uint256 _amount) unpaused external returns (bool) {
        stakePool memory stakePoolDetails = stakePoolsById[_stakePoolId];

        require(_amount <= getMaxStakableTokens(),"You need more NFTs to stake this amount");
        require(stakeToken.allowance(msg.sender, address(this)) >= _amount,'Tokens not approved for transfer');
        
        bool success = stakeToken.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token Transfer failed.");

        userStake memory userStakeDetails;

        uint256 userStakeid = stakeIndex++;
        userStakeDetails.id = userStakeid;
        userStakeDetails.stakePoolId = _stakePoolId;
        userStakeDetails.stakeBalance = _amount;
        userStakeDetails.status = 1;
        userStakeDetails.owner = msg.sender;
        userStakeDetails.createdTime = block.timestamp;
        userStakeDetails.unlockTime = block.timestamp + (stakePoolDetails.duration * 1 days);
        userStakeDetails.lockDuration = stakePoolDetails.duration;
        userStakeDetails.lockedTime = block.timestamp;
        userStakesById[userStakeid] = userStakeDetails;
    
        uint256[] storage userStakeIdsArray = userStakeIds[msg.sender];
    
        userStakeIdsArray.push(userStakeid);
        userStakeArray.push(userStakeDetails);
    
        userStake[] storage userStakeList = userStakeLists[msg.sender];
        userStakeList.push(userStakeDetails);
        
        user memory userDetails = users[msg.sender];

        if(userDetails.id == 0){
            userDetails.id = ++userIndex;
            userDetails.createdTime = block.timestamp;
        }

        userDetails.totalStakedBalance += _amount;

        users[msg.sender] = userDetails;

        stakePoolDetails.stakedTokens += _amount;
    
        stakePoolArray[_stakePoolId] = stakePoolDetails;
        
        stakePoolsById[_stakePoolId] = stakePoolDetails;

        totalStakedBalance = totalStakedBalance + _amount;
        
        return true;
    }

    function restake(uint256 _stakeId) nonReentrant unpaused external returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
      
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1,"You have already unstaked");

        userStakeDetails.lockedTime = block.timestamp;
        userStakeDetails.unlockTime = userStakeDetails.lockDuration * 1 days;

        userStakesById[_stakeId] = userStakeDetails;
        updateStakeArray(_stakeId);

        return true; 
    }

    function unstake(uint256 _stakeId) nonReentrant external returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 stakePoolId = userStakeDetails.stakePoolId;
        uint256 stakeBalance = userStakeDetails.stakeBalance;
        
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1,"You have already unstaked");
        
        stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];

        uint256 unstakableBalance;
  
        uint256 claimableRewards;
        uint256 earlyUnstakePenaltyAmount;

        if(isStakeLocked(_stakeId) && isPaused == false){
            claimableRewards = getUnclaimedRewards(_stakeId);
            earlyUnstakePenaltyAmount = (claimableRewards * stakePoolDetails.earlyUnstakePenalty)/100;
          
            unstakableBalance = stakeBalance + (claimableRewards - earlyUnstakePenaltyAmount);
           
        }else{
            unstakableBalance = stakeBalance;
        }

        userStakeDetails.status = 0;

        userStakesById[_stakeId] = userStakeDetails;

        stakePoolDetails.stakedTokens = stakePoolDetails.stakedTokens - stakeBalance;

        userStakesById[_stakeId] = userStakeDetails;

        user memory userDetails = users[msg.sender];
        userDetails.totalStakedBalance =   userDetails.totalStakedBalance - stakeBalance;

        users[msg.sender] = userDetails;

        stakePoolsById[stakePoolId] = stakePoolDetails;

        updateStakeArray(_stakeId);

        totalStakedBalance =  totalStakedBalance - stakeBalance;

        require(stakeToken.balanceOf(address(this)) >= unstakableBalance, "Insufficient contract token balance");
        
        bool success;

        success = stakeToken.transfer(msg.sender, unstakableBalance);
        require(success, "Token Transfer failed.");

        success = false;

        if(earlyUnstakePenaltyAmount > 0 && stakeToken.balanceOf(address(this)) > 0){
            success = rewardToken.transfer(owner(), earlyUnstakePenaltyAmount);
            require(success, "Token Transfer failed.");
        }

        return true;
    }

    function isStakeLocked(uint256 _stakeId) public view returns (bool) {
        userStake memory userStakeDetails = userStakesById[_stakeId];
        if(block.timestamp < userStakeDetails.unlockTime){
            return true;
        }else{
            return false;
        }
    }

    function getStakePoolIdByStakeId(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        return userStakeDetails.stakePoolId;
    }

    function getUserStakeIds() public view returns(uint256[] memory){
        return (userStakeIds[msg.sender]);
    }

    function getUserStakeIdsByAddress(address _userAddress) public view returns(uint256[] memory){
         return(userStakeIds[_userAddress]);
    }

    
    function getUserAllStakeDetails() public view returns(userStake[] memory){
        return (userStakeLists[msg.sender]);
    }

    function getUserAllStakeDetailsByAddress(address _userAddress) public view returns(userStake[] memory){
        return (userStakeLists[_userAddress]);
    }

    function getUserStakeOwner(uint256 _stakeId) public view returns (address){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        return userStakeDetails.owner;
    }

    function getUserStakeBalance(uint256 _stakeId) public view returns (uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        return userStakeDetails.stakeBalance;
    }
    
    function getUnclaimedRewards(uint256 _stakeId) public view returns (uint256){
        userStake memory userStakeDetails = userStakeArray[_stakeId];
        uint256 stakePoolId = userStakeDetails.stakePoolId;

        stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];
        uint256 stakeApr = getDPR(getRarityToApply(), stakePoolDetails.duration);

        uint applicableRewards = (userStakeDetails.stakeBalance * stakeApr)/(magnitude * 100); //divided by 10000 to handle decimal percentages like 0.1%
        uint unclaimedRewards = (applicableRewards * getElapsedTime(_stakeId));

        return unclaimedRewards; 
    }

    function getElapsedTime(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 lapsedDays;

        if(block.timestamp > userStakeDetails.unlockTime){  
            lapsedDays = userStakeDetails.lockDuration;
        } else{
            lapsedDays = ((block.timestamp - userStakeDetails.lockedTime)/3600)/24; //3600 seconds per hour so: lapsed days = lapsed time * (3600seconds /24hrs)
        }
        return lapsedDays;  
    }
    
    function getTotalUnclaimedRewards(address _userAddress) public view returns (uint256){
        uint256[] memory stakeIds = getUserStakeIdsByAddress(_userAddress);
        uint256 totalUnclaimedRewards;
        for(uint256 i = 0; i < stakeIds.length; i++) {
            userStake memory userStakeDetails = userStakesById[stakeIds[i]];
            if(userStakeDetails.status == 1){
                totalUnclaimedRewards += getUnclaimedRewards(stakeIds[i]);
            }
        }
        return totalUnclaimedRewards;
    }

    
    function getAllPoolDetails() public view returns(stakePool[] memory){
        return (stakePoolArray);
    }

    function claimRewards(uint256 _stakeId) nonReentrant unpaused public returns (bool){
        
        address userStakeOwner = getUserStakeOwner(_stakeId);
        require(userStakeOwner == msg.sender,"You don't own this stake");

        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 stakePoolId = userStakeDetails.stakePoolId;

        require(userStakeDetails.status == 1, "You can not claim after unstaked");
        require(isStakeLocked(_stakeId) == false,"You can not withdraw");
        
        stakePool memory stakePoolDetails = stakePoolsById[stakePoolId];

        uint256 unclaimedRewards = getUnclaimedRewards(_stakeId);
        
        userStakeDetails.totalClaimedRewards = userStakeDetails.totalClaimedRewards + unclaimedRewards;
        userStakeDetails.lastClaimedTime = block.timestamp;
        userStakeDetails.lockedTime = block.timestamp;

       
        userStakeDetails.unlockTime = userStakeDetails.lockedTime + (stakePoolDetails.duration * 1 days);
        
        userStakesById[_stakeId] = userStakeDetails;
        updateStakeArray(_stakeId);

        totalClaimedBalance += unclaimedRewards;

        user memory userDetails = users[msg.sender];
        userDetails.totalClaimedRewards  +=  unclaimedRewards;

        users[msg.sender] = userDetails;

        require(rewardToken.balanceOf(address(this)) >= unclaimedRewards, "Insufficient contract reward token balance");

        if(rewardToken.decimals() < stakeToken.decimals()){
            unclaimedRewards = unclaimedRewards * (10**(stakeToken.decimals() - rewardToken.decimals()));
        }else if(rewardToken.decimals() > stakeToken.decimals()){
            unclaimedRewards = unclaimedRewards / (10**(rewardToken.decimals() - stakeToken.decimals()));
        }

        bool success = rewardToken.transfer(msg.sender, unclaimedRewards);
        require(success, "Token Transfer failed.");

        return true;
    }

    function updateStakeArray(uint256 _stakeId) internal {
        userStake[] storage userStakesArray = userStakeLists[msg.sender];
        
        for(uint i = 0; i < userStakesArray.length; i++){
            userStake memory userStakeFromArrayDetails = userStakesArray[i];
            if(userStakeFromArrayDetails.id == _stakeId){
                userStake memory userStakeDetails = userStakesById[_stakeId];
                userStakesArray[i] = userStakeDetails;
            }
        }
    }

    function getUserDetails(address _userAddress) external view returns (user memory){
        user memory userDetails = users[_userAddress];
        return(userDetails);
    }
    
    function pauseStake(bool _pauseStatus) public onlyOwner(){
        isPaused = _pauseStatus;
    }
    
    function setMaxStakableTokensPerNFT(uint256 _maxStakableTokensPerNFT) public onlyOwner{
        maxStakableTokensPerNFT = _maxStakableTokensPerNFT;
    }

    function injectRewardsSupply(uint256 _amount) public {
        require(rewardToken.allowance(msg.sender, address(this)) >= _amount,'Tokens not approved for transfer');
        
        bool success = rewardToken.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token Transfer failed.");
        totalInjectedRewardsSupply += _amount;
    }

    function withdrawContractETH() public onlyOwner paused returns(bool){
        bool success;
        (success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");

        return true;
    }

    function withdrawInjectedRewardSupply(uint256 _amount) public onlyOwner paused returns(bool){
        bool success;
        
        require(_amount <= totalInjectedRewardsSupply,"Can not withdraw more than injected supply");
        success = rewardToken.transfer(msg.sender, _amount);
        require(success, "Token Transfer failed.");

        totalInjectedRewardsSupply -= _amount;
        return true;
    }

    receive() external payable {}
}