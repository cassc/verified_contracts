/*
//.............................................................................
//....SSSSSS....TTTTTTTTT.....OOOOOO......NN......N....EEEEEEEE....DDDD........
//...SSSSSSSS..STTTTTTTTTT..OOOOOOOOO...ONNNN...NNNN..EEEEEEEEEE..DDDDDDDDD....
//..SSSSSSSSSS.STTTTTTTTTT.OOOOOOOOOOO..ONNNNN..NNNN..EEEEEEEEEE..DDDDDDDDDD...
//..SSSSSSSSSS.STTTTTTTTTT.OOOOOOOOOOOO.ONNNNN..NNNN..EEEEEEEEEE..DDDDDDDDDDD..
//.SSSS...SSSSS....TTTT...TOOOO....OOOO.ONNNNNN.NNNN..EEE.........DDD....DDDD..
//.SSSSSS..........TTTT...TOOO.....OOOO.ONNNNNN.NNNN..EEEEEEEEEE..DDD....DDDD..
//..SSSSSSSSS......TTTT...TOOO......OOOOONNNNNNNNNNN..EEEEEEEEEE..DDD.....DDD..
//..SSSSSSSSSS.....TTTT...TOOO......OOOOONNNNNNNNNNN..EEEEEEEEEE..DDD.....DDD..
//....SSSSSSSSS....TTTT...TOOO......OOOOONNN.NNNNNNN..EEEEEEEEEE..DDD....DDDD..
//.SSSS..SSSSSS....TTTT...TOOO.....OOOO.ONNN.NNNNNNN..EEE.........DDD....DDDD..
//.SSSS....SSSS....TTTT...TOOOO....OOOO.ONNN..NNNNNN..EEE.........DDD...DDDDD..
//.SSSSSSSSSSSS....TTTT....OOOOOOOOOOOO.ONNN...NNNNN..EEEEEEEEEEE.DDDDDDDDDDD..
//..SSSSSSSSSS.....TTTT.....OOOOOOOOOO..ONNN...NNNNN..EEEEEEEEEEE.DDDDDDDDDD...
//...SSSSSSSSS.....TTTT.....OOOOOOOOO...ONNN....NNNN..EEEEEEEEEEE.DDDDDDDDD....
//....SSSSSS..................OOOOOO...........................................
//.............................................................................

 Lets get $STONED on ETH, Ape, chill & shill...

 Website: https://www.stonederc20.xyz/
 Twitter: https://twitter.com/StonedERC20
 Telegram: https://t.me/StonedERC20
 Leaderboard: https://dapp.stonederc20.xyz/
 ENS: $stoned.eth

 Community Subdomains:
 420.$stoned.eth
 bullish.$stoned.eth
 topg.$stoned.eth
 bong.$stoned.eth
 420-0g-$baller.$stoned.eth
 lfg.$stoned.eth
 dreamcatcher.$stoned.eth
 degen.$stoned.eth
 69.$stoned.eth
 puffdaddy.$stoned.eth

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
}

contract FOURTWENTY is Context, IERC20, Ownable {
    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 420690000000 * 10 ** _decimals;
    string private constant _name = unicode"420";
    string private constant _symbol = unicode"420";

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    constructor () {
        _balances[_msgSender()] = _tTotal;
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;
        emit Transfer(from, to, amount);
    }
}