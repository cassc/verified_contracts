/**
 *Submitted for verification at BscScan.com on 2022-11-17
*/

/**
BePulser SCORE - RatioScore
*/

// SPDX-License-Identifier: MIT
// File: contracts/bet/interfaces/game/IRatioScore.sol



pragma solidity ^0.8.7;

interface IRatioScore {
    /**
     * @dev Start a new round, trigger when this new round includes few matches
     */
    event StartNewRound(uint256 indexed round, uint256 indexed few, bool indexed force);

    /**
     * @dev trigger when tie game(let the ball included)
     */
    event TieScore(bool indexed maxEqual);

    /**
     * @dev start a new round, new round includes how many matches(if force is true, means force to open next round, even this round did not end ) (default 2 results, 0 odd, 1 even)
     */
    function startNewRound(uint256 few, bool force) external;

    /**
     * @dev Query the let the ball of which match of which round
     */
    function searchWhichGamesConced(uint256 round, uint256 which) external view returns (uint256[] memory conced);
}

// File: contracts/bet/interfaces/base/IBaseStruct.sol



pragma solidity ^0.8.7;

interface IBaseStruct {
    struct AddressOnceInfo {
        uint256 round;
        uint256 which;

        uint256 betMoney; // betting amount
        uint256 betResult; // betting result

        uint256 gameState; // match status
        uint256 gameResult; // match result

        uint256 WinMoney; // prize money

        bool isTake; // if withdrawal the prize
    }
}
// File: contracts/bet/interfaces/base/IBaseUser.sol



pragma solidity ^0.8.7;


interface IBaseUser is IBaseStruct {

    /**
     * @dev Trigger when bet in which result of which match of which round
     */
    event CoinsBetWhichGame(uint256 indexed round, uint256 indexed which, uint256 indexed index, uint256 money, address user);

    /**
     * @dev trigger when settle the prize money for user of which match of which round
     */
    event SettlementWhichGame(uint256 indexed round, uint256 indexed which, uint256 indexed result, uint256 money, address user);

    /**
     * @dev query how many rounds in total
     */
    function searchAllRound() external view returns (uint256 allRound);

    /**
     * @dev query how many matches in which round (round = 2**256 - 1 represents the current round)
     */
    function searchGamesNumber(uint256 round) external view returns (uint256 nhumber);

    /**
     * @dev query how many results of all matches in which round
     */
    function searchGameResultNumber(uint256 round) external view returns (uint256[] memory number);

    /**
     * @dev bet in which result of which game of which round
     */
    function coinsBetWhichGame(uint256 round, uint256 which, uint256 index) external payable returns (uint256 money);

    /**
     * @dev query the total better in which round
     */
    function searchPeopleNumber(uint256 round) external view returns (uint256[] memory nhumber);

    /**
     * @dev Query the money amount in the betting pool of all results of which match of which round
     */
    function searchMoneyNumberWhichGame(uint256 round, uint256 which) external view returns (uint256[] memory nhumber);

    /**
     * @dev Query the stat of all matches of which round (0 initial status 1 betable 2 end bet, to be drawn 3 drawn 4 nul match) (round=2**256-1 represents the current round)
     */
    function searchGameState(uint256 round) external view returns (uint256[] memory state);

    /**
     * @dev inquire the ending time for betting of all the matches in which round (round=2**256-1 represents the current round)
     */
    function searchGameEndTime(uint256 round) external view returns (uint256[] memory endTime);

    /**
     * @dev settle the prize money of which match of which round for users, nul matches can use this interface to get their money back (round=2**256-1 represents the current round)
     */
    function settlementWhichGame(uint256 round, uint256 which) external returns (uint256 money);

    /**
     * @dev inquire all the results of all the matches in which round (2**256-1 means no result yet, 2**256-2 means invalid match ) (round=2**256-1 represents the current round)
     */
    function searchGameResult(uint256 round) external view returns (uint256[] memory result);

    /**
     * @dev Query the result of which match of  which round  (round=2**256-1 represents the current round)
     */
    function searchWhichGameResultList(uint256 round, uint256 which) external view returns (uint256[] memory result);

    /**
     * @dev query the bet money amout of which round of which the address
     */
    function searchRoundAddressBetMoney(uint256 round) external view returns (uint256[] memory betMoney);

    /**
     * @dev Check the details of this address
     */
    function searchAddressInfo(address user) external view returns (AddressOnceInfo[] memory addressInfo);

    /**
     * @dev search all player address
     */
    function searchAllPlayer() external view returns (address[] memory playerAddress);
}

// File: contracts/bet/interfaces/base/IBaseAdmini.sol



pragma solidity ^0.8.7;

