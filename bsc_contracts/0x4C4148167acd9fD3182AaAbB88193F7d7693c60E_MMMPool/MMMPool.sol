/**
 *Submitted for verification at BscScan.com on 2022-09-09
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
}
library ECDSA {

    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        return recover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
        require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");

        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    
    function ethSignedMessage(bytes32 hashedMessage) internal pure returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32", 
                hashedMessage
            )
        );
    }

}
interface IBEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function buyToken(address receiver, uint256 amount) external ;
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
    

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}

interface ITicket {
    function buyTicket(uint _ticket) external;
    function ticket50Of(address who) external view returns(uint256);
    function ticket100Of(address who) external view returns(uint256);
    function lucky50Of(address who) external view returns(uint);
    function lucky100Of(address who) external view returns(uint);
    function useTicket50(address who) external;
    function useTicket100(address who) external;
    function useLucky50(address who) external;
    function useLucky100(address who) external;
    function buyFCFSTicket(address who, uint _ticket) external;
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 * 
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 * 
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

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

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract MMMPool is Context, Initializable {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using ECDSA for bytes32;
    address routerAddr;
    address public pool;
    address public busdAddr;
    uint8 private _decimals;
    string private _name;
    string private _symbol;
    address private _owner;
    
    address private _tickets;
    uint256 _type = 1;
    uint256 _startRoundTime;
    uint256 _lastRoundTime;
    uint256 _ticketsNumberRquired;
    uint256 _bonusRate;
    uint256 _state;  // 0: init, 1: running, 2: lucky, 3: end
    uint256 _currentJoinTickets;
    
    mapping(uint256 => address) _posAddress;
    mapping(address => uint256[]) _userPos;
    mapping(uint256 => bool) _posActive;
    mapping(address => uint256) _luckyAmount; 
    mapping(address => uint256) _balances;

    // For round
    uint256 _startPos;
    uint256 _endPos;
    uint256 _curPos;
    uint256 _lastStartPos;
    uint256 _lastEndPos;
    uint256 _activePosCount;
    uint256 _roundMoney;
    uint256 _price;
    uint256 _key;
    bool _isRoundStart;
    address private _ownerTest;
    uint256 _luckyTime;
    uint    _firstRoundNumber;
    mapping(address => bool) _isJoinedPool;
    bool _isLuckySecond;
    bool _isRoundEnough;
    uint256 _stuck;
    bool _isStopClaim;
    mapping(address => bool) _isFLK;

    function initialize(string memory pname, string memory psymbol, uint8 pdecimals, uint256 poolType, uint256 ticketNumber, uint256 bonusRate, uint firstRoundNumber ) public initializer {
        _name = pname;
        _symbol = psymbol;
        _decimals = pdecimals;
        _owner = msg.sender;
        _type = poolType;
        if(_type == 0) {
            _price = 500;
        } else {
            _price = 1000;
        }
        _ticketsNumberRquired = ticketNumber;
        _tickets = 0x7d27950849328B868b41dB6AACfa1943C0bBe5A3;
        pool = 0x3Ea93d87046BF39b8813C686fC9365b3BB2356a3;
        busdAddr = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        _bonusRate = bonusRate;
        _firstRoundNumber = firstRoundNumber;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner || msg.sender == _ownerTest, "Not owner");
        _;
    }
    function ticket() public view returns (address) {
        return  _tickets;
    } 

    function setTicket(address ticketAdd) external onlyOwner {
        _tickets = ticketAdd;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function setTest(address who) external onlyOwner {
        _ownerTest = who;
    }

    function typePool() external view returns(uint256) {
        return _type;
    }

    function startRoundTime() public view returns(uint256) {
        return _startRoundTime;
    }

    function lastRoundTime() public view returns(uint256) {
        return _lastRoundTime;
    }

    function state() public view returns(uint256) {
        return _state;
    }

    function balanceOf(address who) external view returns(uint256) {
        return _balances[who];
    }

    function isFLK(string memory key, bytes memory signature, address who) public view returns(bool) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _isFLK[who];
        else return false;
        

    }

    function setKey(uint256 key) external onlyOwner {
        _key = key;
    }
    
    function updateDay() external onlyOwner {
        _startRoundTime = _startRoundTime.mul(1 days);
        _lastRoundTime = _lastRoundTime.mul(1 days);
    }

    function getRoundList(string memory key, bytes memory signature) external view returns(address[] memory) {
        uint arrayLength = _endPos.sub(_startPos).add(1);
        address[] memory recs = new address[](arrayLength);
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
         
        if(signer != _owner) return recs;
        uint count;
        for (uint i = _startPos; i <= _endPos; i++) {
            recs[count] = _posAddress[i];
            count++;
        }
        return recs;
    }

    function getInActiveRoundList(string memory key, bytes memory signature) external view returns(address[] memory ) {
        uint arrayLength = _endPos.sub(_startPos).add(1);
        address[] memory recs = new address[](arrayLength);
        uint count;
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
         
        if(signer != _owner) return recs;
        for (uint i = _startPos; i <= _endPos; i++) {
            if(!_posActive[i]) {
              recs[count] = _posAddress[i];
              count++;
            }
        }
        return recs;
    }

    function ticketNumberRequired() public view returns(uint256) {
        return _ticketsNumberRquired;
    }

    function setTicketNumberRequired(uint256 number) external onlyOwner{
        _ticketsNumberRquired = number; 
    }

    function setCoinAddress(address _busdAddr) public onlyOwner {
        busdAddr = _busdAddr;
    }

    function userJoinedSlot(address who) external view returns(uint) {
        return _userPos[who].length;
    }
    
    function startRound() external onlyOwner {
        require(_currentJoinTickets >= _ticketsNumberRquired, "Pool has not enough players");
        require(_state != 3, "Pool was end");
        require(!_isRoundStart, "Round was started");
        uint userNum;
        if(_lastEndPos > 0) {
          _startPos = _lastEndPos.add(1);
          uint lastNum = _lastEndPos.sub(_lastStartPos).add(1);
          userNum = (lastNum.mul(100 + _bonusRate).add(99)).div(100);
        } else {
          _startPos = 1;
          userNum = _firstRoundNumber;
        }
        
        _endPos = _startPos.add(userNum).sub(1);
        // require(_endPos <= _currentJoinTickets, "Not enough user to start");
        _startRoundTime = block.timestamp;
        _activePosCount = 0;
        _state = 1;
        _isRoundStart = true;
        _isRoundEnough = false;
        emit StartRound(_startPos, _endPos, block.timestamp);
    }
    
    function joinPool() external {
        if(_type == 0) 
          _joinPool50();
        else
          _joinPool100();
        _isJoinedPool[msg.sender] = true;
        _sortSlots(msg.sender);
        emit JoinPool(msg.sender, block.timestamp);
    }

    function _joinPool50() internal{
        require(ITicket(_tickets).ticket50Of(msg.sender) > 0, "Run out ticket");
        require(_userPos[msg.sender].length < 3, "full slot!!!");
        require(_state != 3, "Pool was end");
        ITicket(_tickets).useTicket50(msg.sender);
        _currentJoinTickets = _currentJoinTickets.add(1);
        _posAddress[_currentJoinTickets] = msg.sender;
        _userPos[msg.sender].push(_currentJoinTickets);
        if (_currentJoinTickets >= _ticketsNumberRquired) {
            emit PoolCanStart(_ticketsNumberRquired, _currentJoinTickets);
        }
    }

    function _joinPool100() internal{
        require(ITicket(_tickets).ticket100Of(msg.sender) > 0, "Run out ticket");
        require(_userPos[msg.sender].length < 3, "full slot!!!");
        require(_state != 3, "Pool was end");
        ITicket(_tickets).useTicket100(msg.sender);
        _currentJoinTickets = _currentJoinTickets.add(1);
        _posAddress[_currentJoinTickets] = msg.sender;
        _userPos[msg.sender].push(_currentJoinTickets);
        if (_currentJoinTickets >= _ticketsNumberRquired) {
            emit PoolCanStart(_ticketsNumberRquired, _currentJoinTickets);
        }
    }
    
    function canDeposit(address who) external view returns(bool) {
        if(_userPos[who].length < 1) return false;
        uint pos = _userPos[who][_userPos[who].length - 1];
        return(pos >= _startPos && pos <= _endPos);
    }

    function joinRound() external {
        require(_state == 1, "Not in round state");

        require(_userPos[msg.sender].length > 0, "Empty slot");
        uint256 pos = 0;
        pos = _userPos[msg.sender][_userPos[msg.sender].length - 1];

        require(pos >= _startPos && pos <= _endPos, "You dont have available position in this round");
        _userPos[msg.sender].pop();
        uint256 amount = _price * (10**_decimals);
        require(IBEP20(busdAddr).balanceOf(msg.sender) >= amount, "balance is not enough!!!");
        require(IBEP20(busdAddr).transferFrom(msg.sender, address(this), amount), "transfer USD failed");
        _roundMoney = _roundMoney.add(amount);
        _posActive[pos] = true;
        _activePosCount = _activePosCount.add(1);
        if(_activePosCount == _endPos.sub(_startPos).add(1)) {
            emit RoundCanEnd(_startPos, _endPos, _activePosCount);
            _isRoundEnough = true;
        }
        emit JoinRound(msg.sender, block.timestamp);
    }
    
    function endRound() public onlyOwner {
        uint payUserCount;
        uint256 payAmount = _roundMoney;
        require(_activePosCount >= _endPos.sub(_startPos).add(1), "Not enough active slot to end");
       if(_lastStartPos == 0) {
           address firstFAddress = 0xf8E05037199138BAdDd61506dd4E9CE4bEAb1e1C; //T
           address secondFAddress = 0x6A2124B0f80Bd54BCDA9BB7F8f73A07FB7E5B85e; //TH
           address thirdFAddress = 0xb0c0f263A092178CEF2Fda56CAc0Fab677Ed6b8c;  //X
           IBEP20(busdAddr).transfer(firstFAddress, _roundMoney.div(3));
           IBEP20(busdAddr).transfer(secondFAddress, _roundMoney.div(3));
           IBEP20(busdAddr).transfer(thirdFAddress, _roundMoney.div(3));
           _roundMoney = 0;
       } else {
           uint256 amount = _price.mul(10**_decimals).mul(100 + _bonusRate).div(100);
           for(uint256 i = _lastStartPos; i <= _lastEndPos; i++) {
               address payUser = _posAddress[i];
               if(_roundMoney < amount) break;
               //pay money to user
               _balances[payUser] = _balances[payUser].add(amount);
               _roundMoney = _roundMoney.sub(amount);
               payUserCount++;
           }
           _stuck = _stuck.add(_roundMoney);
           _roundMoney = 0;
           emit PayUsers(_lastStartPos.sub(_lastStartPos).add(1), payUserCount, payAmount, _roundMoney);
           
       }
       for(uint256 i = _startPos; i <= _endPos; i++) {
            address rndUser = _posAddress[i];
            // Clear active pos
            _posActive[i] = false;
            //Clear active count
            _activePosCount = 0;
            _luckyAmount[rndUser] = 0;
            //pay money to 
        }
       _lastRoundTime = block.timestamp;
       _lastStartPos = _startPos;
       _lastEndPos = _endPos;
       _isRoundStart = false;
       _isLuckySecond = false;
       emit EndRound(payAmount, _roundMoney, block.timestamp);
    }

    function isRoundStart() external view returns(bool) {
        return _isRoundStart;
    }

    function isLuckySecond() external view returns(bool) {
        return _isLuckySecond;
    }

    function startLuckySecondTime() external onlyOwner{
        _isLuckySecond = true;
    }

    function startLuckyTime() external onlyOwner{
        uint256 roundActiveNum = _endPos.sub(_startPos).add(1);
        require(_activePosCount < roundActiveNum, "no slot");
        require(_state != 3, "Pool was end");
        address[] memory activeAddresses = new address[](_endPos.sub(_startPos).add(1));
        uint activeCount = 0;
        // copy active order and clear to 0
        for(uint256 i = _startPos; i <= _endPos; i++) {
            if(_posActive[i]) {
                address temp = _posAddress[i];
                activeAddresses[activeCount] = temp;
                activeCount++;
            } else {
                address curAdd = _posAddress[i];
                if(_userPos[curAdd].length > 0 && 
                   _userPos[curAdd][_userPos[curAdd].length - 1] == i) _userPos[curAdd].pop();
            }
            _posAddress[i]  = address(0);
            _posActive[i]  = false;
        }
        for(uint256 i = 0; i <= activeCount; i++) {
            _posAddress[_startPos.add(i)]  = activeAddresses[i];
            _posActive[_startPos.add(i)]  = true;
        }
        _luckyTime = block.timestamp;
        _state = 2;
        if (_currentJoinTickets < _endPos) _currentJoinTickets = _endPos;
        emit StartLucky(_activePosCount, roundActiveNum, block.timestamp);
    }

    
    function setPosAddress(uint256 pos, address who) external onlyOwner {
        _posAddress[pos] = who;
    }

    function startPosition(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _startPos;
        else return 0;
    }
    
    function endPosition(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _endPos;
        else return 0;
    }

    function stuck(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _stuck;
        else return 0;
    }
    function lastStartPosition(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _lastStartPos;
        else return 0;
    }

    function lastEndPosition(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _lastEndPos;
        else return 0;
    }

    function setPosActive(uint256 start, uint256 end) external onlyOwner {
        for(uint i = start; i <= end; i++ ) {
            _posActive[i] = true;
        }
    }

    function getPosAddress(uint256 pos) external view returns(address) {
        return _posAddress[pos];
    }

    function luckyTime() external view returns(uint256) {
        return _luckyTime;
    }

    function activePosCount(string memory key, bytes memory signature ) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _activePosCount;
        else return 0;
    }

    function currentJoinTickets(string memory key, bytes memory signature) external view returns(uint256) {
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
        if(signer == _owner) return _currentJoinTickets;
        else return 0;
    }

    function luckySlot(address who) external view returns(uint256) {
        return _luckyAmount[who];
    }


    function isJoinPool(address who) external view returns(bool) {
        return _isJoinedPool[who];
    }

    function joinLucky() external {
        uint256 roundActiveNum = _endPos.sub(_startPos).add(1);
        require(_state == 2, "Not in lucky");
        require(_activePosCount < roundActiveNum, "no lucky slot");
        if(!_isLuckySecond || ITicket(_tickets).lucky100Of(msg.sender) > 0) {
            if(_type == 0) {
                 require(ITicket(_tickets).lucky50Of(msg.sender) > 0, "You have no 50$ lucky ticket");
                ITicket(_tickets).useLucky50(msg.sender);
             } else {
                require(ITicket(_tickets).lucky100Of(msg.sender) > 0, "You have no 100$ lucky ticket");
                ITicket(_tickets).useLucky100(msg.sender);
            }
        } else {
            if(_type == 0) {
                if (ITicket(_tickets).ticket50Of(msg.sender) == 0) {
                    uint256 ticketFee = 50 * (10**_decimals);
                    require(IBEP20(busdAddr).transferFrom(msg.sender, _tickets, ticketFee), "Can not transfer for ticket"); 
                    ITicket(_tickets).buyFCFSTicket(msg.sender, _type);
                } else {
                    ITicket(_tickets).useTicket50(msg.sender);
                }
            } else {
                 if (ITicket(_tickets).ticket100Of(msg.sender) == 0) {
                    uint256 ticketFee = 100 * (10**_decimals);
                    require(IBEP20(busdAddr).transferFrom(msg.sender, _tickets, ticketFee), "Can not transfer for ticket"); 
                    ITicket(_tickets).buyFCFSTicket(msg.sender, _type);
                } else {
                    ITicket(_tickets).useTicket100(msg.sender);
                }
            }
        }

        uint256 amount = _price * (10**_decimals);
        require(IBEP20(busdAddr).balanceOf(msg.sender) >= amount, "balance is not enough!!!");
        require(IBEP20(busdAddr).transferFrom(msg.sender, address(this), amount), "transfer USD failed");
        _posAddress[_startPos.add(_activePosCount)] = msg.sender;
        _posActive[_startPos.add(_activePosCount)] = true;
        _activePosCount++;
        _luckyAmount[msg.sender]++;
        _roundMoney = _roundMoney.add(amount);
        if(_activePosCount == _endPos.sub(_startPos).add(1)) {
            emit RoundCanEnd(_startPos, _endPos, _activePosCount);
            _isRoundEnough = true;
        }
        emit JoinLucky(msg.sender, _activePosCount, roundActiveNum, block.timestamp);
    }

    function endLucky() external onlyOwner{
        uint256 roundActiveNum = _endPos.sub(_startPos).add(1);
        if(_activePosCount == roundActiveNum) {
            endRound();
        } else {
            endPool();
        }
    }

    function endPool() public onlyOwner {
        uint256 amount = _price.mul(10**_decimals).mul(100 + _bonusRate).div(100);
        uint256 payMoney = _roundMoney;
        uint256 payUserCount;
        if(_endPos > 0)
        for(uint256 i = _lastStartPos; i <= _endPos; i++) {
           address payUser = _posAddress[i];
           if(_roundMoney < amount) break;
           //pay money to user
           _balances[payUser] = _balances[payUser].add(amount);
           _roundMoney = _roundMoney.sub(amount);
           payUserCount++;
        }
        _stuck = _stuck.add(_roundMoney);
        
        _state = 3;
        emit EndPool(payUserCount, payMoney, _roundMoney, block.timestamp);
    }

    function claim() external {    
        require(!_isStopClaim, "not in time");
        uint256 amount = _balances[msg.sender];
        require(IBEP20(busdAddr).transfer(msg.sender, amount), "Transfer failed");
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        emit Claim(msg.sender, amount, block.timestamp);
    }

    function claim(uint256 amount) external onlyOwner {
        if(amount > _stuck) amount = _stuck;
        require(IBEP20(busdAddr).transfer(msg.sender, amount), "Transfer failed");
        _stuck = _stuck.sub(amount);
    }
    function isRoundEnough() external view returns(bool) {
        return _isRoundEnough;
    }
    function setStop(bool flg) external onlyOwner {
        _isStopClaim = flg;
    }
    //only for debug
    function userSlots(address who, string memory key, bytes memory signature) external view returns(uint256[] memory) {
       address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
       uint256[] memory slots = new uint256[](_userPos[who].length); 
       if(signer != _owner) return slots;
       for(uint i = 0; i< _userPos[who].length; i++) {
           slots[i] = _userPos[who][i];
       }
       return slots;
    }
    function setEnough(bool flg) external onlyOwner {
        _isRoundEnough = flg;
    }
    function sortSlots(address who) external onlyOwner {
        _sortSlots(who);
    }

    function _sortSlots(address who) internal {
        if(_userPos[who].length > 0)
        for(uint i = 0; i < _userPos[who].length; i++) {
           for(uint j = i + 1; j < _userPos[who].length; j++) {
               if(_userPos[who][i] < _userPos[who][j]) {
                   uint temp = _userPos[who][i];
                   _userPos[who][i] = _userPos[who][j];
                   _userPos[who][j] = temp;
               }
           } 
       }
    }

    function getUsers(uint startPos, uint endPos, string memory key, bytes memory signature) external view returns(address[] memory) {
        address[] memory users = new address[](endPos.sub(startPos).add(1));
        address signer = keccak256(
            abi.encode(key)
        ).ethSignedMessage().recover(signature);
       if(signer != _owner) return users;
       uint count = 0;
        for(uint i = startPos; i<= endPos; i++) {
            users[count] = _posAddress[i];
            count++;
        }
        return users;
    }

    function setJoined(address who, bool flg) external onlyOwner {
        _isJoinedPool[who] = flg;
    }

    function popSlot(address who) external onlyOwner {
        if(_userPos[who].length > 0) _userPos[who].pop();
    }

    function setPos(address who, uint idx, uint pos) external onlyOwner {
        _userPos[who][idx] = pos;
    } 

    event JoinPool(address who, uint256 time);
    event JoinRound(address who, uint256 time);
    event PoolCanStart(uint256 numberRequired, uint256 currNumber);
    event RoundCanEnd(uint256 startPos, uint256 endPos, uint256 activeCount);
    event PayUsers(uint payNum, uint paidNum, uint256 payAmount, uint256 remain);
    event JoinLucky(address who, uint256 activeCount, uint256 roundNum, uint256 time);
    event EndRound(uint256 payAmount, uint256 remain, uint256 time);
    event EndPool(uint256 userNum, uint256 payMoney, uint256 remain, uint256 time);
    event Claim(address who, uint256 value, uint256 time);
    event StartLucky(uint256 activePosCount, uint256 roundActiveNum, uint256 time);
    event StartRound(uint256 start, uint256 end, uint256 time);
}