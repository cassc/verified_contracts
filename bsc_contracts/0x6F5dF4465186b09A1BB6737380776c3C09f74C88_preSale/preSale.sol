/**
 *Submitted for verification at BscScan.com on 2022-10-15
*/

/**
 *Submitted for verification at BscScan.com on 2022-07-20
 */

pragma solidity 0.8.15;

//SPDX-License-Identifier: MIT Licensed

interface IBEP20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external;

    function transfer(address to, uint256 value) external;

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
}

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract preSale {
    using SafeMath for uint256;

    IBEP20 public token;
    AggregatorV3Interface public priceFeedbnb;

    address payable public owner;

    uint256 public tokenPerUsd;
    uint256 public preSaleStartTime;
    uint256 public soldToken;
    uint256 public amountRaisedbnb;
    uint256 public totalSupply;
    uint256 public minAmount;
    uint256 public maxAmount;
    mapping(address => uint256) public coinBalance;
    modifier onlyOwner() {
        require(msg.sender == owner, "PRESALE: Not an owner");
        _;
    }

    event BuyToken(address indexed _user, uint256 indexed _amount);

    constructor(
        address payable _owner,
        IBEP20 _token,
        uint256 _time
    ) {
        owner = _owner;
        token = _token;
        priceFeedbnb = AggregatorV3Interface(
            0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE 
        );
        tokenPerUsd = 14285750000;
        totalSupply = 750000 * 1e9;
        minAmount = 0.5 ether;
        maxAmount = 20 ether;
        preSaleStartTime = _time;
    }

    receive() external payable {}

    // to get real time price of bnb
    function getLatestPricebnb() public view returns (uint256) {
        (, int256 price, , , ) = priceFeedbnb.latestRoundData();
        return uint256(price).div(1e8);
    }

    // to buy token during preSale time => for web3 use

    function buyToken() public payable {
        require(msg.value >= minAmount, "AMount too short");
        require(
            msg.value <= coinBalance[msg.sender].add(msg.value),
            "Amount too big"
        );
        require(block.timestamp >= preSaleStartTime);
        require(soldToken <= totalSupply, "All token sold");
        uint256 numberOfTokens = bnbToToken(msg.value);

        token.transfer(msg.sender, numberOfTokens);

        soldToken = soldToken.add(numberOfTokens);
        amountRaisedbnb = amountRaisedbnb.add(msg.value);
        coinBalance[msg.sender] = coinBalance[msg.sender].add(msg.value);

        emit BuyToken(msg.sender, numberOfTokens);
    }

    // to check number of token for given bnb
    function bnbToToken(uint256 _amount) public view returns (uint256) {
        uint256 bnbToUsd = _amount.mul(getLatestPricebnb());
        uint256 numberOfTokens = bnbToUsd.mul(tokenPerUsd).div(1e18);
        return numberOfTokens;
    }

    // to change Price of the token
    function changePrice(
        uint256 _price,
        uint256 _total,
        uint256 _sold
    ) external onlyOwner {
        tokenPerUsd = _price;
        totalSupply = _total;
        soldToken = _sold;
    }

    // to change preSale time duration
    function setPreSaleTime(uint256 _startTime) external onlyOwner {
        preSaleStartTime = _startTime;
    }

    function changeAmount(uint256 _amount, uint256 _maxAmount)
        external
        onlyOwner
    {
        minAmount = _amount;
        maxAmount = _maxAmount;
    }

    // transfer ownership
    function changeOwner(address payable _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    // change tokens
    function changeToken(address _token) external onlyOwner {
        token = IBEP20(_token);
    }

    // to draw funds for liquidity
    function transferFunds(uint256 _value) external onlyOwner {
        owner.transfer(_value);
    }

    // to draw out tokens
    function transferTokens(uint256 _value) external onlyOwner {
        token.transfer(owner, _value);
    }

    // to get current UTC time
    function getCurrentTime() external view returns (uint256) {
        return block.timestamp;
    }

    function contractBalancebnb() external view returns (uint256) {
        return address(this).balance;
    }

    function getContractTokenApproval() external view returns (uint256) {
        return token.allowance(owner, address(this));
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
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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