interface IBaseAdmini {
    /**
     * @dev trigger when set how many results are in which match of which round
     */
    event SetWhichGamesResultNumber(uint256 indexed round, uint256 indexed which, uint256 indexed number, uint256[] ver);

    /**
     * @dev trigger when set the ending time of which match of which round
     */
    event SetWhichGamesEndTime(uint256 indexed round, uint256 indexed which, uint256 indexed endTime);

    /**
     * @dev trigger when bet which match of which round
     */
    event StartBetWhichlGames(uint256 indexed round, uint256 indexed which);

    /**
     * @dev trigger when stop betting for which match of which round
     */
    event CloseBetWhichlGames(uint256 indexed round, uint256 indexed which);

    /**
     * @dev trigger when cancle the result of which match of which round
     */
    event CancelWhichlGamesResult(uint256 indexed round, uint256 indexed which);

    /**
     * @dev trigger when set the result of which match of which round
     */
    event SetWhichlGamesResult(uint256 indexed round, uint256 indexed which, uint256[] result);

    /**
     * @dev Trigger when nullify which match of which round
     */
    event InvalWhichlGames(uint256 indexed round, uint256 indexed which);

    /**
     * @dev trigger when end which match of which round
     */
    event EndWhichlGames(uint256 indexed round, uint256 indexed which, uint256 indexed result);

    /**
     * @dev trigger when withdraw partial tax
     */
    event GetTax(uint256 indexed moneyNum, address indexed receiver);

    /**
     * @dev trigger when withdraw all tax
     */
    event GetAllTax(uint256 indexed moneyNum, address indexed receiver);

    /**
     * @dev trigger when set the tax ratio
     */
    event SetTaxRatio(uint256 indexed ratio);

    /**
     * @dev trigger when set minimun betting amount
     */
    event SetMinBet(uint256 indexed minBet);

    /**
     * @dev Set how many results of which match of which round  (round=2**256-1 represents the current round)
     */
    function setWhichGamesResultNumber(uint256 round, uint256 which, uint256 number, uint256[] calldata ver) external;

    /**
     * @dev set the ending time for betting of which match in which round  (round=2**256-1 represents the current round)
     */
    function setWhichGamesEndTime(uint256 round, uint256 which, uint256 endTime) external;

    /**
     * @dev Start betting for which match of which round  (round=2**256-1 represents the current round)
     */
    function startBetWhichlGames(uint256 round, uint256 which) external;

    /**
     * @dev Stop betting for which match of which round  (round=2**256-1 represents the current round)
     */
    function closeBetWhichlGames(uint256 round, uint256 which) external;

    /**
     * @dev Cancle the result of which match of match round  (round=2**256-1 represents the current round)
     */
    function cancelWhichlGamesResult(uint256 round, uint256 which) external;

    /**
     * @dev set the game result of which bet in which round (round=2**256-1 represents the current round) (e.g. Team A score 5, Team B score 10, then result=[5,10])
     */
    function setWhichlGamesResult(uint256 round, uint256 which, uint256[] calldata result) external;

    /**
     * @dev nullify which match of which round (round=2**256-1 represents the current round)
     */
    function invalWhichlGames(uint256 round, uint256 which) external;

    /**
     * @dev end which match of which round (round=2**256-1 represents the current round)
     */
    function endWhichlGames(uint256 round, uint256 which) external;

    /**
     * @dev Query how much tax left
     */
    function searchTax() external view returns (uint256 money);

    /**
     * @dev withdraw part of tax
     */
    function getTax(uint256 moneyNum) external returns (uint256 money);

    /**
     * @dev withdraw all tax
     */
    function getAllTax() external returns (uint256 money);

    /**
     * @dev Set tax ratio
     */
    function setTaxRatio(uint256 ratio) external;

    /**
     * @dev query the current tax ratio
     */
    function searchTaxRatio() external view returns (uint256 ratio);

    /**
     * @dev query all cumulative tax
     */
    function searchCumulativeTax() external view returns (uint256 ratio);

    /**
     * @dev query the total money amount in the contract
     */
    function searchAllPool() external view returns (uint256 money);

    /**
     * @dev set the minimum betting amount
     */
    function setMinBet(uint256 minBet) external;

