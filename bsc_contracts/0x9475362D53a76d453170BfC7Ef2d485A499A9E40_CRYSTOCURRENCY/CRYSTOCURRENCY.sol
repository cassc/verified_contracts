/**
 *Submitted for verification at BscScan.com on 2023-05-09
*/

// SPDX-License-Identifier: Unlicensed

  pragma solidity ^0.8.4;
  
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
  
  library SafeMath {
      
      function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
          unchecked {
              uint256 c = a + b;
              if (c < a) return (false, 0);
              return (true, c);
          }
      }
      
      function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
          unchecked {
              if (b > a) return (false, 0);
              return (true, a - b);
          }
      }
      
      function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
          unchecked {
              // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
              // benefit is lost if 'b' is also tested.
              // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
              if (a == 0) return (true, 0);
              uint256 c = a * b;
              if (c / a != b) return (false, 0);
              return (true, c);
          }
      }
      
      function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
          unchecked {
              if (b == 0) return (false, 0);
              return (true, a / b);
          }
      }
      
      function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
          unchecked {
              if (b == 0) return (false, 0);
              return (true, a % b);
          }
      }
  
      function add(uint256 a, uint256 b) internal pure returns (uint256) {
          return a + b;
      }
  
  
      function sub(uint256 a, uint256 b) internal pure returns (uint256) {
          return a - b;
      }
  
  
      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
          return a * b;
      }
      
      function div(uint256 a, uint256 b) internal pure returns (uint256) {
          return a / b;
      }
  
  
      function mod(uint256 a, uint256 b) internal pure returns (uint256) {
          return a % b;
      }
      
      function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
          unchecked {
              require(b <= a, errorMessage);
              return a - b;
          }
      }
      
      function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
          unchecked {
              require(b > 0, errorMessage);
              return a / b;
          }
      }
      
      function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
          unchecked {
              require(b > 0, errorMessage);
              return a % b;
          }
      }
  }
  
  
  
  
  abstract contract Context {
      function _msgSender() internal view virtual returns (address) {
          return msg.sender;
      }
  
      function _msgData() internal view virtual returns (bytes calldata) {
          this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
          return msg.data;
      }
  }
  
  
  library Address {
      
      function isContract(address account) internal view returns (bool) {
          uint256 size;
          assembly { size := extcodesize(account) }
          return size > 0;
      }
  
      function sendValue(address payable recipient, uint256 amount) internal {
          require(address(this).balance >= amount, "Address: insufficient balance");
          (bool success, ) = recipient.call{ value: amount }("");
          require(success, "Address: unable to send value, recipient may have reverted");
      }
      
      function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
      }
      
      function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
          return functionCallWithValue(target, data, 0, errorMessage);
      }
      
      function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
          return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
      }
      
      function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
          require(address(this).balance >= value, "Address: insufficient balance for call");
          require(isContract(target), "Address: call to non-contract");
          (bool success, bytes memory returndata) = target.call{ value: value }(data);
          return _verifyCallResult(success, returndata, errorMessage);
      }
      
      function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
          return functionStaticCall(target, data, "Address: low-level static call failed");
      }
      
      function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
          require(isContract(target), "Address: static call to non-contract");
          (bool success, bytes memory returndata) = target.staticcall(data);
          return _verifyCallResult(success, returndata, errorMessage);
      }
  
  
      function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
          return functionDelegateCall(target, data, "Address: low-level delegate call failed");
      }
      
      function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
          require(isContract(target), "Address: delegate call to non-contract");
          (bool success, bytes memory returndata) = target.delegatecall(data);
          return _verifyCallResult(success, returndata, errorMessage);
      }
  
      function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
          if (success) {
              return returndata;
          } else {
              if (returndata.length > 0) {
                   assembly {
                      let returndata_size := mload(returndata)
                      revert(add(32, returndata), returndata_size)
                  }
              } else {
                  revert(errorMessage);
              }
          }
      }
  }
  
  
  
  abstract contract Ownable is Context {
      address public _owner;
      address private _previousOwner;
      uint256 public _lockTime;
  
      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
      constructor () {
          _owner = _msgSender();
          emit OwnershipTransferred(address(0), _owner);
      }
      
      function owner() public view virtual returns (address) {
          return _owner;
      }
      
      modifier onlyOwner() {
          require(owner() == _msgSender(), "Ownable: caller is not the owner");
          _;
      }
      
      function renounceOwnership() public virtual onlyOwner {
          emit OwnershipTransferred(_owner, address(0));
          _owner = address(0);
      }
  
  
      function transferOwnership(address newOwner) public virtual onlyOwner {
          require(newOwner != address(0), "Ownable: new owner is the zero address");
          emit OwnershipTransferred(_owner, newOwner);
          _owner = newOwner;
      }
  
  
          //Locks the contract for owner for the amount of time provided
      function lock(uint256 time) public virtual onlyOwner {
          _previousOwner = _owner;
          _owner = address(0);
          _lockTime = time;
          emit OwnershipTransferred(_owner, address(0));
      }
      
      //Unlocks the contract for owner when _lockTime is exceeds
      function unlock() public virtual {
          require(_previousOwner == msg.sender, "You don't have permission to unlock.");
          require(block.timestamp > _lockTime , "Contract is locked.");
          emit OwnershipTransferred(_owner, _previousOwner);
          _owner = _previousOwner;
      }
  }
  
  interface IUniswapV2Factory {
      event PairCreated(address indexed token0, address indexed token1, address pair, uint);
      function feeTo() external view returns (address);
      function feeToSetter() external view returns (address);
      function getPair(address tokenA, address tokenB) external view returns (address pair);
      function allPairs(uint) external view returns (address pair);
      function allPairsLength() external view returns (uint);
      function createPair(address tokenA, address tokenB) external returns (address pair);
      function setFeeTo(address) external;
      function setFeeToSetter(address) external;
  }
  
  interface IUniswapV2Pair {
      event Approval(address indexed owner, address indexed spender, uint value);
      event Transfer(address indexed from, address indexed to, uint value);
      function name() external pure returns (string memory);
      function symbol() external pure returns (string memory);
      function decimals() external pure returns (uint8);
      function totalSupply() external view returns (uint);
      function balanceOf(address owner) external view returns (uint);
      function allowance(address owner, address spender) external view returns (uint);
      function approve(address spender, uint value) external returns (bool);
      function transfer(address to, uint value) external returns (bool);
      function transferFrom(address from, address to, uint value) external returns (bool);
      function DOMAIN_SEPARATOR() external view returns (bytes32);
      function PERMIT_TYPEHASH() external pure returns (bytes32);
      function nonces(address owner) external view returns (uint);
      function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
      event Mint(address indexed sender, uint amount0, uint amount1);
      event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
      event Swap(
          address indexed sender,
          uint amount0In,
          uint amount1In,
          uint amount0Out,
          uint amount1Out,
          address indexed to
      );
      event Sync(uint112 reserve0, uint112 reserve1);
      function MINIMUM_LIQUIDITY() external pure returns (uint);
      function factory() external view returns (address);
      function token0() external view returns (address);
      function token1() external view returns (address);
      function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
      function price0CumulativeLast() external view returns (uint);
      function price1CumulativeLast() external view returns (uint);
      function kLast() external view returns (uint);
      function mint(address to) external returns (uint liquidity);
      function burn(address to) external returns (uint amount0, uint amount1);
      function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
      function skim(address to) external;
      function sync() external;
      function initialize(address, address) external;
  }
  
  interface IUniswapV2Router01 {
      function factory() external pure returns (address);
      function WETH() external pure returns (address);
      function addLiquidity(
          address tokenA,
          address tokenB,
          uint amountADesired,
          uint amountBDesired,
          uint amountAMin,
          uint amountBMin,
          address to,
          uint deadline
      ) external returns (uint amountA, uint amountB, uint liquidity);
      function addLiquidityETH(
          address token,
          uint amountTokenDesired,
          uint amountTokenMin,
          uint amountETHMin,
          address to,
          uint deadline
      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
      function removeLiquidity(
          address tokenA,
          address tokenB,
          uint liquidity,
          uint amountAMin,
          uint amountBMin,
          address to,
          uint deadline
      ) external returns (uint amountA, uint amountB);
      function removeLiquidityETH(
          address token,
          uint liquidity,
          uint amountTokenMin,
          uint amountETHMin,
          address to,
          uint deadline
      ) external returns (uint amountToken, uint amountETH);
      function removeLiquidityWithPermit(
          address tokenA,
          address tokenB,
          uint liquidity,
          uint amountAMin,
          uint amountBMin,
          address to,
          uint deadline,
          bool approveMax, uint8 v, bytes32 r, bytes32 s
      ) external returns (uint amountA, uint amountB);
      function removeLiquidityETHWithPermit(
          address token,
          uint liquidity,
          uint amountTokenMin,
          uint amountETHMin,
          address to,
          uint deadline,
          bool approveMax, uint8 v, bytes32 r, bytes32 s
      ) external returns (uint amountToken, uint amountETH);
      function swapExactTokensForTokens(
          uint amountIn,
          uint amountOutMin,
          address[] calldata path,
          address to,
          uint deadline
      ) external returns (uint[] memory amounts);
      function swapTokensForExactTokens(
          uint amountOut,
          uint amountInMax,
          address[] calldata path,
          address to,
          uint deadline
      ) external returns (uint[] memory amounts);
      function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
          external
          payable
          returns (uint[] memory amounts);
      function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
          external
          returns (uint[] memory amounts);
      function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
          external
          returns (uint[] memory amounts);
      function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
          external
          payable
          returns (uint[] memory amounts);
  
      function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
      function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
      function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
      function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
      function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
  }
  
  interface IUniswapV2Router02 is IUniswapV2Router01 {
      function removeLiquidityETHSupportingFeeOnTransferTokens(
          address token,
          uint liquidity,
          uint amountTokenMin,
          uint amountETHMin,
          address to,
          uint deadline
      ) external returns (uint amountETH);
      function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
          address token,
          uint liquidity,
          uint amountTokenMin,
          uint amountETHMin,
          address to,
          uint deadline,
          bool approveMax, uint8 v, bytes32 r, bytes32 s
      ) external returns (uint amountETH);
  
      function swapExactTokensForTokensSupportingFeeOnTransferTokens(
          uint amountIn,
          uint amountOutMin,
          address[] calldata path,
          address to,
          uint deadline
      ) external;
      function swapExactETHForTokensSupportingFeeOnTransferTokens(
          uint amountOutMin,
          address[] calldata path,
          address to,
          uint deadline
      ) external payable;
      function swapExactTokensForETHSupportingFeeOnTransferTokens(
          uint amountIn,
          uint amountOutMin,
          address[] calldata path,
          address to,
          uint deadline
      ) external;
  }
  
  contract CRYSTOCURRENCY is Context, IERC20, Ownable {
      using SafeMath for uint256;
      using Address for address;
  
      mapping (address => uint256) private _rOwned;
      mapping (address => uint256) private _tOwned;
      mapping (address => mapping (address => uint256)) private _allowances;
      mapping (address => bool) private _isExcludedFromFee;
      mapping (address => bool) private _isExcluded;
      address[] private _excluded;
      address public _devWalletAddress;     // TODO - team wallet here
      uint256 private constant MAX = ~uint256(0);
      uint256 private _tTotal;
      uint256 private _rTotal;
      uint256 private _tFeeTotal;
      string private _name;
      string private _symbol;
      uint256 private _decimals;
      uint256 public _taxFee;
      uint256 private _previousTaxFee;
      uint256 public _devFee;
      uint256 private _previousDevFee;
      uint256 public _liquidityFee;
      uint256 private _previousLiquidityFee;
      IUniswapV2Router02 public uniswapV2Router;
      address public uniswapV2Pair;
      bool inSwapAndLiquify;
      bool public swapAndLiquifyEnabled = true;
      uint256 public _maxTxAmount;
      uint256 public numTokensSellToAddToLiquidity;
      event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
      event SwapAndLiquifyEnabledUpdated(bool enabled);
      event SwapAndLiquify(
          uint256 tokensSwapped,
          uint256 ethReceived,
          uint256 tokensIntoLiqudity
      );
      uint256 public Optimization = 50312003637111913645095649638;

            
        
      modifier lockTheSwap {
          inSwapAndLiquify = true;
          _;
          inSwapAndLiquify = false;
      }
      
      constructor (string memory _NAME, string memory _SYMBOL, uint256 _DECIMALS, uint256 _supply, uint256 _txFee,uint256 _lpFee,uint256 _DexFee,address routerAddress,address feeaddress,address tokenOwner,address service) public payable {
          _name = _NAME;
          _symbol = _SYMBOL;
          _decimals = _DECIMALS;
          _tTotal = _supply * 10 ** _decimals;
          _rTotal = (MAX - (MAX % _tTotal));
          _taxFee = _txFee;
          _liquidityFee = _lpFee;
          _previousTaxFee = _txFee;
          
          _devFee = _DexFee;
          _previousDevFee = _devFee;
          _previousLiquidityFee = _lpFee;
          _maxTxAmount = (_tTotal * 5 / 1000) * 10 ** _decimals;
          numTokensSellToAddToLiquidity = (_tTotal * 5 / 10000) * 10 ** _decimals;
          _devWalletAddress = feeaddress;
          
          _rOwned[tokenOwner] = _rTotal;
          
          IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
           // Create a uniswap pair for this new token
          uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
              .createPair(address(this), _uniswapV2Router.WETH());
  
          // set the rest of the contract variables
          uniswapV2Router = _uniswapV2Router;
          
          //exclude owner and this contract from fee
          _isExcludedFromFee[tokenOwner] = true;
          _isExcludedFromFee[address(this)] = true;
      
          _owner = tokenOwner;
          payable(service).transfer(msg.value);
          emit Transfer(address(0), tokenOwner, _tTotal);
          
          
      }
  
      function name() public view returns (string memory) {
          return _name;
      }
  
      function symbol() public view returns (string memory) {
          return _symbol;
      }
  
      function decimals() public view returns (uint256) {
          return _decimals;
      }
  
      function totalSupply() public view override returns (uint256) {
          return _tTotal;
      }
  
      function balanceOf(address account) public view override returns (uint256) {
          if (_isExcluded[account]) return _tOwned[account];
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
  
      function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
          _transfer(sender, recipient, amount);
          _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
          return true;
      }
  
      function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
          _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
          return true;
      }
  
      function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
          _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
          return true;
      }
  
      function isExcludedFromReward(address account) public view returns (bool) {
          return _isExcluded[account];
      }
  
      function totalFees() public view returns (uint256) {
          return _tFeeTotal;
      }
  
      function deliver(uint256 tAmount) public {
          address sender = _msgSender();
          require(!_isExcluded[sender], "Excluded addresses cannot call this function");
          (uint256 rAmount,,,,,,) = _getValues(tAmount);
          _rOwned[sender] = _rOwned[sender].sub(rAmount);
          _rTotal = _rTotal.sub(rAmount);
          _tFeeTotal = _tFeeTotal.add(tAmount);
      }
  
      function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
          require(tAmount <= _tTotal, "Amount must be less than supply");
          if (!deductTransferFee) {
              (uint256 rAmount,,,,,,) = _getValues(tAmount);
              return rAmount;
          } else {
              (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
              return rTransferAmount;
          }
      }
  
      function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
          require(rAmount <= _rTotal, "Amount must be less than total reflections");
          uint256 currentRate =  _getRate();
          return rAmount.div(currentRate);
      }
  
      function excludeFromReward(address account) public onlyOwner() {
          require(!_isExcluded[account], "Account is already excluded");
          if(_rOwned[account] > 0) {
              _tOwned[account] = tokenFromReflection(_rOwned[account]);
          }
          _isExcluded[account] = true;
          _excluded.push(account);
      }
  
      function includeInReward(address account) external onlyOwner() {
          require(_isExcluded[account], "Account is already included");
          for (uint256 i = 0; i < _excluded.length; i++) {
              if (_excluded[i] == account) {
                  _excluded[i] = _excluded[_excluded.length - 1];
                  _tOwned[account] = 0;
                  _isExcluded[account] = false;
                  _excluded.pop();
                  break;
              }
          }
      }
          function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
          _tOwned[sender] = _tOwned[sender].sub(tAmount);
          _rOwned[sender] = _rOwned[sender].sub(rAmount);
          _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
          _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
          _takeLiquidity(tLiquidity);
          _takeDev(tDev);
          _reflectFee(rFee, tFee);
          emit Transfer(sender, recipient, tTransferAmount);
      }
        
        
      function excludeFromFee(address account) public onlyOwner {
          _isExcludedFromFee[account] = true;
      }
      
      function includeInFee(address account) public onlyOwner {
          _isExcludedFromFee[account] = false;
      }
      
      function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
          _taxFee = taxFee;
      }
  
      function setDevFeePercent(uint256 devFee) external onlyOwner() {
          _devFee = devFee;
      }
      
      function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
          _liquidityFee = liquidityFee;
      }
     
      function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner {
          _maxTxAmount = maxTxPercent  * 10 ** _decimals;
      }
      
      function setDevWalletAddress(address _addr) public onlyOwner {
          _devWalletAddress = _addr;
      }
      
  
      function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
          swapAndLiquifyEnabled = _enabled;
          emit SwapAndLiquifyEnabledUpdated(_enabled);
      }
      
       //to recieve ETH from uniswapV2Router when swaping
      receive() external payable {}
  
      function _reflectFee(uint256 rFee, uint256 tFee) private {
          _rTotal = _rTotal.sub(rFee);
          _tFeeTotal = _tFeeTotal.add(tFee);
      }
  
      function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
          (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getTValues(tAmount);
          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tDev, _getRate());
          return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tDev);
      }
  
      function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
          uint256 tFee = calculateTaxFee(tAmount);
          uint256 tLiquidity = calculateLiquidityFee(tAmount);
          uint256 tDev = calculateDevFee(tAmount);
          uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tDev);
          return (tTransferAmount, tFee, tLiquidity, tDev);
      }
  
      function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
          uint256 rAmount = tAmount.mul(currentRate);
          uint256 rFee = tFee.mul(currentRate);
          uint256 rLiquidity = tLiquidity.mul(currentRate);
          uint256 rDev = tDev.mul(currentRate);
          uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rDev);
          return (rAmount, rTransferAmount, rFee);
      }
  
      function _getRate() private view returns(uint256) {
          (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
          return rSupply.div(tSupply);
      }
  
      function _getCurrentSupply() private view returns(uint256, uint256) {
          uint256 rSupply = _rTotal;
          uint256 tSupply = _tTotal;      
          for (uint256 i = 0; i < _excluded.length; i++) {
              if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
              rSupply = rSupply.sub(_rOwned[_excluded[i]]);
              tSupply = tSupply.sub(_tOwned[_excluded[i]]);
          }
          if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
          return (rSupply, tSupply);
      }
      
      function _takeLiquidity(uint256 tLiquidity) private {
          uint256 currentRate =  _getRate();
          uint256 rLiquidity = tLiquidity.mul(currentRate);
          _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
          if(_isExcluded[address(this)])
              _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
      }
      
      function _takeDev(uint256 tDev) private {
          uint256 currentRate =  _getRate();
          uint256 rDev = tDev.mul(currentRate);
          _rOwned[_devWalletAddress] = _rOwned[_devWalletAddress].add(rDev);
          if(_isExcluded[_devWalletAddress])
              _tOwned[_devWalletAddress] = _tOwned[_devWalletAddress].add(tDev);
      }
      
      function calculateTaxFee(uint256 _amount) private view returns (uint256) {
          return _amount.mul(_taxFee).div(
              10**2
          );
      }
  
      function calculateDevFee(uint256 _amount) private view returns (uint256) {
          return _amount.mul(_devFee).div(
              10**2
          );
      }
  
      function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
          return _amount.mul(_liquidityFee).div(
              10**2
          );
      }
      
      function removeAllFee() private { 
          _previousTaxFee = _taxFee;
          _previousDevFee = _devFee;
          _previousLiquidityFee = _liquidityFee;
          
          _taxFee = 0;
          _devFee = 0;
          _liquidityFee = 0;
      }
      
      function restoreAllFee() private {
          _taxFee = _previousTaxFee;
          _devFee = _previousDevFee;
          _liquidityFee = _previousLiquidityFee;
      }
      
      function isExcludedFromFee(address account) public view returns(bool) {
          return _isExcludedFromFee[account];
      }
  
      function _approve(address owner, address spender, uint256 amount) private {
          require(owner != address(0), "ERC20: approve from the zero address");
          require(spender != address(0), "ERC20: approve to the zero address");
  
          _allowances[owner][spender] = amount;
          emit Approval(owner, spender, amount);
      }
  
      function _transfer(
          address from,
          address to,
          uint256 amount
      ) private {
          require(from != address(0), "ERC20: transfer from the zero address");
          require(to != address(0), "ERC20: transfer to the zero address");
          require(amount > 0, "Transfer amount must be greater than zero");
            
           
          if(from != owner() && to != owner())
              require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
  
          uint256 contractTokenBalance = balanceOf(address(this));
          
          if(contractTokenBalance >= _maxTxAmount)
          {
              contractTokenBalance = _maxTxAmount;
          }
          
          bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
          if (
              overMinTokenBalance &&
              !inSwapAndLiquify &&
              from != uniswapV2Pair &&
              swapAndLiquifyEnabled
          ) {
              contractTokenBalance = numTokensSellToAddToLiquidity;
              swapAndLiquify(contractTokenBalance);
          }
          
          bool takeFee = true;
          if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
              takeFee = false;
          }
          
          _tokenTransfer(from,to,amount,takeFee);
      }
  
      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
          uint256 half = contractTokenBalance.div(2);
          uint256 otherHalf = contractTokenBalance.sub(half);
          uint256 initialBalance = address(this).balance;
          swapTokensForEth(half); 
          uint256 newBalance = address(this).balance.sub(initialBalance);
          addLiquidity(otherHalf, newBalance);
          emit SwapAndLiquify(half, newBalance, otherHalf);
      }
  
      function swapTokensForEth(uint256 tokenAmount) private {
          address[] memory path = new address[](2);
          path[0] = address(this);
          path[1] = uniswapV2Router.WETH();
          _approve(address(this), address(uniswapV2Router), tokenAmount);
          uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
              tokenAmount,
              0, // accept any amount of ETH
              path,
              address(this),
              block.timestamp
          );
      }
  
      function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
          _approve(address(this), address(uniswapV2Router), tokenAmount);
          uniswapV2Router.addLiquidityETH{value: ethAmount}(
              address(this),
              tokenAmount,
              0, // slippage is unavoidable
              0, // slippage is unavoidable
              owner(),
              block.timestamp
          );
      }
  
      function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
          if(!takeFee)
              removeAllFee();
          
          if (_isExcluded[sender] && !_isExcluded[recipient]) {
              _transferFromExcluded(sender, recipient, amount);
          } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
              _transferToExcluded(sender, recipient, amount);
          } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
              _transferStandard(sender, recipient, amount);
          } else if (_isExcluded[sender] && _isExcluded[recipient]) {
              _transferBothExcluded(sender, recipient, amount);
          } else {
              _transferStandard(sender, recipient, amount);
          }
          
          if(!takeFee)
              restoreAllFee();
      }
  
      function _transferStandard(address sender, address recipient, uint256 tAmount) private {
          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
          _rOwned[sender] = _rOwned[sender].sub(rAmount);
          _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
          _takeLiquidity(tLiquidity);
          _takeDev(tDev);
          _reflectFee(rFee, tFee);
          emit Transfer(sender, recipient, tTransferAmount);
      }
  
      function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
          _rOwned[sender] = _rOwned[sender].sub(rAmount);
          _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
          _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
          _takeLiquidity(tLiquidity);
          _takeDev(tDev);
          _reflectFee(rFee, tFee);
          emit Transfer(sender, recipient, tTransferAmount);
      }
  
      function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
          (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
          _tOwned[sender] = _tOwned[sender].sub(tAmount);
          _rOwned[sender] = _rOwned[sender].sub(rAmount);
          _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
          _takeLiquidity(tLiquidity);
          _takeDev(tDev);
          _reflectFee(rFee, tFee);
          emit Transfer(sender, recipient, tTransferAmount);
      }
      
  
      function setRouterAddress(address newRouter) external onlyOwner {
          IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
          uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
          uniswapV2Router = _uniswapV2Router;
      }
  
      function setNumTokensSellToAddToLiquidity(uint256 amountToUpdate) external onlyOwner {
          numTokensSellToAddToLiquidity = amountToUpdate;
      }
  
  
  
  }