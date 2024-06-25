/**
 *Submitted for verification at BscScan.com on 2022-12-10
*/

/**
 * works with token 0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d
*/
pragma solidity ^0.8.16;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}

abstract contract Context {
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal pure returns (bytes calldata) {
        return msg.data;
    }
}

contract Events {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    event NewDeposit(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardWithdraw(address indexed user, uint256 amount);
}

abstract contract Ownable is Events, Context {
    address public _owner;

    constructor(address newOwner) {
        _owner = newOwner;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
}

contract TokenStaking is Ownable {
    using SafeMath for uint256;
    uint256 public rewardPercentage;

    IERC20 token;

    uint256 private divider = 10000;

    uint256 public refferalFee = 1000;

    uint256 public adminFee = 2000;

    uint256 public totalInvested;

    uint256 public totalRewardWithdrwal;

    struct deposit {
        uint256 amount;
        uint256 checkpoint;
        bool isWithdraw;
    }

    struct stack {
        deposit[] deposites;
        address userAddress;
    }
    mapping(address => stack) public Stack;

    struct refRewards {
        uint256 totalRewards;
        uint256 totalEarn;
    }
    mapping(address => refRewards) public refferralRewards;

    mapping(address => address[]) public refAddress;

    constructor(address _token) Ownable(msg.sender) {
        rewardPercentage = 100;
        token = IERC20(_token);
    }

    function checkExitsUser(address _refer, address _user)
        private
        view
        returns (bool)
    {
        bool found = false;
        for (uint256 i = 0; i < refAddress[_refer].length; i++) {
            if (refAddress[_refer][i] == _user) {
                found = true;
                break;
            }
        }
        return found;
    }

    function getUserRefferalRewards(address _address)
        public
        view
        returns (uint256 totalRewards, uint256 totalEarn)
    {
        totalRewards = refferralRewards[_address].totalRewards;
        totalEarn = refferralRewards[_address].totalEarn;
    }

    function invest(uint256 amount, address reffer) external {
        require(
            amount <= token.allowance(msg.sender, address(this)),
            "Insufficient Allowence to the contract"
        );
        stack storage users = Stack[msg.sender];
        if (reffer != address(0) && reffer != msg.sender) {
            if (!checkExitsUser(msg.sender, reffer)) {
                refAddress[msg.sender].push(reffer);
            }
        }

        totalInvested = totalInvested.add(amount);
        Stack[msg.sender].userAddress = msg.sender;
        users.deposites.push(deposit(amount, block.timestamp, false));

        token.transferFrom(msg.sender, address(this), amount);
        emit NewDeposit(msg.sender, amount);
    }

    // GET USER INVESTMENT DETAIL
    function getUserTotalDeposit(address _address)
        public
        view
        returns (uint256)
    {
        stack storage users = Stack[_address];
        uint256 totalDeposit = 0;
        for (uint256 i = 0; i < users.deposites.length; i++) {
            totalDeposit += users.deposites[i].amount;
        }
        return totalDeposit;
    }

    // GET USER TOTAL INVESTMENT
    function getUserTotalNoDeposit(address _address)
        public
        view
        returns (uint256)
    {
        stack storage users = Stack[_address];
        return users.deposites.length;
    }

    // GET USER DEPOSIT DETAIL
    function getUserDepositDetail(uint256 id, address _address)
        public
        view
        returns (
            uint256 amount,
            uint256 checkpoint,
            bool isWithdraw
        )
    {
        stack storage users = Stack[_address];
        amount = users.deposites[id].amount;
        checkpoint = users.deposites[id].checkpoint;
        isWithdraw = users.deposites[id].isWithdraw;
    }

    /* WITHDRAW USER INVESTMENT
     */
    function withdrawInvestment() external {
        uint256 totalAmount = getUserTotalDeposit(msg.sender);
        require(totalAmount > 0, "You are not invested yet!");
        require(
            totalAmount <= getContractTokenBalance(),
            "Not Enough Token for withdrwal from contract please try after some time"
        );

        // SAVE USER REWARDS INFOS
        stack storage users = Stack[msg.sender];
        for (uint256 i = 0; i < users.deposites.length; i++) {
            users.deposites[i].amount = 0;
            users.deposites[i].isWithdraw = true;
        }
        refferralRewards[msg.sender].totalRewards = 0;
        refferralRewards[msg.sender].totalEarn = 0;
        totalInvested -= totalAmount;
        token.transfer(msg.sender, totalAmount);
    }

    function claimRewards() external {
        require(
            Stack[msg.sender].userAddress == msg.sender,
            "You are not the owner of this investment"
        );
        uint256 totalRewards = calclulateReward(msg.sender);
        require(
            totalRewards > 0,
            "You dont have sufficient rewards for withdraw"
        );

        uint256 totalRefferalRewards;
        uint256 userRefReward;

        if (refAddress[msg.sender].length > 0) {
            totalRefferalRewards = totalRewards.mul(refferalFee).div(divider);
        }

        for (uint256 i = 0; i < refAddress[msg.sender].length; i++) {
            uint256 refReward = totalRefferalRewards.div(
                refAddress[msg.sender].length
            );
            refferralRewards[refAddress[msg.sender][i]]
                .totalRewards += refReward;
            refferralRewards[refAddress[msg.sender][i]].totalEarn += refReward;
        }

        if (refferralRewards[msg.sender].totalRewards > 0) {
            userRefReward = refferralRewards[msg.sender].totalRewards;
            token.transfer(msg.sender, userRefReward);
            refferralRewards[msg.sender].totalRewards -= userRefReward;
        }

        stack storage users = Stack[msg.sender];
        for (uint256 i = 0; i < users.deposites.length; i++) {
            users.deposites[i].checkpoint = block.timestamp;
        }

        totalRewardWithdrwal += totalRewards.add(userRefReward);

        uint256 adminReward = totalRewards.mul(adminFee).div(divider);
        uint256 userRemainingReards = totalRewards.sub(adminReward).sub(
            totalRefferalRewards
        );

        token.transfer(owner(), adminReward);
        token.transfer(msg.sender, userRemainingReards);
        emit RewardWithdraw(msg.sender, userRemainingReards);
    }

    function calclulateReward(address _address) public view returns (uint256) {
        stack storage users = Stack[_address];
        uint256 reward = 0;
        for (uint256 i = 0; i < users.deposites.length; i++) {
            uint256 depositeAmount = users.deposites[i].amount;
            uint256 time = block.timestamp.sub(users.deposites[i].checkpoint);
            reward += depositeAmount
                .mul(rewardPercentage)
                .div(divider)
                .mul(time)
                .div(1 days); // 100 * 100 / 10000 * 86400 / 86400 (1% day)
        }
        return reward;
    }

    function getContractTokenBalance()
        public
        view
        returns (uint256 totalTokens)
    {
        totalTokens = token.balanceOf(address(this));
    }

    function returnStuckTokens(
        address stuckToken,
        address recipient,
        uint256 amount
    ) public onlyOwner {
        require(
            stuckToken != address(token),
            "Error: You can't to withdraw a main token"
        );
        IERC20 _stuckToken = IERC20(stuckToken);
        _stuckToken.transfer(recipient, amount);
    }

    function getTokenAddress() external view returns (address _token) {
        return address(token);
    }

    fallback() external {
        revert("You cant send BNB in the smart contract");
    }
}