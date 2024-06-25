// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PvPGame {
  IERC20 coin;
  address Owner;
  address burnAccount = 0x000000000000000000000000000000000000dEaD;
  uint256 burnRate = 300; //30%

  struct history {
    address owner;
    address participant;
    address winner;
    uint256 amount;
    uint256 timestamp;
  }

  uint256 totalBattles;
  address[] battleCreators;
  bool stopped = false;

  mapping(address => uint256) activeBattleInserted;
  mapping(address => history[]) userHistory;
  mapping(address => uint256) activeBattleTimestamp;

  event BattleCreated(address indexed player, uint256 indexed amount);
  event BattleConcluded(
    address indexed winner,
    address indexed loser,
    uint256 indexed amount
  );

  constructor(IERC20 _coin, address _owner) {
    Owner = _owner;
    coin = _coin;
  }

  modifier OnlyOwners() {
    require((msg.sender == Owner), "You are not the owner of the token");
    _;
  }

  // Main Functions

  function createBattle(uint256 _input) public {
    address player = msg.sender;
    require(!stopped, "Contract is currently stopped.");
    require(
      coin.balanceOf(player) >= _input,
      "You do not have enough to create the battle"
    );
    require(
      coin.allowance(player, address(this)) >= _input,
      "Allowance is not setup for this address"
    );
    require(
      activeBattleInserted[player] == 0,
      "You cannot create more than one battle"
    );

    coin.transferFrom(player, address(this), _input);
    activeBattleInserted[player] = _input;
    activeBattleTimestamp[player] = block.timestamp;
    _addAddress(player);

    emit BattleCreated(player, _input);
  }

  function joinBattle(address _whos) public {
    address player = msg.sender;

    require(!stopped, "Contract is currently stopped.");
    require(_whos != player, "You cannot enter your own battle");
    require(
      activeBattleInserted[_whos] != 0,
      "Battle does not exist / was already concluded"
    );
    require(
      coin.balanceOf(player) >= activeBattleInserted[_whos],
      "You do not have enough tokens to join the battle"
    );
    require(
      coin.allowance(player, address(this)) >= activeBattleInserted[_whos],
      "Allowance is not setup for this address"
    );

    coin.transferFrom(player, address(this), activeBattleInserted[_whos]);
    uint256 winnerIndex = _random(2, _whos);
    address winner;
    address loser;
    uint256 totalAmount = activeBattleInserted[_whos] * 2;
    if (winnerIndex == 0) {
      winner = _whos;
      loser = player;
    } else {
      winner = player;
      loser = _whos;
    }
    uint256 burnAmount = (activeBattleInserted[_whos] * burnRate) / 1000;
    activeBattleInserted[_whos] = 0;
    activeBattleTimestamp[player] = 0;
    _removeAddress(_whos);
    _burn(burnAmount);
    coin.transfer(winner, totalAmount - burnAmount);

    // Owner log
    _inputLog(
      _whos,
      _whos,
      player,
      winner,
      totalAmount - burnAmount,
      block.timestamp
    );

    // Player log
    _inputLog(
      player,
      _whos,
      player,
      winner,
      totalAmount - burnAmount,
      block.timestamp
    );

    emit BattleConcluded(winner, loser, totalAmount);
  }

  function removeBattle() public {
    address player = msg.sender;
    uint256 _tempInserted = activeBattleInserted[player];
    require(_tempInserted != 0, "You do not have a battle.");
    activeBattleInserted[player] = 0;
    _removeAddress(player);
    coin.transfer(player, _tempInserted);
  }

  function checkTotalBattleAmount() public view returns (uint256) {
    return totalBattles;
  }

  function checkTotalBattleAddresses() public view returns (address[] memory) {
    return battleCreators;
  }

  function checkUserHistory(
    address _address,
    uint256 _index
  )
    public
    view
    returns (
      address owner,
      address participant,
      address winner,
      uint256 amount,
      uint256 timestamp
    )
  {
    history memory _temp = userHistory[_address][_index];
    owner = _temp.owner;
    participant = _temp.participant;
    winner = _temp.winner;
    amount = _temp.amount;
    timestamp = _temp.timestamp;
  }

  function checkUserHistoryLength(
    address _address
  ) public view returns (uint256 length) {
    length = userHistory[_address].length;
  }

  function checkBattleInput(address _address) public view returns (uint256) {
    return activeBattleInserted[_address];
  }

  function checkBattleTimestamp(
    address _address
  ) public view returns (uint256) {
    return activeBattleTimestamp[_address];
  }

  // Utilities

  function _inputLog(
    address _player,
    address owner,
    address participant,
    address winner,
    uint256 amount,
    uint256 timestamp
  ) internal {
    history memory _history = history(
      owner,
      participant,
      winner,
      amount,
      timestamp
    );
    userHistory[_player].push(_history);
  }

  function _burn(uint256 _amount) internal {
    coin.transfer(burnAccount, _amount);
  }

  function _random(uint256 _max, address _seedaddr) internal view returns (uint256) {
    uint256 rnd = uint256(
      keccak256(abi.encodePacked(block.difficulty, block.timestamp, _max, _seedaddr))
    );
    return (rnd % _max);
  }

  function _addAddress(address _address) internal {
    battleCreators.push(_address);
    totalBattles++;
  }

  function _removeAddress(address _address) internal {
    uint256 indexToRemove = _indexOfAddress(battleCreators, _address);
    battleCreators[indexToRemove] = battleCreators[battleCreators.length - 1];
    battleCreators.pop();
    totalBattles--;
  }

  function _indexOfAddress(
    address[] memory arr,
    address _index
  ) internal pure returns (uint256) {
    for (uint256 i = 0; i < arr.length; i++) {
      if (arr[i] == _index) {
        return i;
      }
    }
    revert("Not Found");
  }

  // Owner Functions

  function changeOwner(address _newOwner) public OnlyOwners {
    Owner = _newOwner;
  }

  function changeBurnRate(uint256 _newRate) public OnlyOwners {
    burnRate = _newRate;
  }

  function removeBattleOwner(address _player) public OnlyOwners {
    uint256 _tempInserted = activeBattleInserted[_player];
    require(_tempInserted != 0, "This player does not have a battle active");
    activeBattleInserted[_player] = 0;
    _removeAddress(_player);
  }

  function withdraw() public OnlyOwners {
    uint256 _balance = coin.balanceOf(address(this));
    coin.transfer(Owner, _balance);
  }
}