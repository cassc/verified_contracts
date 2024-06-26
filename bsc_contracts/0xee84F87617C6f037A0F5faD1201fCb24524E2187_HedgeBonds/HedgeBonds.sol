/**
 *Submitted for verification at BscScan.com on 2022-12-19
*/

//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract Ownable {

    address private owner;
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier onlyOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    
    function symbol() external view returns(string memory);
    
    function name() external view returns(string memory);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);
    
    /**
     * @dev Returns the number of decimal places
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IMDBOracle {
    function lastAnswer() external view returns (uint256);
}

/** 
    MDB Hedge Bonds
    Locks Up Funds For 60 Days
    +25% Hedged Downside
 */
contract HedgeBonds is Ownable {

    // MDB Token
    address public constant MDB = 0x0557a288A93ed0DF218785F2787dac1cd077F8f3;

    // MDB Oracle
    IMDBOracle public constant Oracle = IMDBOracle(0xf353B10dF47d21c8715D4fCE6C969a99EdA6FDd9);

    // PCS Router
    IUniswapV2Router02 public constant router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    // day
    uint256 private constant day = 28800;

    // Lock Time In Blocks
    uint256 public lockTime = day * 60;

    // Minimum Value To Buy Bond
    uint256 public minimumValue = 1 * 10**18; // 1 BNB

    // Value Increase
    uint256 public valueIncrease = 125;

    // Bond Structure
    struct Bond {
        address recipient;
        uint256 numTokens;
        uint256 unlockBlock;
        uint256 purchaseCost;
        uint256 indexInUserArray;
    }

    // User -> ID[]
    mapping ( address => uint256[] ) public userIDs;

    // ID -> Bond
    mapping ( uint256 => Bond ) public bonds;

    // Global ID Nonce
    uint256 public nonce;

    // Swap Path
    address[] private path;

    // Paused
    bool public paused = true;

    // White list for initial use
    mapping ( address => bool ) public isWhitelisted;
    bool public whitelistEnabled = true;

    // Events
    event BondCreated(address indexed user, uint amount, uint unlockBlock, uint bondID);

    constructor(){
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = MDB;
    }

    function setLockTime(uint newLockTime) external onlyOwner {
        require(
            newLockTime < day * 366,
            'Lock Time Too Long'
        );
        
        lockTime = newLockTime;
    }

    function disableWhitelist() external onlyOwner {
        whitelistEnabled = false;
    }

    function enableWhitelist() external onlyOwner {
        whitelistEnabled = true;
    }

    function pauseContract() external onlyOwner {
        paused = true;
    }

    function unpauseContract() external onlyOwner {
        paused = false;
    }

    function setValueIncrease(uint newValue) external onlyOwner {
        require(newValue >= 100 && newValue <= 1000, 'Out Of Bounds');
        valueIncrease = newValue;
    }

    function addWhitelist(address[] calldata users, bool isWhitelisted_) external onlyOwner {
        uint len = users.length;
        for (uint i = 0; i < len;) {
            isWhitelisted[users[i]] = isWhitelisted_;
            unchecked { ++i; }
        }
    }

    function setMinimumValue(uint newMinimum) external onlyOwner {
        require(
            newMinimum > 0,
            'Minimum too small'
        );

        minimumValue = newMinimum;
    }

    function withdrawBNB() external onlyOwner {
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }

    function withdrawToken(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(msg.sender, amount);
    }

    receive() external payable {
        _purchaseBond(msg.sender, msg.value, 0);
    }

    function purchaseBond() external payable {
        _purchaseBond(msg.sender, msg.value, 0);
    }

    function purchaseBondMinOut(uint minOut) external payable {
        _purchaseBond(msg.sender, msg.value, minOut);
    }

    function releaseBond(uint256 bondID) external {
        _releaseBond(bondID);
    }

    function releaseBonds(uint256[] calldata bondIDs) external {
        uint len = bondIDs.length;
        for (uint i = 0; i < len;) {
            _releaseBond(bondIDs[i]);
            unchecked { ++i; }
        }
    }

    function _releaseBond(uint256 bondID) internal {
        require(
            bondID < nonce,
            'Invalid Bond ID'
        );
        require(
            bonds[bondID].unlockBlock <= block.number,
            'Lock Time Has Not Passed'
        );

        // number of MDB tokens bond ID has held
        uint256 nTokens = tokensToReceive(bondID);

        // recipient of the MDB Tokens held by bond ID
        address recipient = bonds[bondID].recipient;

        // Ensure ID Has Not Already Been Released
        require(
            nTokens > 0 &&
            recipient != address(0),
            'Bond has already been released'
        );

        // Maybe remove bondID from user array
        _removeBond(bondID);

        // send tokens back to recipient
        if (nTokens > balanceOf()) {
            nTokens = balanceOf();
        }
        require(
            IERC20(MDB).transfer(
                recipient,
                nTokens
            ),
            'Failure On Token Transfer'
        );
    }

    function _purchaseBond(address user, uint amount, uint minOut) internal {
        require(
            paused == false,
            'Contract Is Paused'
        );
        require(
            user != address(0),
            'Zero User'
        );
        require(
            amount >= minimumValue,
            'Amount Less Than Minimum'
        );
        if (whitelistEnabled) {
            require(
                isWhitelisted[user],
                'User Not Whitelisted'
            );
        }

        // buy MDB
        uint received = _buy(amount, minOut);

        // register bond to nonce
        bonds[nonce].recipient = user;
        bonds[nonce].numTokens = received;
        bonds[nonce].purchaseCost = Oracle.lastAnswer();
        bonds[nonce].unlockBlock = block.number + lockTime;
        bonds[nonce].indexInUserArray = userIDs[user].length;

        // register nonce to user
        userIDs[user].push(nonce);

        // emit event
        emit BondCreated(user, amount, bonds[nonce].unlockBlock, nonce);

        // increment global nonce
        unchecked {
            nonce++;
        }
    }

    function _buy(uint amount, uint minOut) internal returns (uint256) {

        // MDB balance before buy
        uint before = balanceOf();

        // swap BNB to MDB
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(minOut, path, address(this), block.timestamp + 100);

        // MDB balance after buy
        uint After = balanceOf();
        
        // ensure tokens were received
        require(
            After > before,
            'Zero Received'
        );

        // ensure minOut was preserved
        uint received = After - before;
        require(
            received >= minOut,
            'Min Out'
        );

        // return number of tokens purchased
        return received;
    }

    function _removeBond(uint256 bondID) internal {

        // index of bond ID we are removing
        uint rmIndex = bonds[bondID].indexInUserArray;
        // user who owns the bond ID
        address user = bonds[bondID].recipient;
        // length of user bond ID array
        uint userIDLength = userIDs[user].length;

        // set index of last element to be removed index
        bonds[
            userIDs[user][userIDLength - 1]
        ].indexInUserArray = rmIndex;

        // set removed element to be last element of user array
        userIDs[user][
            rmIndex
        ] = userIDs[user][userIDLength - 1];

        // pop last element off user array
        userIDs[user].pop();

        // remove bond data
        delete bonds[bondID];
    }

    function tokensToReceive(uint256 bondID) public view returns (uint256 nTokens) {

        // number of MDB tokens bond ID has held
        nTokens = bonds[bondID].numTokens;

        // Ensure ID Has Not Already Been Released
        if(nTokens == 0) {
            return 0;
        }

        // Evaluate Price compared to previous
        uint256 oldPrice = bonds[bondID].purchaseCost;
        uint256 newPrice = currentPrice();

        // Determine whether or not extra tokens should be given
        if (newPrice > oldPrice) {

            // new price is greater, reduce +25% amount based on USD Value
            uint256 targetPrice = (oldPrice * valueIncrease) / 100;
            
            // if new price is less than +25% of old price, give extra up to +25%, else give no extra
            if (targetPrice > newPrice) {
                nTokens += ( nTokens * ( targetPrice - newPrice ) ) / oldPrice;
            }

        } else {
            // new price is less, give +25%
            nTokens = ( nTokens * valueIncrease ) / 100;
        }
    }

    function totalTokensOwed() external view returns (uint256 total) {
        for ( uint i = 0; i < nonce; ) {
            total += tokensToReceive(i);
            unchecked { ++i; }
        }
    }

    function balanceOf() public view returns (uint256) {
        return IERC20(MDB).balanceOf(address(this));
    }
    
    function timeUntilUnlock(uint256 bondID) public view returns (uint256) {
        return bonds[bondID].unlockBlock <= block.number ? 0 : bonds[bondID].unlockBlock - block.number;
    }

    function numBonds(address user) public view returns (uint256) {
        return userIDs[user].length;
    }

    function fetchBondIDs(address user) external view returns (uint256[] memory) {
        return userIDs[user];
    }

    function fetchTotalTokensToClaim(address user) external view returns (uint256 total) {
        uint nBonds = numBonds(user);
        for (uint i = 0; i < nBonds;) {
            total += tokensToReceive(userIDs[user][i]);
            unchecked { ++i; }
        }
    }

    function fetchTotalTokensToClaimThatCanBeClaimed(address user) external view returns (uint256 total) {
        (, uint256[] memory tokens) = fetchIDsAndNumTokensThatCanBeClaimed(user);
        for (uint i = 0; i < tokens.length;) {
            total += tokens[i];
            unchecked { ++i; }
        }
    }

    function fetchIDsAndNumTokensAndLockDurations(address user) external view returns (uint256[] memory, uint256[] memory, uint256[] memory) {
        uint nBonds = numBonds(user);
        uint256[] memory tokens = new uint256[](nBonds);
        uint256[] memory unlockDurations = new uint256[](nBonds);

        for (uint i = 0; i < nBonds;) {
            tokens[i] = tokensToReceive(userIDs[user][i]);
            unlockDurations[i] = timeUntilUnlock(userIDs[user][i]);
            unchecked { ++i; }
        }
        return (userIDs[user], tokens, unlockDurations);
    }

    function fetchIDsAndNumTokensThatCanBeClaimed(address user) public view returns (uint256[] memory, uint256[] memory) {
        uint nBonds = numBonds(user);

        uint count = 0;
        for (uint i = 0; i < nBonds;) {
            if (timeUntilUnlock(userIDs[user][i]) == 0) {
                count++;
            }
            unchecked { ++i; }
        }

        uint256[] memory tokens = new uint256[](count);
        uint256[] memory IDs = new uint256[](count);

        uint uCount = 0;
        for (uint i = 0; i < nBonds;) {
            if (timeUntilUnlock(userIDs[user][i]) == 0) {
                tokens[uCount] = tokensToReceive(userIDs[user][i]);
                IDs[uCount] = userIDs[user][i];
                unchecked { uCount++; ++i; }
            }
        }

        return (IDs, tokens);
    }

    function fetchIDsThatCanBeClaimed(address user) public view returns (uint256[] memory) {
        uint nBonds = numBonds(user);

        uint count = 0;
        for (uint i = 0; i < nBonds;) {
            if (timeUntilUnlock(userIDs[user][i]) == 0) {
                count++;
            }
            unchecked { ++i; }
        }

        uint256[] memory IDs = new uint256[](count);

        uint uCount = 0;
        for (uint i = 0; i < nBonds;) {
            if (timeUntilUnlock(userIDs[user][i]) == 0) {
                IDs[uCount] = userIDs[user][i];
                unchecked { uCount++; }
            }
            unchecked { ++i; }
        }

        return (IDs);
    }

    function currentPrice() public view returns (uint256) {
        return Oracle.lastAnswer();
    }
}