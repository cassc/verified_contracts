/**

*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Token {
  function transferFrom(
    address,
    address,
    uint256
  ) external returns (bool);

  function transfer(address, uint256) external returns (bool);
}

interface IUniswapV2Factory {
  function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );
}

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, 'SafeMath: subtraction overflow');
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
    require(c / a == b, 'SafeMath: multiplication overflow');
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, 'SafeMath: division by zero');
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
}

contract Ownable is Context {
  address private _owner;
  address private _previousOwner;

  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), 'Caller is not the owner');
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function transferOwnership(address newOwner) public virtual onlyOwner {
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract MinuToken is Context, IERC20, Ownable {
  using SafeMath for uint256;
  mapping(address => uint256) private _rOwned;
  mapping(address => uint256) private _tOwned;
  mapping(address => mapping(address => uint256)) private _allowances;
  mapping(address => bool) private _isExcludedFromFee;
  mapping(address => bool) public presaleClaims;

  uint256 private constant MAX = ~uint256(0);
  uint256 private constant _tTotal = 100_000_000_000_000 * 10**18;
  uint256 private _rTotal = (MAX - (MAX % _tTotal));
  uint256 private _tFeeTotal;

  uint256 public marketingTax = 3;
  uint256 public minerTax = 2;

  uint256 private constant _redisFeeOnBuy = 0;
  uint256 private _taxFeeOnBuy = marketingTax + minerTax;

  uint256 private constant _redisFeeOnSell = 0;
  uint256 private _taxFeeOnSell = marketingTax + minerTax;

  uint256 private _redisFee;
  uint256 private _taxFee;

  string private constant _name = 'Minu';
  string private constant _symbol = 'MINU';
  uint8 private constant _decimals = 18;

  address public presaleAddress;
  address payable private _minerTvlAddress = payable(0x1495909E77f57fbe2e977d96f754e9d170C80eb5);
  address payable private _marketingAddress = payable(0x215A2b80846646353Fcc8Cee22142Bd037839cc1);

  IUniswapV2Router02 public uniswapV2Router;
  address public uniswapV2Pair;

  bool private inSwap = false;
  bool private swapEnabled = true;

  modifier lockTheSwap() {
    inSwap = true;
    _;
    inSwap = false;
  }

  constructor(address _owner) {
    require(_owner != address(0), 'Owner cannot be the zero address');
    transferOwnership(_owner);
    
    _rOwned[_owner] = _rTotal;


    address router;
    if (block.chainid == 56) {
      router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    } else if (block.chainid == 97) {
      router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
    } else {
      revert();
    }

    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
    uniswapV2Router = _uniswapV2Router;
    uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

    _isExcludedFromFee[owner()] = true;
    _isExcludedFromFee[address(this)] = true;
    _isExcludedFromFee[_minerTvlAddress] = true;
    _isExcludedFromFee[_marketingAddress] = true;

    emit Transfer(address(0x0000000000000000000000000000000000000000), _owner, _tTotal);
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
    return tokenFromReflection(_rOwned[account]);
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

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      _msgSender(),
      _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
    );
    return true;
  }

  function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
    require(rAmount <= _rTotal, 'Amount must be less than total reflections');
    uint256 currentRate = _getRate();
    return rAmount.div(currentRate);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) private {
    require(owner != address(0), 'ERC20: approve from the zero address');
    require(spender != address(0), 'ERC20: approve to the zero address');
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(
    address from,
    address to,
    uint256 amount
  ) private {
    if (from == presaleAddress) {
      presaleClaims[to] = true;
    }

    _redisFee = 0;
    _taxFee = 0;

    if (from != owner() && to != owner()) {
      uint256 contractTokenBalance = balanceOf(address(this));
      if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance > 0) {
        swapTokensForEth(contractTokenBalance);
        uint256 contractETHBalance = address(this).balance;
        if (contractETHBalance > 0) {
          sendETHToFee(address(this).balance);
        }
      }

      if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
        _redisFee = _redisFeeOnBuy;
        _taxFee = _taxFeeOnBuy;
      }

      if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
        _redisFee = _redisFeeOnSell;
        _taxFee = _taxFeeOnSell;
      }

      if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
        _redisFee = 0;
        _taxFee = 0;
      }
    }

    _tokenTransfer(from, to, amount);
  }

  event presaleAddressUpdated(address previous, address next);

  function setPresaleAddress(address account) public onlyOwner {
    emit presaleAddressUpdated(presaleAddress, account);
    presaleAddress = account;
    _isExcludedFromFee[presaleAddress] = true;
  }

  function isPresaleClaimed(address account) public view virtual returns (bool) {
    return presaleClaims[account];
  }

  function setPresaleClaims(address[] memory accounts, bool value) public onlyOwner {
    for (uint256 i = 0; i < accounts.length; ++i) {
      presaleClaims[accounts[i]] = value;
    }
  }

  function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();
    _approve(address(this), address(uniswapV2Router), tokenAmount);
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0,
      path,
      address(this),
      block.timestamp
    );
  }

  function sendETHToFee(uint256 amount) private {
    if (marketingTax + minerTax == 0) {
      return;
    }

    uint256 share = amount.mul(marketingTax).div(marketingTax + minerTax);
    _minerTvlAddress.transfer(share);
    _marketingAddress.transfer(amount - share);
  }

  function _tokenTransfer(
    address sender,
    address recipient,
    uint256 amount
  ) private {
    _transferStandard(sender, recipient, amount);
  }

  event tokensRescued(address indexed token, address indexed to, uint256 amount);

  function rescueForeignTokens(
    address _tokenAddr,
    address _to,
    uint256 _amount
  ) public onlyOwner {
    emit tokensRescued(_tokenAddr, _to, _amount);
    Token(_tokenAddr).transfer(_to, _amount);
  }

  event devAddressUpdated(address indexed previous, address indexed adr);

  function setNewDevAddress(address payable dev) public onlyOwner {
    emit devAddressUpdated(_minerTvlAddress, dev);
    _minerTvlAddress = dev;
    _isExcludedFromFee[_minerTvlAddress] = true;
  }

  event marketingAddressUpdated(address indexed previous, address indexed adr);

  function setNewMarketingAddress(address payable markt) public onlyOwner {
    emit marketingAddressUpdated(_marketingAddress, markt);
    _marketingAddress = markt;
    _isExcludedFromFee[_marketingAddress] = true;
  }

  function _transferStandard(
    address sender,
    address recipient,
    uint256 tAmount
  ) private {
    (
      uint256 rAmount,
      uint256 rTransferAmount,
      uint256 rFee,
      uint256 tTransferAmount,
      uint256 tFee,
      uint256 tTeam
    ) = _getValues(tAmount);
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    _takeTeam(tTeam);
    _reflectFee(rFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _takeTeam(uint256 tTeam) private {
    uint256 currentRate = _getRate();
    uint256 rTeam = tTeam.mul(currentRate);
    _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
  }

  function _reflectFee(uint256 rFee, uint256 tFee) private {
    _rTotal = _rTotal.sub(rFee);
    _tFeeTotal = _tFeeTotal.add(tFee);
  }

  receive() external payable {}

  function _getValues(uint256 tAmount)
    private
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    )
  {
    (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _redisFee);
    uint256 currentRate = _getRate();
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
    return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
  }

  function _getTValues(
    uint256 tAmount,
    uint256 TeamFee,
    uint256 taxFee
  )
    private
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 tFee = tAmount.mul(taxFee).div(100);
    uint256 tTeam = tAmount.mul(TeamFee).div(100);
    uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
    return (tTransferAmount, tFee, tTeam);
  }

  function _getRValues(
    uint256 tAmount,
    uint256 tFee,
    uint256 tTeam,
    uint256 currentRate
  )
    private
    pure
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 rAmount = tAmount.mul(currentRate);
    uint256 rFee = tFee.mul(currentRate);
    uint256 rTeam = tTeam.mul(currentRate);
    uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
    return (rAmount, rTransferAmount, rFee);
  }

  function _getRate() private view returns (uint256) {
    (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
    return rSupply.div(tSupply);
  }

  function _getCurrentSupply() private view returns (uint256, uint256) {
    uint256 rSupply = _rTotal;
    uint256 tSupply = _tTotal;
    if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
    return (rSupply, tSupply);
  }

  function manualswap() external {
    require(_msgSender() == owner());
    uint256 contractBalance = balanceOf(address(this));
    swapTokensForEth(contractBalance);
  }

  function manualsend() external {
    require(_msgSender() == owner());
    uint256 contractETHBalance = address(this).balance;
    sendETHToFee(contractETHBalance);
  }

  function setFee(uint256 _marketingTax, uint256 _minerTax) public onlyOwner {
    require(_marketingTax + _minerTax < 25, 'Tax cannot be more than 25.');
    marketingTax = _marketingTax;
    minerTax = _minerTax;
    _taxFeeOnBuy = _marketingTax + _minerTax;
    _taxFeeOnSell = _marketingTax + _minerTax;
  }

  function toggleSwap(bool _swapEnabled) public onlyOwner {
    swapEnabled = _swapEnabled;
  }

  function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
    for (uint256 i = 0; i < accounts.length; i++) {
      _isExcludedFromFee[accounts[i]] = excluded;
    }
  }
}