/**
 *Submitted for verification at BscScan.com on 2023-01-06
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

interface Erc20Token {
    function totalSupply() external view returns (uint256);

    function balanceOf(address _who) external view returns (uint256);

    function transfer(address _to, uint256 _value) external;

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external;

    function approve(address _spender, uint256 _value) external;

    function burnFrom(address _from, uint256 _value) external;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Sale {
    uint256 private constant ONE_Month = 60 * 60 * 24 * 30;
    uint256 private constant LockWarehouse = 10000;
    address public Uaddress;
    using SafeMath for uint256;
    Erc20Token internal constant _USDTAddr =
        Erc20Token(0x55d398326f99059fF775485246999027B3197955);
    Erc20Token internal constant _DOTCAddr =
        Erc20Token(0x81495eDABD3531eE3e7b06A67F6563E7dAC081d9);
    mapping(address => uint256) public _playerAddrMap;
    uint256 public _playerCount;
    uint256 public nodeTime = 100000000000;
    address[] public node;
    uint256 public maxNodeLength = 500;
    bool public _LOCK = false;
    bool public _nodeLOCK = false;
    uint256 public nodePrice = 30000 * (10**18);
    address _owner;
    address _nodeDividendOwner;

    mapping(uint256 => Player) public _playerMap;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Permission denied");
        _;
    }

    modifier onlyPermission() {
        require(msg.sender == _owner || msg.sender == _nodeDividendOwner, "Permission denied");
        _;
    }

    modifier isRealPlayer() {
        uint256 id = _playerAddrMap[msg.sender];
        require(id > 0, "userDoesNotExist");
        _;
    }

    modifier isLOCK() {
        require(_LOCK, "islock");
        _;
    }

    function nodeLOCK(bool LOCK) public onlyOwner {
        _nodeLOCK = LOCK;
    }

    function stop(bool LOCK) public onlyOwner {
        _LOCK = LOCK;
    }

    function setUaddressship(address newaddress) public onlyOwner {
        require(newaddress != address(0));
        Uaddress = newaddress;
    }

    function setMaxNodeLength(uint256 _l) public onlyOwner {
        maxNodeLength = _l;
    }

    function setNodePrice(uint256 _price) public onlyOwner {
        nodePrice = _price * (10**18);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        _owner = newOwner;
    }

    function transferNodeDividendOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        _nodeDividendOwner = newOwner;
    }

    struct Player {
        uint256 id;
        address addr;
        uint256 investTime;
        uint256 Available;
        uint256 LockWarehouse;
    }

    constructor() {
        _owner = msg.sender;
        _nodeDividendOwner = msg.sender;
    }

    function registry(address playerAddr) internal {
        uint256 id = _playerAddrMap[playerAddr];
        require(id == 0, "nodeAlreadyExists");
        require(node.length <= maxNodeLength, "NodeSoldOut");
        _playerCount++;
        _playerAddrMap[playerAddr] = _playerCount;
        _playerMap[_playerCount].id = _playerCount;
        _playerMap[_playerCount].addr = playerAddr;
        _playerMap[_playerCount].investTime = block.timestamp;
        _playerMap[_playerCount].LockWarehouse = LockWarehouse;
        node.push(playerAddr);
    }

    function buyNode() public payable {
        require(block.timestamp > nodeTime, "83791");
        require(_nodeLOCK, "isnodeLOCK");
        uint256 _usdtBalance = _USDTAddr.balanceOf(msg.sender);
        require(_usdtBalance >= nodePrice, "9999");
        _USDTAddr.transferFrom(msg.sender, address(Uaddress), nodePrice);
        registry(msg.sender);
    }

    function settleStatic() external isRealPlayer {
        uint256 id = _playerAddrMap[msg.sender];
        uint256 difTime = block.timestamp.sub(_playerMap[id].investTime);
        uint256 dif = difTime.div(ONE_Month).mul(1000000000000000000000);
        require(dif > 1000000000000000000000, "ThereAreNoONE_MonthToSettle");

        if (dif > _playerMap[_playerCount].LockWarehouse) {
            _USDTAddr.transfer(
                msg.sender,
                _playerMap[_playerCount].LockWarehouse
            );
            _playerMap[_playerCount].LockWarehouse = 0;
        } else {
            _USDTAddr.transfer(msg.sender, dif);
            _playerMap[_playerCount].LockWarehouse = _playerMap[_playerCount]
                .LockWarehouse
                .sub(dif);
        }
        _playerMap[id].investTime = block.timestamp;
    }

    // 节点分红
    function nodeDividend(uint256 amount) public onlyPermission {
        for (uint256 i = 0; i < node.length; i++) {
            _DOTCAddr.transfer(node[i], amount);
        }
    }
}