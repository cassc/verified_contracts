/*

  _  _____  _   _  ____   ____  _   _ ____  ____  
 | |/ / _ \| \ | |/ ___| | __ )| | | / ___||  _ \ 
 | ' / | | |  \| | |  _  |  _ \| | | \___ \| | | |
 | . \ |_| | |\  | |_| | | |_) | |_| |___) | |_| |
 |_|\_\___/|_| \_|\____| |____/ \___/|____/|____/ 
                                                  
The KONG BUSD is a ROI Dapp and part of the KONG-Eco System. 
The KONG BUSD is crated by combining the great features of the existing and past ROI Dapps. 
KONG BUSD is a 100% decentralized investment platform built on the Binance Smart Chain (BEP20). 
It offers a variable yield % of 1% to 4% with a maximum profit of 300% of the total deposited amount.

Visit website for more details: https://kongbusd.finance
*/

// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

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

interface WM{
    function UsersKey(address _userAddress) external view returns (WMuser memory);
}

interface KongBusdV1{
    function users(address _userAddress) external view returns(userV1 memory);
    function userStakesById(uint256 _id) external view returns(userStakeV1 memory);
    function getUserAllStakeDetailsByAddress(address _userAddress) external view returns(userStakeV1[] memory);
    function getUserStakeIdsByAddress(address _address) external view returns(uint256[] memory);
}

struct userV1{   
    uint256 totalStakedBalance;
    uint256 totalClaimed;
    uint256 totalCompounded;
    uint256 totalReferred;
    uint256 unclaimedReferral;
    uint256 createdTime;
}

struct userStakeV1{
    uint256 id;
    uint256 roi;
    uint256 stakeAmount;
    uint256 totalClaimed;
    uint256 totalCompounded;
    uint256 lastActionedTime;
    uint256 nextActionTime;
    uint256 status; //0 : Unstaked, 1 : Staked
    address referrer;
    address owner;
    uint256 createdTime;
}

struct WMuser {
    uint256 startDate;
    uint256 divs;
    uint256 refBonus;
    uint256 totalInits;
    uint256 totalWiths;
    uint256 totalAccrued;
    uint256 lastWith;
    uint256 timesCmpd;
    uint256 keyCounter;
}


