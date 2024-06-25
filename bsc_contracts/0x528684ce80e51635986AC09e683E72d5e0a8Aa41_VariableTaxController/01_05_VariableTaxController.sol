// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract VariableTaxController is OwnableUpgradeable {

    using SafeMath for uint256;
    using SafeMath for uint8;

    address public race_address;
    IRace private race;

    struct user_stats {
        /** stats: starting from zero after variableTaxImplementation */
        uint256 nitro_amount;
        uint256 claim_amount;
        uint256 timestamp_nitro;
        uint256 timestamp_claim;
        uint256 airdrop_amount;
        uint256 timestamp_airdrop;
        uint256 deposit_amount;
        uint256 timestamp_deposit;

        uint256 calculated_claim_backlog; // this value is live calculated with every nitro/claim/airdrop/deposit
        uint256 total_payouts; //total payouts = (claim + nitro) this value counts nitro even if 13700 is reached

        user_boosterV2[3] boosterslotsV2;
    }

    mapping(address => user_stats) public userStats;
    
    address public paymentReceiver;

    struct user_boosterV2 {
        uint256 boost; // 5 = 0.5%
        uint256 end_time;
        uint256 gastank;
    }

    uint256 booster_pointCost;
    uint256 booster_increaseRatio;
    uint256 booster_maxDays; // 30
    uint256 booster_maxBoostSum; // 10
    uint256 booster_maxBoostSingle; // 5

    address constant BUSD = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56); // MAINNET

    modifier onlyRace {
        require( msg.sender == race_address || msg.sender == owner() );
        _;
    }

    event BoosterBuy(address _addr, uint256 _busd_amount, uint256 _percentage, uint256 _days, uint256 _gas_tank);

    function initialize() external initializer {
        __Ownable_init();

        updateRaceContract(address(0xbd6e5D331A09fb39D28CB76510ae9b7d7781aE68)); // mainnet race
    }   

    /*function upgrade261122() external onlyOwner {

        booster_maxDays = 30;
        booster_maxBoostSum = 10;
        booster_maxBoostSingle = 10;
        booster_pointCost = 40;
        booster_increaseRatio = 70000000000000000; // 0.07

        paymentReceiver = address(0xB9a62a44aDf302d086f30e5Aa96Af244573Be52D); // should be the LMS contract on mainnet
    }*/

    function setMaxBoosterDays( uint256 _booster_maxDays ) external onlyOwner {
        booster_maxDays = _booster_maxDays;
    }

    function getBoosterRate( address _addr ) public view returns (uint256){
        uint256 additionalRate = 0;

        for(uint256 i = 0; i < 3; i++){
            user_boosterV2 memory booster = userStats[_addr].boosterslotsV2[i];

            if(booster.end_time > block.timestamp){
                additionalRate += booster.boost;
            }
        }

        if(additionalRate > booster_maxBoostSum){
            additionalRate = booster_maxBoostSum; //whatever happens...
        }

        return additionalRate;
    }

    function getBoosterSlotInfo(address _addr) public view returns (uint256 _slot0_percent, uint256 _slot1_percent, uint256 _slot2_percent, uint256 _slot0_endtime, uint256 _slot1_endtime, uint256 _slot2_endtime, uint256 _slot0_gastank, uint256 _slot1_gastank, uint256 _slot2_gastank ){
        if(booster_maxDays > 0){
            _slot0_percent = userStats[_addr].boosterslotsV2[0].boost;
            _slot1_percent = userStats[_addr].boosterslotsV2[1].boost;
            _slot2_percent = userStats[_addr].boosterslotsV2[2].boost;

            _slot0_endtime = userStats[_addr].boosterslotsV2[0].end_time;
            _slot1_endtime = userStats[_addr].boosterslotsV2[1].end_time;
            _slot2_endtime = userStats[_addr].boosterslotsV2[2].end_time;

            _slot0_gastank = userStats[_addr].boosterslotsV2[0].gastank;
            _slot1_gastank = userStats[_addr].boosterslotsV2[1].gastank;
            _slot2_gastank = userStats[_addr].boosterslotsV2[2].gastank;
        }else{
            _slot0_percent = 0;
            _slot1_percent = 0;
            _slot2_percent = 0;

            _slot0_endtime = 0;
            _slot1_endtime = 0;
            _slot2_endtime = 0;

            _slot0_gastank = 0;
            _slot1_gastank = 0;
            _slot2_gastank = 0;
        }
    }

    function buyBooster( uint256 _slotIndex, uint256 _boost, uint256 _days ) external {
        address _addr = msg.sender;
        require(getBoosterRate(_addr).add(_boost) <= booster_maxBoostSum, "maximum boost reached");
        require(_days <= booster_maxDays && _days > 0, "invalid day range");
        require(_boost <= booster_maxBoostSingle && _boost > 0, "invalid boost range");
        require(userStats[_addr].boosterslotsV2[_slotIndex].end_time == 0 || userStats[_addr].boosterslotsV2[_slotIndex].end_time < block.timestamp, "slot not available available" );

        (,,uint256 deposits,,,,) = race.userInfo(_addr);
        require(deposits > 0, "not invested");
        require(deposits < 50000 ether, "price not computable");
        
        uint256 boosterPrice = calculateBoosterPrice(_addr, _boost, _days);

        // auto nitro before buying the booster
        race.execAutopilot(_addr);

        require(paymentReceiver != address(0), "missing target wallet");
        require(IToken(BUSD).transferFrom(_addr, paymentReceiver, boosterPrice), "transfer payment failed");
        

        userStats[_addr].boosterslotsV2[_slotIndex] = user_boosterV2(_boost, block.timestamp.add(_days.mul(1 days)), deposits);       

        emit BoosterBuy(_addr, boosterPrice, _boost, _days, deposits);
    }

    function setPromoBooster( address _addr, uint256 _slotIndex, uint256 _boost, uint256 _days ) external onlyOwner {

        require(getBoosterRate(_addr).add(_boost) <= booster_maxBoostSum, "maximum boost reached");
        require(_days <= booster_maxDays, "maximum days exceeded");
        require(_boost <= booster_maxBoostSingle, "maximum boost rate exceeded");
        require(userStats[_addr].boosterslotsV2[_slotIndex].end_time == 0 || userStats[_addr].boosterslotsV2[_slotIndex].end_time < block.timestamp, "slot not available available" );

        (,,uint256 deposits,,,,) = race.userInfo(_addr);
        require(deposits > 0, "not invested");

        // auto nitro before adding the booster
        race.execAutopilot(_addr);
        
        userStats[_addr].boosterslotsV2[_slotIndex] = user_boosterV2(_boost, block.timestamp.add(_days.mul(1 days)), deposits);        
    }

    /*function calculateBoosterPrice( address _addr, uint256 _boost, uint256 _days ) public view returns (uint256) {
        (,,uint256 deposits,,,,) = race.userInfo(_addr);
        uint256 pistonPrice = 2 ether;
        uint256 maxWalletPayout = 50000 ether;
        uint256 tankPointRatio = booster_increaseRatio + (maxWalletPayout - abs(int(maxWalletPayout) - int(deposits))) / 1000;
        return (_boost * 10 * booster_pointCost * pistonPrice * tankPointRatio) / 1000 * _days / 1 ether;

    }*/

    function calculateBoosterPrice( address _addr, uint256 _boost, uint256 _days ) public view returns (uint256) {
        (,,uint256 deposits,,,,) = race.userInfo(_addr);
        uint256 pistonPrice = 2 ether;

        uint256 tankPointRatio = booster_increaseRatio + deposits / 1000;
        return (_boost  * booster_pointCost * pistonPrice * tankPointRatio) / 100 * _days / 1 ether;
    }

    /*function abs(int x) private pure returns (uint256) {
        return uint256(x >= 0 ? x : -x);
    }*/
    

    function _calcTotal( address _addr, uint256 _amount ) internal {
        if(userStats[_addr].total_payouts == 0){
            // get initial value from race contract
            (,,,uint256 user_payouts,,,) = race.userInfo(_addr);
            userStats[_addr].total_payouts = user_payouts; 
        }

        // increase the payouts. comes from nitro and claim
        userStats[_addr].total_payouts += _amount;
    }

    function increaseNitroDirect(uint256 _nitro_amount, address _addr) external onlyRace {
        userStats[_addr].nitro_amount += _nitro_amount;
        userStats[_addr].timestamp_nitro = block.timestamp;
        _calcTotal(_addr, _nitro_amount);

        // new
        if( _nitro_amount < userStats[_addr].calculated_claim_backlog ){
            userStats[_addr].calculated_claim_backlog -= _nitro_amount; // reduce claim backlog
        }else{
            userStats[_addr].calculated_claim_backlog = 0;
        }  
    }

    function increaseNitro(uint256 _nitro_amount) external onlyRace {
        address _addr = tx.origin;

        userStats[_addr].nitro_amount += _nitro_amount;
        userStats[_addr].timestamp_nitro = block.timestamp;
        _calcTotal(_addr, _nitro_amount);

        // new
        if( _nitro_amount < userStats[_addr].calculated_claim_backlog ){
            userStats[_addr].calculated_claim_backlog -= _nitro_amount; // reduce claim backlog
        }else{
            userStats[_addr].calculated_claim_backlog = 0;
        }  
    }
    
    function increaseClaim(uint256 _claim_amount) external onlyRace {
        address _addr = tx.origin;

        userStats[_addr].claim_amount += _claim_amount;
        userStats[_addr].timestamp_claim = block.timestamp;
        _calcTotal(_addr, _claim_amount);

        // new 
        userStats[_addr].calculated_claim_backlog += _claim_amount;
    }

    function increaseAirdrop(uint256 _airdrop_amount) external onlyRace {
        address _addr = tx.origin;

        userStats[_addr].airdrop_amount += _airdrop_amount;
        userStats[_addr].timestamp_airdrop = block.timestamp;

        // new
        if( _airdrop_amount < userStats[_addr].calculated_claim_backlog ){
            userStats[_addr].calculated_claim_backlog -= _airdrop_amount; // reduce claim backlog
        }else{
            userStats[_addr].calculated_claim_backlog = 0;
        }
    }

    function increaseDeposit(uint256 _deposit_amount) external onlyRace {
        address _addr = tx.origin;

        userStats[_addr].deposit_amount += _deposit_amount;
        userStats[_addr].timestamp_deposit = block.timestamp;

        // new
        if( _deposit_amount < userStats[_addr].calculated_claim_backlog ){
            userStats[_addr].calculated_claim_backlog -= _deposit_amount; // reduce claim backlog
        }else{
            userStats[_addr].calculated_claim_backlog = 0;
        }
    }

    function getVariableTax(address _addr, uint256 _base_tax, uint256 _amount_to_claim) external view returns (uint256) {
        return this.getVariableTax(_addr, _base_tax, _amount_to_claim, 0);
    }

    function getVariableTax(address _addr, uint256 _base_tax, uint256 _amount_to_claim, uint256 _amount_to_nitro) external view returns (uint256) {
        return this.getVariableTax(_addr, _base_tax, _amount_to_claim, _amount_to_nitro, 0);
    }

    function getVariableTaxV1(address _addr, uint256 _base_tax, uint256 _amount_to_claim, uint256 _amount_to_nitro, uint256 _amount_to_deposit) external view returns (uint256) {
        (,,uint256 user_deposits,,,,) = race.userInfo(_addr);

        (,,,uint256 claim_backlog,) = _getUserStats(_addr, _amount_to_claim, _amount_to_nitro, _amount_to_deposit);

        uint256 claimed_percent = SafeMath.mul(100, claim_backlog).mul(1000).div(user_deposits); 

        uint256 variableTax = 0;
        if(claimed_percent > 3000) variableTax = 15; // up to 3%
        if(claimed_percent > 5000) variableTax = 40; // 5%
        if(claimed_percent > 7000) variableTax = 65; // 7% and above

        return _base_tax.add(variableTax);
    }

    function getVariableTax(address _addr, uint256 _base_tax, uint256 _amount_to_claim, uint256 _amount_to_nitro, uint256 _amount_to_deposit) external view returns (uint256) {
        (,,uint256 user_deposits,,,,) = race.userInfo(_addr);

        (,,,uint256 claim_backlog,) = _getUserStats(_addr, _amount_to_claim, _amount_to_nitro, _amount_to_deposit);

        uint256 claimed_percent = SafeMath.mul(100, claim_backlog).mul(1000).div(user_deposits); 
        uint256 basePayoutRate = 10; // base 10 = 1%
        uint256 boosterRate = getBoosterRate(_addr);
        uint256 finalPayoutRate = basePayoutRate + boosterRate;

        uint256 variableTax = 0;
        if(claimed_percent > finalPayoutRate.mul(300)) variableTax = 15; // up to 3%
        if(claimed_percent > finalPayoutRate.mul(500)) variableTax = 40; // 5%
        if(claimed_percent > finalPayoutRate.mul(700)) variableTax = 65; // 7% and above

        return _base_tax.add(variableTax);
    }

    function _getUserStats(address _addr, uint256 _amount_to_claim, uint256 _amount_to_nitro, uint256 _amount_to_deposit) internal view returns (uint256 nitro_amount, uint256 claim_amount, uint256 airdrop_amount, uint256 claim_backlog, uint256 nitro_lead){

        uint256 claimAmount = userStats[_addr].calculated_claim_backlog.add(_amount_to_claim);
        uint256 nitroAmount = _amount_to_nitro;
        nitroAmount = nitroAmount.add(_amount_to_deposit);

        if(nitroAmount < claimAmount){
            claim_backlog = claimAmount.sub(nitroAmount);
        }else{
            claim_backlog = 0;
        }

        nitro_lead = 0; // always zero...

        return (userStats[_addr].nitro_amount, userStats[_addr].claim_amount, userStats[_addr].airdrop_amount, claim_backlog, nitro_lead);
    }

    function updateRaceContract(address _value) public onlyOwner {
        race = IRace(_value);
        race_address = _value;
    }

    function getUserStats(address _addr) external view returns(uint256 nitro_amount, uint256 claim_amount, uint256 airdrop_amount, uint256 claim_backlog, uint256 nitro_lead){
        return _getUserStats(_addr, 0, 0, 0);
    }

    function getTaxRateForecastV1(address _addr, uint256 _base_tax) external view returns(uint256 stage1Start, uint256 stage2Start, uint256 stage3Start, uint256 stage1Tax, uint256 stage2Tax, uint256 stage3Tax){
        (,,uint256 user_deposits,,,,) = race.userInfo(_addr);

        stage1Start = user_deposits.mul(3).div(100);
        stage2Start = user_deposits.mul(5).div(100);
        stage3Start = user_deposits.mul(7).div(100);

        stage1Tax = SafeMath.add(_base_tax, 15);
        stage2Tax = SafeMath.add(_base_tax, 40);
        stage3Tax = SafeMath.add(_base_tax, 65);
    }

    function getTaxRateForecast(address _addr, uint256 _base_tax) external view returns(uint256 stage1Start, uint256 stage2Start, uint256 stage3Start, uint256 stage1Tax, uint256 stage2Tax, uint256 stage3Tax){
        (,,uint256 user_deposits,,,,) = race.userInfo(_addr);

        uint256 basePayoutRate = 10; // base 10 = 1%
        uint256 boosterRate = getBoosterRate(_addr);
        uint256 finalPayoutRate = basePayoutRate + boosterRate;

        stage1Start = user_deposits.mul(finalPayoutRate.mul(3)).div(1000);
        stage2Start = user_deposits.mul(finalPayoutRate.mul(5)).div(1000);
        stage3Start = user_deposits.mul(finalPayoutRate.mul(7)).div(1000);

        stage1Tax = SafeMath.add(_base_tax, 15);
        stage2Tax = SafeMath.add(_base_tax, 40);
        stage3Tax = SafeMath.add(_base_tax, 65);
    }

    function getUserTotalPayouts(address _addr) external view returns (uint256){
        return userStats[_addr].total_payouts;
    }
    
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, throws on overflow.
   */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
   */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /* @dev Subtracts two numbers, else returns zero */
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b > a) {
            return 0;
        } else {
            return a - b;
        }
    }

    /**
     * @dev Adds two numbers, throws on overflow.
   */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

interface IRace {
    function userInfo(address _addr) external view returns(address upline, uint256 deposit_time, uint256 deposits, uint256 payouts, uint256 direct_bonus, uint256 match_bonus, uint256 last_airdrop );
    function usersRealDeposits(address _addr) external view returns(uint256 deposits, uint256 deposits_BUSD);
    function execAutopilot(address _addr) external returns (bool);
}


interface IToken {

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}