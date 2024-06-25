// SPDX-License-Identifier: UNLICENSED
/*

.---.  .---.     ,-----.    .-------. .-------.    ____     
|   |  |_ _|   .'  .-,  '.  \  _(`)_ \\  _(`)_ \ .'  __ `.  
|   |  ( ' )  / ,-.|  \ _ \ | (_ o._)|| (_ o._)|/   '  \  \ 
|   '-(_{;}_);  \  '_ /  | :|  (_,_) /|  (_,_) /|___|  /  | 
|      (_,_) |  _`,/ \ _/  ||   '-.-' |   '-.-'    _.-`   | 
| _ _--.   | : (  '\_/ \   ;|   |     |   |     .'   _    | 
|( ' ) |   |  \ `"/  \  ) / |   |     |   |     |  _( )_  | 
(_{;}_)|   |   '. \_/``".'  /   )     /   )     \ (_ o _) / 
'(_,_) '---'     '-----'    `---'     `---'      '.(_,_).'  
                                                            

Hoppa Tournament

- The token amount you send is your stake
- The higher your stake, the higher the reward if you are the winner
- Rewards are paid out when the Game Maker selects the winners
- There is a penalty when you unstake the tokens before the game ends
  The penalty is to give incenctive to complete the game, as it impacts
  the game experience of others when you leave early.
- You can unstake at most the amount of tokens you put in minus the penalty
- The penalty is lifted once the Game Maker closes the Arena
- The tokens you stake are held by the contract
- Winners are paid from the total amount staked
- How winners are determined is not part of this contract


A 2D platform game by Moonshot & Ra8bits

Play: https://moonarcade.games/hoppa

Source: https://github.com/moonshot-platform/hoppa


*/

pragma solidity ^0.7.3;

interface IERC20 {

    function totalSupply() external view returns (uint256);

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

// File @openzeppelin/contracts/math/[email protected]

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract HoppaTournament {

    using SafeMath for uint256;

    address public owner;

    address public tokenContract;
 
    uint256 public totalTokensStaked;
    uint256 public totalPlayers;
    uint256 public gameEndTime;
    
    uint8 public penaltyPercentage;

    mapping(address => bool) public gameMakers;
    mapping(address => uint) public stakedTokens;

    event EnterArena(address indexed buyer);
    event SelectWinner(address indexed winner, uint256 amount);
    event SetTokenAddress(address newTokenContract);
    event WithdrawBNB(uint256 amount);
    event WithdrawTokens(address tokenContractAddress, uint256 amount);
    event TournamentOpenUntil(uint256 endAt);
    event LeaveArena(address player);
    event PlayerRemoved(address player);
    event GameMakerAdded(address gamemaker);
    event GameMakerRemoved(address gamemaker);
    event DeserterPenaltyChanged(uint newPenaltyPercentage);
    event ApprovedTransfer(address player, uint256 amount);

    constructor(address _tokenContract) {
        owner = msg.sender;
        tokenContract = _tokenContract;
    }

    modifier onlyGameMaker {
        require( gameMakers[ msg.sender ] , "Only the game maker can call this function.");
        _;
    }

    modifier onlyOwner {
        require( owner == msg.sender , "Only the owner can call this function.");
        _;
    }

    function withdrawTokens(address tokenContractAddress) external onlyOwner {
        uint256 amount = IERC20(tokenContractAddress).balanceOf(address(this));
        require(amount > 0, "Nothing to withdraw.");
        IERC20(tokenContractAddress).transfer( msg.sender , amount);

        emit WithdrawTokens(tokenContractAddress, amount);
    }

    function withdrawBNB() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable( msg.sender ).transfer( balance );
        emit WithdrawBNB(balance);
    }

    function setTokenAddress(address newTokenContract) external onlyOwner() {
        tokenContract = newTokenContract;
        emit SetTokenAddress(tokenContract);
    }

    function addGameMaker(address _gameMaker) external onlyOwner {
        gameMakers[ _gameMaker ] = true;
        emit GameMakerAdded(_gameMaker);
    }

    function removeGameMaker(address _gameMaker) external onlyOwner {
        gameMakers[ _gameMaker ] = false;
        emit GameMakerRemoved(_gameMaker);
    }
  
    function setPenaltyPercentage(uint8 penalty) external onlyGameMaker {
        require( penalty < 50, "Penalty cannot be more than 50%");
        penaltyPercentage = penalty;
        emit DeserterPenaltyChanged(penaltyPercentage);
    }

    function removePlayer(address player) external onlyGameMaker {
        require( stakedTokens[ player ] > 0, "Player is not staked.");

        uint256 withdrawAmount = getWithdrawAmount( player );
        uint256 unstakeAmount = calcUnstakeAmount(withdrawAmount);
        IERC20( tokenContract ).transfer( player, unstakeAmount );
        
        stakedTokens[ player ] = 0;
        totalTokensStaked = totalTokensStaked.sub(unstakeAmount);
        totalPlayers --;
        
        emit PlayerRemoved(player);
    }

