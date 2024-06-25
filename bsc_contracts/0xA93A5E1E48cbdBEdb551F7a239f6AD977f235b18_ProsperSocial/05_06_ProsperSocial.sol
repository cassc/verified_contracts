// SPDX-License-Identifier: MIT

pragma solidity 0.6.5;
pragma experimental ABIEncoderV2;

import "./ContextUpgradeSafe.sol";
import "./IERC20.sol";
import "./Initializable.sol";
import "./Ownable.sol";
import "./SafeMath.sol";


contract ProsperSocial is Ownable, Initializable, ContextUpgradeSafe {

    using SafeMath for uint;

    struct Pool {
        address creator;
        address token;
        string category;
        string question;
        uint optionsCount;
        uint minBet;
        uint start;
        uint startPeriod;
        uint end;
        uint endPeriod;
    }

    uint private FEE_PART = 875;
    uint private FEE_DIVIDER = 10000;

    Pool[] public pools;
    mapping (address => bool) public whitelistedAddress;
    mapping (uint => mapping (uint => uint)) public totals;
    mapping (uint => uint) public taken;
    mapping (uint => uint) public results;
    mapping (uint => bool) public resultIsSet;
    mapping (uint => mapping (uint => string)) public options;

    mapping (address => mapping (address => uint)) public fees;
    mapping (uint => mapping (address => mapping(uint => uint))) public funds;

    event NewPool(uint id, address creator, address token, uint minBet, uint start, uint startPeriod, uint end, uint endPeriod, string ppolCategory, string poolQuestion, string[] poolOptions);
    event Bet(uint id, address sender, address asset, uint amount, uint option);
    event Collect(uint id, address sender, uint amount);
    event ResultAnnounced(uint id, uint option);
    event Claim(address claimer, address asset, uint amount);
    event Taken(uint id);

    function __ProsperSocial_init() internal initializer {
        __Context_init_unchained();
        __ProsperSocial_init_unchained();
    }

    function __ProsperSocial_init_unchained() internal initializer {
    }

    function initialize() public initializer {
        __ProsperSocial_init();
    }

    modifier canClaim(address user, address asset) {
        require(fees[user][asset] > 0, "Accumulated fees are not zero");
        _;
    }

    modifier onlyCreator(uint id) {
        require(pools[id].creator == msg.sender);
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelistedAddress[msg.sender], "Your wallet is not in whitelist");
        _;
    }

    function transfer(address from, address payable to, address asset, uint amount) internal {
        if (asset == address(0)) {
            if (address(this) != to) {
                to.call{value: amount};
            }
        } else {
            if (from == address(this)) {
                IERC20(asset).transfer(to, amount);
            } else {
                IERC20(asset).transferFrom(from, to, amount);
            }
        }
    }

    function createPool(address token, uint minBet, uint start, uint startPeriod, uint end, uint endPeriod, string memory poolCategory, string memory poolQuestion, string[] memory poolOptions) onlyWhitelisted public {
        require(block.number < start && end > start + startPeriod, "Invalid period");
        require(poolOptions.length >= 2, "Pool should have at least two options");
        uint id = pools.length;
        Pool memory newPool = Pool(msg.sender, token, poolCategory, poolQuestion, poolOptions.length, minBet, start, startPeriod, end, endPeriod);
        pools.push(newPool);

        for(uint i = 0; i < newPool.optionsCount; i++) {
            options[id][i] = poolOptions[i];
        }

        emit NewPool(id, msg.sender, token, minBet, start, startPeriod, end, endPeriod, poolCategory, poolQuestion, poolOptions);
    }

    function bet(uint id, address asset, uint amount, uint option) public payable {
        require(asset == pools[id].token, "Sent asset is same as asset in which we collect bets");
        if (asset == address(0)) {
            require(amount == msg.value, "Sent value should be equal to the amount");
        }
        require(amount > 0 && amount >= pools[id].minBet, "Amount should be at least the minimal bet");
        require(option < pools[id].optionsCount, "Option is out of bounds");
        uint start = pools[id].start;
        require(block.number >= start && block.number <= start.add(pools[id].startPeriod), "Acceptance period");
        uint fee = amount.div(500);
        uint amt = amount.sub(fee);
        totals[id][option] = totals[id][option].add(amt);
        funds[id][msg.sender][option] = funds[id][msg.sender][option].add(amt);
        fees[owner()][asset] = fees[owner()][asset].add(fee);
        transfer(msg.sender, payable(address(this)), asset, amount);
        emit Bet(id, msg.sender, asset, amount, option);
    }

    function setResult(uint id, uint option) public onlyCreator(id) {
        uint end = pools[id].end;
        require(block.number >= end && block.number <= end.add(pools[id].endPeriod), "Settlement period");
        require(option <= pools[id].optionsCount, "Option out of bounds");
        results[id] = option;
        resultIsSet[id] = true;
        emit ResultAnnounced(id, option);
    }

    function collect(uint id) public {
        uint timeToCollect = pools[id].end.add(pools[id].endPeriod);
        require(block.number > timeToCollect && block.number < timeToCollect.add(403200), "After price settlement period and not later than 14 days");
        address owner = owner();
        address token = pools[id].token;
        uint winningOption = results[id];
        uint amount = funds[id][msg.sender][winningOption];
        if (resultIsSet[id]) {
            require(amount > 0, "User has no earnings");
            uint losersTotal = 0;
            for (uint i = 0; i < pools[id].optionsCount; i++) {
                if (i == winningOption) {
                    continue;
                }
                losersTotal = losersTotal.add(totals[id][i]);
            }
            uint earnings = losersTotal.mul(amount).div(totals[id][winningOption]);
            uint fee = earnings.mul(FEE_PART).div(FEE_DIVIDER);
            fees[owner][token] = fees[owner][token].add(fee);
            earnings = earnings.sub(fee);
            amount = amount.add(earnings);
            taken[id] = taken[id].add(amount).add(fee);
        } else {
            amount = 0;
            for (uint i = 0; i < pools[id].optionsCount; i++) {
                amount = amount.add(funds[id][msg.sender][i]);
            }
            taken[id] = taken[id].add(amount);
        }

        funds[id][msg.sender][winningOption] = 0;
        transfer(address(this), msg.sender, token, amount);
        emit Collect(id, msg.sender, amount);
    }

    function claimNotTaken(uint id) public onlyOwner {
        uint total = 0;
        for (uint i = 0; i < pools[id].optionsCount; i++) {
            total = total.add(totals[id][i]);
        }
        transfer(address(this), msg.sender, pools[id].token, total.sub(taken[id]));
        taken[id] = total;
        emit Taken(id);
    }

    function claim(address asset) public canClaim(msg.sender, asset) {
        uint amount = fees[msg.sender][asset];
        fees[msg.sender][asset] = 0;
        transfer(address(this), msg.sender, asset, amount);
        emit Claim(msg.sender, asset, amount);
    }

    function addAddressToWhitelist(address _address) onlyOwner public {
        whitelistedAddress[_address] = true;
    }

    function removeAddressFromWhitelist(address _address) onlyOwner public {
        whitelistedAddress[_address] = false;
    }


    uint256[44] private __gap;
}