/**
 *Submitted for verification at BscScan.com on 2022-09-23
*/

pragma solidity 0.5.8;

interface IBEP20 {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

 
  function name() external view returns (string memory);


  function getOwner() external view returns (address);

 
  function balanceOf(address account) external view returns (uint256);

  
  function transfer(address recipient, uint256 amount) external returns (bool);

  
  function allowance(address _owner, address spender) external view returns (uint256);


  function approve(address spender, uint256 amount) external returns (bool);


  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

 
  event Transfer(address indexed from, address indexed to, uint256 value);


  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BUSDVERSE {
	using SafeMath for uint256;
    using SafeMath for uint8;

    IBEP20 public BUSD = IBEP20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56); 

	uint256 constant public INVEST_MIN_AMOUNT = 5 ether; //5 BUSD
	uint256[] public REFERRAL_PERCENTS = [50, 30, 20];
	uint256 constant public PROJECT_FEE = 60;
	uint256 constant public DEVELOPER_FEE = 10;
    uint256 constant public MARKETING_FEE = 30;
	uint256 constant public PERCENT_STEP = 5;
	uint256 constant public PERCENTS_DIVIDER= 1000;
	uint256 constant public TIME_STEP = 1 days;

	uint256 constant public RESTAKE_MIN_AMOUNT = 0.05 ether; // 0.05 BUSD
	uint256 constant public RESTAKE_EXTRA_PROFIT = 2; // 0.2%
	uint256 constant public RESTAKE_RANDOM_EXTRA_PROFIT = 4; // 0.4%
	
	uint256 public totalStaked;
	uint256 public totalRefBonus;
	uint256 public totalUsers;

    bool public launched = false;

    struct Plan {
        uint256 time;
        uint256 percent;
    }

    Plan[] internal plans;

	struct Deposit {
        uint8 plan;
		uint256 percent;
		uint256 amount;
		uint256 profit;
		uint256 start;
		uint256 finish;
	}

	struct User {
		Deposit[] deposits;
		uint256 checkpoint;
		address referrer;
		uint256 referrals;
		uint256 totalBonus;
		uint256 withdrawn;
	}

	mapping (address => User) internal users;

	uint256 public startUNIX;
	address private commissionWallet;
	address private developerWallet;
    address private marketingWallet;
	
	

