/**
 *Submitted for verification at BscScan.com on 2023-01-26
*/

pragma solidity 0.5.8;

/**
 *
 * https://moonshots.farm
 * 
 * Want to own the next 1000x SHIB/DOGE/HEX token? Farm a new/trending moonshot every other day, automagically!
 *
 */

contract BananaVault {
	using SafeMath for uint256;
	using SafeMath128 for uint128;

	ERC20 constant bones = ERC20(0x08426874d46f90e5E527604fA5E3e30486770Eb3);
	ERC20 constant banana = ERC20(0x603c7f932ED1fc6575303D8Fb018fDCBb0f39a95);
	ERC20 constant syrup = ERC20(0x86Ef5e73EDB2Fea111909Fe35aFcC564572AcC06);
	ERC20 constant wbnb = ERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

	SyrupPool constant bananaPool = SyrupPool(0x71354AC3c695dfB1d3f595AfA5D4364e9e06339B);
	BonesStaking bonesStaking = BonesStaking(0x57D3Ac2c209D9De02A80700C1D1C2cA4BC029b04);
	
	UniswapV2 constant cakeV2 = UniswapV2(0x10ED43C718714eb63d5aA57B78B54704E256024E);
	MoonshotGovernance constant governance = MoonshotGovernance(0x7cE91cEa92e6934ec2AAA577C94a13E27c8a4F21);

	mapping(address => uint16[]) public playersSnapshotDays; // Epochs player changed balance 
	mapping(address => uint128[]) public playersSnapshotBalances; // Balances for the above epochs
	
	mapping(address => mapping(uint256 => bool)) public playersSnapshotsClaimed;
	uint256[] public totalDepositSnapshots;
	uint256[] public farmedAmountSnapshots; // Amount of tokens farmed by epoch
	address[] public farmedTokensSnapshots; // Address which was farmed by epoch

	uint256 public totalShares;
	uint256 public pricePerShare = 10 ** 18;
	uint256 constant internal magnitude = 2 ** 64;

	uint256 public lockPeriod = 30; // Moonshots unlock after 30 snapshots (60 days)
	uint256 constant withdrawPeriod = 15; // Moonshots expire in 15 snapshots (30 days to claim)
	uint256 public lastSnapshot;

	uint256 public pendingBonesAlloc;
	uint256 public pendingFeesAlloc;
	uint256 public cashoutTax = 20; // 0.2% withdraw fee to prevent abuse
	address blobby = msg.sender;

	constructor() public {
		wbnb.approve(address(bonesStaking), 2 ** 255);
		bones.approve(address(bonesStaking), 2 ** 255);
		banana.approve(address(bananaPool), 2 ** 255);
		banana.approve(address(cakeV2), 2 ** 255);
	}
	
	function() payable external { /* Payable */ }

	function deposit(uint128 amount) external {
		address farmer = msg.sender;
		require(farmer == tx.origin);
		require(banana.transferFrom(address(farmer), address(this), amount));
		pullOutstandingDivs();

		bananaPool.deposit(0, amount);

		uint256 sharesGained = (uint256(amount) * (10 ** 18)) / pricePerShare;
		totalShares += sharesGained;

		uint128 oldBalance;
		uint256 length = playersSnapshotBalances[farmer].length;
		if (length > 0) {
			oldBalance = playersSnapshotBalances[farmer][length - 1];
		}
		updateBalance(oldBalance.add(uint128(sharesGained)), farmer);
	}

	function updateBalance(uint128 newBalance, address farmer) internal {
		uint256 length = playersSnapshotDays[farmer].length;
		if (length > 0 && playersSnapshotDays[farmer][length - 1] == epoch()) {
			playersSnapshotBalances[farmer][length - 1] = newBalance;
		} else {
			playersSnapshotDays[farmer].push(epoch());
			playersSnapshotBalances[farmer].push(newBalance);
		}
	}

	function pullOutstandingDivs() public {
		if (totalShares > 0) {
			uint256 beforeBalance = banana.balanceOf(address(this));
			bananaPool.withdraw(0, 0);

			uint256 divsGained = banana.balanceOf(address(this)) - beforeBalance;
			uint256 bonesShare = (divsGained * 5) / 100; // 5% to bones stakers
			uint256 toCompound = (divsGained - bonesShare) / 2; // Half banana farmed gets compounded, other half yolos into the x100 moonshot coins
			bananaPool.deposit(0, toCompound);
			pricePerShare += toCompound * (10 ** 18) / totalShares;
			pendingBonesAlloc += bonesShare;
		}
	}

	function cashout(uint128 amount) external {
		address farmer = msg.sender;
		pullOutstandingDivs();

		uint256 shares = (uint256(amount) * (10 ** 18)) / pricePerShare;
		totalShares = totalShares.sub(shares);

		uint256 length = playersSnapshotBalances[farmer].length;
		require(length > 0);
		uint128 oldBalance = playersSnapshotBalances[farmer][length - 1];
		updateBalance(oldBalance.sub(uint128(shares)), farmer);

		bananaPool.withdraw(0, amount);

		uint256 fee = (amount * cashoutTax) / 10000;
		pendingFeesAlloc += fee;
		require(banana.transfer(farmer, amount - fee));
	}

	function claimYield(uint256 index) external {
		require(!playersSnapshotsClaimed[msg.sender][index]);
		require(index.add(lockPeriod) < epoch() && epoch() <= index.add(lockPeriod + withdrawPeriod)); // 60 + 30 days to claim
		uint256 playersBalance = playersBalanceOnDay(index);
		if (playersBalance > 0) {
			uint256 divs = (farmedAmountSnapshots[index] * playersBalance) / totalDepositSnapshots[index];
			if (divs > 0) {
				playersSnapshotsClaimed[msg.sender][index] = true;
				if (farmedTokensSnapshots[index] == address(bones)) {
					bonesStaking.depositFor(msg.sender, divs);
				} else {
					ERC20(farmedTokensSnapshots[index]).transfer(msg.sender, divs);
				}
			}
		}
	}

	function pullBonusBones() external {
		require(msg.sender == blobby);
		governance.pullWeeklyRewards();
	}

	function updateBonesStaking(address newStaking) external {
		require(msg.sender == blobby);
		bonesStaking = BonesStaking(newStaking);
		wbnb.approve(address(bonesStaking), 2 ** 255);
		bones.approve(address(bonesStaking), 2 ** 255);
	}

	function sweepCake(uint256 amount, uint256 minBNB) external {
		require(msg.sender == blobby);
		pendingBonesAlloc = pendingBonesAlloc.sub(amount);

		address[] memory path = new address[](2);
        path[0] = address(banana);
        path[1] = address(wbnb);
        
        cakeV2.swapExactTokensForTokens(amount, minBNB, path, address(this), 2 ** 255);
		bonesStaking.distributeDivs(wbnb.balanceOf(address(this)));
	}

	function sweepExpired(uint256 index, uint256 tokens, uint256 minBNB, bool sweepBNB, bool pullInstead) external {
		require(msg.sender == blobby);
		require(epoch() > index.add(lockPeriod + withdrawPeriod)); // 60 + 30 days passed
		ERC20 moonshot = ERC20(farmedTokensSnapshots[index]);

		uint256 amount = tokens;
		if (amount == 0) {
			amount = moonshot.balanceOf(address(this));
		}

		if (amount > 0) {
			if (pullInstead) { // If liquidity no longer exists can just remove expired token
				moonshot.transfer(blobby, amount);
			} else {
				address[] memory path = new address[](2);
				path[0] = address(moonshot);
				path[1] = address(wbnb);
				cakeV2.swapExactTokensForTokens(amount, minBNB, path, address(this), 2 ** 255);
			}
		}

		if (sweepBNB) { // Once dust gets enough, sweep to use as LP/buybacks/burns
			wbnb.transfer(blobby, wbnb.balanceOf(address(this)));
		}
	}

	// Incase anyone mistakely sends unrelated tokens to this contract
	function sweepLostTokens(address token, uint256 amount, address recipient) external {
		require(msg.sender == blobby);
		require(token != address(banana) && token != address(syrup));

		uint256 start = farmedTokensSnapshots.length - 1;
		for (uint256 i = 0; i < 90; i++) {
			// Token address cannot be in any of the last 90 snapshots
			require(token != farmedTokensSnapshots[start - i]);
		}
		ERC20(token).transfer(recipient, amount);
	}

	function sweepFees(address recipient, uint256 amount) external {
		require(msg.sender == blobby);
		pendingFeesAlloc = pendingFeesAlloc.sub(amount);
		banana.transfer(recipient, amount);
	}

	function updateFee(uint256 newAmount) external {
		require(msg.sender == blobby);
		require(newAmount <= 50); // 0.5% max
		cashoutTax = newAmount;
	}

	function updateLockPeriod(uint256 newLockPeriod) external {
		require(msg.sender == blobby);
		require(newLockPeriod <= 60 && newLockPeriod >= 15); // So can be slightly tweaked if necessary
		lockPeriod = newLockPeriod;
	}

	function buyMoonshots(uint256 amount, uint256 minTokens) public {
		require(msg.sender == blobby);

		uint256 length = farmedTokensSnapshots.length;
		require(length > 0);
		address moonshot = farmedTokensSnapshots[length - 1];

        require(amount <= moonshotAlloc());
		if (amount > 0) {
			address[] memory path = new address[](3);
        	path[0] = address(banana);
        	path[1] = address(wbnb);
			path[2] = address(moonshot);
        	cakeV2.swapExactTokensForTokens(amount, minTokens, path, address(this), 2 ** 255);
		}
	}

	function snapshotMoonshotDivs(address nextToken, uint256 minTokens) external {
		require(msg.sender == blobby);
		require(now > lastSnapshot + 23 hours);

		uint256 length = farmedTokensSnapshots.length;
		if (length > 0) { // No prior gains when adding first token
			address priorMoonshot = farmedTokensSnapshots[length - 1];
			if (minTokens > 0) { // Can buy more tokens before snapshot
				buyMoonshots(moonshotAlloc(), minTokens);
			}
			farmedAmountSnapshots.push(ERC20(priorMoonshot).balanceOf(address(this)));
			totalDepositSnapshots.push(totalShares); // Store amount owned and amount farming (for divs calc)
		}

		farmedTokensSnapshots.push(nextToken); // Move onto next moonshot token
		ERC20(nextToken).approve(address(cakeV2), 2 ** 255);
		lastSnapshot = now;
	}



	function moonshotAlloc() view public returns (uint256) {
		return(banana.balanceOf(address(this)) - (pendingBonesAlloc + pendingFeesAlloc));
	}

	function cakeBalance(address farmer) view public returns (uint256) {
		uint256 pendingPricePerShare = pricePerShare;
		uint256 pendingCompoundCake = (bananaPool.pendingBanana(0, address(this)) * 475) / 1000;
		pendingPricePerShare += (pendingCompoundCake * (10 ** 18)) / totalShares;

		uint256 length = playersSnapshotBalances[farmer].length;
		if (length > 0) {
			return (playersSnapshotBalances[farmer][length - 1] * pendingPricePerShare) / (10 ** 18);
		}
	}

	function totalCakeBalance() view public returns (uint256) {
		return (totalShares * pricePerShare) / (10 ** 18);
	}

	function epoch() public view returns (uint16) {
		return uint16(farmedTokensSnapshots.length - 1);
	}
	
	function playersBalanceOnDay(uint256 search) public view returns (uint256) {
		for (uint256 i = playersSnapshotDays[msg.sender].length; i > 0; i--) {
			uint256 day = playersSnapshotDays[msg.sender][i - 1];
			if (day <= search) {
				return playersSnapshotBalances[msg.sender][i - 1];
			}
		}
		return 0;
	}

	function availableYields(uint256 offset, uint256 amount) external view returns (address[] memory, uint256[] memory, bool[] memory) {
        uint256 results = amount;
        if (results > farmedTokensSnapshots.length - offset) {
            results = farmedTokensSnapshots.length - offset;
        }

        address[] memory tokens = new address[](results);
        uint256[] memory yields = new uint256[](results);
		bool[] memory claimed = new bool[](results);

		uint256 start = farmedTokensSnapshots.length - (offset + 1);
		for (uint256 i = 0; i < results; i++) {
			(tokens[i], yields[i], claimed[i]) = availableYield(start);
			start--;
		}

		return (tokens, yields, claimed);
	}
	
	function availableYield(uint256 index) public view returns (address, uint256, bool) {
		uint256 yieldShare;
		if (index < farmedAmountSnapshots.length) {
			yieldShare = (farmedAmountSnapshots[index] * playersBalanceOnDay(index)) / totalDepositSnapshots[index];
		}
		return (farmedTokensSnapshots[index], yieldShare, playersSnapshotsClaimed[msg.sender][index]);
	}

}