    /**
     * @dev query the mininum betting amount
     */
    function searchMinBet() external view returns (uint256 minBet);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/bet/base/BaseFunction.sol



pragma solidity ^0.8.7;




abstract contract BaseFunction is IBaseUser, IBaseAdmini, Ownable {
    struct UserInfo {
        uint256 betMoney; // betting amount
        uint256 betResult; // betting result
        bool isTake; // if withdrawal the prize
    }

    struct GameInfo {
        uint256 gamePool; // gaming pool
        uint256 tax; // tax money
        uint256 takeTaxGamePool; // except tax money

        uint256 endTime; // betting end time

        uint256 gameState; // match status
        uint256 peopleNum; // how many people who bet

        uint256[] resultList; // certain match result

        uint256 resultNum; // results number(how Many results)
        mapping(uint256 => uint256) resultPool; // each betting amount for every results

        uint256 result; // match result
    }

    struct GameOnceRoundInfo {
        uint256 gameNum;
        mapping(uint256 => GameInfo) gameMap;
    }

    struct GameRoundInfo {
        uint256 roundNum;
        mapping(uint256 => GameOnceRoundInfo) roundGameMap;
    }

    uint256 constant UINT256_MAX = 2**256 - 1;

    uint256 constant CURRENT_ROUND = 2**256 - 1;
    uint256 constant NEXT_ROUND = 2**256 - 2;
    uint256 constant INIT_ROUND = 2**256 - 3;

    uint256 constant GAME_RESULT_NOT = 2**256 - 1;
    uint256 constant GAME_RESULT_INVAL = 2**256 - 2;

    uint256 constant GAME_STATE_INIT = 0;
    uint256 constant GAME_STATE_BET = 1;
    uint256 constant GAME_STATE_CLOSE_BET = 2;
    uint256 constant GAME_STATE_END = 3;
    uint256 constant GAME_STATE_END_INVAL = 4;

    uint256 constant USER_GAME_NO_BET = 100;
    uint256 constant USER_GAME_WIN = 101;
    uint256 constant USER_GAME_LOSE = 102;

    uint256 constant USER_GAME_NOT_BET_RESULT = 2**256 - 3;

    uint256 constant MAX_RATIO = 100000;

    mapping(address => 
        mapping(uint256 => 
        mapping(uint256 => UserInfo))) internal _addressInfoMap;

    mapping(address => uint256) internal _playNum;
    address[] internal _allPlayer;

    GameRoundInfo internal _gameRoundInfo;

    uint256 internal _taxRatio = 0; // contract tax ratio

    uint256 internal _allPool = 0; // total money amount in the contract

    uint256 internal _allTaxPool = 0; // all tax money in the contract

    uint256 internal _cumulativeTaxPool = 0; // all cumulative tax money in the contract

    uint256 internal _allTakeTaxPool = 0; // all money except tax in the contract

    uint256 internal _minBet = 1000; // minimum betting amount

    /**
     * @dev query how many rounds in total
     */
    function searchAllRound() public view virtual override returns (uint256 allRound) {
        return _gameRoundInfo.roundNum;
    }

    /**
     * @dev query how many matches in which round (round = 2**256 - 1 represents the current round)
     */
    function searchGamesNumber(uint256 round) public view virtual override returns (uint256 nhumber) {
        round = _setRound(round);
        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchGamesNumber Illegal round");
        return _gameRoundInfo.roundGameMap[round].gameNum;
    }

    /**
     * @dev query how many results of all matches in which round
     */
    function searchGameResultNumber(uint256 round) public view virtual override returns (uint256[] memory number) {
        round = _setRound(round);
        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchGameResultNumber Illegal round");
        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory endNumber = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            endNumber[i] = _gameRoundInfo.roundGameMap[round].gameMap[i].resultNum;
        }

        return endNumber;
    }

    /**
     * @dev bet in which result of which game of which round
     */
    function coinsBetWhichGame(uint256 round, uint256 which, uint256 index) public virtual override payable returns (uint256 money) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: coinsBetWhichGame Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: coinsBetWhichGame Illegal which");
        require(GAME_STATE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: coinsBetWhichGame gameState is not bet");
        require(index < _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum, "BaseFunction: coinsBetWhichGame Illegal index");
        require(_addressInfoMap[msg.sender][round][which].betMoney == 0, "BaseFunction: coinsBetWhichGame user already bet");
        require(block.timestamp < _gameRoundInfo.roundGameMap[round].gameMap[which].endTime, "BaseFunction: coinsBetWhichGame time is end");
        require(msg.value >= _minBet, "BaseFunction: msg.value need >= _minBet");

        _gameRoundInfo.roundGameMap[round].gameMap[which].peopleNum++;
        _gameRoundInfo.roundGameMap[round].gameMap[which].gamePool += msg.value;
        _gameRoundInfo.roundGameMap[round].gameMap[which].resultPool[index] += msg.value;

        _addressInfoMap[msg.sender][round][which].betMoney = msg.value;
        _addressInfoMap[msg.sender][round][which].betResult = index;

        _allPool += msg.value;

        if (_playNum[msg.sender] == 0) {
            _allPlayer.push(msg.sender);
        }
        _playNum[msg.sender]++;

        emit CoinsBetWhichGame(round, which, index, _addressInfoMap[msg.sender][round][which].betMoney, msg.sender);

        return _addressInfoMap[msg.sender][round][which].betMoney;
    }

