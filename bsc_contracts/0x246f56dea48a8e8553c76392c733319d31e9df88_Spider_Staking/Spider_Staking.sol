/**
 *Submitted for verification at BscScan.com on 2023-02-20
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IBEP20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender)external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value)external returns (bool);
  function transferFrom(address from, address to, uint256 value)external returns (bool);
  function burn(uint256 value)external returns (bool);
  event Transfer(address indexed from,address indexed to,uint256 value);
  event Approval(address indexed owner,address indexed spender,uint256 value);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

}

abstract contract Initializable {

    bool private _initialized;

    bool private _initializing;

    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

contract Spider_Staking is Initializable {
    using SafeMath for uint256;

    struct Plan {
        uint256 time;
        uint256 second;
        uint16 percent;
    }

	struct Deposit {
        uint16 plan;
		uint256 amount;
		uint256 start;
        uint256 end;
        uint256 persec;
        bool isWithdraw;
        bool isClaimed;
	}

	struct User {
		Deposit[] deposits;
		uint256 bonus;
        uint256 checkpoint;
		uint256 withdrawn;
	}

    modifier onlyAdmin() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

	mapping (address => User) internal users; 
    mapping(uint16=> Plan) internal plans;
    mapping(uint16 =>uint256) internal totalInvested;
    mapping(uint16=>uint256) internal totalReward;

    address private owner;
    IBEP20 private BTGtoken;
    
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyWithdrawn(address indexed user, uint256 amount);
    event NewDeposit(address indexed user, uint256 amount,uint16 plan);

    function initialize(address ownerAddress, IBEP20 _spiderToken) public
        initializer {
            owner = ownerAddress;
            BTGtoken = _spiderToken;
            plans[1].time = 90 days; //lock time
            plans[1].second= 7776000;
            plans[1].percent = 150; //rewards %

            plans[2].time = 180 days;//lock
            plans[2].second= 15552000;
            plans[2].percent = 480; //rewards%
            
            plans[3].time = 365 days; //lock
            plans[3].second= 31536000;
            plans[3].percent = 600;//rewards %
           
    }

    function Stake(uint256 amount , uint16 _plan) external {
        require(_plan <= 3, "Invalid plan");
        require(!isContract(msg.sender),"Can not be contract");
        require(BTGtoken.balanceOf(msg.sender)>=amount,"Low Balance");
        require(BTGtoken.allowance(msg.sender,address(this))>=amount,"Invalid allowance amount");
        uint256  share= amount.mul(plans[_plan].percent).div(100);
        uint256 timee=plans[_plan].second;
        uint256 persec=share.div(timee);
        BTGtoken.transferFrom(msg.sender,address(this),amount);
        users[msg.sender].deposits.push(Deposit(_plan,amount, block.timestamp,block.timestamp.add(plans[_plan].time),persec,false,false));
        totalInvested[_plan] = totalInvested[_plan].add(amount);
        emit NewDeposit(msg.sender,amount,_plan);
    }

	function claimReward(uint16 _plan) external {
		User storage user = users[msg.sender];
        uint256 totalAmount;
		for (uint256 i = 0; i < user.deposits.length; i++) {
			uint256 finish = user.deposits[i].start.add(plans[user.deposits[i].plan].time);
            bool alreadyClaimed = user.deposits[i].isClaimed;
            bool alreadyWithdraw = user.deposits[i].isWithdraw;
			if (block.timestamp >= finish && !alreadyClaimed &&!alreadyWithdraw && user.deposits[i].plan ==_plan) {
				uint256  share= user.deposits[i].amount.mul(plans[user.deposits[i].plan].percent).div(100);
                totalReward[user.deposits[i].plan]=totalReward[user.deposits[i].plan].add(share);
                totalInvested[user.deposits[i].plan] = totalInvested[user.deposits[i].plan].sub(user.deposits[i].amount);
				totalAmount=totalAmount.add(share).add(user.deposits[i].amount);
                user.deposits[i].isClaimed=true;
			}
		}
		require(totalAmount > 0, "User has no dividends");
		user.checkpoint = block.timestamp;
		user.withdrawn = user.withdrawn.add(totalAmount);
		BTGtoken.transfer(msg.sender,totalAmount);
		emit Withdrawn(msg.sender, totalAmount);
	}

    function emergencyWithdraw(uint16 index) external {
        require(users[msg.sender].deposits.length>index,"Out of Index");
        require(!users[msg.sender].deposits[index].isWithdraw&&!users[msg.sender].deposits[index].isClaimed,"Already claim or withdraw");
        users[msg.sender].deposits[index].isWithdraw=true;
        BTGtoken.transfer(msg.sender,users[msg.sender].deposits[index].amount);
        totalInvested[users[msg.sender].deposits[index].plan]= totalInvested[users[msg.sender].deposits[index].plan].sub(users[msg.sender].deposits[index].amount);
        users[msg.sender].withdrawn = users[msg.sender].withdrawn.add(users[msg.sender].deposits[index].amount);
        emit EmergencyWithdrawn(msg.sender, users[msg.sender].deposits[index].amount);
    }

	function getUserDividends(address userAddress,uint16 _plan) public view returns (uint256) {
		User storage user = users[userAddress];
		uint256 totalAmount;
		for (uint256 i = 0; i < user.deposits.length; i++) {
       if(user.deposits[i].plan ==_plan){
			uint256 finish = user.deposits[i].start.add(plans[user.deposits[i].plan].time);
            bool alreadyClaimed = user.deposits[i].isClaimed;
            bool alreadyWithdraw = user.deposits[i].isWithdraw;
			if (block.timestamp >= finish && !alreadyClaimed &&!alreadyWithdraw ) {
				uint256 share = user.deposits[i].amount.mul(plans[user.deposits[i].plan].percent).div(100);
				totalAmount=totalAmount.add(share).add(user.deposits[i].amount);
			} else if(block.timestamp <= finish && !alreadyClaimed &&!alreadyWithdraw){
               uint256 starttime = user.deposits[i].start;
               uint256 nowsec = block.timestamp.sub(starttime);
               uint256 perse = user.deposits[i].persec;
               totalAmount = nowsec.mul(perse);
            }
        }
		}

		return totalAmount;
	}

    function getUserTotalDeposits(address userAddress) public view returns(uint256 amount) {
		for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
            if(!users[userAddress].deposits[i].isWithdraw&&!users[userAddress].deposits[i].isClaimed)
			amount = amount.add(users[userAddress].deposits[i].amount);
		}
	}

    function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint16 plan, uint256 percent, uint256 amount, uint256 start, uint256 finish) {
	    User storage user = users[userAddress];
		plan = user.deposits[index].plan;
		percent = plans[plan].percent;
		amount = user.deposits[index].amount;
		start = user.deposits[index].start;
		finish = user.deposits[index].start.add(plans[user.deposits[index].plan].time);
	}

   	function getPlanInfo(uint16 _plan) external view returns(uint256 time, uint16 percent) {
		time = plans[_plan].time;
		percent = plans[_plan].percent;
	}

	function getUserTotalWithdrawn(address user) external view returns (uint256) {
		return users[user].withdrawn;
	}

    function getUserDeposits(address user) external view returns(Deposit[] memory) {
		return users[user].deposits;
	}

    function getOwner() external view returns(address) {
        return owner;
    }

    function getToken() external view returns(IBEP20) {
        return BTGtoken;
    }

    function isContract(address _address) public view returns (bool _isContract) {
          uint32 size;
          assembly {
            size := extcodesize(_address)
          }
          return (size > 0);
    }   
    
    function withdrawToken(IBEP20 _token , uint256 amount) external onlyAdmin {
        _token.transfer(owner,amount);
    }

    function withdrawBNB (uint256 amount) external onlyAdmin {
        payable(owner).transfer(amount);
    }

    function getTotalInvested () external view returns (uint256,uint256,uint256,uint256,uint256) {
        return (totalInvested[1],totalInvested[2],totalInvested[3],totalInvested[4],totalInvested[5]);
    }

    function getTotalReward () external view returns (uint256,uint256,uint256,uint256,uint256) {
        return (totalReward[1],totalReward[2],totalReward[3],totalReward[4],totalReward[5]);
    }

}