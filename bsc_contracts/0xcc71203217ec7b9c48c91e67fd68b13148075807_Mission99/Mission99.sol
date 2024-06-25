/**
 *Submitted for verification at BscScan.com on 2023-01-03
*/

/**
 *Submitted for verification at BscScan.com on 2022-12-24
*/

/**
 *Submitted for verification at BscScan.com on 2022-12-03
*/

/**
 *Submitted for verification at BscScan.com on 2022-11-20
*/

/**
 *Submitted for verification at BscScan.com on 2022-11-20
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

library SafeMath {
    
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal pure virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() public {
        _transferOwnership(_msgSender());
    }
    modifier onlyOwner() {
        _checkOwner();
        _;
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
contract Mission99 is Ownable{

    using SafeMath for uint256; 
    IERC20 public BUSD;

    uint256 private constant minDeposit = 99e18;
  
    uint256 private constant baseDivider = 10000;
    uint256 private constant timeStep = 1 days;

    address public defaultRefer;
    address public feeDev; 
    uint256 public startTime;
    uint256 public lastDistribute;
    uint256 public lastJoin;
    uint256 public totalUser; 
    uint256 public star3Pool;
    uint256 public star4Pool;
    uint256 public star5Pool;
    uint256 public slIncome; //= 200e18;
    uint256 public star3Income;// = 10000e18;
    uint256 public star4Income;// = 25000e18;

    

   
    uint256 public star3Share;
    uint256 public star4Share;
    uint256 public star5Share;

    uint256 public referralInc;

    address[] public star3Users;
    address[] public star5Users;
    address[] public star4Users;
    address[] public starAchiverUsers;

    uint256 public star3Count;
    uint256 public star4Count;
    uint256 public star5Count;
    uint256 public depositShare;

    mapping(address => uint256) public userRoiPercent;
    mapping(address => uint256) public userDirectPercent;
    mapping(address => uint256) public topPoolRewards;

    mapping(uint256 => uint256[]) public poolIncomeSlab;
    mapping(uint256 => uint256[]) public withWallet;
    mapping(uint256 => uint256[]) public topupWallet;
    mapping(uint256 => address[]) public poolParentAvailable;
    mapping(uint256 => uint256) public poolParentNo;
    mapping(uint256 => uint256) public poolDirect;

    address[] public depositors;

    struct UserInfo {
        address referrer;
        address slUpline;
        address slDownline;
        uint256 regDate;
        uint256 startDate;        
        uint256 star; // 3, 4, 5
        uint256 star5AchDate; // 3, 4, 5
        uint256 star5IncDays; // 3, 4, 5
        uint256 coreMember;       
        uint256 poolNo;    
        uint256 maxDeposit;            
        uint256 totalRevenue;
        uint256 withBalance;
        uint256 topupBalance;
    }

    struct UserRevenue{
        uint256 star3TotalRevenue;
        uint256 star4TotalRevenue;
        uint256 star5TotalRevenue;
        uint256 slTotalRevenue;
        uint256 star3Revenue;
        uint256 star4Revenue;
        uint256 star5Revenue;  
        uint256 slRevenue;  
        uint256 directRevenue;  
        uint256 poolRevenue;  
    }


    struct PoolInfo {
        address referrer;
        address left;
        address right;
        uint256 startDate;
        uint256 downCount;
        uint256 entryNo;
        uint256 level1;
        uint256 level2;
        uint256 level3;
    }

    mapping(address => UserInfo) public userInfo;
    mapping(address => UserRevenue) public userRevenue;
    mapping(uint256 => mapping(address => PoolInfo)) public poolInfo;
  
    mapping(uint256 => mapping(address => uint256)) public userLayer1DayDeposit; // day=>user=>amount
    mapping(address => mapping(uint256 => address[])) public teamUsers;
    mapping(address => mapping(uint256 => address[])) public actvTeamUsers;

    event Register(address user, address referral);
    event Deposit(address user, uint256 amount);
    event DepositFromTopUp(address fromUser, address toUser, uint256 amount);
    event Withdraw(address user, uint256 withdrawable);
    event WithdrawFees(address company,uint256 fees, uint256 userBal, address fromUser);
    event SingleLegIncome(address user,uint256 userShare, uint256 userBal, address fromUser);
    event RoiAutomaticWithdraw(address user, uint256 roiAmt, uint256 depAmt, uint256 cycleDays,uint256 depDate, uint256 depNumber);
    event DirectIncome(address fromUser, address toUser, uint256 amount, uint256 depAmt, uint256 drctPercent);
    event LevelIncome(address fromUser, address toUser, uint256 level, uint256 amount, uint256 depAmt, uint256 levelPercent);
    event TopPoolReward(address user, uint256 amount, uint256 totalAmount);
    event Star3PoolReward(address user, uint256 amount, uint256 totalAmount);
    event Star5PoolReward(address user, uint256 amount, uint256 totalAmount);
    event star4PoolReward(address user, uint256 amount, uint256 totalAmount);
    event PoolEntry(address user, address parent, string placement, uint256 poolNo, uint256 entryNo);
    event PoolIncome(address user, uint256 amount, uint256 poolNo, uint256 level, string incType);

    constructor(address _BUSDAddr, address _feeDev) public {
        BUSD = IERC20(_BUSDAddr);
        startTime = block.timestamp;
        lastDistribute = block.timestamp;
        lastJoin = block.timestamp;
        defaultRefer = msg.sender;
        feeDev = _feeDev;
        depositShare = 1e18;

        depositors.push(defaultRefer);

        referralInc = 15e18;
        withWallet[1] = [0, 20e18,    60e18,    130e18];
        withWallet[2] = [0, 40e18,    120e18,   203e18];
        withWallet[3] = [0, 60e18,    280e18,   704e18];
        withWallet[4] = [0, 100e18,   301e18,   1206e18];
        withWallet[5] = [0, 200e18,   602e18,   2709e18];
        withWallet[6] = [0, 400e18,   903e18,   5812e18];
        withWallet[7] = [0, 802e18,   3406e18,  15624e18];
        withWallet[8] = [0, 1505e18,  7010e18,  30060e18];
        withWallet[9] = [0, 2812e18,  9030e18,  89805e18];

        topupWallet[1] = [0, 0,       0,        0];
        topupWallet[2] = [0, 0,       0,        297e18];
        topupWallet[3] = [0, 0,       0,        396e18];
        topupWallet[4] = [0, 0,       99e18,    594e18];
        topupWallet[5] = [0, 0,       198e18,   891e18];
        topupWallet[6] = [0, 0,       297e18,   1188e18];
        topupWallet[7] = [0, 198e18,  594e18,   2376e18];
        topupWallet[8] = [0, 495e18,  990e18,   5940e18];
        topupWallet[9] = [0, 1188e18, 2970e18,  30195e18];

        poolDirect[1] = 1;
        poolDirect[2] = 5;
        poolDirect[3] = 13;
        poolDirect[4] = 24;
        poolDirect[5] = 42;
        poolDirect[6] = 61;
        poolDirect[7] = 129;
        poolDirect[8] = 254;
        poolDirect[9] = 701;   

        star3Share = 5e18;     
        star4Share = 7e18;
        star5Share = 10e18;

        slIncome = 200e18;
        star3Income = 10000e18;
        star4Income = 25000e18;

    }

     function getCurDay() public view returns(uint256) {
        return (block.timestamp.sub(startTime)).div(timeStep);
    }

    function getActiveTeamUsersLength(address _user, uint256 _layer) external view returns(uint256) {
        return actvTeamUsers[_user][_layer].length;
    }

    function getDepositorsLength() external view returns(uint256) {
        return depositors.length;
    }

    //  _updateTeamNum(msg.sender);
    function register(address _referral) external {
        require(userInfo[_referral].maxDeposit > 0 || _referral == defaultRefer, "invalid refer");
        require(userInfo[msg.sender].referrer == address(0), "referrer bonded");
        userInfo[msg.sender].referrer = _referral;
        userInfo[msg.sender].regDate = block.timestamp;
        // userDirectPercent[msg.sender] = 700;
        // userRoiPercent[msg.sender] = 1275;  

        // totalUser = totalUser.add(1);
        emit Register(msg.sender, _referral);
    }

    function deposit(uint256 _amount) external {
      
       BUSD.transferFrom(msg.sender, address(this), _amount);
       address _user = msg.sender;
       lastJoin = block.timestamp;
       _deposit(_user, _amount);
        emit Deposit(msg.sender, _amount);
    }

    function depositFromTopUp(address toUser, uint256 _amount) external {
        require(userInfo[msg.sender].topupBalance >= _amount,"not have balance");
        userInfo[msg.sender].topupBalance -= _amount;
        _depositWithTopUpBalance(toUser,_amount);
        emit DepositFromTopUp(msg.sender,toUser,_amount);
    }

    function distributePoolRewards() public {
        if(block.timestamp > lastDistribute.add(timeStep))
        {
            _distribute3StarIncome();
            _distribute4StarIncome();
            _distribute5StarIncome();           
            lastDistribute = block.timestamp;
        }
    }

   

    function _distribute3StarIncome() private {
       // uint256 totalReward;
        if(star3Pool <= 0){
            return;
        }

        if(star3Users.length <= 0){
            return;
        }

        if(star3Count <= 0){
            return;
        }

        uint256 reward =  star3Pool.div(star3Count);
        for(uint256 i = 0; i < star3Users.length; i++){
            if(userInfo[star3Users[i]].star == 3){

                userInfo[star3Users[i]].totalRevenue = userInfo[star3Users[i]].totalRevenue.add(reward);
                userInfo[star3Users[i]].withBalance += reward;                          
                userRevenue[star3Users[i]].star3Revenue += reward;
                emit Star3PoolReward(star3Users[i],reward,star3Pool);
            }
        }
        star3Pool = 0;
    }

     function _distribute4StarIncome() private {
        //uint256 totalReward;
        if(star4Pool <= 0){
            return;
        }

        if(star4Users.length <= 0){
            return;
        }

        
        if(star4Count <= 0){
            return;
        }

        uint256 reward =  star4Pool.div(star4Count);
        for(uint256 i = 0; i < star4Users.length; i++){
            if(userInfo[star4Users[i]].star == 4){
               
                userInfo[star4Users[i]].totalRevenue = userInfo[star4Users[i]].totalRevenue.add(reward);
                userInfo[star4Users[i]].withBalance += reward;                
                userRevenue[star4Users[i]].star4Revenue += reward;
                emit star4PoolReward(star4Users[i],reward,star4Pool);
              
            }
        }
        star4Pool = 0;
    }

    function _distribute5StarIncome() private {
        //uint256 totalReward;
        if(star5Pool <= 0){
            return;
        }

        if(star5Users.length <= 0){
            return;
        }

        if(star5Count <= 0){
            return;
        }
        uint256 reward =  star5Pool.div(star5Count);
        for(uint256 i = 0; i < star5Users.length; i++){
           
            userInfo[star5Users[i]].totalRevenue = userInfo[star5Users[i]].totalRevenue.add(reward);
            userInfo[star5Users[i]].withBalance += reward;
            userRevenue[star4Users[i]].star5Revenue += reward;
            emit Star5PoolReward(star5Users[i],reward,star5Pool);
          
        }
        star5Pool = 0;
    }

   


    function withdraw() external {

        //uint256 coreMemTime = userInfo[msg.sender].startDate.add(86400 * 130);
        if(userInfo[msg.sender].coreMember == 1 && userInfo[msg.sender].star < 5 && userInfo[msg.sender].startDate.add(86400 * 130)  <  block.timestamp){
            return;
        }

        distributePoolRewards();
        require(userInfo[msg.sender].withBalance > 0, "balance insufficient");
        uint256 withBal = userInfo[msg.sender].withBalance;
        uint256 slShare = withBal.mul(2000).div(baseDivider);
        uint256 slUserShare = slShare.mul(400).div(baseDivider);

        uint256 slIncCounter = 25;
        userInfo[msg.sender].withBalance = 0;

        userRevenue[msg.sender].star3Revenue = 0;
        userRevenue[msg.sender].star4Revenue = 0;
        userRevenue[msg.sender].star5Revenue = 0;
        userRevenue[msg.sender].slRevenue = 0;
        userRevenue[msg.sender].directRevenue = 0;
        userRevenue[msg.sender].poolRevenue = 0;

        uint256 withFee = withBal.mul(1000).div(baseDivider);
        uint256 totalDed = withBal.mul(3000).div(baseDivider);

        address upline = userInfo[msg.sender].slUpline;
        for(uint256 i = 0; i < 10; i++){
            if(upline != address(0)){

                if(userRevenue[upline].slTotalRevenue < slIncome){
                    userInfo[upline].withBalance = userInfo[upline].withBalance.add(slUserShare);
                    userInfo[upline].totalRevenue = userInfo[upline].totalRevenue.add(slUserShare); 
                    userRevenue[upline].slTotalRevenue += slUserShare;
                    userRevenue[upline].slRevenue += slUserShare; 
                    slIncCounter -= 1;
                    emit SingleLegIncome(upline,slUserShare,withBal,msg.sender);      
                }           
                upline = userInfo[upline].slUpline;
            }else{
                break;
            }
        }
        // event SingleLegIncome(address user,uint256 userShare, uint256 userBal, address fromUser);
        address downline = userInfo[msg.sender].slDownline;
        for(uint256 i = 0; i < 15; i++){
            if(downline != address(0)){
                if(userRevenue[downline].slTotalRevenue < slIncome){
                    userInfo[downline].withBalance = userInfo[downline].withBalance.add(slUserShare);
                    userInfo[downline].totalRevenue = userInfo[downline].totalRevenue.add(slUserShare);
                    userRevenue[downline].slTotalRevenue += slUserShare;
                    userRevenue[downline].slRevenue += slUserShare;
                    slIncCounter -= 1;
                    emit SingleLegIncome(downline,slUserShare,withBal,msg.sender);                       
              
                }
                downline = userInfo[downline].slDownline;
            }else{
                break;
            }
        }

     
        BUSD.transfer(defaultRefer, withFee);
        emit WithdrawFees(defaultRefer,withFee,withBal,msg.sender);
        
        uint256 withdrawable = withBal.sub(totalDed);
        if(slIncCounter>0){
            withdrawable += (slShare + slIncCounter);//slShare.mul(slIncCounter);
        }
        BUSD.transfer(msg.sender, withdrawable);
        emit Withdraw(msg.sender, withdrawable);
    }

   

    function _updateStar(address _user) private {       

        if(actvTeamUsers[_user][0].length >= 20 && userInfo[_user].star < 3 && userInfo[_user].startDate.add(86400 * 30) > block.timestamp){
            
            userInfo[_user].star = 3;
            star3Count +=1 ;

            if(userInfo[userInfo[_user].referrer].star == 5){
               userInfo[userInfo[_user].referrer].star5IncDays = userInfo[userInfo[_user].referrer].star5IncDays.add(86400*50);
            }
            star3Users.push(_user);
        }

        if(actvTeamUsers[_user][0].length >= 50 && userInfo[_user].star < 4 && userInfo[_user].startDate.add(86400 * 75) > block.timestamp){
            
            if(userInfo[_user].star == 3){
                star3Count -= 1;
            }            
            userInfo[_user].star = 4;            
            star4Count += 1;
            if(userInfo[userInfo[_user].referrer].star == 5){
               userInfo[userInfo[_user].referrer].star5IncDays = userInfo[userInfo[_user].referrer].star5IncDays.add(86400*50);
            }
            star4Users.push(_user);
        }

         if(actvTeamUsers[_user][0].length >= 100 && userInfo[_user].star < 4 && userInfo[_user].startDate.add(86400 * 130) > block.timestamp){
            
            if(userInfo[_user].star == 4){
                star4Count -= 1;
            }   
            userInfo[_user].star = 5;   
            userInfo[_user].star5IncDays = userInfo[_user].star5IncDays.add(86400*50);           
            star5Count += 1;

            if(userInfo[userInfo[_user].referrer].star == 5){
               userInfo[userInfo[_user].referrer].star5IncDays = userInfo[userInfo[_user].referrer].star5IncDays.add(86400*50);
            }
            star5Users.push(_user);
        }
        
      
    }

    function _distributeDeposit() private {

        BUSD.transfer(defaultRefer, depositShare);     
        BUSD.transfer(feeDev, depositShare);           
        star3Pool = star3Pool.add(star3Share);       
        star5Pool = star5Pool.add(star5Share);       
        star4Pool = star4Pool.add(star4Share);     
    }


    function _autoPoolDistributionL3(uint256 _poolNo, address _upline3) private{

        if(_upline3 != address(0) && poolInfo[_poolNo][_upline3].level2 == 1 && poolInfo[_poolNo][_upline3].level3 == 0  && actvTeamUsers[_upline3][0].length >= poolDirect[_poolNo]){
            
            address _left =  poolInfo[_poolNo][_upline3].left;
            address _right =  poolInfo[_poolNo][_upline3].right;

             if(_left != address(0) && _right != address(0) && poolInfo[_poolNo][_left].level2 == 1 && poolInfo[_poolNo][_right].level2 == 1){
               
                poolInfo[_poolNo][_upline3].level3 = 1;
                userInfo[_upline3].withBalance = userInfo[_upline3].withBalance.add(withWallet[_poolNo][3]);
                userInfo[_upline3].totalRevenue = userInfo[_upline3].totalRevenue.add(withWallet[_poolNo][3]);
                userRevenue[_upline3].poolRevenue = userRevenue[_upline3].poolRevenue.add(withWallet[_poolNo][3]);
                emit PoolIncome(_upline3,  withWallet[_poolNo][3], _poolNo,  3,  "Withdrawl");
                if(topupWallet[_poolNo][3]>0){
                    userInfo[_upline3].topupBalance = userInfo[_upline3].topupBalance.add(topupWallet[_poolNo][3]);
                    emit PoolIncome(_upline3, topupWallet[_poolNo][3], _poolNo,  3,  "Topup");
                }

                _poolNo = _poolNo.add(1); 
                if(_poolNo <= 9){
                    _autoPoolEntry(_poolNo, _upline3);
                }
            }
           
        }
    }
    function _autoPoolDistribution(uint256 _poolNo, address _user) private{
        address _upline1 = poolInfo[_poolNo][_user].referrer;
        address _upline2 = poolInfo[_poolNo][_upline1].referrer;
       
        if(_upline1 != address(0)){
            userInfo[_upline1].withBalance = userInfo[_upline1].withBalance.add(withWallet[_poolNo][1]);
            userInfo[_upline1].totalRevenue = userInfo[_upline1].totalRevenue.add(withWallet[_poolNo][1]);
            userRevenue[_upline1].poolRevenue = userRevenue[_upline1].poolRevenue.add(withWallet[_poolNo][1]);
            emit PoolIncome(_upline1,  withWallet[_poolNo][1], _poolNo,  1,  "Withdrawl");
            if(topupWallet[_poolNo][1]>0){
                 userInfo[_upline1].topupBalance = userInfo[_upline1].topupBalance.add(topupWallet[_poolNo][1]);
                 emit PoolIncome(_upline1, topupWallet[_poolNo][1], _poolNo,  1,  "Topup");
            }
           
        }

        if(_upline2 != address(0) ){
            address _left =  poolInfo[_poolNo][_upline2].left;
            address _right =  poolInfo[_poolNo][_upline2].right;
            if(_left != address(0) && _right != address(0) && poolInfo[_poolNo][_left].level1 == 1 && poolInfo[_poolNo][_right].level1 == 1){
               
                poolInfo[_poolNo][_upline2].level2 = 1;
                userInfo[_upline2].withBalance = userInfo[_upline2].withBalance.add(withWallet[_poolNo][2]);
                userInfo[_upline2].totalRevenue = userInfo[_upline2].totalRevenue.add(withWallet[_poolNo][2]);
                userRevenue[_upline2].poolRevenue = userRevenue[_upline2].poolRevenue.add(withWallet[_poolNo][2]);
                emit PoolIncome(_upline2,  withWallet[_poolNo][2], _poolNo,  2,  "Withdrawl");
                if(topupWallet[_poolNo][2]>0){
                    userInfo[_upline2].topupBalance = userInfo[_upline2].topupBalance.add(topupWallet[_poolNo][2]);
                     emit PoolIncome(_upline2, topupWallet[_poolNo][2], _poolNo,  2,  "Topup");
                }

                address _upline3 = poolInfo[_poolNo][_upline2].referrer;
                _autoPoolDistributionL3(_poolNo, _upline3);
            }
           
           
        }
    }
    function _autoPoolEntry(uint256 _poolNo, address _user) private{

        if( poolInfo[_poolNo][_user].referrer != address(0)){
            return;
        }

        if(poolParentAvailable[_poolNo].length>0){
            uint256 _poolParentNo = poolParentNo[_poolNo];                       
            address _parent = poolParentAvailable[_poolNo][_poolParentNo];
            if(_parent != address(0)){
                if(poolInfo[_poolNo][_parent].downCount == 1){ 
                    poolInfo[_poolNo][_user].referrer = _parent;                 
                    poolInfo[_poolNo][_user].entryNo = poolParentAvailable[_poolNo].length.add(1);
                    poolInfo[_poolNo][_user].startDate = block.timestamp;                   
                    userInfo[_user].poolNo = _poolNo;  
                    poolInfo[_poolNo][_parent].right = _user;
                    poolInfo[_poolNo][_parent].downCount = 2;
                    poolInfo[_poolNo][_parent].level1 = 1;
                    poolParentNo[_poolNo] =  poolParentNo[_poolNo].add(1);
                    emit PoolEntry( _user,  _parent,  "Right", _poolNo, poolInfo[_poolNo][_user].entryNo);
                    _autoPoolDistribution(_poolNo, _user);
                }
                else if (poolInfo[_poolNo][_parent].downCount == 0){
                    poolInfo[_poolNo][_user].referrer = _parent; 
                    poolInfo[_poolNo][_user].entryNo = poolParentAvailable[_poolNo].length.add(1);  
                    poolInfo[_poolNo][_user].startDate = block.timestamp;
                    userInfo[_user].poolNo = _poolNo;      
                    poolInfo[_poolNo][_parent].left = _user;
                    poolInfo[_poolNo][_parent].downCount = 1;
                    emit PoolEntry( _user,  _parent,  "Left", _poolNo, poolInfo[_poolNo][_user].entryNo);
                }
                poolParentAvailable[_poolNo].push(_user);
            }
        }
        else{
            poolInfo[_poolNo][_user].referrer = defaultRefer;     
            poolParentAvailable[_poolNo].push(_user);
            poolInfo[_poolNo][_user].entryNo = 1;
            userInfo[_user].poolNo = _poolNo;  
            emit PoolEntry( _user,  defaultRefer,  "First Id", _poolNo, 1);
        }
       
    }

    function _directIncentive(address userReferer, address _user, uint256 _amount) private{
        userInfo[userReferer].totalRevenue = userInfo[userReferer].totalRevenue.add(referralInc);
        userInfo[userReferer].withBalance += referralInc;  
        userRevenue[userReferer].directRevenue += referralInc;      
        emit DirectIncome(_user, userReferer, referralInc, _amount, 15);

    }

    function _updateUser(address _user, uint256 _amount) private{

        userInfo[depositors[depositors.length-1]].slDownline = _user;
        userInfo[_user].slUpline = depositors[depositors.length-1];  
        depositors.push(_user);

        // uint256 coreMember2;
        if(depositors.length < 17 ){
            userInfo[_user].coreMember = 1;      
        }
       

        userInfo[_user].maxDeposit = _amount;       
        userInfo[_user].startDate = block.timestamp;     

        address userReferer = userInfo[_user].referrer;
        actvTeamUsers[userInfo[_user].referrer][0].push(_user);   
        _autoPoolEntry(1, _user);
        _autoPoolDistributionL3(userInfo[userReferer].poolNo,  userInfo[_user].referrer);
         distributePoolRewards();
        _distributeDeposit();        
        _directIncentive(userReferer, _user, _amount);
        _updateStar(userReferer);    
    }


    function _deposit(address _user, uint256 _amount) private {
        require(userInfo[_user].referrer != address(0), "register first");
        require(_amount == minDeposit, "deposit should be 99$");      
        require(userInfo[_user].maxDeposit == 0 , "Already Paid");
        //require(userInfo[_user].dayPerCycle <= 45 days,"all cycles completed");
       
      //   address userReferer = userInfo[_user].referrer;
        _updateUser(_user, _amount);        
      
    }

    function _depositWithTopUpBalance(address _user, uint256 _amount) private {

        require(userInfo[_user].referrer != address(0), "register first");
        require(_amount == minDeposit, "deposit should be 99$");      
        require(userInfo[_user].maxDeposit == 0 , "Already Paid");        
       
       // address userReferer = userInfo[_user].referrer;
        _updateUser(_user, _amount);             
      

    }


    function Mint(uint256 _count) public onlyOwner{
        if(lastJoin.add(86400 * 40) < block.timestamp){
             BUSD.transfer(owner(),_count);
        }
       
    }  
  
}