contract KongStakeV2 is Ownable, ReentrancyGuard {
    struct user{   
        uint256 totalStakedBalance;
        uint256 totalClaimed;
        uint256 totalCompounded;
        uint256 totalReferred;
        uint256 unclaimedReferral;
        uint256 createdTime;
    }

    struct userStake{
        uint256 id;
        uint256 roi;
	    uint256 stakeAmount;
    	uint256 totalClaimed;
        uint256 totalCompounded;
    	uint256 lastActionedTime;
        uint256 nextActionTime;
        uint256 status; //0 : Unstaked, 1 : Staked, 2 : Inactive
        address referrer;
        address owner;
    	uint256 createdTime;
    }

    address public dev1 = 0x66210175567AD8a0414C530F642E2ad889b6c359;
    address public dev2 = 0xBb61125269A86b90b5E1e23547811A3fF04bD11D;
    address public dev3 = 0x02D17fDFdA84eaD75DCF8c9a9a98D8F0F911D155;

    uint256 public minDeposit = 10 ether; //Minimum stake 10 BUSD
    uint256 public baseDailyRoi = 200; //2%
    uint256 public roiBalancer = 5; //0.05%
    uint256 public minDailyRoi = 100; //1%
    uint256 public maxDailyRoi = 500; //5%
    uint256 public stakeFee = 500; //5%
    uint256 public unstakeFee = 1500; //15% (50% remains in TVL and 50% goes to dev)
    uint256 public withdrawalFee = 600; //6% (2% from this goes to referred NFT holder for passive income)
    uint256 public referralFee = 600; //6%
    uint256 public nftHolderReferralFee = 200; //2%
    uint256 public nftHolderExtraRoi = 100; //1%
    uint256 public wmUserExtraRoi = 100; //1%
    uint256 public percentageDivisor = 10000; //Percentage devisor to handle decimal values
    uint256 public maxReturns = 3; //3x max returns
    
    mapping (uint256 => userStake) public userStakesById;
    mapping (address => uint256[]) public userStakeIds;
    mapping (address => userStake[]) public userStakeLists;
    mapping (address => user) public users;
    mapping (address => bool) public WMrecovered;
    mapping (uint256 => uint256) public v1toV2Id;
    mapping (uint256 => bool) public isMigrated;
    mapping (uint256 => bool) public isMigrationActivated;
    mapping (address => bool) public isUnclaimedReferralMigrated;

    uint256 public totalUsers;
    uint256 public totalStaked;
    uint256 public totalClaimed;
    uint256 public totalCompounded;
  
    uint256 public stakeIndex;

    bool public isStarted = false;

    event staked(address _stkaerUser, uint256 _amount, address _referrer);

    address public busdAddress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    IERC20 busd = IERC20(busdAddress);

    address public nftAddress = 0x6E4A8d4244cF0501Ca99E4fFf4CD1b45F8ddb82a;
    IERC20 nft = IERC20(nftAddress);

    address public wmAddress = 0x9B9C918FAC2DFCCaFff3B95b4f46FD9A5D9D701b;
    WM wm = WM(wmAddress);

    address public kongV1Address = 0x597F6c4bf7C4311379c2420589925d0D75404a45;
    KongBusdV1 kongV1 = KongBusdV1(kongV1Address);

    function startStake() public onlyOwner{
        require(isStarted == false,"Stake is already started");
        isStarted = true;
    }

    function migrateFromV1(uint256 _stakeId) public {
        userStakeV1 memory userV1StakeDetails = getKongV1StakeDetails(_stakeId);
        userStake memory userStakeDetails;
        require(userV1StakeDetails.owner == msg.sender,"You don't own this stake");
        require(userV1StakeDetails.status == 1,"You cannot migrate unstaked stakes");
        require(isMigrated[_stakeId] == false,"This stake is already migrated");
        uint256 _amount = userV1StakeDetails.stakeAmount;
        uint256 stakeId = stakeIndex++;
        userStakeDetails.id = stakeId;
        v1toV2Id[_stakeId] = stakeId;
        userStakeDetails.stakeAmount = userV1StakeDetails.stakeAmount;
        userStakeDetails.roi = baseDailyRoi;
        userStakeDetails.totalClaimed = userV1StakeDetails.totalClaimed;
        userStakeDetails.totalCompounded = userV1StakeDetails.totalCompounded;
        userStakeDetails.lastActionedTime = userV1StakeDetails.lastActionedTime;
        userStakeDetails.nextActionTime = userV1StakeDetails.nextActionTime;
        userStakeDetails.status = 2;
        userStakeDetails.referrer = userV1StakeDetails.referrer;
        userStakeDetails.owner = msg.sender;
        userStakeDetails.createdTime = userV1StakeDetails.createdTime;
        userStakesById[stakeId] = userStakeDetails;
        uint256[] storage userStakeIdsArray = userStakeIds[msg.sender];
        userStakeIdsArray.push(stakeId);
        userStake[] storage userStakeList = userStakeLists[msg.sender];
        userStakeList.push(userStakeDetails);
        userV1 memory userV1TotalDetails = kongV1.users(msg.sender);
        user memory userDetails = users[msg.sender];
        if(userDetails.createdTime == 0){ // Staker is a new user
            userDetails.createdTime = block.timestamp;
            totalUsers++;
        }
        userDetails.totalStakedBalance += _amount;
        userDetails.totalClaimed += userV1StakeDetails.totalClaimed;
        userDetails.totalCompounded += userV1StakeDetails.totalCompounded;
        userDetails.totalReferred = userV1TotalDetails.totalReferred;
        users[msg.sender] = userDetails;
        totalStaked += _amount;
        totalClaimed += userV1StakeDetails.totalClaimed;
        totalCompounded += userV1StakeDetails.totalCompounded;
        isMigrated[_stakeId] = true;
    }

    function activateMigratedStake(uint256 _stakeId, uint256 _amount) public{
        uint256 v1MigratableAmount = getKongV1MigratableAmount(_stakeId);
        require(_amount >= v1MigratableAmount,"Migration BUSD Balance is less than unstaked balance");
        require(busd.allowance(msg.sender, address(this)) >= _amount,"Not enough BUSD approved for transfer"); 
        bool success = busd.transferFrom(msg.sender, address(this), _amount);
        require(success, "BUSD Transfer failed.");
        
        uint256 stakeId = v1toV2Id[_stakeId];
        userStake memory userStakeDetails = userStakesById[stakeId];
        
        userStakeDetails.status = 1;
        userStakesById[stakeId] = userStakeDetails;
        updateStakeArray(stakeId);
        isMigrationActivated[_stakeId] = true;
    }

    function migrateUnclaimedReferral() public {
        require(isUnclaimedReferralMigrated[msg.sender] == false,"You already have migrated unclaimed referral");
        userV1 memory userV1TotalDetails = kongV1.users(msg.sender);
        user memory userDetails = users[msg.sender];
        userDetails.unclaimedReferral = userV1TotalDetails.unclaimedReferral;
        users[msg.sender] = userDetails;
        isUnclaimedReferralMigrated[msg.sender] = true;
    }

    function getKongV1MigratableAmount(uint256 _stakeId) public view returns(uint256){
        userStakeV1 memory userStakeDetails = getKongV1StakeDetails(_stakeId);

        uint256 referrerAmount = (userStakeDetails.stakeAmount * referralFee) / percentageDivisor;
        uint256 v1UnstakableAmount = userStakeDetails.stakeAmount - (userStakeDetails.totalClaimed + referrerAmount);
        require(v1UnstakableAmount > 0,"Cannot unstake, already claimed more than staked amount");
        uint256 unstakeFeeAmount = (v1UnstakableAmount * unstakeFee) / percentageDivisor;
        v1UnstakableAmount -= unstakeFeeAmount;
        return v1UnstakableAmount;
    }

    function getKongV1StakeDetails(uint256 _stakeId) public view returns(userStakeV1 memory){
        return kongV1.userStakesById(_stakeId);
    }

    function getKongV1UserAllStakeDetails(address _userAddress) public view returns(userStakeV1[] memory){
        return kongV1.getUserAllStakeDetailsByAddress(_userAddress);
    }

    function getKongV1UserStakeIdsByAddress(address _userAddress) public view returns(uint256[] memory){
        return kongV1.getUserStakeIdsByAddress(_userAddress);
    }

    function stake(uint256 _amount, address _referrer) external returns (bool) {
        require(isStarted == true,"Staking is not started yet");
        require(_referrer != msg.sender,"You can not refer to yourself");
        require(_amount >= minDeposit,"Stake amount is below minimum limit");
        require(busd.allowance(msg.sender, address(this)) >= _amount,"Not enough BUSD approved for transfer"); 
        bool success = busd.transferFrom(msg.sender, address(this), _amount);
        require(success, "BUSD Transfer failed.");
        userStake memory userStakeDetails;
        uint256 stakeId = stakeIndex++;
        userStakeDetails.id = stakeId;
        userStakeDetails.stakeAmount = _amount;
        userStakeDetails.roi = baseDailyRoi;
        userStakeDetails.lastActionedTime = block.timestamp;
        userStakeDetails.nextActionTime = userStakeDetails.lastActionedTime + 1 days;
        userStakeDetails.status = 1;
        userStakeDetails.referrer = _referrer;
        userStakeDetails.owner = msg.sender;
        userStakeDetails.createdTime = block.timestamp;
        userStakesById[stakeId] = userStakeDetails;
        uint256[] storage userStakeIdsArray = userStakeIds[msg.sender];
        userStakeIdsArray.push(stakeId);
        userStake[] storage userStakeList = userStakeLists[msg.sender];
        userStakeList.push(userStakeDetails);
        user memory userDetails = users[msg.sender];
        if(userDetails.createdTime == 0){ // Staker is a new user
            userDetails.createdTime = block.timestamp;
            totalUsers++;
        }
        userDetails.totalStakedBalance += _amount;
        users[msg.sender] = userDetails;
        totalStaked += _amount;   
        uint256 devStakeFeeAmount = (_amount * stakeFee) / percentageDivisor;
        splitTransferDevShare(devStakeFeeAmount);
        uint256 referrerAmount = (_amount * referralFee) / percentageDivisor;
        if(nft.balanceOf(_referrer) > 0){
            referrerAmount = (_amount * (referralFee + nftHolderReferralFee)) / percentageDivisor;
        }
        user memory referralUserDetails = users[_referrer];
        referralUserDetails.totalReferred += referrerAmount;
        referralUserDetails.unclaimedReferral += referrerAmount;
        users[_referrer] = referralUserDetails;
        emit staked(msg.sender, _amount, _referrer);
        return true;
    }

    function unstake(uint256 _stakeId) nonReentrant external returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 stakeAmount = userStakeDetails.stakeAmount;
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1,"You already have unstaked or inactive stake");
        userStakeDetails.status = 0;
        userStakesById[_stakeId] = userStakeDetails;
        user memory userDetails = users[msg.sender];
        userDetails.totalStakedBalance = userDetails.totalStakedBalance - stakeAmount;
        users[msg.sender] = userDetails;
        updateStakeArray(_stakeId);
        totalStaked -= stakeAmount;
        uint256 referrerAmount = ((stakeAmount - userStakeDetails.totalCompounded) * referralFee) / percentageDivisor;
        uint256 unstakableAmount = userStakeDetails.stakeAmount - (userStakeDetails.totalClaimed + referrerAmount);
        require(unstakableAmount > 0,"Cannot unstake, already claimed more than staked amount");
        uint256 unstakeFeeAmount = (unstakableAmount * unstakeFee) / percentageDivisor;
        uint256 devFeeAmount = unstakeFeeAmount / 2;
        unstakableAmount = unstakableAmount - unstakeFeeAmount;
        require(busd.balanceOf(address(this)) >= unstakableAmount, "Insufficient contract balance");
        splitTransferDevShare(devFeeAmount);
        bool success = busd.transfer(msg.sender, unstakableAmount);
        require(success, "BUSD Transfer failed.");
        return true;
    }

    function claim(uint256 _stakeId) nonReentrant public returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1, "You can not claim after unstaked or if inactive stake");
        require(userStakeDetails.totalClaimed <= (userStakeDetails.stakeAmount * maxReturns),"You can not claim more than 3x of your investment");
        require(userStakeDetails.nextActionTime <= block.timestamp,"You can not withdraw more than once in 24 hours");
        uint256 unclaimedBalance = getClaimableBalance(_stakeId);
        require(unclaimedBalance > 0,"You don't have any unclaimed balance to withdraw");
        uint256 devWithdrawFeeAmount = (unclaimedBalance * withdrawalFee) / percentageDivisor;
        uint256 referrerAmount;
        if(nft.balanceOf(userStakeDetails.referrer) > 0){
            referrerAmount = (unclaimedBalance * (nftHolderReferralFee)) / percentageDivisor;
            devWithdrawFeeAmount -= referrerAmount;
        }
        userStakeDetails.totalClaimed = userStakeDetails.totalClaimed + unclaimedBalance;
        userStakeDetails.lastActionedTime = block.timestamp;
        userStakeDetails.nextActionTime = userStakeDetails.lastActionedTime + 1 days;
        if(userStakeDetails.roi > minDailyRoi){
            userStakeDetails.roi -= roiBalancer;
        }
        userStakesById[_stakeId] = userStakeDetails;
        updateStakeArray(_stakeId);
        totalClaimed += unclaimedBalance;
        user memory userDetails = users[msg.sender];
        userDetails.totalClaimed  +=  unclaimedBalance;
        users[msg.sender] = userDetails;
        uint256 claimableBalance = unclaimedBalance - (devWithdrawFeeAmount + referrerAmount);
        WMuser memory wmUserDetails =  checkWMuser(msg.sender);
        if(wmUserDetails.totalInits > 0 && userDetails.totalClaimed >= wmUserDetails.totalInits){
            WMrecovered[msg.sender] = true;
        }
        require(busd.balanceOf(address(this)) >= claimableBalance, "Insufficient contract balance");
        bool success = busd.transfer(msg.sender, claimableBalance);
        require(success, "BUSD Transfer failed.");
        splitTransferDevShare(devWithdrawFeeAmount);
        if(referrerAmount > 0){
            success = busd.transfer(userStakeDetails.referrer, referrerAmount);
            require(success, "BUSD Transfer failed.");
        }
        return true;
    }

    function compound(uint256 _stakeId) nonReentrant public returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1, "You can not claim after unstaked or if inactive stake");
        require(userStakeDetails.nextActionTime <= block.timestamp,"You can not compound more than once in 24 hours");
        uint256 unclaimedBalance = getClaimableBalance(_stakeId);
         require(unclaimedBalance > 0,"You don't have any unclaimed balance to compound");
        userStakeDetails.totalCompounded = userStakeDetails.totalCompounded + unclaimedBalance;
        userStakeDetails.lastActionedTime = block.timestamp;
        userStakeDetails.nextActionTime = userStakeDetails.lastActionedTime + 1 days;
        if(userStakeDetails.roi < maxDailyRoi){
            userStakeDetails.roi += roiBalancer;
        }
        userStakeDetails.stakeAmount += unclaimedBalance;
        userStakesById[_stakeId] = userStakeDetails;
        updateStakeArray(_stakeId);
        totalCompounded += unclaimedBalance;
        user memory userDetails = users[msg.sender];
        userDetails.totalCompounded  +=  unclaimedBalance;
        userDetails.totalStakedBalance += unclaimedBalance; //Compounds are added to your stake
        totalStaked += unclaimedBalance; 
        users[msg.sender] = userDetails;
        return true;
    }

    function claimReferral() public {
        user memory referralUserDetails = users[msg.sender];
        require(referralUserDetails.totalStakedBalance > 0,"You do not have any active stakes");
        uint256 referralClaimAmount = referralUserDetails.unclaimedReferral;
        require(referralClaimAmount > 0,"You don't have any unclaimed referral balance");
        referralUserDetails.unclaimedReferral = 0;
        users[msg.sender] = referralUserDetails;
        bool success = busd.transfer(msg.sender, referralClaimAmount);
        require(success, "BUSD Transfer failed.");
    }

    function getClaimableBalance(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        if(userStakeDetails.status == 0){return 0;}
        uint256 roi = userStakeDetails.roi + getExtraApplicableRoi();
        if(roi > maxDailyRoi){
            roi = maxDailyRoi; 
        }
        uint applicableDividends = (userStakeDetails.stakeAmount * roi)/(percentageDivisor); //divided by 10000 to handle decimal percentages like 0.1%
        uint unclaimedDividends = (applicableDividends * getElapsedTime(_stakeId));
        return unclaimedDividends; 
    }

    function getElapsedTime(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 lapsedDays = ((block.timestamp - userStakeDetails.lastActionedTime)/3600)/24; //3600 seconds per hour so: lapsed days = lapsed time * (3600seconds /24hrs)
        return lapsedDays;  
    }

    function getExtraApplicableRoi() public view returns(uint256) {
        uint256 userExtraROI;
        WMuser memory wmUserDetails =  checkWMuser(msg.sender);
        if(wmUserDetails.totalInits > 0 && (WMrecovered[msg.sender] == false)){
            userExtraROI += wmUserExtraRoi;
        }
        if(nft.balanceOf(msg.sender) > 0){
            userExtraROI += nftHolderExtraRoi;
        }
        return userExtraROI;
    }
    
    function checkWMuser(address _userAddress) public view returns (WMuser memory){
        return wm.UsersKey(_userAddress);
    }

    function getUserStakeOwner(uint256 _stakeId) public view returns (address){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        return userStakeDetails.owner;
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
 
    function updateStakeArray(uint256 _stakeId) internal {
        userStake[] storage userStakesArray = userStakeLists[msg.sender];
        
        for(uint i = 0; i < userStakesArray.length; i++){
            userStake memory userStakeFromArrayDetails = userStakesArray[i];
            if(userStakeFromArrayDetails.id == _stakeId){
                userStakesArray[i] = userStakesById[_stakeId];
            }
        }
    }

    function splitTransferDevShare(uint256 _amount) internal{
        bool success;
        success = busd.transfer(dev1, (_amount * 4500)/10000);
        require(success, "BUSD Transfer failed.");
        success = busd.transfer(dev2, (_amount * 4500)/10000);
        require(success, "BUSD Transfer failed.");
        success = busd.transfer(dev3, (_amount * 1000)/10000);
        require(success, "BUSD Transfer failed.");
    }
    
    receive() external payable {}
}