	event Newbie(address user);
	event NewDeposit(address indexed user, uint8 plan, uint256 percent, uint256 amount, uint256 profit, uint256 start, uint256 finish);
	event Withdrawn(address indexed user, uint256 amount);
	event RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);

	constructor(address wallet, address _developer, address _marketing) public {
		require(!isContract(wallet));
		commissionWallet = wallet;
		developerWallet = _developer;
        marketingWallet = _marketing;
        startUNIX = block.timestamp.add(365 days);

        plans.push(Plan(14, 80)); // 8% per day for 14 days
        plans.push(Plan(28, 70)); // 7% per day for 28 days (compounding)
        plans.push(Plan(14, 120)); // 12% per day for 14 days (at the end)
		plans.push(Plan(14, 40)); // 4-12% per day for 14 days (random)
        plans.push(Plan(28, 40)); // 4-9% per day for 28 days (random, compounding)
        plans.push(Plan(10, 80)); // 8-16% per day for 10-18 days (at the end, random)
	}

    function launch() public {
        require(msg.sender == developerWallet);
        require(launched == false);
		startUNIX = block.timestamp;

        launched = true;
		
        
    } 


    function invest(address referrer,uint8 plan, uint256 value) public {
        _invest(referrer, plan, msg.sender, value,0);
           
    }


	function _invest(address referrer, uint8 plan, address sender, uint256 value, uint256 extraProfit) private {
		uint256 minAmount = INVEST_MIN_AMOUNT;

		if(extraProfit > 0) {
			minAmount = RESTAKE_MIN_AMOUNT;
		}

		require(value >= minAmount);
        require(plan < 6, "Invalid plan");
        require(startUNIX < block.timestamp, "contract hasn`t started yet");

		if(extraProfit == 0) {
			BUSD.transferFrom(sender, address(this), value);
		}

    
		

		uint256 fee = value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
		BUSD.transfer(commissionWallet,fee);
		uint256 developerFee = value.mul(DEVELOPER_FEE).div(PERCENTS_DIVIDER);
		BUSD.transfer(developerWallet,developerFee);
        uint256 marketingFee = value.mul(MARKETING_FEE).div(PERCENTS_DIVIDER);
		BUSD.transfer(marketingWallet,marketingFee);
		
		User storage user = users[sender];

		if (user.referrer == address(0)) {
			if (users[referrer].deposits.length > 0 && referrer != sender) {
				user.referrer = referrer;
			}

			address upline = user.referrer;
			for (uint256 i = 0; i < 3; i++) {
				if (upline != address(0)) {
					users[upline].referrals = users[upline].referrals.add(1);
					upline = users[upline].referrer;
				} else break;
			}
		}


				if (user.referrer != address(0)) {
					uint256 _refBonus = 0;
					address upline = user.referrer;
					for (uint256 i = 0; i < 3; i++) {
						if (upline != address(0)) {
							uint256 amount = value.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);
							
							users[upline].totalBonus = users[upline].totalBonus.add(amount);
                            BUSD.transfer(upline,amount);
							_refBonus = _refBonus.add(amount);
						
							emit RefBonus(upline, sender, i, amount);
							upline = users[upline].referrer;
						} else break;
					}

					totalRefBonus = totalRefBonus.add(_refBonus);

				}
		

		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(sender);
		}

		

		(uint256 percent, uint256 profit, uint256 finish) = getResult(plan, value, extraProfit);
		
		user.deposits.push(Deposit(plan, percent, value, profit, block.timestamp, finish));

		totalStaked = totalStaked.add(value);
        totalUsers = totalUsers.add(1);
		
		emit NewDeposit(sender, plan, percent, value, profit, block.timestamp, finish);
	}

	function reStake(uint8 plan, address referrer) public {
		require(startUNIX < block.timestamp, "contract hasn`t started yet");

        User storage user = users[msg.sender];

        uint256 totalAmount = getUserDividends(msg.sender);

        require(totalAmount >= RESTAKE_MIN_AMOUNT, "Invalid amount");

		user.checkpoint = block.timestamp;

		_invest(referrer, plan, msg.sender, totalAmount, RESTAKE_EXTRA_PROFIT);


	}

	function reStakeRandom(address referrer) public {
		require(startUNIX < block.timestamp, "contract hasn`t started yet");

        User storage user = users[msg.sender];

        uint256 totalAmount = getUserDividends(msg.sender);

        require(totalAmount >= RESTAKE_MIN_AMOUNT, "Invalid amount");

		user.checkpoint = block.timestamp;

		uint8 plan = uint8(getRandomNumber().mod(6));

		_invest(referrer, plan, msg.sender, totalAmount, RESTAKE_RANDOM_EXTRA_PROFIT);


	}

	function withdraw() public {
		User storage user = users[msg.sender];

		uint256 totalAmount = getUserDividends(msg.sender);

		require(totalAmount > 0, "User has no dividends");

		uint256 contractBalance = getContractBalance();
		if (contractBalance < totalAmount) {
			totalAmount = contractBalance;
		}

		user.checkpoint = block.timestamp;

		user.withdrawn = user.withdrawn.add(totalAmount);
		BUSD.transfer(msg.sender,totalAmount);

		emit Withdrawn(msg.sender, totalAmount);

	}

	
    

	function getContractBalance() public view returns (uint256) {
		return BUSD.balanceOf(address(this));
	}

	function getPlanInfo(uint8 plan) public view returns(uint256 time, uint256 percent) {
		time = plans[plan].time;
		percent = plans[plan].percent;
	}

	function getPercent(uint8 plan) public view returns (uint256) {

            uint256 percent = plans[plan].percent;

            if(plan == 3 || plan == 5) {
                uint256 random = getRandomNumber().mod(80);
                percent = percent.add(random);
            }

            if(plan == 4) {
                uint256 random = getRandomNumber().mod(50);
                percent = percent.add(random);
            }

            
            

	    
			return percent.add(PERCENT_STEP.mul(block.timestamp.sub(startUNIX)).div(TIME_STEP));
		
    }

    function getTime(uint8 plan) public view returns (uint256) {
        if(plan < 5) {
            return plans[plan].time;
        } else {
            uint256 random = getRandomNumber().mod(9);
            return plans[plan].time.add(random);
        }
    } 
    

	function getResult(uint8 plan, uint256 deposit, uint256 extraProfit) public view returns (uint256 percent, uint256 profit, uint256 finish) {
		percent = getPercent(plan);
        uint256 time = getTime(plan);

        if(extraProfit > 0) {
            percent = percent.add(extraProfit);
        }

        if(plan == 1 || plan == 4) {
            for (uint256 i = 0; i < time; i++) {
			    profit = profit.add((deposit.add(profit)).mul(percent).div(PERCENTS_DIVIDER));
			}
        } else {
            profit = deposit.mul(percent).div(PERCENTS_DIVIDER).mul(time);
        }

		finish = block.timestamp.add(time.mul(TIME_STEP));
	}


    function getRandomNumber() private view returns(uint256) {

        bytes32 _blockhash = blockhash(block.number-1);
        
        
        return uint256(keccak256(abi.encode(_blockhash,totalStaked,totalUsers,block.difficulty,block.timestamp)));

    }
	
    


	function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		uint8 plan;

		for (uint256 i = 0; i < user.deposits.length; i++) {
			plan = user.deposits[i].plan;

			if (user.checkpoint < user.deposits[i].finish) {
				
				if(plan == 2 || plan == 5) {
					if(block.timestamp > user.deposits[i].finish) {
						totalAmount = totalAmount.add(user.deposits[i].profit);
					}
				}

				if(plan == 0 || plan == 3) {
					uint256 share = user.deposits[i].amount.mul(user.deposits[i].percent).div(PERCENTS_DIVIDER);
					uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
					uint256 to = user.deposits[i].finish < block.timestamp ? user.deposits[i].finish : block.timestamp;
					if (from < to) {
						totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
					}
				}

				if(plan == 1 || plan == 4) {
					uint256 passedDays = block.timestamp.sub(user.checkpoint).div(TIME_STEP);
					uint256 payout = 0;
					uint256 percent = user.deposits[i].percent;
					    
					for(uint256 k = 0; k < passedDays; k++){
					    payout = payout.add(user.deposits[i].amount.add(payout).mul(percent).div(PERCENTS_DIVIDER));
					}
					    
					    totalAmount = totalAmount.add(payout);
				}



			}
		}

       
		return totalAmount;
	}

    function getContractInfo() public view returns(uint256, uint256, uint256) {
        return(totalStaked, totalRefBonus, totalUsers);
    }

	function getUserWithdrawn(address userAddress) public view returns(uint256) {
		return users[userAddress].withdrawn;
	}

	function getUserCheckpoint(address userAddress) public view returns(uint256) {
		return users[userAddress].checkpoint;
	}
    
	function getUserReferrer(address userAddress) public view returns(address) {
		return users[userAddress].referrer;
	} 

	function getUserDownlineCount(address userAddress) public view returns(uint256) {
		return (users[userAddress].referrals);
	}

	function getUserReferralTotalBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].totalBonus;
	}


	function getUserAmountOfDeposits(address userAddress) public view returns(uint256) {
		return users[userAddress].deposits.length;
	}

	function getUserTotalDeposits(address userAddress) public view returns(uint256 amount) {
		for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
			amount = amount.add(users[userAddress].deposits[i].amount);
		}
	}

	function getUserTotalWithdrawn(address userAddress) public view returns(uint256 amount) {
		
	}

	function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint8 plan, uint256 percent, uint256 amount, uint256 profit, uint256 start, uint256 finish) {
	    User storage user = users[userAddress];

		plan = user.deposits[index].plan;
		percent = user.deposits[index].percent;
		amount = user.deposits[index].amount;
		profit = user.deposits[index].profit;
		start = user.deposits[index].start;
		finish = user.deposits[index].finish;
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
    
     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}