    function openArena(uint daysDuration) external onlyGameMaker {
        uint256 gameDuration = daysDuration * 1 days;
        gameEndTime = block.timestamp + gameDuration;

        emit TournamentOpenUntil(gameEndTime);
    }

    function selectWinner(address _winner) public onlyGameMaker {
        uint256 balance =  IERC20(tokenContract).balanceOf(address(this));
        require(!gameMakers[ _winner ], "Game Maker cannot be a winner." );
        require(_winner != owner , "Owner cannot be a winner.");
        require(balance > 0, "Contract balance is 0.");
        require(stakedTokens[_winner] > 0, "Player does not have a stake.");
        
        uint256 unstakeAmount = balance.mul( stakedTokens[ _winner ] ).div( totalTokensStaked );

        require(IERC20(tokenContract).transfer(_winner, unstakeAmount), "Token transfer failed.");
        
        
        totalTokensStaked = totalTokensStaked.sub(unstakeAmount);
        stakedTokens[_winner] = 0;

        totalPlayers --;
        emit SelectWinner(_winner, unstakeAmount);
    }

    function selectWinners(address[] memory winners) external onlyGameMaker {
        for( uint i = 0; i < winners.length; i ++ ) {
            if( stakedTokens[ winners[i] ] > 0 ) {
                selectWinner( winners[i] );
            }
        }
    }

    function closeArena() external onlyGameMaker {
        gameEndTime = block.timestamp;
    }

    function enterArena(uint256 amount) external {
        require( IERC20(tokenContract).balanceOf(msg.sender) >= amount, "Insufficient balance.");
        require(amount > 0, "Invalid amount.");

        IERC20(tokenContract).transferFrom(msg.sender, address(this), amount);
        totalTokensStaked = totalTokensStaked.add( amount );
        stakedTokens[ msg.sender ] = stakedTokens[ msg.sender ].add( amount );
        
        totalPlayers ++;

        emit EnterArena(msg.sender);
    }
    
    function leaveArena() external {
        require(stakedTokens[msg.sender] > 0, "You have no tokens staked.");
        
        uint256 withdrawAmount = getWithdrawAmount(msg.sender);
        uint256 unstakeAmount = calcUnstakeAmount(withdrawAmount);

        require( IERC20( tokenContract ).transfer(msg.sender, unstakeAmount), "Token transfer failed.");

        totalTokensStaked = totalTokensStaked.sub( unstakeAmount );
        stakedTokens[msg.sender] = 0;
        totalPlayers --;

        emit LeaveArena(msg.sender);
    }

    function getTotalAmountStaked() external view returns (uint256) {
        return totalTokensStaked;
    }

    function getTotalPlayers() external view returns (uint256) {
        return totalPlayers;
    }

    function playerHasJoined() external view returns (uint256) {
        return stakedTokens[msg.sender];
    }

    function isUnderPenalty() external view returns (bool) {
        return block.timestamp < gameEndTime;
    }

    function getClosingDate() external view returns (uint256) {
        return gameEndTime;
    }

    function hasJoined() external view returns (bool) {
        return stakedTokens[ msg.sender ] > 0;
    }

    function getCurrentStake() external view returns (uint256) {
        return stakedTokens[ msg.sender ];
    }

    function isGameMaker() external view returns (bool) {
        return gameMakers[ msg.sender ];
    }

    function estimateUnstakeAmount() external view returns (uint256) {
        uint256 withdrawAmount = getWithdrawAmount( msg.sender );
        uint256 unstakeAmount = calcUnstakeAmount(withdrawAmount);
        return unstakeAmount;
    }

    function estimateReward() external view returns (uint256) {
        uint256 balance =  IERC20(tokenContract).balanceOf(address(this));
        uint256 estimatedAmount = balance.mul( stakedTokens[ msg.sender ] ).div( totalTokensStaked );
        return estimatedAmount;
    }

    function getWithdrawAmount(address player) internal view returns (uint256) {
        uint256 withdrawAmount = 0;
        if(block.timestamp < gameEndTime) {
            // there is a penalty for unstaking before the game ends
            uint256 penalty = stakedTokens[player].mul( penaltyPercentage ).div( 100 );
            withdrawAmount = stakedTokens[player].sub( penalty );
        }
        else {
            // tokens to unstake
            withdrawAmount = stakedTokens[player];
        }
        return withdrawAmount;
    }

    function calcUnstakeAmount( uint256 withdrawAmount ) internal view returns (uint256) {
        uint256 balance = IERC20(tokenContract).balanceOf(address(this));
        uint256 unstakeAmount = 0;

        if( balance >= totalTokensStaked ) {
            // simply unstaking returns at most the amount you put in, minus the penalty
            unstakeAmount = withdrawAmount; 
        }
        else {
            // or less, depending on the contract's balance
            unstakeAmount = balance.mul( withdrawAmount ).div( totalTokensStaked );
        }
        return unstakeAmount;
    }


}