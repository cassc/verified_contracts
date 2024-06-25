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

contract KongStake is Ownable, ReentrancyGuard {
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
        uint256 status; //0 : Unstaked, 1 : Staked
        address referrer;
        address owner;
    	uint256 createdTime;
    }

    userStake[] public userStakeArray;

    address public dev1 = 0xBb61125269A86b90b5E1e23547811A3fF04bD11D;
    address public dev2 = 0x2DD3a7Ae8B896520794c8DE43358953BD11a6dB2;
    address public dev3 = 0x02D17fDFdA84eaD75DCF8c9a9a98D8F0F911D155;

    uint256 public minDeposit = 10 ether; //Minimum stake 10 BUSD
    uint256 public baseDailyRoi = 200; //2%
    uint256 public roiBalancer = 5; //0.05%
    uint256 public minDailyRoi = 100; //1%
    uint256 public maxDailyRoi = 100; //1%
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

    uint256 public totalUsers;
    uint256 public totalStaked;
    uint256 public totalClaimed;
    uint256 public totalCompounded;
  
    uint256 public stakeIndex;

    bool public isStarted = false;

    //Testnet
    address public busdAddress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    IERC20 busd = IERC20(busdAddress);

    address public nftAddress = 0xB76D45af35F48F7E995715879387C2502EddE9E8;
    IERC20 nft = IERC20(nftAddress);

    address public wmAddress = 0x9B9C918FAC2DFCCaFff3B95b4f46FD9A5D9D701b;
    WM wm = WM(wmAddress);

    function startStake() public onlyOwner{
        require(isStarted == false,"Stake is already started");
        isStarted = true;
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
        userStakeDetails.roi = getApplicableRoi();
        userStakeDetails.lastActionedTime = block.timestamp;
        userStakeDetails.nextActionTime = userStakeDetails.lastActionedTime + 1 days;
        userStakeDetails.status = 1;
        userStakeDetails.referrer = _referrer;
        userStakeDetails.owner = msg.sender;
        userStakeDetails.createdTime = block.timestamp;
        userStakesById[stakeId] = userStakeDetails;
        uint256[] storage userStakeIdsArray = userStakeIds[msg.sender];
        userStakeIdsArray.push(stakeId);
        userStakeArray.push(userStakeDetails);
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
        return true;
    }

    function unstake(uint256 _stakeId) nonReentrant external returns (bool){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 stakeAmount = userStakeDetails.stakeAmount;
        require(userStakeDetails.owner == msg.sender,"You don't own this stake");
        require(userStakeDetails.status == 1,"You already have unstaked");
        userStakeDetails.status = 0;
        userStakesById[_stakeId] = userStakeDetails;
        user memory userDetails = users[msg.sender];
        userDetails.totalStakedBalance = userDetails.totalStakedBalance - stakeAmount;
        users[msg.sender] = userDetails;
        updateStakeArray(_stakeId);
        totalStaked -= stakeAmount;
        uint256 referrerAmount = (stakeAmount * referralFee) / percentageDivisor;
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
        require(userStakeDetails.status == 1, "You can not claim after unstaked");
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
        WMuser memory wmUserDetails =  checkWMuser(msg.sender);
        if(userDetails.totalClaimed < wmUserDetails.totalInits){
            WMrecovered[msg.sender] = true;
        }
        require(busd.balanceOf(address(this)) >= unclaimedBalance, "Insufficient contract balance");
        bool success = busd.transfer(msg.sender, unclaimedBalance);
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
        require(userStakeDetails.status == 1, "You can not claim after unstaked");
        require(userStakeDetails.nextActionTime <= block.timestamp,"You can not compound more than once in 24 hours");
        uint256 unclaimedBalance = getClaimableBalance(_stakeId);
         require(unclaimedBalance > 0,"You don't have any unclaimed balance to compound");
        userStakeDetails.totalCompounded = userStakeDetails.totalCompounded + unclaimedBalance;
        userStakeDetails.lastActionedTime = block.timestamp;
        userStakeDetails.nextActionTime = userStakeDetails.lastActionedTime + 1 days;
        if(userStakeDetails.roi < getApplicableRoi() + maxDailyRoi){
            userStakeDetails.roi += roiBalancer;
        }
        userStakeDetails.stakeAmount += unclaimedBalance;
        userStakesById[_stakeId] = userStakeDetails;
        updateStakeArray(_stakeId);
        totalCompounded += unclaimedBalance;
        user memory userDetails = users[msg.sender];
        userDetails.totalCompounded  +=  unclaimedBalance;
        users[msg.sender] = userDetails;
        return true;
    }

    function claimReferral() public {
        user memory referralUserDetails = users[msg.sender];
        require(referralUserDetails.totalStakedBalance > 0,"You do not have any active stakes");
        uint256 referralClaimAmount = referralUserDetails.unclaimedReferral;
        require(referralClaimAmount > 0,"You don't have any unclaimed referral balance");
        referralUserDetails.unclaimedReferral = 0;
        bool success = busd.transfer(msg.sender, referralClaimAmount);
        require(success, "BUSD Transfer failed.");
    }

    function getClaimableBalance(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakeArray[_stakeId];
        uint256 roi = userStakeDetails.roi;
        uint applicableDividends = (userStakeDetails.stakeAmount * roi)/(percentageDivisor); //divided by 10000 to handle decimal percentages like 0.1%
        uint unclaimedDividends = (applicableDividends * getElapsedTime(_stakeId));
        return unclaimedDividends; 
    }

    function getElapsedTime(uint256 _stakeId) public view returns(uint256){
        userStake memory userStakeDetails = userStakesById[_stakeId];
        uint256 lapsedDays = ((block.timestamp - userStakeDetails.lastActionedTime)/3600)/24; //3600 seconds per hour so: lapsed days = lapsed time * (3600seconds /24hrs)
        return lapsedDays;  
    }

    function getApplicableRoi() public view returns(uint256) {
        uint256 userROI = baseDailyRoi;
        WMuser memory wmUserDetails =  checkWMuser(msg.sender);
        if(wmUserDetails.totalInits > 0 && (WMrecovered[msg.sender] == false)){
            userROI += wmUserExtraRoi;
        }
        if(nft.balanceOf(msg.sender) > 0){
            userROI += nftHolderExtraRoi;
        }
        return userROI;
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
                userStake memory userStakeDetails = userStakesById[_stakeId];
                userStakesArray[i] = userStakeDetails;
            }
        }
    }

    function splitTransferDevShare(uint256 _amount) internal{
        bool success;
        success = busd.transfer(dev1, (_amount * 4925)/10000);
        require(success, "BUSD Transfer failed.");
        success = busd.transfer(dev2, (_amount * 4925)/10000);
        require(success, "BUSD Transfer failed.");
        success = busd.transfer(dev3, (_amount * 50)/10000);
        require(success, "BUSD Transfer failed.");
    }

    receive() external payable {}
}