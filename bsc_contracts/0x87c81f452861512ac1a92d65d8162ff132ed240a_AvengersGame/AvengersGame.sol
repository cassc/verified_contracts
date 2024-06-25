/**
 *Submitted for verification at BscScan.com on 2022-11-24
*/

// SPDX-License-Identifier: MIT
//
//    ,---.                                                          ,----.                             
//   /  O  \,--.  ,--.,---. ,--,--,  ,---.  ,---. ,--.--. ,---.     '  .-./    ,--,--.,--,--,--. ,---.  
//  |  .-.  |\  `'  /| .-. :|      \| .-. || .-. :|  .--'(  .-'     |  | .---.' ,-.  ||        || .-. : 
//  |  | |  | \    / \   --.|  ||  |' '-' '\   --.|  |   .-'  `)    '  '--'  |\ '-'  ||  |  |  |\   --. 
//  `--' `--'  `--'   `----'`--''--'.`-  /  `----'`--'   `----'      `------'  `--`--'`--`--`--' `----' 
//                                  `---'                                                                                                                          
pragma solidity ^0.8.17;

contract AvengersGame {

    uint LEVELS_COUNT = 10;
    uint ROOT_WALLETS_COUNT = 4;
    uint SECONDS_IN_DAY = 24 * 3600;
    uint SECONDS_IN_DAY_HALF = 12 * 3600;

    uint[] levelIntervals = [
        0 hours,   // level 1 = 0*24h
        24 hours,  // level 2 = 1*24h
        48 hours,  // level 3 = 2*24h
        72 hours,  // level 4 = 3*24h
        96 hours,  // level 5 = 4*24h
        120 hours, // level 6 = 5*24h
        144 hours, // level 7 = 6*24h
        168 hours, // level 8 = 7*24h
        192 hours, // level 9 = 8*24h
        216 hours  // level 10 = 9*24h
    ];

    uint[] levelPrices = [
        0.09 * 1e18, // 1 POOL = 0.05 BNB
        0.19 * 1e18, // 2 POOL = 0.07 BNB
        0.29 * 1e18, // 3 POOL = 0.10 BNB
        0.39 * 1e18, // 4 POOL = 0.13 BNB
        0.49 * 1e18, // 5 POOL = 0.16 BNB
        0.59 * 1e18, // 6 POOL = 0.25 BNB
        0.69 * 1e18, // 7 POOL = 0.30 BNB
        0.69 * 1e18, // 8 POOL = 0.35 BNB
        0.89 * 1e18, // 9 POOL = 0.40 BNB
        1.00 * 1e18  // 10 POOL = 0.45 BNB
    ];

    uint REGISTRATION_PRICE = 0 * 1e18; // 0 ETH
    uint LEVEL_FEE_PERCENTS = 5; // 5% fee
    uint USER_REWARD_PERCENTS = 75; // 75% reward

    uint[] referrerPercents = [
        6, // 6% to 1st referrer
        3, // 3% to 2nd referrer
        2, // 2% to 3rd refrrer
        3, // 3% to 4th referrer
        6  // 6% to 5th referrer
    ];
	
    struct User {
        uint id;
        address userAddr;
        address referrer;
        uint regDate;
        UserLevelInfo[] levels;
        uint maxLevel;
        uint debit;
        uint credit;
        uint referralReward;
        uint lastReferralReward;
        uint levelProfit;
        uint line1;
        uint line2;
        uint line3;
        uint line4;
        uint line5;
        uint8 walletType;
    }

    struct UserLevelInfo {
        uint openState; // 0 - closed, 1 - closed (opened once), 2 - opened
        uint payouts;
        uint partnerBonus;
        uint poolProfit;
        uint missedProfit;
    }

    struct PlaceInQueue {
        int pos;
        uint size;
    }

    address private adminWallet;
    address private regFeeWallet;
    address private marketingWallet;
    uint private initialDate;
    mapping (address => User) private users;
    address[] private userAddresses;
    uint private userCount;
    address private rootWallet1;
    address private rootWallet2;
    address private rootWallet3;
    address private rootWallet4;
    mapping(uint => address[]) private levelQueue;
    mapping(uint => uint) private headIndex;
    uint private marketingBalance;
    uint private transactionCounter;
    uint private turnoverAmount;
    uint private date24h1;
    uint private date24h2;
    uint32 private users24h1;
    uint32 private users24h2;
    uint32 private transactions24h1;
    uint32 private transactions24h2;
    uint private turnover24h1;
    uint private turnover24h2;
    uint private state;
    address private contractID;
    address private receiveImpl;
    address private fallbackImpl;

    constructor(bytes memory data) {
        uint level;

        // Capture the creation date and time
        initialDate = block.timestamp;

        // Defining wallets
        adminWallet = msg.sender;
        regFeeWallet = readAddress(data, 0x15);
        marketingWallet = readAddress(data, 0x29);
        rootWallet1 = readAddress(data, 0x3d);
        rootWallet2 = readAddress(data, 0x51);
        rootWallet3 = readAddress(data, 0x65);
        rootWallet4 = readAddress(data, 0x79);

        // Adding root users to the users table
        for (uint i = 0; i < ROOT_WALLETS_COUNT; i++) {
            address addr;
            address reff;
            if (i == 0) {
                addr = rootWallet1;
                reff = rootWallet1;
            }
            else if (i == 1) {
                addr = rootWallet2;
                reff = rootWallet1;
            }
            else if (i == 2) {
                addr = rootWallet3;
                reff = rootWallet2;
            }
            else {
                addr = rootWallet4;
                reff = rootWallet3;
            }
            
            users[addr].id = userCount;
            users[addr].userAddr = addr;
            users[addr].referrer = reff;
            users[addr].regDate = block.timestamp;
            users[addr].maxLevel = LEVELS_COUNT;
            userAddresses.push(addr);
            userCount++;

            for (level = 0; level < LEVELS_COUNT; level++) {
                users[addr].levels.push(UserLevelInfo({
                    openState: 2, // opened
                    payouts: 0,
                    missedProfit: 0,
                    partnerBonus: 0,
                    poolProfit: 0
                }));
            }
        }

        // Filling levels queue with initial values
        for (level = 0; level < LEVELS_COUNT; level++) {
            levelQueue[level].push(rootWallet1);
            levelQueue[level].push(rootWallet2);
            levelQueue[level].push(rootWallet3);
            levelQueue[level].push(rootWallet4);
        }
    }

    receive() external payable {
        if (receiveImpl == address(0))
            invest();
        else 
            delegate(receiveImpl);
    }

    fallback() external payable {
        if (fallbackImpl != address(0))
            delegate(fallbackImpl);
    }

    modifier verified() { 
        require((state & 2) == 0);
        _;
    }

    function delegate(address impl) private {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function readAddress(bytes memory data, uint offs) pure private returns (address) {
        address addr;
        assembly {
            addr := mload(add(data, offs))
        }
        return addr;
    }

    function isContract(address addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }

    function stats24hNormalize(uint half) private {
        uint date = block.timestamp / SECONDS_IN_DAY;
        if (half == 0) {
            if (date24h1 != date) {
                date24h1 = date;
                users24h1 = 0;
                transactions24h1 = 0;
                turnover24h1 = 0;
            }
        }
        else {
            if (date24h2 != date) {
                date24h2 = date;
                users24h2 = 0;
                transactions24h2 = 0;
                turnover24h2 = 0;
            }
        }
    }

    function internalRegister(uint referrerID, uint investAmount, uint walletType) private {
        address referrer;

        require((state & 1) == 0); // Check if contract is suspended
        require(investAmount >= REGISTRATION_PRICE + levelPrices[0]); // Check if receive the right amount
        require(users[msg.sender].regDate == 0); // Check if user is already registered
        require(!isContract(msg.sender)); // This should be user wallet, not contract or other bot

        // If referrer is not valid then set it to default
        if (referrerID < userCount)
            referrer = userAddresses[referrerID];
        else
            referrer = rootWallet1;

        // Adding user to the users table
        users[msg.sender].id = userCount;
        users[msg.sender].userAddr = msg.sender;
        users[msg.sender].referrer = referrer;
        users[msg.sender].regDate = block.timestamp;
        users[msg.sender].walletType = uint8(walletType);
        userAddresses.push(msg.sender);
        userCount++;

        // Creating levels for the user
        for (uint level = 0; level < LEVELS_COUNT; level++) {
            users[msg.sender].levels.push(UserLevelInfo({
                openState: 0, // closed
                payouts: 0,
                missedProfit: 0,
                partnerBonus: 0,
                poolProfit: 0
            }));
        }

        // Filling referrer lines
        address currRef = users[msg.sender].referrer;
        users[currRef].line1++;
        currRef = users[currRef].referrer;
        users[currRef].line2++;
        currRef = users[currRef].referrer;
        users[currRef].line3++;
        currRef = users[currRef].referrer;
        users[currRef].line4++;
        currRef = users[currRef].referrer;
        users[currRef].line5++;

        if (REGISTRATION_PRICE > 0) {
            // Sending the money to the project wallet
            payable(regFeeWallet).transfer(REGISTRATION_PRICE);

            // Storing substracted amount
            users[msg.sender].credit += REGISTRATION_PRICE;
            turnoverAmount += REGISTRATION_PRICE;
        }

        // Updating stats
        uint half = (block.timestamp / SECONDS_IN_DAY_HALF) % 2;
        stats24hNormalize(half);
        if (half == 0) {
            users24h1++;
            turnover24h1 += REGISTRATION_PRICE;
        }
        else {
            users24h2++;
            turnover24h2 += REGISTRATION_PRICE;
        }
    }

    function internalBuyLevel(uint level, uint investAmount) private {
        // Prepare the data
        uint levelPrice = levelPrices[level];

        require(level < LEVELS_COUNT); // Check if level number is valid
        require((state & 1) == 0); // Check if contract is suspended
        require(investAmount >= levelPrice); // Check if receive the right amount
        require(users[msg.sender].regDate > 0); // Check if user is exists
        require((state & 4) == 0 || level <= users[msg.sender].maxLevel); // Check if all levels are allowed (or they allowed by sequence)
        require(block.timestamp >= initialDate + levelIntervals[level]); // Check if level is available
        require(users[msg.sender].levels[level].openState != 2); // Check if level is not opened

        // Updating stats
        uint half = (block.timestamp / SECONDS_IN_DAY_HALF) % 2;
        stats24hNormalize(half);
        if (half == 0) {
            transactions24h1++;
            turnover24h1 += investAmount;
        }
        else {
            transactions24h2++;
            turnover24h2 += investAmount;
        }

        // Storing substracted amount
        users[msg.sender].credit += investAmount;
        turnoverAmount += investAmount;

        // Sending fee for buying level
        uint levelFee = levelPrice * LEVEL_FEE_PERCENTS / 100;
        payable(marketingWallet).transfer(levelFee);
        marketingBalance += levelFee;
        investAmount -= levelFee;

        // Sending rewards to top referrers
        address referrer = users[msg.sender].referrer;
        for (uint i = 0; i < 5; i++) {
            // Calculating the value to invest to current referrer
            uint value = levelPrice * referrerPercents[i] / 100;

            // Skipping all the referres that does not have this level previously opened
            while (users[referrer].levels[level].openState == 0) {
                users[referrer].levels[level].missedProfit += value;
                referrer = users[referrer].referrer;
            }

            // If it is not root user than we sending money to it, otherwice we collecting the rest of money
            payable(referrer).transfer(value);
            users[referrer].debit += value;
            users[referrer].referralReward += value;
            users[referrer].lastReferralReward = value;
            users[referrer].levels[level].partnerBonus += value;
            investAmount -= value;

            // Switching to the next referrer (if we can)
            referrer = users[referrer].referrer;
        }

        // Sending reward to first user in the queue of this level
        address rewardAddress = levelQueue[level][headIndex[level]];
        if (rewardAddress != msg.sender) {
            uint reward = levelPrice * USER_REWARD_PERCENTS / 100;
            bool sent = payable(rewardAddress).send(reward);
            if (sent) {
                investAmount -= reward;
                users[rewardAddress].debit += reward;
                users[rewardAddress].levelProfit += reward;
                users[rewardAddress].levels[level].poolProfit += reward;
                users[rewardAddress].levels[level].payouts++;
                if (users[rewardAddress].levels[level].payouts & 1 == 0 && users[rewardAddress].id >= ROOT_WALLETS_COUNT)
                    users[rewardAddress].levels[level].openState = 1; // closed (opened once)
                else
                    levelQueue[level].push(rewardAddress);
                delete levelQueue[level][headIndex[level]];
                headIndex[level]++;
            }
        }

        if (investAmount > 0) {
            payable(marketingWallet).transfer(investAmount); 
            marketingBalance += investAmount;
        }

        // Activating level
        levelQueue[level].push(msg.sender);
        users[msg.sender].levels[level].openState = 2;
        users[msg.sender].levels[level].missedProfit = 0;
        if (level >= users[msg.sender].maxLevel)
            users[msg.sender].maxLevel = level + 1;

        transactionCounter++;
    }

    function register(uint referrerID, uint levelNumber, uint walletType) public payable {
        uint restOfAmount = msg.value;
        internalRegister(referrerID, restOfAmount, walletType);
        restOfAmount -= REGISTRATION_PRICE;
        internalBuyLevel(levelNumber, restOfAmount);
    }

    function buyLevel(uint level) public payable {
        internalBuyLevel(level, msg.value);
    }

    function invest() public payable {
        uint restOfAmount = msg.value;
        if (users[msg.sender].regDate == 0) {
            internalRegister(0, restOfAmount, 0);
            restOfAmount -= REGISTRATION_PRICE;
        }
        internalBuyLevel(users[msg.sender].maxLevel, restOfAmount);
        transactionCounter++;
    }

    function getPrices() public view verified returns (uint regPrice, uint[] memory lvlPrices) {
        return (REGISTRATION_PRICE, levelPrices);
    }

    function getLevelsCount() public view verified returns (uint) {
        return LEVELS_COUNT;
    }

    function getAvailableLevels() public view verified returns (bool[] memory) {
        bool[] memory list = new bool[](LEVELS_COUNT);
        uint time = block.timestamp;
        for (uint level = 0; level < LEVELS_COUNT; level++)
            list[level] = time >= initialDate + levelIntervals[level];

        return list;
    }

    function getSchedule() public view verified returns(uint date, uint[] memory intervals) {
        return (initialDate, levelIntervals);
    }

    function setSchedule(uint date, uint[] memory intervals) public {
        require(msg.sender == adminWallet);
        initialDate = date;
        for (uint i = 0; i < LEVELS_COUNT; i++)
            levelIntervals[i] = intervals[i];

        transactionCounter++;
    }

    function getUserCount() public view verified returns(uint) {
        return userCount;
    }

    function getUserAddresses() public view verified returns(address[] memory) {
        return userAddresses;
    }

    function getUserAddressesFragment(uint offset, uint count) public view verified returns(address[] memory) {
        address[] memory list = new address[](count);
        for (uint i = 0; i < count; i++)
            list[i] = userAddresses[offset + i];

        return list;
    }

    function getUsersFragment(uint offset, uint count) public view verified returns(User[] memory) {
        User[] memory list = new User[](count);
        for (uint i = 0; i < count; i++)
            list[i] = users[userAddresses[offset + i]];

        return list;
    }

    function getUser(address userAddr) public view verified returns(User memory) {
        return users[userAddr];
    }

    function getUserByID(uint id) public view verified returns(User memory) {
        return getUser(userAddresses[id]);
    }

    function hasUser(address userAddr) public view verified returns(bool) {
        return users[userAddr].regDate > 0;
    }

    function detectChanges() public view verified returns(uint) {
        uint changes = transactionCounter;
        if ((state & 1) > 0)
            changes += 9999;
        return changes;
    }

    function getQueueSize(uint level) public view verified returns (uint) {
        return levelQueue[level].length - headIndex[level];
    }

    function getQueueFragment(uint level, uint offs, uint count) public view verified returns (address[] memory) {
        if (count == 0)
            count = getQueueSize(level);

        address[] memory queue = new address[](count);
        uint index = 0;
        uint i = headIndex[level] + offs;
        uint n = i + count;
        for (; i < n; i++) {
            queue[index] = levelQueue[level][i];
            index++;
        }

        return queue;
    }

    function getQueueForLevel(uint level) public view verified returns (address[] memory addresses, uint[] memory payouts) {
        uint queueSize = levelQueue[level].length - headIndex[level];
        address[] memory addressQueue = new address[](queueSize);
        uint[] memory payoutsQueue = new uint[](queueSize);

        uint index = 0;
        uint n = levelQueue[level].length;
        for (uint i = headIndex[level]; i < n; i++) {
            address addr = levelQueue[level][i];
            addressQueue[index] = addr;
            payoutsQueue[index] = users[addr].levels[level].payouts;
            index++;
        }

        return (addressQueue, payoutsQueue);
    }

    function getSlots(address userAddr) public view verified returns(int[] memory slots, uint[] memory sizes, uint[] memory partnerBonuses, uint[] memory poolProfits, uint[] memory missedProfits, uint contractState) {
        int[] memory slotList = new int[](LEVELS_COUNT);
        uint[] memory sizeList = new uint[](LEVELS_COUNT);
        uint[] memory partnerBonusList = new uint[](LEVELS_COUNT);
        uint[] memory poolProfitList = new uint[](LEVELS_COUNT);
        uint[] memory missedProfitList = new uint[](LEVELS_COUNT);
        for (uint level = 0; level < LEVELS_COUNT; level++) {
            if (block.timestamp < initialDate + levelIntervals[level]) {
                slotList[level] = -1; // Not availabled yet (user need to wait some time once it bacome available)
                continue;
            }

			if (users[userAddr].levels[level].missedProfit > 0)
                missedProfitList[level] = users[userAddr].levels[level].missedProfit;

            if ((state & 4) > 0 && level > users[userAddr].maxLevel) {
                slotList[level] = -2; // Not allowed yet (previous level is not opened)
                continue;
            }

            partnerBonusList[level] = users[userAddr].levels[level].partnerBonus;
            poolProfitList[level] = users[userAddr].levels[level].poolProfit;

            if (users[userAddr].levels[level].openState != 2) {
                if (users[userAddr].levels[level].openState == 0)
                    slotList[level] = -3; // Available for opening
                else
                    slotList[level] = -4; // Available for reopening

                continue;
            }

            int place = 0;
            for (uint i = headIndex[level]; i < levelQueue[level].length; i++) {
                place++;
                if (levelQueue[level][i] == userAddr) {
                    slotList[level] = place;
                    sizeList[level] = levelQueue[level].length - headIndex[level];
                    break;
                }
            }
        }

        return (slotList, sizeList, partnerBonusList, poolProfitList, missedProfitList, state);
    }

    function getPlaceInQueue(address userAddr, uint level) public view verified returns (int pos, uint size) {
        int place = 0;
        for (uint i = headIndex[level]; i < levelQueue[level].length; i++) {
            place++;
            if (levelQueue[level][i] == userAddr)
                return (place, levelQueue[level].length - headIndex[level]);
        }
        
        return (-1, 0);
    }

    function getPlaceInQueues(address userAddr) public view verified returns (PlaceInQueue[] memory) {
        PlaceInQueue[] memory list = new PlaceInQueue[](LEVELS_COUNT);
        for (uint level = 0; level < LEVELS_COUNT; level++)
            (list[level].pos, list[level].size) = getPlaceInQueue(userAddr, level);
        
        return list;
    }

    function levelIsOpened(address userAddr, uint level) public view verified returns(bool) {
        return users[userAddr].levels[level].openState == 2;
    }

    function getBalances(uint start, uint end) public view verified returns (uint counter, uint marketingFee, address[] memory wallets, address[] memory referrers, uint[] memory debits, uint[] memory credits) {
        if (start > end) {
            start = 0;
            end = userCount;
        }
        
        uint n = end - start;
        address[] memory referrerList = new address[](n);
        uint[] memory debitList = new uint[](n);
        uint[] memory creditList = new uint[](n);
        for (uint i = start; i < end; i++) {
            address addr = userAddresses[i];
            referrerList[i] = users[addr].referrer;
            debitList[i] = users[addr].debit;
            creditList[i] = users[addr].credit;
        }
        return (transactionCounter, marketingBalance, userAddresses, referrerList, debitList, creditList);
    }

    function withdraw(uint amount, address payable destAddr) public {
        require(msg.sender == adminWallet);
        destAddr.transfer(amount);
    }

    function donate() public verified payable {
        payable(marketingWallet).transfer(msg.value);
    }

    function getTotalInfo() public view verified returns(uint totalUsers, uint totalTransactions, uint totalTurnover, uint users24h, uint transactions24h, uint turnover24h) {
        return (
            userCount,
            transactionCounter,
            turnoverAmount,
            users24h1 + users24h2,
            transactions24h1 + transactions24h2,
            turnover24h1 + turnover24h2
        );
    }

    function getUserAddrByID(uint id) public view verified returns(address) {
        return userAddresses[id];
    }

    function getUserIDByAddr(address userAddr) public view verified returns(uint) {
        return users[userAddr].id;
    }

    function getState() public view returns (uint) {
        return state;
    }

    function setState(uint value) public {
        require(msg.sender == adminWallet);
        state = value;
    }

    function update(address contractAddr, address receiveAddr, address fallbackAddr) public {
        require(msg.sender == adminWallet);
        contractID = contractAddr;
        receiveImpl = receiveAddr;
        fallbackImpl = fallbackAddr;
    }

}