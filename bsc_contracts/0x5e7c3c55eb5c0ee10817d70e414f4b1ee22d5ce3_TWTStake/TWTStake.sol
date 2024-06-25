/**
 *Submitted for verification at BscScan.com on 2023-02-28
*/

/*   TWTStake - earning platform on Binance Smart Chain.
 *   It's all about people, crypto and opportunities.
 *   Made by community, with love.
 *
 *  
 *   Website: https://twtstake.com
 *   Blog: https://blog.twtstake.com
 *
 *
 *                         IN TRUST WE TRUST
 *
 *                       *(((((((((((((((((((,                   
 *               ((((((((((((((((((((((((((((((((((((/           
 *           /(((((((((((((((((((((((((((((((((((((((((((.       
 *          (((((                (((((       (((((    (((((      
 *           *((((/               /(*     (((((,    (((((.       
 *              (((((         /((((((((((((((    .(((((          
 *                *((((((((((((((*   /((((((((((((((.            
 *                  ((((*,                  .,*((((              
 *                  ((((                       ((((              
 *                  ((((    (((        (((     (((*              
 *                  /(((    ((((       ((((    (((               
 *                   (((                      *(((               
 *                   ((((                     ((((               
 *                   /(((                     (((.               
 *                    ((((      (((((((      ((((                
 *                     (((((/             (((((,                 
 *                       .(((((((     (((((((                    
 *                            (((((((((((                        
 *                                (((
 *
 *                             TWT $100
 *   
 *
 *
 *
 *   [USAGE INSTRUCTION]
 *
 *   1) Connect any supported wallet
 *   2) Choose one of the staking plans, enter the TWT amount (1 TWT minimum) and confirm transaction after using our website "Stake" button
 *   3) Wait for your earnings
 *   4) Withdraw earnings any time using our website "Withdraw" button
 *   5) Affiliate Earnings available to withdraw each time someone deposit using your link.
 *
 *   [DEPOSIT TERMS AND CONDITIONS]
 *
 *   - Minimal deposit: 1 TWT, no maximal limit
 *   - Total income: based on chosen plan from 1% to 3% Daily ROI
 *   - Earnings every moment, withdraw any time (if contract have enough balance)
 *
 *   [AFFILIATE PROGRAM]
 *
 *   - 5-level referral rewards: 7% - 3% - 1.5% - 1% - 0.5%
 *
 * [FUNDS DISTRIBUTION]
 *
 * - 90% allocated to the platform's main balance, which will be used to pay staking rewards and offer affiliate program bonuses.
 * - 10% allocated to advertising and promotion expenses, support work, technical functioning, and administration fees.
 *
 *   Note: This is community project, with a high risks.
 *   No one can guarantee you a return on investment.
 *   Payments only available when contract have enough balance.
 *   Deposit at your own risk.
 */

pragma solidity 0.5.10;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

