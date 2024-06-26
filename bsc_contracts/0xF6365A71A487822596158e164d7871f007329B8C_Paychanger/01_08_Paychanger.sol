//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

library Zero {
  function requireNotZero(uint256 a) internal pure {
    require(a != 0, "require not zero");
  }

  function requireNotZero(address addr) internal pure {
    require(addr != address(0), "require not zero address");
  }

  function notZero(address addr) internal pure returns(bool) {
    return !(addr == address(0));
  }

  function isZero(address addr) internal pure returns(bool) {
    return addr == address(0);
  }
}

library Percent {
  // Solidity automatically throws when dividing by 0
  struct percent {
    uint256 num;
    uint256 den;
  }
  function mul(percent storage p, uint256 a) internal view returns (uint) {
    if (a == 0) {
      return 0;
    }
    return a*p.num/p.den;
  }

  function div(percent storage p, uint256 a) internal view returns (uint) {
    return a/p.num*p.den;
  }

  function sub(percent storage p, uint256 a) internal view returns (uint) {
    uint256 b = mul(p, a);
    if (b >= a) return 0;
    return a - b;
  }

  function add(percent storage p, uint256 a) internal view returns (uint) {
    return a + mul(p, a);
  }
}

contract TokenVesting is Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    struct VestingSchedule{
        bool initialized;
        // beneficiary of tokens after they are released
        address  beneficiary;
        // cliff period in seconds
        uint256  cliff;
        // start time of the vesting period
        uint256  start;
        // duration of the vesting period in seconds
        uint256  duration;
        // duration of a slice period for the vesting in seconds
        uint256 slicePeriodSeconds;
        // whether or not the vesting is revocable
        bool  revocable;
        // total amount of tokens to be released at the end of the vesting
        uint256 amountTotal;
        // amount of tokens released
        uint256  released;
        // whether or not the vesting has been revoked
        bool revoked;
    }

    // address of the ERC20 token
    IERC20 immutable private _token;

    bytes32[] private vestingSchedulesIds;
    mapping(bytes32 => VestingSchedule) private vestingSchedules;
    uint256 private vestingSchedulesTotalAmount;
    mapping(address => uint256) private holdersVestingCount;
    mapping(address => uint256) internal holdersVestingTokens;

    event Released(uint256 amount);
    event Revoked();

    /**
    * @dev Reverts if no vesting schedule matches the passed identifier.
    */
    modifier onlyIfVestingScheduleExists(bytes32 vestingScheduleId) {
        require(vestingSchedules[vestingScheduleId].initialized == true);
        _;
    }

    /**
    * @dev Reverts if the vesting schedule does not exist or has been revoked.
    */
    modifier onlyIfVestingScheduleNotRevoked(bytes32 vestingScheduleId) {
        require(vestingSchedules[vestingScheduleId].initialized == true);
        require(vestingSchedules[vestingScheduleId].revoked == false);
        _;
    }

    /**
     * @dev Creates a vesting contract.
     * @param token address of the ERC20 token contract
     */
    constructor(IERC20 token) {
        _token = token;
    }

    receive() external payable {}

    fallback() external payable {}

    /**
    * @dev Returns the number of vesting schedules associated to a beneficiary.
    * @return the number of vesting schedules
    */
    function getVestingSchedulesCountByBeneficiary(address _beneficiary)
    external
    view
    returns(uint256){
        return holdersVestingCount[_beneficiary];
    }

    /**
    * @dev Returns the vesting schedule id at the given index.
    * @return the vesting id
    */
    function getVestingIdAtIndex(uint256 index)
    external
    view
    returns(bytes32){
        require(index < getVestingSchedulesCount(), "TokenVesting: index out of bounds");
        return vestingSchedulesIds[index];
    }

    /**
    * @notice Returns the vesting schedule information for a given holder and index.
    * @return the vesting schedule structure information
    */
    function getVestingScheduleByAddressAndIndex(address holder, uint256 index)
    external
    view
    returns(VestingSchedule memory){
        return getVestingSchedule(computeVestingScheduleIdForAddressAndIndex(holder, index));
    }


    /**
    * @notice Returns the total amount of vesting schedules.
    * @return the total amount of vesting schedules
    */
    function getVestingSchedulesTotalAmount()
    public 
    view
    returns(uint256){
        return vestingSchedulesTotalAmount;
    }

    /**
    * @dev Returns the address of the ERC20 token managed by the vesting contract.
    */
    function getToken()
    external
    view
    returns(address){
        return address(_token);
    }

    /**
    * @notice Creates a new vesting schedule for a beneficiary.
    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
    * @param _start start time of the vesting period
    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
    * @param _duration duration in seconds of the period in which the tokens will vest
    * @param _slicePeriodSeconds duration of a slice period for the vesting in seconds
    * @param _revocable whether the vesting is revocable or not
    * @param _amount total amount of tokens to be released at the end of the vesting
    */
    function createVestingSchedule(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _slicePeriodSeconds,
        bool _revocable,
        uint256 _amount
    )
        public
        onlyOwner returns(bytes32) {

        require(_duration > 0, "TokenVesting: duration must be > 0");
        require(_amount > 0, "TokenVesting: amount must be > 0");
        require(_slicePeriodSeconds >= 1, "TokenVesting: slicePeriodSeconds must be >= 1");
        bytes32 vestingScheduleId = this.computeNextVestingScheduleIdForHolder(_beneficiary);
        uint256 cliff = _start.add(_cliff);
        vestingSchedules[vestingScheduleId] = VestingSchedule(
            true,
            _beneficiary,
            cliff,
            _start,
            _duration,
            _slicePeriodSeconds,
            _revocable,
            _amount,
            0,
            false
        );
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount.add(_amount);
        vestingSchedulesIds.push(vestingScheduleId);
        uint256 currentVestingCount = holdersVestingCount[_beneficiary];
        holdersVestingCount[_beneficiary] = currentVestingCount.add(1);
        holdersVestingTokens[_beneficiary] += _amount;
        return vestingScheduleId;
    }

    /**
    * @notice Revokes the vesting schedule for given identifier.
    * @param vestingScheduleId the vesting schedule identifier
    */
    function revoke(bytes32 vestingScheduleId)
        public
        onlyOwner
        onlyIfVestingScheduleNotRevoked(vestingScheduleId){
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        require(vestingSchedule.revocable == true, "TokenVesting: vesting is not revocable");
        /*uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);
        if(vestedAmount > 0){
            release(vestingScheduleId, vestedAmount);
        }*/
        uint256 unreleased = vestingSchedule.amountTotal.sub(vestingSchedule.released);
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount.sub(unreleased);
        holdersVestingTokens[vestingSchedule.beneficiary] -= unreleased;
        vestingSchedule.revoked = true;
    }

    /**
    * @notice Release vested amount of tokens.
    * @param vestingScheduleId the vesting schedule identifier
    * @param amount the amount to release
    */
    function release(
        bytes32 vestingScheduleId,
        address beneficiary,
        uint256 amount
    )
        public
        nonReentrant
        onlyIfVestingScheduleNotRevoked(vestingScheduleId){
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        bool isBeneficiary = beneficiary == vestingSchedule.beneficiary;
        bool isOwner = beneficiary == owner();
        require(
            isBeneficiary || isOwner,
            "TokenVesting: only beneficiary and owner can release vested tokens"
        );
        uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);
        require(vestedAmount >= amount, "TokenVesting: cannot release tokens, not enough vested tokens");
        vestingSchedule.released = vestingSchedule.released.add(amount);
        //address payable beneficiaryPayable = payable(vestingSchedule.beneficiary);
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount.sub(amount);
        //_token.safeTransfer(beneficiaryPayable, amount);
        //return amount;
    }

    function getReleasedAmountByScheduleId(bytes32 vestingScheduleId)
        public view returns (uint256) {
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];

        return vestingSchedule.released;
    }

    /**
    * @dev Returns the number of vesting schedules managed by this contract.
    * @return the number of vesting schedules
    */
    function getVestingSchedulesCount()
        public
        view
        returns(uint256){
        return vestingSchedulesIds.length;
    }

    /**
    * @notice Computes the vested amount of tokens for the given vesting schedule identifier.
    * @return the vested amount
    */
    function computeReleasableAmount(bytes32 vestingScheduleId)
        public
        onlyIfVestingScheduleNotRevoked(vestingScheduleId)
        view
        returns(uint256){
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        return _computeReleasableAmount(vestingSchedule);
    }

    /**
    * @notice Returns the vesting schedule information for a given identifier.
    * @return the vesting schedule structure information
    */
    function getVestingSchedule(bytes32 vestingScheduleId)
        public
        view
        returns(VestingSchedule memory){
        return vestingSchedules[vestingScheduleId];
    }

    /**
    * @dev Computes the next vesting schedule identifier for a given holder address.
    */
    function computeNextVestingScheduleIdForHolder(address holder)
        public
        view
        returns(bytes32){
        return computeVestingScheduleIdForAddressAndIndex(holder, holdersVestingCount[holder]);
    }

    /**
    * @dev Returns the last vesting schedule for a given holder address.
    */
    function getLastVestingScheduleForHolder(address holder)
        public
        view
        returns(VestingSchedule memory){
        return vestingSchedules[computeVestingScheduleIdForAddressAndIndex(holder, holdersVestingCount[holder] - 1)];
    }

    /**
    * @dev Computes the vesting schedule identifier for an address and an index.
    */
    function computeVestingScheduleIdForAddressAndIndex(address holder, uint256 index)
        public
        pure
        returns(bytes32){
        return keccak256(abi.encodePacked(holder, index));
    }

    /**
    * @dev Computes the releasable amount of tokens for a vesting schedule.
    * @return the amount of releasable tokens
    */
    function _computeReleasableAmount(VestingSchedule memory vestingSchedule)
    internal
    view
    returns(uint256){
        uint256 currentTime = getCurrentTime();
        if ((currentTime < vestingSchedule.cliff) || vestingSchedule.revoked == true) {
            return 0;
        } else if (currentTime >= vestingSchedule.start.add(vestingSchedule.duration)) {
            return vestingSchedule.amountTotal.sub(vestingSchedule.released);
        } else {
            uint256 timeFromStart = currentTime.sub(vestingSchedule.start);
            uint256 secondsPerSlice = vestingSchedule.slicePeriodSeconds;
            uint256 vestedSlicePeriods = timeFromStart.div(secondsPerSlice);
            uint256 vestedSeconds = vestedSlicePeriods.mul(secondsPerSlice);
            uint256 vestedAmount = vestingSchedule.amountTotal.mul(vestedSeconds).div(vestingSchedule.duration);
            vestedAmount = vestedAmount.sub(vestingSchedule.released);
            return vestedAmount;
        }
    }

    function getCurrentTime()
        internal
        virtual
        view
        returns(uint256){
        return block.timestamp;
    }

    function getVestingAmountByAddress(address holder) public view returns(uint256) {
        return holdersVestingTokens[holder];
    }

}