interface BonesStaking {
	function depositFor(address player, uint256 amount) external;
	function distributeDivs(uint256 amount) external;
}

interface MoonshotGovernance {
	function pullWeeklyRewards() external;
}

interface SyrupPool {
	function deposit(uint256 _pid, uint256 _amount) external;
	function withdraw(uint256 _pid, uint256 _amount) external;
	function emergencyWithdraw(uint256 _pid) external;
	function pendingBanana(uint256 _pid, address _user) external view returns (uint256); 
}

interface WBNB {
	function withdraw(uint wad) external;
}

interface UniswapV2 {
	function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

interface ERC20 {
	function totalSupply() external view returns (uint256);
	function balanceOf(address who) external view returns (uint256);
	function allowance(address owner, address spender) external view returns (uint256);
	function transfer(address to, uint256 value) external returns (bool);
	function approve(address spender, uint256 value) external returns (bool);
	function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
	function transferFrom(address from, address to, uint256 value) external returns (bool);
	function burn(uint256 amount) external;

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

	/**
	* @dev Multiplies two numbers, throws on overflow.
	*/
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		assert(c / a == b);
		return c;
	}

	/**
	* @dev Integer division of two numbers, truncating the quotient.
	*/
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		// assert(b > 0); // Solidity automatically throws when dividing by 0
		uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
		return c;
	}

	/**
	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	*/
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}

	/**
	* @dev Adds two numbers, throws on overflow.
	*/
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		assert(c >= a);
		return c;
	}
}

library SafeMath128 {

	/**
	* @dev Adds two numbers, throws on overflow.
	*/
	function add(uint128 a, uint128 b) internal pure returns (uint128) {
		uint128 c = a + b;
		assert(c >= a);
		return c;
	}

	/**
	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	*/
	function sub(uint128 a, uint128 b) internal pure returns (uint128) {
		assert(b <= a);
		return a - b;
	}

}