    /**
     * @dev query the total better in which round
     */
    function searchPeopleNumber(uint256 round) public view virtual override returns (uint256[] memory nhumber) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchPeopleNumber Illegal round");
        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory peopleNumber = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            peopleNumber[i] = _gameRoundInfo.roundGameMap[round].gameMap[i].peopleNum;
        }

        return peopleNumber;
    }

    /**
     * @dev Query the money amount in the betting pool of all results of which match of which round
     */
    function searchMoneyNumberWhichGame(uint256 round, uint256 which) public view virtual override returns (uint256[] memory nhumber) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchMoneyNumberWhichGame Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: searchMoneyNumberWhichGame Illegal which");
        uint256 resultNum = _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum;

        uint256[] memory moneyNumber = new uint256[](resultNum);

        for (uint256 i = 0; i < resultNum; ++i) {
            moneyNumber[i] = _gameRoundInfo.roundGameMap[round].gameMap[which].resultPool[i];
        }

        return moneyNumber;
    }

    /**
     * @dev Query the stat of all matches of which round (0 initial status 1 betable 2 end bet, to be drawn 3 drawn 4 nul match) (round=2**256-1 represents the current round)
     */
    function searchGameState(uint256 round) public view virtual override returns (uint256[] memory state) {
        round = _setRound(round);

        if (round == INIT_ROUND) {
            return new uint256[](0);
        }

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchGameState Illegal round");
        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory gameState = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            gameState[i] = _gameRoundInfo.roundGameMap[round].gameMap[i].gameState;
        }

        return gameState;
    }

    /**
     * @dev inquire the ending time for betting of all the matches in which round (round=2**256-1 represents the current round)
     */
    function searchGameEndTime(uint256 round) public view virtual override returns (uint256[] memory endTime) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchGameEndTime Illegal round");
        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory gameEndTime = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            gameEndTime[i] = _gameRoundInfo.roundGameMap[round].gameMap[i].endTime;
        }

        return gameEndTime;
    }

    /**
     * @dev settle the prize money of which match of which round for users, nul matches can use this interface to get their money back (round=2**256-1 represents the current round)
     */
    function settlementWhichGame(uint256 round, uint256 which) public virtual override returns (uint256 money) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: settlementWhichGame Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: settlementWhichGame Illegal which");
        require((GAME_STATE_END == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState) || 
            (GAME_STATE_END_INVAL == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState), "BaseFunction: settlementWhichGame gameState is not end or is not inval");
        require(GAME_RESULT_NOT != _gameRoundInfo.roundGameMap[round].gameMap[which].result, "BaseFunction: settlementWhichGame not have result");
        require(_addressInfoMap[msg.sender][round][which].betMoney != 0, "BaseFunction: settlementWhichGame user not bet");
        require(_addressInfoMap[msg.sender][round][which].isTake == false, "BaseFunction: settlementWhichGame user is tacke");

        uint256 winMoney = 0;
        if (_gameRoundInfo.roundGameMap[round].gameMap[which].gameState == GAME_STATE_END_INVAL) {
            winMoney = _addressInfoMap[msg.sender][round][which].betMoney;
            payable(msg.sender).transfer(winMoney);
            _allPool -= winMoney;
        } else {
            require(_addressInfoMap[msg.sender][round][which].betResult == _gameRoundInfo.roundGameMap[round].gameMap[which].result, "BaseFunction: settlementWhichGame user result error");
            require(_gameRoundInfo.roundGameMap[round].gameMap[which].resultPool[_gameRoundInfo.roundGameMap[round].gameMap[which].result] != 0, "BaseFunction: settlementWhichGame dev 0 error");
            winMoney = (_addressInfoMap[msg.sender][round][which].betMoney * _gameRoundInfo.roundGameMap[round].gameMap[which].takeTaxGamePool) / 
                _gameRoundInfo.roundGameMap[round].gameMap[which].resultPool[_gameRoundInfo.roundGameMap[round].gameMap[which].result];
            payable(msg.sender).transfer(winMoney);
            _allPool -= winMoney;
        }
        _addressInfoMap[msg.sender][round][which].isTake = true;
        
        emit SettlementWhichGame(round, which, _gameRoundInfo.roundGameMap[round].gameMap[which].result,winMoney, msg.sender);

        return winMoney;
    } 

    /**
     * @dev inquire all the results of all the matches in which round (2**256-1 means no result yet, 2**256-2 means invalid match ) (round=2**256-1 represents the current round)
     */
    function searchGameResult(uint256 round) public view virtual override returns (uint256[] memory result) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchGameResult Illegal round");
        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory endResult = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            endResult[i] = _gameRoundInfo.roundGameMap[round].gameMap[i].result;
        }

        return endResult;
    }

    /**
     * @dev Query the result of which match of  which round  (round=2**256-1 represents the current round)
     */
    function searchWhichGameResultList(uint256 round, uint256 which) public view virtual override returns (uint256[] memory result) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchWhichGameResultList Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: searchWhichGameResultList Illegal which");

        return _gameRoundInfo.roundGameMap[round].gameMap[which].resultList;
    }

    /**
     * @dev query the bet money amout of which round of which the address
     */
    function searchRoundAddressBetMoney(uint256 round) public view virtual override returns (uint256[] memory betMoney) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: searchRoundAddressBetMoney Illegal round");

        uint256 gameNum = _gameRoundInfo.roundGameMap[round].gameNum;

        uint256[] memory __betMoney = new uint256[](gameNum);
        for (uint256 i = 0; i < gameNum; ++i) {
            __betMoney[i] = _addressInfoMap[msg.sender][round][i].betMoney;
        }

        return __betMoney;
    }


    /**
     * @dev Check the details of this address
     */
    function searchAddressInfo(address user) public view virtual override returns (AddressOnceInfo[] memory addressInfo) {
        
        uint256 allRound = _gameRoundInfo.roundNum;

        uint256 gameNum = 0;
        uint256 infoNum = 0;

        uint256 betMoney = 0;
        uint256 betResult = 0;
        uint256 gameState = 0;
        uint256 gameResult = 0;
        uint256 wMoney = 0;

        if (user == address(0)) {
            user = msg.sender;
        }

        AddressOnceInfo[] memory __addressInfo = new AddressOnceInfo[](_playNum[user]);

        for (uint256 ii = 0; ii < allRound; ++ii) {
            gameNum = _gameRoundInfo.roundGameMap[ii].gameNum;
            for (uint256 jj = 0; jj < gameNum; ++jj) {
                if (_addressInfoMap[user][ii][jj].betMoney > 0) {
                    __addressInfo[infoNum].round = ii;
                    __addressInfo[infoNum].which = jj;

                    betMoney = _addressInfoMap[user][ii][jj].betMoney;
                    betResult = _addressInfoMap[user][ii][jj].betResult;

                    __addressInfo[infoNum].betMoney = betMoney;
                    __addressInfo[infoNum].betResult = betResult;

                    gameState = _gameRoundInfo.roundGameMap[ii].gameMap[jj].gameState;
                    gameResult = _gameRoundInfo.roundGameMap[ii].gameMap[jj].result;

                    __addressInfo[infoNum].gameState = gameState;
                    __addressInfo[infoNum].gameResult = gameResult;

                    if (gameState == GAME_STATE_END_INVAL) {
                        wMoney = betMoney;
                    } else if (gameState == GAME_STATE_END) {
                        if (betResult == gameResult) {
                            require(_gameRoundInfo.roundGameMap[ii].gameMap[jj].resultPool[gameResult] != 0, "BaseFunction: searchAddressInfo dev 0 error");
                            wMoney = (betMoney * _gameRoundInfo.roundGameMap[ii].gameMap[jj].takeTaxGamePool) / 
                                _gameRoundInfo.roundGameMap[ii].gameMap[jj].resultPool[gameResult];
                        } else {
                            wMoney = 0;
                        }
                    } else {
                        wMoney = 0;
                    }

                    __addressInfo[infoNum].WinMoney = wMoney;

                    __addressInfo[infoNum].isTake = _addressInfoMap[user][ii][jj].isTake;

                    ++infoNum;
                }
            }
        }
        return __addressInfo; 
    }

    /**
     * @dev search all player address
     */
    function searchAllPlayer() public view virtual override returns (address[] memory playerAddress) {
        return _allPlayer;
    }

    /**
     * @dev Set how many results of which match of which round  (round=2**256-1 represents the current round)
     */
    function setWhichGamesResultNumber(uint256 round, uint256 which, uint256 number, uint256[] calldata ver) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: setWhichGamesResultNumber Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: setWhichGamesResultNumber Illegal which");
        require(GAME_STATE_INIT == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: setWhichGamesResultNumber gameState is not init");

        _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum = number;

        emit SetWhichGamesResultNumber(round, which, number, ver);
    }

    /**
     * @dev set the ending time for betting of which match in which round  (round=2**256-1 represents the current round)
     */
    function setWhichGamesEndTime(uint256 round, uint256 which, uint256 endTime) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: setWhichGamesEndTime Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: setWhichGamesEndTime Illegal which");
        require(GAME_STATE_INIT == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: setWhichGamesEndTime gameState is not init");

        _gameRoundInfo.roundGameMap[round].gameMap[which].endTime = endTime;

        emit SetWhichGamesEndTime(round, which, endTime);
    }

    /**
     * @dev Start betting for which match of which round  (round=2**256-1 represents the current round)
     */
    function startBetWhichlGames(uint256 round, uint256 which) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: startBetWhichlGames Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: startBetWhichlGames Illegal which");
        require(GAME_STATE_INIT == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: startBetWhichlGames gameState is not init");

        _beforeStartBetWhichlGames(round, which);

        _gameRoundInfo.roundGameMap[round].gameMap[which].gameState = GAME_STATE_BET;

        emit StartBetWhichlGames(round, which);
    }

    /**
     * @dev Stop betting for which match of which round  (round=2**256-1 represents the current round)
     */
    function closeBetWhichlGames(uint256 round, uint256 which) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: closeBetWhichlGames Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: closeBetWhichlGames Illegal which");
        require(GAME_STATE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: closeBetWhichlGames gameState is not bet");

        _gameRoundInfo.roundGameMap[round].gameMap[which].gameState = GAME_STATE_CLOSE_BET;

        emit CloseBetWhichlGames(round, which);
    }

    /**
     * @dev Cancle the result of which match of match round  (round=2**256-1 represents the current round)
     */
    function cancelWhichlGamesResult(uint256 round, uint256 which) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: cancelWhichlGamesEnd Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: cancelWhichlGamesEnd Illegal which");
        require(GAME_STATE_CLOSE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: cancelWhichlGamesEnd gameState is not close bet");

        _gameRoundInfo.roundGameMap[round].gameMap[which].resultList = new uint256[](0);

        emit CancelWhichlGamesResult(round, which);
    }

    /**
     * @dev set the game result of which bet in which round (round=2**256-1 represents the current round) (e.g. Team A score 5, Team B score 10, then result=[5,10])
     */
    function setWhichlGamesResult(uint256 round, uint256 which, uint256[] calldata result) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: setWhichlGamesEnd Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: setWhichlGamesEnd Illegal which");
        require(GAME_STATE_CLOSE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: setWhichlGamesEnd gameState is not colse bet");

        _gameRoundInfo.roundGameMap[round].gameMap[which].resultList = new uint256[](0);
        for (uint256 i = 0; i < result.length; ++i) {
            _gameRoundInfo.roundGameMap[round].gameMap[which].resultList.push(result[i]);
        }

        emit SetWhichlGamesResult(round, which, result);
    }

    /**
     * @dev nullify which match of which round (round=2**256-1 represents the current round)
     */
    function invalWhichlGames(uint256 round, uint256 which) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: invalWhichlGames Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: invalWhichlGames Illegal which");
        require(GAME_STATE_CLOSE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: invalWhichlGames gameState is not close bet");

        _gameRoundInfo.roundGameMap[round].gameMap[which].resultList = new uint256[](0);
        _gameRoundInfo.roundGameMap[round].gameMap[which].result = GAME_RESULT_INVAL;
        _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum = 0;

        _gameRoundInfo.roundGameMap[round].gameMap[which].gameState = GAME_STATE_END_INVAL;
        _countMoney(round, which, true);

        emit InvalWhichlGames(round, which);
    }

    /**
     * @dev end which match of which round (round=2**256-1 represents the current round)
     */
    function endWhichlGames(uint256 round, uint256 which) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "BaseFunction: endWhichlGames Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "BaseFunction: endWhichlGames Illegal which");
        require(GAME_STATE_CLOSE_BET == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "BaseFunction: endWhichlGames gameState is not close bet");

        _beforeEndWhichlGames(round, which);
        
        if (_gameRoundInfo.roundGameMap[round].gameMap[which].gameState == GAME_STATE_END_INVAL) {
            return;
        }

        _gameRoundInfo.roundGameMap[round].gameMap[which].gameState = GAME_STATE_END;
        _countMoney(round, which, false);

        emit EndWhichlGames(round, which, _gameRoundInfo.roundGameMap[round].gameMap[which].result);
    }

    /**
     * @dev Query how much tax left
     */
    function searchTax() public view virtual override returns (uint256 money) {
        return _allTaxPool;
    }

    /**
     * @dev withdraw part of tax
     */
    function getTax(uint256 moneyNum) public virtual override onlyOwner returns (uint256 money) {
        require(moneyNum <= _allTaxPool, "BaseFunction: getTax Illegal money");
        payable(msg.sender).transfer(moneyNum);
        _allTaxPool -= moneyNum;
        _allPool -= moneyNum;

        emit GetTax(moneyNum, msg.sender);
        return moneyNum;
    }

    /**
     * @dev withdraw all tax
     */
    function getAllTax() public virtual override onlyOwner returns (uint256 money) {
        payable(msg.sender).transfer(_allTaxPool);
        uint256 getMoney = _allTaxPool;
        _allTaxPool = 0;
        _allPool -= getMoney;

        emit GetAllTax(getMoney, msg.sender);
        return getMoney;
    }

    /**
     * @dev Set tax ratio
     */
    function setTaxRatio(uint256 ratio) public virtual override onlyOwner {
        require(ratio < MAX_RATIO, "BaseFunction: setTaxRatio Illegal ratio");
        _taxRatio = ratio;

        emit SetTaxRatio(ratio);
    }

    /**
     * @dev query the current tax ratio
     */
    function searchTaxRatio() public view virtual override returns (uint256 ratio) {
        return _taxRatio;
    }

    /**
     * @dev query all cumulative tax
     */
    function searchCumulativeTax() public view virtual override returns (uint256 ratio) {
        return _cumulativeTaxPool;
    }

    /**
     * @dev query the total money amount in the contract
     */
    function searchAllPool() public view virtual override returns (uint256 money) {
        return _allPool;
    }

    /**
     * @dev set the minimum betting amount
     */
    function setMinBet(uint256 minBet) public virtual override onlyOwner {
        require(minBet != _minBet, "BaseFunction: setMinBet minBet is equal _minBet");
        _minBet = minBet;

        emit SetMinBet(_minBet);
    }

    /**
     * @dev query the mininum betting amount
     */
    function searchMinBet() public view virtual override returns (uint256 minBet) {
        return _minBet;
    }

    /**
     * @dev Preprocessing function before bet starts
     */
    function _beforeStartBetWhichlGames(uint256 round, uint256 which) internal virtual {}

    /**
     * @dev After certain result set, call in the prize result before the game ends
     */
    function _beforeEndWhichlGames(uint256 round, uint256 which) internal virtual {}

    /**
     * @dev calculate the money amount
     */
    function _countMoney(uint256 round, uint256 which, bool isInval) internal virtual {
        if (isInval == false) {
            _gameRoundInfo.roundGameMap[round].gameMap[which].tax = _gameRoundInfo.roundGameMap[round].gameMap[which].gamePool * _taxRatio / MAX_RATIO;
            _gameRoundInfo.roundGameMap[round].gameMap[which].takeTaxGamePool = _gameRoundInfo.roundGameMap[round].gameMap[which].gamePool - _gameRoundInfo.roundGameMap[round].gameMap[which].tax;
            _allTaxPool += _gameRoundInfo.roundGameMap[round].gameMap[which].tax;
            _cumulativeTaxPool += _gameRoundInfo.roundGameMap[round].gameMap[which].tax;
            _allTakeTaxPool = _allPool - _allTaxPool;
        } else {
            _gameRoundInfo.roundGameMap[round].gameMap[which].takeTaxGamePool = _gameRoundInfo.roundGameMap[round].gameMap[which].gamePool;
        }
    }

    /**
     * @dev calculate the rounds
     */
    function _setRound(uint256 round) internal view virtual returns (uint256 currentRound) {
        if (round == CURRENT_ROUND) {
            if (_gameRoundInfo.roundNum > 0) {
                return _gameRoundInfo.roundNum - 1;
            } else {
                return INIT_ROUND;
            }
        } else if (round == NEXT_ROUND) {
            return _gameRoundInfo.roundNum;
        }
        return round;
    }

    /**
     * @dev Start new round and set how many matches in this round
     */
    function _startNewRound(uint256 round, uint256 few) internal virtual onlyOwner returns (uint256 currentRound) {
        round = _setRound(round);
        require(round == _gameRoundInfo.roundNum, "BaseFunction: _startNewRound Illegal round");
        _gameRoundInfo.roundNum++;
        _gameRoundInfo.roundGameMap[round].gameNum = few;

        for (uint256 i = 0; i < few; ++i) {
            _gameRoundInfo.roundGameMap[round].gameMap[i].result = GAME_RESULT_NOT;
        }

        return _gameRoundInfo.roundNum;
    }
}

