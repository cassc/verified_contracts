// SPDX-License-Identifier: PROPRIETARY

pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
 *
 * Contract created and developed by QuemGanha Team
 * Do you like it ?
 * Help us and making a donation...
 * You can donate at contract Creator's wallet!
 *
 *  Any question or suggestion ? Send us an email: [email protected]
 *
 * Candidates Index:
 * 0 - Invalid
 * 1 - Lula
 * 2 - Jair
 * 3 - Felipe
 * 4 - Ciro
 * 5 - Simone
 * 6 - Eymael
 * 7 - Roberto
 * 8 - Kelmon
 * 9 - Sofia
 * 10 - Vera
 * 11 - Leonardo
 * 12 - Soraya
 */

contract QuemGanha is Ownable {
  uint8 public candidateWinner;
  uint public betTimeLimit;
  uint public amountToWinners;
  uint public amountFee;
  bool public feeCollected;

  uint public constant minBetValue = 0.01 ether;
  string public constant name = "Quem Ganha ?";
  string public constant url = "https://www.quemganha.org";

  uint[13] private candidateAmount;
  mapping(address => uint[13]) bettors;
  mapping(address => bool) winBetCollected;

  constructor() {
    // 02 October 2022  03:00:00 GMT
    betTimeLimit = 1664679600;
  }

  // ------------------------------ [Public|External] [View|Pure] Methods
  /**
   * Get all information from sum value from every candidate
   * @return candidates - List with sum bet from every candidate
   */
  function getAllCandidatesAmount() external view returns (uint[13] memory) {
    return candidateAmount;
  }

  /**
   * This is a only a contract look to let know the name of each candidate index.
   * This is not used for anything else in contract, its only for reference
   * @return candidateNames - List of strings with every candidate name and index that is represented in contract
   */
  function getCandidate() external pure returns (string[12] memory candidateNames) {
    candidateNames[0] = "1 - Lula";
    candidateNames[1] = "2 - Jair Bolsonaro";
    candidateNames[2] = "3 - Felipe D Avila";
    candidateNames[3] = "4 - Ciro Gomes";
    candidateNames[4] = "5 - Simone Tebet";
    candidateNames[5] = "6 - Eymael";
    candidateNames[6] = "7 - Roberto Jefferson";
    candidateNames[7] = "8 - Kelmon Souza";
    candidateNames[8] = "9 - Sofia Manzano";
    candidateNames[9] = "10 - Vera";
    candidateNames[10] = "11 - Leornardo Pericles";
    candidateNames[11] = "12 - Soraya Thronicke";
  }

  /**
   * Get all bets from a given wallet.
   * @param bettor - wallet that want to be checked
   * @return bets - List with amount bet from wallet of each candidate
   */
  function getBettorAmount(address bettor) external view returns (uint[13] memory bets) {
    bets = bettors[bettor];
  }

  /**
   * Returns the amount earned from a bettor.
   * It only brings information after has been defined an winner
   * @param bettor - wallet that want to be checked
   * @return amount - amount value that the wallet has right to collect
   */
  function getRewardAmount(address bettor) public view returns (uint amount) {
    uint8 winnerIndex = candidateWinner;
    uint yourWinBet = bettors[bettor][winnerIndex];
    if (yourWinBet <= 0) return 0;
    return (amountToWinners * yourWinBet) / candidateAmount[winnerIndex];
  }

  /**
   * Facilitator that allow collected almost every information necessary to populate an website
   * If there is no wallet to be send, the address 0x0 can be sent.
   * @param bettor - Address given to provide some information about it. If there is no wallet to send, the value 0x0 is accepted
   * @return candidates - List with sum bet from every candidate
   * @return bets - List with sum bet done from given wallet on each candidate
   * @return balance - Contract current BNB balance
   * @return winnerIndex - Index number of winner. Value 0 is given if its not defined the winner yet
   * @return winnersAmount - Total sum value from losers candidates. Value 0 is given if its not defined the winner yet
   * @return timeLimit - Timestamp limit to make a bet.
   * @return reward - Return the amount value that the wallet has right to collect. 0 is given it wallet has no right or winner is not defined yet
   * @return collected - Boolean value that indicates if given wallet has collected his reward
   */
  function getFullData(address bettor)
    external
    view
    returns (
      uint[13] memory candidates,
      uint[13] memory bets,
      uint balance,
      uint winnerIndex,
      uint winnersAmount,
      uint timeLimit,
      uint reward,
      bool collected
    )
  {
    candidates = candidateAmount;
    bets = bettors[bettor];
    balance = address(this).balance;
    winnerIndex = candidateWinner;
    timeLimit = betTimeLimit;
    winnersAmount = amountToWinners;
    collected = winBetCollected[bettor];
    reward = getRewardAmount(bettor);
  }

  // ------------------------------ Public Executable Methods ------------------------------
  /**
   * Place a bet. The bet value needs to be send through BNB gas.
   * ! Do not send WBNB or any other token to contract
   *
   * @param candidateIndex - Number from 1 to 12 of candidate the bettor want to place a bet
   * @return bool that indicates if has finalized successfully
   */
  function addBet(uint8 candidateIndex) external payable returns (bool) {
    uint amount = msg.value;

    require(candidateIndex >= 1 && candidateIndex <= candidateAmount.length - 1, _msgInvalidCandidateIndex);
    require(amount >= minBetValue, _msgInvalidBetAmount);
    require(block.timestamp < betTimeLimit, _msgBetRoundEnded);

    bettors[msg.sender][candidateIndex] += amount;
    candidateAmount[candidateIndex] += amount;

    emit BetDone(msg.sender, amount);
    return true;
  }

  /**
   * Here each wallet can collect the right reward.
   * Its gives back the amount bet on winner candidate + the amount of reward based on value of loser candidates
   *
   * It will fail if wallet try to collect more then once time.
   * It will fail if wallet try to collect before an winner has been defined
   * It will fail if wallet try to collect before ends the Bet Time Limit
   *
   * @return bool that indicates if operation was executed successfully.
   */
  function collectReward() external returns (bool) {
    uint8 winnerIndex = candidateWinner;
    uint yourWinBet = bettors[msg.sender][winnerIndex];
    uint totalBet = candidateAmount[winnerIndex];

    require(winnerIndex > 0, _msgBetRoundNotEnded);
    require(block.timestamp >= betTimeLimit, _msgBetRoundNotEnded);
    require(yourWinBet > 0, _msgNoWinnerBet);
    require(!winBetCollected[msg.sender], _msgBetAlreadyCollected);

    winBetCollected[msg.sender] = true;

    uint amountWon = (amountToWinners * yourWinBet) / totalBet;

    payable(msg.sender).transfer(amountWon + yourWinBet);
    emit CollectedReward(msg.sender, yourWinBet, amountWon);
    return true;
  }

  // ------------------------------ Administration Methods ------------------------------
  /**
   * Administrative operation to update the time limit in case of there a second round.
   * This will enable reopen bets after first round until 24h before starting votes to second round
   *
   * @param newTimeLimit - timestamp to reopen bets until this new time limit
   */
  function setTimeLimit(uint newTimeLimit) external onlyOwner {
    betTimeLimit = newTimeLimit;
    emit TimeLimitUpdated(newTimeLimit);
  }

  /**
   * Administrative operation to define the winner.
   * A value from 1 to 12 will be set according to the candidate list and according with the voting winner
   *
   * This method makes the calculation considering the amount from losers candidates and store it to be used
   * as base calculations fro wallets collect the rewards.
   *
   * @param candidateIndex - value from 1 to 12
   */
  function setCandidateWinner(uint8 candidateIndex) external onlyOwner {
    require(candidateIndex >= 1 && candidateIndex <= candidateAmount.length - 1, _msgInvalidCandidateIndex);
    require(candidateWinner == 0, _msgWinnerAlreadyDefined);

    uint amountWon;
    candidateWinner = candidateIndex;
    for (uint i = 1; i < candidateAmount.length; i++) {
      if (i != candidateIndex) amountWon += candidateAmount[i];
    }

    uint feeAmount = (amountWon * 20) / 100;

    amountToWinners = amountWon - feeAmount;
    amountFee = feeAmount;

    emit CandidateWinnerUpdated(candidateIndex, amountWon);
  }

  /**
   * Administrative operation that collects fees after ands all bets, after the Bet Time Limit, after has been defined an winner.
   * It now allow collect multiple times.
   */
  function collectFee() external onlyOwner {
    require(candidateWinner > 0, _msgBetRoundNotEnded);
    require(block.timestamp >= betTimeLimit, _msgBetRoundNotEnded);
    require(amountFee > 0, _msgNoFeeAmount);
    require(!feeCollected, _msgFeeAlreadyCollected);

    feeCollected = true;

    payable(owner()).transfer(amountFee);
    emit FeeCollected(amountFee);
  }

  /**
   * Method used to finalize and make final withdrawal of contract gas balances.
   * It can only be done after the participant withdrawal deadline that is 31th November 2022
   */
  function finalWithdraw() external onlyOwner {
    uint dayLimitCollect = 1669852800; // 31 November 2022 (30 after second vote round)
    require(block.timestamp > dayLimitCollect, _msgNotOnTimeToWithdraw);
    payable(owner()).transfer(address(this).balance);
  }

  /**
   * Method used to remove tokens that were accidentally sent to the contract
   * This method cannot remove BNB (that is network gas) from contract, only tokens as ETH, USDT, BUSD...
   */
  function safeApprove(
    address token,
    address spender,
    uint amount
  ) external onlyOwner {
    IERC20(token).approve(spender, amount);
  }

  // ------------------------------ Events ------------------------------
  event TimeLimitUpdated(uint timestamp);
  event FeeCollected(uint feeAmount);
  event CandidateWinnerUpdated(uint8 winner, uint amountWon);
  event BetDone(address indexed bettor, uint amount);
  event CollectedReward(address indexed wallet, uint bet, uint reward);

  // ------------------------------ Errors Msg ------------------------------
  string private constant _msgInvalidCandidateIndex = "Candidato Invalido";
  string private constant _msgInvalidBetAmount = "Aposta Invalida";
  string private constant _msgBetRoundEnded = "Apostas encerradas";
  string private constant _msgWinnerAlreadyDefined = "Candidate winner already defined";
  string private constant _msgBetRoundNotEnded = "As apostas ainda nao foram encerradas";
  string private constant _msgNoFeeAmount = "No fee amount to be collected";
  string private constant _msgFeeAlreadyCollected = "Fee amount already collected";
  string private constant _msgNoWinnerBet = "Voce nao apostou no ganhador";
  string private constant _msgBetAlreadyCollected = "Voce ja coletou seus ganhos";
  string private constant _msgNoDirectDeposit = "Contract does not accept direct deposits";
  string private constant _msgNotOnTimeToWithdraw = "Not on date to make final withdraw.";
}