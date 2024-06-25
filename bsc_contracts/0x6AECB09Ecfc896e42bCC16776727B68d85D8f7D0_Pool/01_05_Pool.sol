// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IPool.sol";
import "./Secure.sol";
import "./Aggregator.sol";
import "./Math.sol";

contract Pool is IPool, Secure {
  using Math for uint256;

  Aggregator private constant priceFeed =
    Aggregator(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);

  IPool private constant oldPool = IPool(0x240680d3417dCaec71AAe482bd3bd919d022BEDe);

  mapping(address => UserStruct) public override users;

  constructor() {
    owner = _msgSender();
  }

  receive() external payable {
    mining(owner);
  }

  function migrateList(address[] memory _users) external onlyOwner {
    for (uint256 i = 0; i < _users.length; i++) {
      migrate(_users[i]);
    }
  }

  function migrate(address user) public onlyOwner {
    require(users[user].referrer == address(0), "Exist");
    (address referrer, uint8 percent, uint256 totalTree, uint256 latestWithdraw) = oldPool
      .users(user);

    require(referrer != address(0), "Not exist");

    users[user].percent = percent;
    users[user].referrer = referrer;
    users[user].totalTree = totalTree;
    users[user].latestWithdraw = latestWithdraw;

    for (uint256 i = 0; i < oldPool.userDepositNumber(user); i++) {
      (uint256 amount, uint256 startTime) = oldPool.userDepositDetails(user, i);
      users[user].invest.push(Invest(amount.toUint128(), startTime.toUint128()));
    }
  }

  // Price Calculation
  function BNBPrice() public view override returns (uint256) {
    (, int256 price, , , ) = priceFeed.latestRoundData();
    return uint256(price);
  }

  function USDtoBNB(uint256 value) public view override returns (uint256) {
    return value.mulDecimals(18).div(BNBPrice());
  }

  function BNBtoUSD(uint256 value) public view override returns (uint256) {
    return value.mul(BNBPrice()).divDecimals(18);
  }

  // Deposit function
  function mining(address referrer) public payable override {
    uint256 value = BNBtoUSD(msg.value);
    require(value >= MINIMUM_INVEST, "VAL");
    if (users[_msgSender()].referrer == address(0)) {
      require(userTotalInvest(referrer) >= MINIMUM_INVEST, "REF");

      users[_msgSender()].referrer = referrer;
      users[_msgSender()].percent = BASE_PERCENT;
      users[_msgSender()].latestWithdraw = block.timestamp;

      _deposit(_msgSender(), value);

      emit RegisterUser(_msgSender(), referrer, value);
    } else {
      if (users[_msgSender()].percent == 0) {
        users[_msgSender()].percent = BASE_PERCENT;
      }
      _deposit(_msgSender(), value);

      emit UpdateUser(_msgSender(), users[_msgSender()].referrer, value);
    }
  }

  // calculate rewards
  function totalInterest(address sender) public view override returns (uint256 rewards) {
    uint256 userPercent = users[sender].percent;

    Invest[] storage userIvest = users[sender].invest;

    for (uint8 i = 0; i < userIvest.length; i++) {
      uint256 startTime = userIvest[i].startTime;
      if (startTime == 0) continue;
      uint256 latestWithdraw = users[sender].latestWithdraw;

      if (latestWithdraw.addDay() <= block.timestamp) {
        if (startTime > latestWithdraw) latestWithdraw = startTime;
        uint256 reward = userPercent.mul(userIvest[i].amount).div(1000);
        uint256 day = block.timestamp.sub(latestWithdraw).toDays();
        rewards = rewards.add(day.mul(reward));
      }
    }
  }

  function calculateInterest(address sender)
    public
    view
    override
    returns (uint256[2][] memory rewards, uint256 requestTime)
  {
    rewards = new uint256[2][](users[sender].invest.length);
    requestTime = block.timestamp;

    for (uint8 i = 0; i < rewards.length; i++) {
      (uint256 day, uint256 interest) = indexInterest(sender, i);
      rewards[i][0] = day;
      rewards[i][1] = interest;
    }
  }

  function indexInterest(address sender, uint256 index)
    public
    view
    override
    returns (uint256 day, uint256 interest)
  {
    uint256 userPercent = users[sender].percent;
    uint256 latestWithdraw = users[sender].latestWithdraw;

    Invest storage userIvest = users[sender].invest[index];
    uint256 startTime = userIvest.startTime;
    if (startTime == 0) return (0, 0);

    if (latestWithdraw.addDay() <= block.timestamp) {
      if (startTime > latestWithdraw) latestWithdraw = startTime;
      uint256 reward = userPercent.mul(userIvest.amount).div(1000);
      day = block.timestamp.sub(latestWithdraw).toDays();
      interest = day.mul(reward);
    }
  }

  // Widthraw Funtions
  function withdrawToInvest() external override {
    uint256 daily = totalInterest(_msgSender());

    require(daily >= MINIMUM_INVEST, "VAL");

    users[_msgSender()].latestWithdraw = block.timestamp;

    _deposit(_msgSender(), daily);

    emit WithdrawToInvest(_msgSender(), users[_msgSender()].referrer, daily);
  }

  function withdrawInterest() public override secured {
    require(userTotalInvest(_msgSender()) >= MINIMUM_INVEST, "USR");
    uint256 daily = totalInterest(_msgSender());

    uint256 bnbAmount = USDtoBNB(daily.sub(FEE));

    require(bnbAmount > 0, "VAL");

    users[_msgSender()].latestWithdraw = block.timestamp;

    _safeTransferETH(_msgSender(), bnbAmount); // Transfer BNB to user

    emit WithdrawInterest(_msgSender(), daily);
  }

  function withdrawInvest(uint256 index) external override secured {
    require(userTotalInvest(_msgSender()) >= MINIMUM_INVEST, "USR");
    require(users[_msgSender()].invest[index].startTime != 0, "VAL");

    (, uint256 daily) = indexInterest(_msgSender(), index);

    uint256 amount = _withdraw(_msgSender(), index);

    uint256 total = amount.add(daily);

    _safeTransferETH(_msgSender(), USDtoBNB(total.sub(FEE))); // Transfer BNB to user

    emit WithdrawInvest(_msgSender(), users[_msgSender()].referrer, total);
  }

  // Private Functions
  function _deposit(address user, uint256 value) private {
    users[user].invest.push(Invest(value.toUint128(), block.timestamp.toUint128()));

    address referrer = users[user].referrer;
    for (uint8 i = 0; i < 50; i++) {
      if (users[referrer].percent == 0) break;
      users[referrer].totalTree = users[referrer].totalTree.add(value);
      referrer = users[referrer].referrer;
    }
  }

  function _withdraw(address user, uint256 index) private returns (uint256 value) {
    users[user].invest[index].startTime = 0;

    value = users[user].invest[index].amount;

    address referrer = users[user].referrer;
    for (uint8 i = 0; i < 50; i++) {
      if (users[referrer].percent == 0) break;
      users[referrer].totalTree = users[referrer].totalTree.sub(value);
      referrer = users[referrer].referrer;
    }

    if (userTotalInvest(user) < MINIMUM_INVEST) _reset(user);
  }

  function _reset(address user) private {
    users[user].percent = 0;
    users[user].totalTree = 0;
    delete users[user].invest;
  }

  // Modify User Functions
  function changeUserPercent(address user, uint8 percent) external override onlyOwner {
    users[user].percent = percent;
  }

  function changeUserInvest(
    address user,
    uint256 index,
    Invest memory invest
  ) external override onlyOwner {
    users[user].invest[index] = invest;
  }

  function changeUserReferrer(address user, address referrer)
    external
    override
    onlyOwner
  {
    users[user].referrer = referrer;
  }

  function changeUserLatestWithdraw(address user, uint256 latestWithdraw)
    external
    override
    onlyOwner
  {
    users[user].latestWithdraw = latestWithdraw;
  }

  function removeUserInvest(address user, uint256 index) external override onlyOwner {
    _withdraw(user, index);
  }

  function resetUser(address user) external override onlyOwner {
    _reset(user);
  }

  // User API Functions
  function BNBValue(address user) external view override returns (uint256) {
    return user.balance;
  }

  function userTotalInvest(address user)
    public
    view
    override
    returns (uint256 totalAmount)
  {
    Invest[] storage userIvest = users[user].invest;
    for (uint8 i = 0; i < userIvest.length; i++) {
      if (userIvest[i].startTime > 0) totalAmount = totalAmount.add(userIvest[i].amount);
    }
  }

  function userDepositNumber(address user) external view override returns (uint256) {
    return users[user].invest.length;
  }

  function userDepositDetails(address user, uint256 index)
    external
    view
    override
    returns (uint256 amount, uint256 startTime)
  {
    amount = users[user].invest[index].amount;
    startTime = users[user].invest[index].startTime;
  }

  function userInvestDetails(address user)
    external
    view
    override
    returns (Invest[] memory)
  {
    return users[user].invest;
  }
}