// File: contracts/bet/RatioScore.sol



pragma solidity ^0.8.7;



contract RatioScore is BaseFunction, IRatioScore {
    struct PointInfo {
        mapping(uint256 => uint256) point; // let the ball
    }

    struct PointOnceRoundInfo {
        mapping(uint256 => PointInfo) pointMap;
    }

    struct PointRoundInfo {
        mapping(uint256 => PointOnceRoundInfo) roundPointMap;
    }

    PointRoundInfo internal _pointRoundInfo;

    uint256 constant NORMAL_RESULT_NUM = 3; // betting the most goals team，normally there's only 2 team competing，so only 3 results， Team A wins，Team B wins，even，If there are 3 teams，so there will be 4 results

    /**
     * @dev start a new round, a new round includes few matches(if force is true, means force to open next round, even this round did not end ) 
     */
    function startNewRound(uint256 few, bool force) public virtual override onlyOwner {
        if (force == false) {
            uint256[] memory state = searchGameState(CURRENT_ROUND);
            for (uint256 i = 0; i < state.length; ++i) {
                require(state[i] == GAME_STATE_END || state[i] == GAME_STATE_END_INVAL, "RatioScore: startNewRound current round not end");
            }
        }

        uint256 round = _startNewRound(NEXT_ROUND, few);

        emit StartNewRound(round, few, force);
    }

    /**
     * @dev query the let the ball of which match of which round
     */
    function searchWhichGamesConced(uint256 round, uint256 which) public view virtual override returns (uint256[] memory conced) {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "RatioScore: setWhichGamesConced Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "RatioScore: setWhichGamesConced Illegal which");

        uint256 resultNum = _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum - 1;

        uint256[] memory __conced = new uint256[](resultNum);
        for (uint256 i = 0; i < resultNum; ++i) {
            __conced[i] = _pointRoundInfo.roundPointMap[round].pointMap[which].point[i];
        }

        return __conced;
    }

    /**
     * @dev Set how many results are in which match of which round(round=2**256-1 represents the current round)
     */
    function setWhichGamesResultNumber(uint256 round, uint256 which, uint256 number, uint256[] calldata ver) public virtual override onlyOwner {
        round = _setRound(round);

        require(round < _gameRoundInfo.roundNum, "RatioScore: setWhichGamesResultNumber Illegal round");
        require(which < _gameRoundInfo.roundGameMap[round].gameNum, "RatioScore: setWhichGamesResultNumber Illegal which");
        require(GAME_STATE_INIT == _gameRoundInfo.roundGameMap[round].gameMap[which].gameState, "RatioScore: setWhichGamesResultNumber gameState is not init");
        require(number >= NORMAL_RESULT_NUM, "RatioScore: setWhichGamesResultNumber number is not >= NORMAL_RESULT_NUM");
        require((number - 1) == ver.length, "RatioScore: setWhichGamesResultNumber number - 1 is not == ver.length");

        _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum = number;

        for (uint256 i = 0; i < ver.length; ++i) {
            _pointRoundInfo.roundPointMap[round].pointMap[which].point[i] = ver[i];
        }

        emit SetWhichGamesResultNumber(round, which, number, ver);
    }

    /**
     * @dev Start a new round and set how many matches in it
     */
    function _startNewRound(uint256 round, uint256 few) internal virtual override onlyOwner returns (uint256 currentRound) {
        round = _setRound(round);
        
        require(round == _gameRoundInfo.roundNum, "RatioScore: _startNewRound Illegal round");
        _gameRoundInfo.roundNum++;
        _gameRoundInfo.roundGameMap[round].gameNum = few;

        for (uint256 i = 0; i < few; ++i) {
            _gameRoundInfo.roundGameMap[round].gameMap[i].resultNum = NORMAL_RESULT_NUM;
            _gameRoundInfo.roundGameMap[round].gameMap[i].result = GAME_RESULT_NOT;
        }

        return _gameRoundInfo.roundNum;
    }

    /**
     * @dev after set the certain result, call in the prize result before the game ends
     */
    function _beforeEndWhichlGames(uint256 round, uint256 which) internal virtual override {
        super._beforeEndWhichlGames(round, which);

        require(_gameRoundInfo.roundGameMap[round].gameMap[which].resultList.length == (_gameRoundInfo.roundGameMap[round].gameMap[which].resultNum - 1), 
            "RatioScore: _beforeEndWhichlGames resultList.length is error"); // minus one is because that the last result is to divde the money equally to users，so the teams number=result numbers -1

        bool maxEqual = false;
        uint256 maxScore = 0;
        uint256 score = 0;
        _gameRoundInfo.roundGameMap[round].gameMap[which].result = 0;
        for (uint256 i = 0; i < (_gameRoundInfo.roundGameMap[round].gameMap[which].resultNum - 1); ++i) {
            score = _gameRoundInfo.roundGameMap[round].gameMap[which].resultList[i] + _pointRoundInfo.roundPointMap[round].pointMap[which].point[i];
            if (maxScore == score) {
                maxEqual = true;
            } else if (maxScore < score) {
                _gameRoundInfo.roundGameMap[round].gameMap[which].result = i;
                maxEqual = false;
                maxScore = score;
            }
        }

        if (maxEqual == true) {
            _gameRoundInfo.roundGameMap[round].gameMap[which].result = _gameRoundInfo.roundGameMap[round].gameMap[which].resultNum - 1;
            emit TieScore(maxEqual);
        }
    }
}