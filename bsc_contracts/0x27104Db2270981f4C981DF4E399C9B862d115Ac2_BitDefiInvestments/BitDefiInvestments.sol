/**
 *Submitted for verification at BscScan.com on 2022-12-24
*/

/**
 *Submitted for verification at BscScan.com on 2022-12-23
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface BEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BitDefiInvestments {
    using SafeMath for uint256;
    BEP20 public bdf = BEP20(0x70FB764c33BA2D92C5700bE4bF8f64Eb6D7FEabc); // Bit-Defi Coin
    
    address public constant feereceiver = 0x78E94C870e2ab8A5d0C9C08e8430745b6c6444DF;
    address public creator;
    uint256 private constant baseDivider = 1000;
    uint256 private constant timeStep = 1 days;
    uint256 private  totalEntry = 1;
    uint256 public  totalStake;
    uint256 public  totalStakeWithdraw;
    struct Player {
        address referrer;
        uint256 entryno;
        uint256 myLastDeposit;
        uint256 myActDirect;
        uint256 pWithdraw;
        uint256 rWithdraw;
        uint256 sWithdraw;
        uint256 lastwDays;
        uint256 stakeTotal;
        uint256 stakeRoi;
        bool isReg;
        mapping(uint256 => uint256) b5Entry;
        mapping(uint256 => uint256) birth;
        mapping(uint256 => mapping(uint256 => uint256)) b5_level;
        mapping(uint256 => mapping(uint256 => uint256)) levelIncome;
        mapping(uint256 => mapping(uint256 => uint256)) poolIncome;
        mapping(uint256 => address) b5_upline;
        mapping(uint256 => mapping(uint256 => uint256)) levelTeam;
        mapping(uint256 => uint256) stakingTeam;
        mapping(uint256 => uint256) stakingLevel;
    }

    mapping(address => Player) public players;
    mapping( uint256 =>  address []) public b5;

    struct Deposit{
        uint256 amount;
        bool isPrimary;
        uint256 pool;
        uint256 rebirth;
        uint256 depTime;
    }

    struct UserDept{
        uint256 amount;
        uint256 depTime;
    }

    struct Withdraw{
        uint256 amount;
        uint8 wtype; 
        uint256 paidTime;
    }
    
    mapping(address => Deposit[]) public deposits;
    mapping(address => UserDept[]) public userDepts;
    mapping(address => Withdraw[]) public withdraws;
    
    
    uint[] level_bonuses = [300, 50, 40, 30, 20, 10, 10, 10, 10, 10];  
    uint[] level_stake = [100, 60, 40, 20, 10];  
    uint[] stake_bonus = [0,100, 200, 300, 500];  
    
    constructor() public {
        creator=msg.sender;
        players[msg.sender].isReg = true;
        for(uint8 i=0;i < 7; i++){
            b5[i].push(msg.sender);
        }
    }
    function contractInfo() public view returns(uint256 balance, uint256 totalSt, uint256 totalSw){
       return (bdf.balanceOf(address(this)),totalStake,totalStakeWithdraw);
    }
    function packageInfo(uint256 _pkg) pure private  returns(uint8 p) {
        if(_pkg == 100e18){
            p=1;
        }else if(_pkg == 200e18){
            p=2;
        }else if(_pkg == 300e18){
            p=3;
        }else if(_pkg == 400e18){
            p=4;
        }else if(_pkg == 500e18){
            p=5;
        }else{
            p=0;
        }
        return p;
    }

    function register(address _referrer) public returns(bool done){
        require(players[_referrer].isReg==true,"Sponsor is not registered.");
        require(players[msg.sender].isReg==false,"You are already registered.");
        players[msg.sender].referrer = _referrer;
        players[msg.sender].isReg = true;
        return true;
    }

    function b5deposit(uint256 _bdf) public {
        require(_bdf >= 50e18, "Invalid Amount");
        bdf.transferFrom(msg.sender,address(this),_bdf);
        uint8 poolNo=packageInfo(_bdf);
        require(players[msg.sender].isReg == true, "Please register first!");
        require(players[msg.sender].b5Entry[poolNo] == 0, "Already registered in pool.");
        
        players[players[msg.sender].referrer].myActDirect++;
        players[msg.sender].b5Entry[poolNo]++;
        b5[poolNo].push(msg.sender);
        bool deptype = (_bdf==50e18)?true:false;
        
        _setb5(poolNo,players[msg.sender].referrer,msg.sender,_bdf,deptype,0);

        deposits[msg.sender].push(Deposit(
            _bdf,
            deptype,
            poolNo,
            0,
            block.timestamp
        ));
    }

    function _setb5(uint256 poolNo,address _referral,address _addr,uint256 _amount, bool deptype,uint8 isNew) private{
        uint256 poollength=b5[poolNo].length;
        uint256 pool = poollength-2; 
        uint256 _ref;
        uint256 _parent;
        if(pool<1){
            _ref = 0; 
        }else{
            _ref = uint256(pool)/5; // formula (x-2)/2
        }
        if(players[b5[poolNo][_ref]].b5_level[poolNo][0]<5){
            _parent = _ref;
        }
        else{
            for(uint256 i=0;i<poollength;i++){
                if(players[b5[poolNo][i]].b5_level[poolNo][0]<5){
                   _parent = i;
                   break;
                }
            }
        }
        players[_addr].b5_upline[poolNo]=b5[poolNo][_parent];
        players[b5[poolNo][_parent]].b5_level[poolNo][0]++;
        address up=b5[poolNo][_parent];
        //referel
        _setReferral(_referral,_amount,poolNo,isNew);
        if(poolNo==0){
            //referel
            players[_referral].levelIncome[poolNo][0]+=_amount.mul(50).div(100);
            //1st upline
            players[up].poolIncome[poolNo][0]+=_amount.mul(50).div(100);
        }else{
            //1st upline
            if(players[up].b5_level[poolNo][0]>2){
                if(players[up].b5Entry[poolNo]>0){
                   players[up].poolIncome[poolNo][0]+=_amount.mul(50).div(100);
                }
                else{
                    players[creator].poolIncome[poolNo][0]+=_amount.mul(50).div(100);
                }
                
            }
            if(players[up].b5_level[poolNo][0]==5){
                players[up].b5_level[poolNo][0]=0;
                b5[poolNo].push(up);
                players[up].birth[poolNo]++;
                deposits[up].push(Deposit(
                    _amount,
                    deptype,
                    poolNo,
                    players[up].birth[poolNo],
                    block.timestamp
                ));
                _setb5(poolNo,players[up].referrer,up,_amount,deptype,1);
            }
            //Feereceiver
            bdf.transfer(feereceiver,_amount.mul(1).div(100));
        }
    }
    function _setReferral(address _referral, uint256 _refAmount, uint256 poolNo, uint8 isNew) private {
        for(uint8 i = 0; i < level_bonuses.length; i++) {
            if(poolNo>=1){
                
                if(players[_referral].b5Entry[poolNo]>0){
                    players[_referral].levelIncome[poolNo][i]+=_refAmount.mul(level_bonuses[i]).div(baseDivider);
                }
                else{
                    players[creator].levelIncome[poolNo][i]+=_refAmount.mul(level_bonuses[i]).div(baseDivider);
                }
            }
            if(isNew==0){
                players[_referral].levelTeam[poolNo][i]++;
            }
            _referral = players[_referral].referrer;
            if(_referral == address(0)) break;
        }
    }

    function staking(uint256 _bdf) public {
        require(_bdf >= 100e18 && _bdf <= 10000e18, "Invalid Amount!");
        require(players[msg.sender].isReg == true, "Please register first.");
        require(players[msg.sender].myLastDeposit==0, "Already staked. Staking is allowed only ones.");
        require(players[msg.sender].b5Entry[5] > 0, "Please buy all pools before staking.");
        bdf.transferFrom(msg.sender, address(this), _bdf);
        totalStake+=_bdf;
        if(players[msg.sender].myLastDeposit==0){
            players[msg.sender].entryno=totalEntry;
            totalEntry++;
        }
        players[msg.sender].myLastDeposit=_bdf;
        userDepts[msg.sender].push(UserDept(
            _bdf,
            block.timestamp
        ));
        UserDept storage pl = userDepts[msg.sender][userDepts[msg.sender].length-1];
        uint256 totalDays=getCurDay(pl.depTime);
        totalDays=(totalDays>=200)?200:totalDays;
        if(totalDays>players[msg.sender].lastwDays && players[msg.sender].stakeTotal>0){
            uint256 roiDay=totalDays-players[msg.sender].lastwDays;
            players[msg.sender].lastwDays=totalDays;
            players[msg.sender].stakeRoi+=players[msg.sender].stakeTotal.mul(roiDay).div(100);
        }
        players[msg.sender].stakeTotal+=_bdf;

        if(userDepts[msg.sender].length>=2 && players[msg.sender].entryno<=100){
            players[msg.sender].stakeTotal+=_bdf.mul(stake_bonus[userDepts[msg.sender].length-1]).div(100);
        }
        _setReferralStake(players[msg.sender].referrer,_bdf);
        //Feereceiver
        bdf.transfer(feereceiver,_bdf.mul(1).div(100));
    }

    function _setReferralStake(address _referral, uint256 _refAmount) private {
        for(uint8 i = 0; i < level_stake.length; i++) {
            players[_referral].stakingLevel[i]+=_refAmount.mul(level_stake[i]).div(baseDivider);
            players[_referral].stakingTeam[i]++;
            
           _referral = players[_referral].referrer;
            if(_referral == address(0)) break;
        }
    }
    
    function b5Info(uint8 pool) view external returns(address [] memory) {
        return b5[pool];
    }
    
    function entryDetails(address _addr) view external returns(uint256 [7] memory b5e) {
        for(uint8 i=0;i<7;i++){
            b5e[i]=players[_addr].b5Entry[i];
        }
        return b5e;
    }

    function birthDetails(address _addr) view external returns(uint256 [7] memory birth) {
        for(uint8 i=0;i<7;i++){
            birth[i]=players[_addr].birth[i];
        }
        return birth;
    }

    function stakeTeamDetails(address user) public view returns(uint256 [5] memory staketeam){
        Player storage pl = players[user];
        for(uint8 i = 0; i < 5; i++) {
            staketeam[i] = pl.stakingTeam[i];
        }
        return(staketeam);
    }

    function poolTeamDetails(address user, uint256 poolNo) public view returns(uint256 [10] memory levelteam){
        Player storage pl = players[user];
        for(uint8 j = 0; j < 10; j++) {
            levelteam[j] = pl.levelTeam[poolNo][j];
        }
        return(levelteam);
    }

    function poolDetails(address _addr, uint256 poolno) view external returns(uint256 seatno) {
        return players[_addr].b5_level[poolno][0];
    }

    function pDetails(address _addr) view external returns(uint256 direct,uint256 pool,uint256 pw) {
        return (
           players[_addr].levelIncome[0][0],
           players[_addr].poolIncome[0][0],
           players[_addr].pWithdraw
        );
    }
    function rDetails(address _addr,uint256 poolNo) view external returns(uint256 levelAll,uint256 pool,uint256[10] memory level,uint256 rw) {
        pool=players[_addr].poolIncome[poolNo][0];
        for(uint8 j=0; j<10;j++){
            levelAll+=players[_addr].levelIncome[poolNo][j];
            level[j]+=players[_addr].levelIncome[poolNo][j];
        }
        return (
           levelAll,
           pool,
           level,
           players[_addr].rWithdraw
        );
    }
    function sDetails(address _addr) view external returns(uint256[5] memory stakelevel,uint256 stakeinc,uint256 stakeTt,uint256 sw) {
        Player storage pl = players[_addr];
        uint256 myRoi;
        
        for(uint8 i = 0; i < 5; i++) {
            stakelevel[i] = pl.stakingLevel[i];
        }
        if(userDepts[_addr].length>0){
            UserDept storage u = userDepts[_addr][userDepts[_addr].length-1];
            uint256 totalDays=getCurDay(u.depTime);
            if(totalDays>=200){
                totalDays=200;
            }
            myRoi+=pl.stakeTotal.mul(totalDays).div(100);
        }

        return(
            stakelevel,
            myRoi,
            pl.stakeTotal,
            pl.sWithdraw
        );
    }

    function userTxnsLength(address user) view public returns(uint256 deps, uint256 stakedeps, uint256 payouts){
        return(deposits[user].length, userDepts[user].length, withdraws[user].length);
    }

    function pwithdraw(uint256 _amount) public{
        require(_amount >= 10e18, "Minimum 10 need");
        
        Player storage player = players[msg.sender];
        uint256 bonus;
        bonus=(player.poolIncome[0][0]+player.levelIncome[0][0])-player.pWithdraw;
        require(_amount<=bonus,"Amount exceeds withdrawable");
        player.pWithdraw+=_amount;
        bdf.transfer(msg.sender,_amount);

        withdraws[msg.sender].push(Withdraw(
            _amount,
            1,
            block.timestamp
        ));
    }
    function rwithdraw(uint256 _amount) public{
        require(_amount >= 10e18, "Minimum 10 need");
        
        Player storage player = players[msg.sender];
        require(player.levelTeam[0][0] >= 5, "Required minimum 5 direct members in primary pool ");
        uint256 bonus;
        for(uint8 i = 1; i < 6; i++){
            bonus+=player.poolIncome[i][0];
            for(uint8 j=0; j<10;j++){
                bonus+=player.levelIncome[i][j];
            }
        }
        bonus-=player.rWithdraw;
        require(_amount<=bonus,"Amount exceeds withdrawable");
        player.rWithdraw+=_amount;
        bdf.transfer(msg.sender,_amount);

        withdraws[msg.sender].push(Withdraw(
            _amount,
            2,
            block.timestamp
        ));
    }
    function swithdraw(uint256 _amount) public{
        require(_amount >= 1e18, "Minimum 1 need");
        
        Player storage player = players[msg.sender];
        require(player.levelTeam[0][0] >= 5, "Required minimum 5 direct members in primary pool ");
        UserDept storage pl = userDepts[msg.sender][userDepts[msg.sender].length-1];
        uint256 totalDays=getCurDay(pl.depTime);
        totalDays=(totalDays>=200)?200:totalDays;
        if(totalDays>player.lastwDays){
            uint256 roiDay=totalDays-player.lastwDays;
            player.lastwDays=totalDays;
            player.stakeRoi+=player.stakeTotal.mul(roiDay).div(100);
        }
        uint256 bonus;
        for(uint8 i = 0; i < 5; i++) {
            bonus+= player.stakingLevel[i];
        }
        bonus+=player.stakeRoi;
        bonus-=player.sWithdraw;
        player.sWithdraw+=_amount;
        
        require(_amount<=bonus && player.sWithdraw <= player.myLastDeposit.mul(2000).div(baseDivider),"Amount exceeds withdrawable");
        bdf.transfer(msg.sender,_amount);
        totalStakeWithdraw+=_amount;
        if(player.sWithdraw >= player.myLastDeposit.mul(2000).div(baseDivider)){
            player.stakeRoi = 0;
            player.stakeTotal = 0;
            for(uint8 i = 0; i < 5; i++) {
                player.stakingLevel[i] = 0;
            }

        }
        withdraws[msg.sender].push(Withdraw(
            _amount,
            3,
            block.timestamp
        ));
    }
    function getCurDay(uint256 startTime) public view returns(uint256) {
        return (block.timestamp.sub(startTime)).div(timeStep);
    }
}  

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) { return 0; }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}