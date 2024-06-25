/**
 *Submitted for verification at BscScan.com on 2023-01-06
*/

pragma solidity 0.5.16;

  interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function burn(uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
  }

  interface Ig {
    function inDAO(address a) external view returns (bool);
  }

  interface IOracle {
    function getCurrentPrice() external view returns (uint256);
  }


  contract Context {
    constructor () internal { 
    }

    function _msgSender() internal view returns (address payable) {
      return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
      this; 
      return msg.data;
    }
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

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b > 0, errorMessage);
      uint256 c = a / b;
      return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
      return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b != 0, errorMessage);
      return a % b;
    }
  }

  contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
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

    function renounceOwnership() public onlyOwner {
      emit OwnershipTransferred(_owner, address(0));
      _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
      _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
      require(newOwner != address(0), "Ownable: new owner is the zero address");
      emit OwnershipTransferred(_owner, newOwner);
      _owner = newOwner;
    }
  }

  contract MyCoin is Context, IBEP20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) public userGain;
    mapping (address => uint256) private _balances;
    mapping (address => uint256) private entry;
    mapping (address => bool) public excluded;  
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 private fee = 0;
    uint256 private prevPrice = 1;
    uint256 private timeStamp = now;
    uint256 private globalLoss = 10000000;
    uint256 private globalGain = 10000000;
    uint256 private lastUpdate = now;
    uint256 private w = 14000;
    uint256 private v = 5;
    uint256 private l = 100000;
    uint8 private a = 80;
    uint8 private transferFee = 5;  
    uint8 private _decimals;
    string private _symbol;
    string private _name;
    bool private paused = false;
    bool private subtractFee = true;

    Ig public gCoin;
    IBEP20 public xgCoin;
    IOracle private myOracle;
    
    constructor() public {
      _name = "MyCoin";
      _symbol = "COIN";
      _decimals = 18;
      _totalSupply = 10000000000000000000000;
      _balances[_msgSender()] = _totalSupply;
      excludeAddr(address(this), true);
      excludeAddr(_msgSender(), true);
      entry[_msgSender()] = now;
      emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function getOwner() external view returns (address) {
      return owner();
    }

    function decimals() external view returns (uint8) {
      return _decimals;
    }

    function symbol() external view returns (string memory) {
      return _symbol;
    }

    function name() external view returns (string memory) {
      return _name;
    }

    function excludeAddr(address account, bool setting) public onlyOwner {
      excluded[account] = setting;
    }

    function emergencyStop(bool _p) public onlyOwner {
      paused = _p;
    }
    
    function init() public onlyOwner {
      prevPrice = getCurrentPrice();
      timeStamp = now;    
    }

    function setFees(uint8 _transferFee, uint8 _fee, bool _subtractFee) public onlyOwner {
      require(_transferFee <= 100);
      transferFee = _transferFee;
      fee = _fee;
      subtractFee = _subtractFee;
    }

    function settings(uint256 _l, uint256 _w, uint8 _a, uint256 _v) public onlyOwner {
      require(_a < 200);
      require(v > 0);
      require(w > 1000);
      require(l > 1000);
      l = _l;
      w = _w;
      a = _a;
      v = _v;
    }

    function totalSupply() external view returns (uint256) {
      return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
      return getNewBalance(account);
    }
    
    function getFee(address account) public view returns (uint256) {
      uint256 _fee = _balances[account] * (now - entry[account]) * fee / 100000000000000;
      if(fee > _balances[account] / 2) _fee = _balances[account] / 2;
      if(inDao(account)) {
        if(subtractFee) { 
          _fee = _fee / 10;
        } else {
          _fee = _fee * 15 / 10;
        }
      }
      return _fee;
    }
    
    function initContracts(address a1, address a2, address a3) public onlyOwner {
      myOracle = IOracle(a1);
      gCoin = Ig(a2);
      xgCoin = IBEP20(a3);
    }

    function currentBalance(address account) external view returns (uint256) {
      return _balances[account];
    }

    function inDao(address account) public view returns (bool) {
      return gCoin.inDAO(account);
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
      _transfer(_msgSender(), recipient, amount);
      return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
      return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
      _approve(_msgSender(), spender, amount);
      return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
      _transfer(sender, recipient, amount);
      if(recipient != address(xgCoin)) {
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
      }
      return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
      return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
      return true;
    }

    function getCurrentPrice() public view returns (uint256) {
      return myOracle.getCurrentPrice() * 10000000000;
    }

    function getNewBalance(address account) internal view returns (uint256) {
      if(userGain[account] == 0) return _balances[account];
      if(!excluded[account] && !paused) {
        uint256 b = _balances[account] * getGain() / userGain[account];
        uint256 _fee = getFee(account); 
        if(subtractFee) {
          return b - _fee;
        } else {
          return b + _fee;
        }
      }
      return _balances[account];
    }

    function getVars() internal view returns (uint256,uint256,uint256,uint256) {
      uint256 c = getCurrentPrice();
      uint256 x = c ** 2 / prevPrice;
      uint256 s = x * (now - timeStamp) * w / 1000000000000;
      uint256 r = x - s;
      return (c, x, s, r);
    }
    
    function getGain() internal view returns (uint256) {
      uint256 R = getR();
      uint256 c = R + globalGain - globalLoss;
      return (R > c) ? c + nextIncrease(R) : c - nextDecrease(R);
    }

    function getR() public view returns (uint256) {
      (uint256 c, uint256 x, uint256 s, uint256 r) = getVars();
      uint256 R = (s > x || r < c) ? c : r;
      return (c * v + R * a / 100) / (v + 1);
    }

    function nextDecrease(uint256 R) internal view returns (uint256) {
      uint256 ratio = (globalLoss * 2 / globalGain);
      uint256 c = getCurrentPrice();
      if(R > c) return 0;
      if(ratio > 4) {
        ratio = ratio ** 2;
        if(ratio > 100000) return 0;
      }
      return (c - R) * (now - lastUpdate) * l / (10000000000000 * ratio);
    }

    function nextIncrease(uint256 R) internal view returns (uint256) {
      uint256 ratio = 1;
      uint256 c = getCurrentPrice();
      if(c > R) return 0;
      if(ratio > 4) {
        ratio = ratio ** 2;
        if(ratio > 100000) return 0;
      }
      return (R - c) * (now - lastUpdate) * l / (10000000000000 * ratio);
    }

    function update() public {
      (uint256 c, uint256 x, uint256 s, uint256 r) = getVars();

      if(s > x || r < c) {
        prevPrice = c;
        timeStamp = now;
      } 
      
      uint256 R = getR();

      if(R > c) {
        globalGain += nextIncrease(R);
      } else {
        globalLoss += nextDecrease(R);
      }
      
      if(globalLoss > getCurrentPrice() + globalGain) {
        emergencyStop(true);
      }

      lastUpdate = now;
    }

    function mint(uint256 _amount) public {
      require(_amount > 0);
      calcBalanceAndUpdate(_msgSender());
      uint256 balanceBefore = xgCoin.balanceOf(address(this));
      xgCoin.transferFrom(_msgSender(), address(this), _amount);
      uint256 balanceAfter = xgCoin.balanceOf(address(this));
      uint256 diff = SafeMath.sub(balanceAfter, balanceBefore);
      require(diff > 0); 
      uint256 amount2 = diff * (1000 - transferFee) / 1000;
      _mint(_msgSender(), amount2 );
      xgCoin.burn(balanceAfter);
    }

    function calcBalanceAndUpdate(address account) public {
      update();
      calcBalance(account);
    }

    function calcBalance(address account) internal {
      uint256 newBalance = getNewBalance(account);
      if(newBalance > _balances[account]) {
        _totalSupply.add(newBalance - _balances[account]);
      } else {
        _totalSupply.sub(_balances[account] - newBalance);
      }
      _balances[account] = newBalance;
      userGain[account] = getGain();
      entry[account] = now;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
      require(sender != address(0), "BEP20: transfer from the zero address");
      require(recipient != address(0), "BEP20: transfer to the zero address");
      require(!paused);
      update();

      if(!excluded[sender]) {
        calcBalance(sender);
      }

      if(!excluded[recipient]) {
        calcBalance(recipient);
      }
      
      uint256 _fee = amount * transferFee / 1000;
      _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
      _balances[recipient] = _balances[recipient].add(amount);

      if(!excluded[recipient] && !paused) {
        require(_balances[recipient] > _fee);
        _burn(recipient, _fee);
      }
      
      emit Transfer(sender, recipient, amount);
    }

    function _burn(address account, uint256 amount) internal {
      require(account != address(0), "BEP20: burn from the zero address");
      if(amount > 0) {
        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
      }
    }

    function burn(uint256 amount) public returns (bool) {
      _burn(_msgSender(), amount);
      return true;
    }

    function _mint(address account, uint256 amount) internal {
      require(account != address(0), "BEP20: mint to the zero address");
      _totalSupply = _totalSupply.add(amount);
      _balances[account] = _balances[account].add(amount);
      emit Transfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
      require(owner != address(0), "BEP20: approve from the zero address");
      require(spender != address(0), "BEP20: approve to the zero address");
      _allowances[owner][spender] = amount;
      emit Approval(owner, spender, amount);
    }

    function getGlobals() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
      uint256 R = getR();
      return (getCurrentPrice(), getGain(), prevPrice, transferFee, globalLoss, globalGain, w, l, nextDecrease(R), nextIncrease(R), v);
    }

    function getUser(address _a) external view returns (uint256, uint256, uint256) {
      return (_balances[_a], userGain[_a], excluded[_a] ? 1 : 0 );
    }

  }