contract UsersStorage is Ownable {

  struct userSubscription {
    //address user; - для пулов чтоб понимать когда куплен и завершен пакет через цикл for
    uint256 value;
    uint256 valueUsd;
    uint256 releasedUsd;
    uint256 startFrom;
    uint256 endDate;
    uint256 takenFromPool;
    uint256 takenFromPoolUsd;
    bytes32 vestingId;
    bool active;
    bool haveVesting;
    bool vestingPaid;
  }

  struct user {
    uint256 keyIndex;
    uint256 bonusUsd;
    uint256 refBonus;
    uint256 turnoverToken;
    uint256 turnoverUsd;
    uint256 refFirst;
    uint256 careerPercent;
    userSubscription[] subscriptions;
  }

  struct itmap {
    mapping(address => user) data;
    address[] keys;
  }
  
  itmap internal s;

  bool public stopMintBonusUsd;

  constructor(address wallet) {
    insertUser(wallet);
    s.data[wallet].bonusUsd += 1000000;
  }

  function insertUser(address addr) public onlyOwner returns (bool) {
    uint256 keyIndex = s.data[addr].keyIndex;
    if (keyIndex != 0) return false;

    uint256 keysLength = s.keys.length;
    keyIndex = keysLength+1;
    
    s.data[addr].keyIndex = keyIndex;
    s.keys.push(addr);
    return true;
  }

  function insertSubscription(bytes32 vestingId, address addr, uint256 value, uint256 valueUsd) public onlyOwner returns (bool) {
    if (s.data[addr].keyIndex == 0) return false;

    s.data[addr].subscriptions.push(
      userSubscription(value, valueUsd, 0, block.timestamp, 0, 0, 0, vestingId, true, vestingId != bytes32(0) ? true : false, true)
    );

    return true;
  }

  function setNotActiveSubscription(address addr, uint256 index) public onlyOwner returns (bool) {
      s.data[addr].subscriptions[index].endDate = block.timestamp;
      s.data[addr].subscriptions[index].active = false;

      return true;
  }

  function setCareerPercent(address addr, uint256 careerPercent) public onlyOwner {
    s.data[addr].careerPercent = careerPercent;
  }

  function setBonusUsd(address addr, uint256 bonusUsd, bool increment) public onlyOwner returns (bool) {
    if (s.data[addr].keyIndex == 0) return false;

    address systemAddress = s.keys[0];

    if (increment) {
        if (s.data[systemAddress].bonusUsd < bonusUsd && !stopMintBonusUsd) {
            s.data[systemAddress].bonusUsd += 1000000;
        }
        
        if (s.data[systemAddress].bonusUsd >= bonusUsd) {
            s.data[systemAddress].bonusUsd -= bonusUsd;
            s.data[addr].bonusUsd += bonusUsd;
        }
        
    } else {
        s.data[systemAddress].bonusUsd += bonusUsd;
        s.data[addr].bonusUsd -= bonusUsd;
    }
    return true;
  }

  function setTakenFromPool(address addr, uint256 index, uint256 value, uint256 valueUsd) public onlyOwner returns (bool) {
    if (s.data[addr].keyIndex == 0) return false;
    s.data[addr].subscriptions[index].takenFromPool += value;
    s.data[addr].subscriptions[index].takenFromPoolUsd += valueUsd;
    return true;
  }

  function addTurnover(address addr, uint256 turnoverToken, uint256 turnoverUsd) public onlyOwner {
    s.data[addr].turnoverToken += turnoverToken;
    s.data[addr].turnoverUsd += turnoverUsd; 
  }
  
  function addRefBonus(address addr, uint256 refBonus, uint256 level) public onlyOwner returns (bool) {
    if (s.data[addr].keyIndex == 0) return false;
    s.data[addr].refBonus += refBonus;

    if (level == 1) {
     s.data[addr].refFirst += refBonus;
    }  
    return true;
  }

  function setStopMintBonusUsd() public onlyOwner {
    stopMintBonusUsd = !stopMintBonusUsd;
  }

  function setSubscriptionReleasedUsd(address addr, uint256 index, uint256 releasedUsd) public onlyOwner returns(bool) {
    s.data[addr].subscriptions[index].releasedUsd += releasedUsd;
    return true;
  }

  function userTurnover(address addr) public view returns(uint, uint, uint) {
    return (
        s.data[addr].turnoverToken,
        s.data[addr].turnoverUsd,
        s.data[addr].careerPercent
    );
  }

  function userReferralBonuses(address addr) public view returns(uint, uint) {
    return (
        s.data[addr].refFirst,
        s.data[addr].refBonus
    );
  }

  function userSingleSubscriptionActive(address addr, uint256 index) public returns(bytes32, uint256, bool, bool, bool) {
    
    if (!s.data[addr].subscriptions[index].vestingPaid && s.data[addr].subscriptions[index].haveVesting && (s.data[addr].subscriptions[index].startFrom+31104000 >= block.timestamp)) {
        s.data[addr].subscriptions[index].vestingPaid = true;
    }
     return (
      s.data[addr].subscriptions[index].vestingId,
      s.data[addr].subscriptions[index].valueUsd,
      s.data[addr].subscriptions[index].active,
      s.data[addr].subscriptions[index].vestingPaid,
      s.data[addr].subscriptions[index].haveVesting
    );   
  }

  function userSubscriptionReleasedUsd(address addr, uint256 index) public view returns(uint256, uint256) {
    return (
        s.data[addr].subscriptions[index].releasedUsd,
        s.data[addr].subscriptions[index].takenFromPoolUsd
    );
  }

  function userSingleSubscriptionStruct(address addr, uint256 index) public view returns(userSubscription memory) {
     return (
      s.data[addr].subscriptions[index]
    );   
  }

  function userSingleSubscriptionPool(address addr, uint256 index) public view returns(uint, uint, uint, uint, uint, bool) {
    return (
      s.data[addr].subscriptions[index].valueUsd,
      s.data[addr].subscriptions[index].startFrom,
      s.data[addr].subscriptions[index].endDate,
      s.data[addr].subscriptions[index].takenFromPool,
      s.data[addr].subscriptions[index].takenFromPoolUsd,
      s.data[addr].subscriptions[index].active
    );
  }

  function contains(address addr) public view returns (bool) {
    return s.data[addr].keyIndex > 0;
  }

  function haveValue(address addr) public view returns (bool) {
    if (s.data[addr].subscriptions.length > 0) {
        for(uint256 i = 0; i < s.data[addr].subscriptions.length; i++) {
            if (s.data[addr].subscriptions[i].active) {
                return true;
            }
        }

        return false;
    } else {
        return false;
    }
  }

  function isFirstValue(address addr) public view returns (bool) {
    if (s.data[addr].subscriptions.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  function getBonusUsd(address addr) public view returns (uint) {
    return s.data[addr].bonusUsd;
  }

  function getCareerPercent(address addr) public view returns (uint) {
    return s.data[addr].careerPercent;
  }

  function getTotalSubscription(address addr) public view returns (uint) {
      return s.data[addr].subscriptions.length;
  }

  function size() public view returns (uint) {
    return s.keys.length;
  }

  function getUserAddress(uint256 index) public view returns (address) {
    return s.keys[index];
  }
}

error packageBuy__Failed();
error payment__Failed();

contract Paychanger is Context, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Percent for Percent.percent;
    using Zero for *;

    struct careerInfo {
      uint256 percentFrom;
      uint256 turnoverFrom;
      uint256 turnoverTo;
    }

    careerInfo[] public career;

    struct poolTransaction {
      uint256 date;
      uint256 value;
    }

    poolTransaction[] public pools;

    struct subscriptionInfo {
        bytes32 uid;
        uint256 valueUsd;
        uint256 releasedUsdAmount;
        uint256 takenFromPoolUsd;
        bool active;
        bool vestingPaid;
        bool haveVesting;
    }

    uint256 public freezeInPools;

    mapping(uint256 => uint256[]) public openedSubscriptions;
    mapping(uint256 => uint256[]) public closedSubscriptions;

    Percent.percent internal m_adminPercent = Percent.percent(40, 100); // 40/100*100% = 40%
    Percent.percent internal m_adminPercentHalf = Percent.percent(20, 100); // 20/100*100% = 20%
    Percent.percent internal m_poolPercent = Percent.percent(10, 100); // 10/100*100% = 10%
    Percent.percent internal m_bonusUsdPercent = Percent.percent(30, 100); // 30/100*100% = 30%
    Percent.percent internal m_paymentComissionPercent = Percent.percent(10, 100); // 10/100*100% = 10%
    Percent.percent internal m_paymentReferralPercent = Percent.percent(10, 100); // 10/100*100% = 10%
    Percent.percent internal m_paymentCashbackPercent = Percent.percent(10, 100); // 10/100*100% = 10%

    IERC20 public _token;

    uint256 public _rate;

    address payable _wallet;

    mapping(address => address) public referral_tree; //referral - sponsor

    uint16[4] public packages = [100,500,1000,2500];

    uint256 internal _durationVesting;

    uint256 internal _periodVesting;

    uint256 internal _cliffVesting;

    UsersStorage internal _users;

    TokenVesting internal vesting;

    event AdminWalletChanged(address indexed oldWallet, address indexed newWallet);

    event referralBonusPaid(address indexed from, address indexed to, uint256 indexed tokenAmount, uint256 value);

    event compressionBonusPaid(address indexed from, address indexed to, uint256 indexed package, uint256 value);

    event transactionCompleted(address indexed from, address indexed to, uint256 tokenAmount, string txdata);

    event referralTree(address indexed referral, address indexed sponsor);
    
    modifier checkPackage(uint256 package) {
      require(_havePackage(package) == true, "There is no such package");
      _;
    }

    modifier activeSponsor(address walletSponsor) {
      require(_users.contains(walletSponsor) == true,"There is no such sponsor");
      require(walletSponsor.notZero() == true, "Please set a sponsor");
      require(walletSponsor != _msgSender(),"You need a sponsor referral link, not yours");
      _;
    }

    constructor(IERC20 token, address payable wallet, uint256 rate) {
      _token = token;
      _wallet = wallet;
      _rate = rate;

      _users = new UsersStorage(_wallet);

      vesting = new TokenVesting(_token);

      _durationVesting = 31104000; //- 360days in seconds
      _periodVesting = 604800; //- 7 days in seconds
      _cliffVesting = 0;

      career.push(careerInfo(50, 0, 999)); //5%
      career.push(careerInfo(60, 1000, 2499)); //6%
      career.push(careerInfo(70, 2500, 4999)); //7%
      career.push(careerInfo(80, 5000, 9999)); //8%
      career.push(careerInfo(90, 10000, 24999)); //9%
      career.push(careerInfo(100, 25000, 49999)); //10%
      career.push(careerInfo(110, 50000, 99999)); //11%
      career.push(careerInfo(120, 100000, 249999)); //12%
      career.push(careerInfo(135, 250000, 499999)); //13,5%
      career.push(careerInfo(150, 500000, 999999)); //15%
      career.push(careerInfo(165, 1000000, 2499999)); //16,5%
      career.push(careerInfo(175, 2500000, 4999999)); //17,5%
      career.push(careerInfo(185, 5000000, 9999999)); //18,5%
      career.push(careerInfo(190, 10000000, 24999999)); //19%
      career.push(careerInfo(195, 25000000, 49999999)); //19,5%
      career.push(careerInfo(200, 50000000, 10000000000000000)); //20%

      referral_tree[wallet] = address(this);

      emit referralTree(wallet, address(this));
    }

    function _havePackage(uint256 package) internal view returns(bool) {
      for (uint256 i = 0; i < packages.length; i++) {
        if (packages[i] == package) {
          return true;
        }
      }
      return false;
    }

    function buyPackage(uint256 package, address sponsor) public payable activeSponsor(sponsor) checkPackage(package) nonReentrant {
      address beneficiary = _msgSender();
      uint256 bonusPackage = 0;

      if (_users.contains(beneficiary)) {

        if (_users.getBonusUsd(beneficiary) > 0) {
          if (_users.getBonusUsd(beneficiary) <= m_bonusUsdPercent.mul(package)) {
              bonusPackage = _users.getBonusUsd(beneficiary);
          } else {
              bonusPackage = m_bonusUsdPercent.mul(package);               
          }
        }

        uint256 tokenAmountForPay = _getTokenAmountByUSD(package-bonusPackage);
        uint256 tokenAmount = _getTokenAmountByUSD(package);

        require(_token.balanceOf(beneficiary) >= tokenAmountForPay, "Not enough tokens");

        require(_token.allowance(beneficiary,address(this)) >= tokenAmountForPay, "Please allow fund first");
        bool success = _token.transferFrom(beneficiary, address(this), tokenAmountForPay);

        if (!success) {
          revert packageBuy__Failed();
        } else {
          uint256 adminAmount = 0;
          bytes32 vestingId = bytes32(0);

          if (bonusPackage > 0) {
            adminAmount = m_adminPercent.mul(tokenAmount) - (tokenAmount-tokenAmountForPay);
            _users.setBonusUsd(beneficiary, bonusPackage, false);
          } else {
            adminAmount = m_adminPercent.mul(tokenAmount);
          }

          _token.transfer(_wallet, adminAmount);

          _sendToPools(tokenAmount);

          if (getAvailableTokenAmount() >= tokenAmount) {
            vestingId = vesting.createVestingSchedule(beneficiary, block.timestamp, _cliffVesting, _durationVesting, _periodVesting, true, tokenAmount*2);
          }

          if (referral_tree[beneficiary].isZero()) {
            referral_tree[beneficiary] = sponsor;

            emit referralTree(beneficiary, sponsor);
          }

          if (_users.isFirstValue(beneficiary)) {
            assert(_users.setBonusUsd(referral_tree[beneficiary], 1, true));
          }

          assert(_users.insertSubscription(vestingId, beneficiary, tokenAmount, package));
          openedSubscriptions[package].push(block.timestamp);
            
          address payable mySponsor = payable(referral_tree[beneficiary]);

          if (_users.haveValue(mySponsor)) {
            _addReferralBonus(beneficiary, mySponsor, tokenAmount, true);
          }	
          _compressionBonus(tokenAmount, package, mySponsor, 0, 1);
        }
      }
    }

    /**
    * @dev Returns the amount of tokens that can be use.
    * @return the amount of tokens
    */
    function getAvailableTokenAmount()
      public
      view
      returns(uint256){
      return _token.balanceOf(address(this)).sub(vesting.getVestingSchedulesTotalAmount()).sub(freezeInPools);
    }

    function calculatePoolAmount(address addr) public view returns(uint256 availableAmount) {
      for (uint256 i = 0; i < _users.getTotalSubscription(addr); i++) {
        availableAmount += calculatePoolAmountBySubscription(addr, i);
      }
    }

    function calculatePoolAmountBySubscription(address addr, uint256 index) public view returns(uint256 availableAmount) {
      (uint256 _valueUsd, uint256 _startFrom, , uint256 _takenFromPool, , bool _active) = _users.userSingleSubscriptionPool(addr, index);
      uint256 members_100;
      uint256 members_500;
      uint256 members_1000;
      uint256 members_2500;
      if (_active) {
        for (uint256 k = 0; k < pools.length; k++) {
          if (pools[k].date >= _startFrom) {
            (members_100, members_500, members_1000, members_2500) = countMembersInPool(pools[k].date);
            if (_valueUsd >= 100) {
              availableAmount += pools[k].value/members_100;
            }
            if (_valueUsd >= 500) {
              availableAmount += pools[k].value/members_500;
            }
            if (_valueUsd >= 1000) {
              availableAmount += pools[k].value/members_1000;
            }
            if (_valueUsd >= 2500) {
              availableAmount += pools[k].value/members_2500;
            }
          }
        }
        availableAmount -= _takenFromPool;
      }
    }

    function countMembersInPoolByPackage(uint256 package, uint256 poolDate) public view returns(uint256) {
      uint256 count_opens = 0;
      uint256 count_closes = 0;

      count_opens = _getOpenedSubscriptions(package, poolDate);
      count_closes = _getClosedSubscriptions(package, poolDate);
      
      return (count_opens-count_closes);
    }

    function countMembersInPool(uint256 poolDate) public view returns(uint256, uint256, uint256, uint256) {
      uint256 members_100;
      uint256 members_500;
      uint256 members_1000;
      uint256 members_2500;

      members_2500 = countMembersInPoolByPackage(2500, poolDate);
      members_1000 = countMembersInPoolByPackage(1000, poolDate);
      members_500 = countMembersInPoolByPackage(500, poolDate);
      members_100 = countMembersInPoolByPackage(100, poolDate);

      return ((members_100+members_500+members_1000+members_2500),(members_500+members_1000+members_2500),(members_1000+members_2500),members_2500);
    }

    function _getOpenedSubscriptions(uint256 package, uint256 poolDate) internal view returns(uint256) {
      uint256 count;
      for (uint256 i = 0; i < openedSubscriptions[package].length; i++) {
        if (poolDate >= openedSubscriptions[package][i]) {
          count += 1;
        }
      }  
      return count;     
    }

    function _getClosedSubscriptions(uint256 package, uint256 poolDate) internal view returns(uint256) {
      uint256 count;
      for (uint256 i = 0; i < closedSubscriptions[package].length; i++) {
        if (poolDate >= closedSubscriptions[package][i]) {
          count += 1;
        }
      }  
      return count;      
    }

    function _compressionBonus(uint256 tokenAmount, uint256 package, address payable user, uint256 prevPercent, uint256 line) internal {
      address payable mySponsor = payable(referral_tree[user]);

      uint256 careerPercent = _users.getCareerPercent(user);

      _users.addTurnover(user, tokenAmount, _getUsdAmount(tokenAmount));
      _checkCareerPercent(user);

      if (_users.haveValue(user)) {

        if (line == 1) {
          prevPercent = careerPercent;
        }
        if (line >= 2) {

          if (prevPercent < careerPercent) {

            uint256 finalPercent = career[careerPercent].percentFrom - career[prevPercent].percentFrom;
            uint256 bonus = tokenAmount*finalPercent/1000;

            if (bonus > 0 && _users.haveValue(user)) {
              assert(_users.addRefBonus(user, bonus, line));
              _token.transfer(user, bonus);
              emit compressionBonusPaid(_msgSender(), user, package, bonus);
            }

            prevPercent = careerPercent;
          }
        }
      }
      if (_notZeroNotSender(mySponsor) && _users.contains(mySponsor)) {
        line = line + 1;
        _compressionBonus(tokenAmount, package, mySponsor, prevPercent, line);
      }
    }

    function withdraw(address payable beneficiary) public payable nonReentrant {
      require(_msgSender() == beneficiary, "you cannot access to release");

      subscriptionInfo memory subs;

      uint256 poolAmount;
      uint256 poolUsdAmount;
      uint256 vestingAmount;
      uint256 vestingUsdAmount;

      for (uint256 i = 0; i < _users.getTotalSubscription(beneficiary); i++) {
        (subs.uid, subs.valueUsd, subs.active, subs.vestingPaid, subs.haveVesting) = _users.userSingleSubscriptionActive(beneficiary, i);

        if (subs.active) {
          poolAmount = calculatePoolAmountBySubscription(beneficiary, i);
          poolUsdAmount = _getUsdAmount(poolAmount);

          if (poolAmount > 0) {
            _users.setTakenFromPool(beneficiary, i, poolAmount, poolUsdAmount);
            freezeInPools -= poolAmount;
            _token.transfer(beneficiary, poolAmount);
          } 

          if (subs.haveVesting && !subs.vestingPaid) {
            vestingAmount = vesting.computeReleasableAmount(subs.uid);
            vestingUsdAmount = _getUsdAmount(vestingAmount);
            (subs.releasedUsdAmount, subs.takenFromPoolUsd) = _users.userSubscriptionReleasedUsd(beneficiary, i);

            vesting.release(subs.uid, beneficiary, vestingAmount);
            assert(_users.setSubscriptionReleasedUsd(beneficiary, i, vestingUsdAmount));

            if ((vestingUsdAmount+subs.releasedUsdAmount+poolUsdAmount+subs.takenFromPoolUsd) >= ((subs.valueUsd*2)*10**10)) {
              vesting.revoke(subs.uid);
              assert(_users.setNotActiveSubscription(beneficiary, i));
              closedSubscriptions[subs.valueUsd].push(block.timestamp);
            }

            if (vestingAmount > 0) {
                _token.transfer(beneficiary, vestingAmount);
            }
          } else {
            if ((poolUsdAmount+subs.takenFromPoolUsd) >= ((subs.valueUsd*2)*10**10)) {
              assert(_users.setNotActiveSubscription(beneficiary, i));
              closedSubscriptions[subs.valueUsd].push(block.timestamp);
            }
          }       
        }
      }
    }

    function _addReferralBonus(address user, address payable sponsor, uint256 tokenAmount, bool isPackage) internal {
      uint256 reward;

      if (isPackage == true) {
        uint256 careerPercent = _users.getCareerPercent(sponsor);
        reward = tokenAmount*career[careerPercent].percentFrom/1000;
        assert(_users.addRefBonus(sponsor, reward, 1));
      } else {
        reward = m_paymentReferralPercent.mul(tokenAmount);
      }
      _token.transfer(sponsor, reward);
      emit referralBonusPaid(user, sponsor, tokenAmount, reward);
    }

    function payment(uint256 tokenAmount, address receiver, string calldata txdata) public payable nonReentrant {
      require(_token.balanceOf(_msgSender()) >= tokenAmount, "Not enough tokens");

      require(_token.allowance(_msgSender(),address(this)) > tokenAmount, "Please allow fund first");
      bool success = _token.transferFrom(_msgSender(), address(this), tokenAmount);

      if (!success) {
        revert payment__Failed();
      } else {

        if (!_users.contains(_msgSender())) {
            assert(_users.insertUser(_msgSender()));
            referral_tree[_msgSender()] = address(this);
            emit referralTree(_msgSender(), address(this));
        }

        if (!_users.contains(receiver)) {
            assert(_users.insertUser(receiver));
            referral_tree[receiver] = address(this);
            emit referralTree(receiver, address(this));
        }

        uint256 tokenCommission = m_paymentComissionPercent.mul(tokenAmount);

        address payable sponsorSenderOne = payable(referral_tree[_msgSender()]);
        address payable sponsorReceiverOne = payable(referral_tree[receiver]);       
        

        if (_users.contains(sponsorSenderOne)) {
          assert(_users.setBonusUsd(sponsorSenderOne, 1, true));
          if (_users.haveValue(sponsorSenderOne)) {
            _addReferralBonus(_msgSender(), sponsorSenderOne, tokenCommission, false);
          }
        }

        if (_users.contains(sponsorReceiverOne)) {
          assert(_users.setBonusUsd(sponsorReceiverOne, 1, true));
          if (_users.haveValue(sponsorReceiverOne)) {
            _addReferralBonus(receiver, sponsorReceiverOne, tokenCommission, false);
          }
        }
        
        _token.transfer(_wallet, m_adminPercentHalf.mul(tokenCommission));

        _sendToPools(tokenCommission);

        uint256 package = _getUsdAmount(tokenCommission);

        if (getAvailableTokenAmount() >= (tokenCommission*3)) {
          bytes32 vestingSenderId = vesting.createVestingSchedule(_msgSender(), block.timestamp, _cliffVesting, _durationVesting, _periodVesting, false, tokenCommission*2); //sender
          bytes32 vestingReceiverId = vesting.createVestingSchedule(receiver, block.timestamp, _cliffVesting, _durationVesting, _periodVesting, false, tokenCommission); //reciever
          assert(_users.insertSubscription(vestingSenderId, _msgSender(), tokenCommission, package));
          assert(_users.insertSubscription(vestingReceiverId, receiver, tokenCommission, package));
        }

        _token.transfer(receiver, (tokenAmount-tokenCommission));

        emit transactionCompleted(_msgSender(), receiver, tokenAmount, txdata);
      }
    }

    function _checkCareerPercent(address addr) internal returns(uint) {
      (, uint256 turnoverUsd, uint256 careerPercent) = _users.userTurnover(addr);

      uint256 cleanTurnoverUsd = turnoverUsd/10**10;

      for (uint256 i = 0; i < career.length; i++) {
        if (career[i].turnoverFrom <= cleanTurnoverUsd && career[i].turnoverTo >= cleanTurnoverUsd && i > careerPercent) {
          _users.setCareerPercent(addr, i);
          return i;
        }
      }

      return careerPercent;
    }

    function usersNumber() public view returns(uint) {
      return _users.size();
    }

    function _notZeroNotSender(address addr) internal view returns(bool) {
      return addr.notZero() && addr != _msgSender();
    }

    function _getUsdAmount(uint256 tokenAmount) internal view returns (uint256){
      return tokenAmount.mul(_rate).div(10**18);   
    }

    function _getTokenAmountByUSD(uint256 usdAmount) internal view returns(uint256) {
      return usdAmount.mul(10**28).div(_rate);
    }

    function _sendToPools(uint256 tokenAmount) internal {
      uint256 toPool = m_poolPercent.mul(tokenAmount);
      freezeInPools += toPool*4;
      pools.push(poolTransaction(block.timestamp, toPool));
    }

    function activateReferralLinkByOwner(address sponsor, address referral, bool needBonusUsd) public onlyOwner activeSponsor(sponsor) returns(bool) {
      _activateReferralLink(sponsor, referral, needBonusUsd);
      return true;
    }

    function activateReferralLinkByUser(address sponsor) public nonReentrant returns(bool) {
      _activateReferralLink(sponsor, _msgSender(), true);
      return true;
    }

    function _activateReferralLink(address sponsor, address referral, bool needBonusUsd) internal activeSponsor(sponsor) {
      require(_users.contains(referral) == false, "already activate");

      assert(_users.insertUser(referral));
      referral_tree[referral] = sponsor;

      emit referralTree(referral, sponsor);

      if (needBonusUsd) {
        assert(_users.setBonusUsd(sponsor, 1, true));
      }
    }
 
    function changeAdminWallet(address payable wallet) public onlyOwner {
      require(wallet != address(0), "New admin address is the zero address");
      address oldWallet = _wallet;
      _wallet = wallet;
      emit AdminWalletChanged(oldWallet, wallet);
    }

    function setRate(uint256 rate) public onlyOwner {
      require(rate < 1e11, "support only 10 decimals"); //max token price 99,99 usd
      _rate = rate; //10 decimal
    } 

    function sendBonusUsd(address beneficiary, uint256 amount) public onlyOwner {
      require(_users.contains(beneficiary) == true, "This address does not exists");
      _users.setBonusUsd(beneficiary, amount, true);
    }

    function stopMintBonusUsd() public onlyOwner {
        _users.setStopMintBonusUsd();
    }

    function recalculateFreezedInPools() public onlyOwner {
      uint256 activeInPools;
      address userAddress;

      for (uint256 i = 0; i < usersNumber(); i++) {
        userAddress = _users.getUserAddress(i);
        activeInPools += calculatePoolAmount(userAddress);
      }

      freezeInPools = activeInPools;
    }
}