library SafeERC20 {
    using SafeMath for uint;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(isContract(address(token)), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }

	function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

contract TWTStake {
	using SafeMath for uint256;
	using SafeERC20 for IERC20;

	IERC20 public token;

	uint256 public STAKE_MIN_AMOUNT;
	uint256[] public REFERRAL_PERCENTS = [70, 30, 15, 10, 5];
	uint256 constant public PROJECT_FEE = 100;
	uint256 constant public PERCENT_STEP = 5;
	uint256 constant public PERCENTS_DIVIDER = 1000;
	uint256 constant public TIME_STEP = 1 days;

	uint256 public totalStaked;
	uint256 public totalRefBonus;

    struct Plan {
        uint256 time;
        uint256 percent;
    }

    Plan[] internal plans;

	struct Deposit {
        uint8 plan;
		uint256 amount;
		uint256 start;
	}

	struct User {
		Deposit[] deposits;
		uint256 checkpoint;
		address referrer;
		uint256[5] levels;
		uint256 bonus;
		uint256 totalBonus;
		uint256 withdrawn;
	}

	mapping (address => User) internal users;

	bool public started;
	address payable public commissionWallet;

	event Newbie(address user);
	event NewDeposit(address indexed user, uint8 plan, uint256 amount);
	event Withdrawn(address indexed user, uint256 amount);
	event RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);
	event FeePayed(address indexed user, uint256 totalAmount);

	constructor(address tokenAddr, uint256 minAmount, address payable wallet) public {
		require(!isContract(wallet) && isContract(tokenAddr));
		token = IERC20(tokenAddr);
		STAKE_MIN_AMOUNT = minAmount;
		commissionWallet = wallet;

        plans.push(Plan(36500, 10));
        plans.push(Plan(40, 30));
        plans.push(Plan(64, 26));
        plans.push(Plan(128, 16));
	}

	function stake(address referrer, uint8 plan, uint256 value) public {
		if (!started) {
			if (msg.sender == commissionWallet) {
				started = true;
			} else revert("Not started yet");
		}

		require(value >= STAKE_MIN_AMOUNT);
        require(plan < 4, "Invalid plan");

		require(value <= token.allowance(msg.sender, address(this)));
		token.safeTransferFrom(msg.sender, address(this), value);

		uint256 fee = value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
		token.safeTransfer(commissionWallet, fee);
		emit FeePayed(msg.sender, fee);

		User storage user = users[msg.sender];

		if (user.referrer == address(0)) {
			if (users[referrer].deposits.length > 0 && referrer != msg.sender) {
				user.referrer = referrer;
			}

			address upline = user.referrer;
			for (uint256 i = 0; i < 5; i++) {
				if (upline != address(0)) {
					users[upline].levels[i] = users[upline].levels[i].add(1);
					upline = users[upline].referrer;
				} else break;
			}
		}

		if (user.referrer != address(0)) {
			address upline = user.referrer;
			for (uint256 i = 0; i < 5; i++) {
				if (upline != address(0)) {
					uint256 amount = value.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);
					users[upline].bonus = users[upline].bonus.add(amount);
					users[upline].totalBonus = users[upline].totalBonus.add(amount);
					emit RefBonus(upline, msg.sender, i, amount);
					upline = users[upline].referrer;
				} else break;
			}
		}

		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(msg.sender);
		}

		user.deposits.push(Deposit(plan, value, block.timestamp));

		totalStaked = totalStaked.add(value);

		emit NewDeposit(msg.sender, plan, value);
	}

	function withdraw() public {
		User storage user = users[msg.sender];

		uint256 totalAmount = getUserDividends(msg.sender);

		uint256 referralBonus = getUserReferralBonus(msg.sender);
		if (referralBonus > 0) {
			user.bonus = 0;
			totalAmount = totalAmount.add(referralBonus);
		}

		require(totalAmount > 0, "User has no dividends");

		uint256 contractBalance = token.balanceOf(address(this));
		if (contractBalance < totalAmount) {
			user.bonus = totalAmount.sub(contractBalance);
			user.totalBonus = user.totalBonus.add(user.bonus);
			totalAmount = contractBalance;
		}

		user.checkpoint = block.timestamp;
		user.withdrawn = user.withdrawn.add(totalAmount);

		token.safeTransfer(msg.sender, totalAmount);

		emit Withdrawn(msg.sender, totalAmount);
	}

	function getContractBalance() public view returns (uint256) {
		return token.balanceOf(address(this));
	}

	function getPlanInfo(uint8 plan) public view returns(uint256 time, uint256 percent) {
		time = plans[plan].time;
		percent = plans[plan].percent;
	}

	function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < user.deposits.length; i++) {
			uint256 finish = user.deposits[i].start.add(plans[user.deposits[i].plan].time.mul(1 days));
			if (user.checkpoint < finish) {
				uint256 share = user.deposits[i].amount.mul(plans[user.deposits[i].plan].percent).div(PERCENTS_DIVIDER);
				uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
				uint256 to = finish < block.timestamp ? finish : block.timestamp;
				if (from < to) {
					totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
				}
			}
		}

		return totalAmount;
	}

	function getUserTotalWithdrawn(address userAddress) public view returns (uint256) {
		return users[userAddress].withdrawn;
	}

	function getUserCheckpoint(address userAddress) public view returns(uint256) {
		return users[userAddress].checkpoint;
	}

	function getUserReferrer(address userAddress) public view returns(address) {
		return users[userAddress].referrer;
	}

	function getUserDownlineCount(address userAddress) public view returns(uint256[5] memory referrals) {
		return (users[userAddress].levels);
	}

	function getUserTotalReferrals(address userAddress) public view returns(uint256) {
		return users[userAddress].levels[0]+users[userAddress].levels[1]+users[userAddress].levels[2]+users[userAddress].levels[3]+users[userAddress].levels[4];
	}

	function getUserReferralBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].bonus;
	}

	function getUserReferralTotalBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].totalBonus;
	}

	function getUserReferralWithdrawn(address userAddress) public view returns(uint256) {
		return users[userAddress].totalBonus.sub(users[userAddress].bonus);
	}

	function getUserAvailable(address userAddress) public view returns(uint256) {
		return getUserReferralBonus(userAddress).add(getUserDividends(userAddress));
	}

	function getUserAmountOfDeposits(address userAddress) public view returns(uint256) {
		return users[userAddress].deposits.length;
	}

	function getUserTotalDeposits(address userAddress) public view returns(uint256 amount) {
		for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
			amount = amount.add(users[userAddress].deposits[i].amount);
		}
	}

	function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint8 plan, uint256 percent, uint256 amount, uint256 start, uint256 finish) {
	    User storage user = users[userAddress];

		plan = user.deposits[index].plan;
		percent = plans[plan].percent;
		amount = user.deposits[index].amount;
		start = user.deposits[index].start;
		finish = user.deposits[index].start.add(plans[user.deposits[index].plan].time.mul(1 days));
	}

	function getSiteInfo() public view returns(uint256 _totalStaked, uint256 _totalBonus) {
		return(totalStaked, totalRefBonus);
	}

	function getUserInfo(address userAddress) public view returns(uint256 totalDeposit, uint256 totalWithdrawn, uint256 totalReferrals) {
		return(getUserTotalDeposits(userAddress), getUserTotalWithdrawn(userAddress), getUserTotalReferrals(userAddress));
	}

	function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
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