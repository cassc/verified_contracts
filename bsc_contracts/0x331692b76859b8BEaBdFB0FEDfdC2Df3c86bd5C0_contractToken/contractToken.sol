/**
 *Submitted for verification at BscScan.com on 2023-01-05
*/

pragma solidity ^0.8.0;

interface IBEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Burn(address indexed owner, address indexed to, uint value);
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address ) {
        return msg.sender;
    }
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

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor ()  {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
		require(_msgSender() != address(0), "BEP20: transfer from the zero address");
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract lpfhpool{
    constructor () {}
}

contract getu is Ownable{
    constructor () {}

    function get(address usdt) public onlyOwner {
        IBEP20(usdt).transfer(owner(),IBEP20(usdt).balanceOf(address(this)));
    }
}

contract BEP20 is Context, Ownable, IBEP20 {
    using SafeMath for uint;

    mapping (address => uint) internal _balances;
    mapping (address => mapping (address => uint)) internal _allowances;
	mapping (address => bool ) public isBot;
	
    uint public totalBurn;
    uint public deployTime;
    
    uint public _totalSupplyA;
	uint public _totalSupplyB;
    uint public _totalSupplyC;
	
	// uint public maxWalletBalance;
	
	uint public buyFee = 9900;
    uint public sellFee = 500;
	uint public marketFee = 300;
    uint public lpFee   = 100;
	uint public reflectionFee = 100;

    // lpfhpool public mpl;

    // uint256 public startTime = 1670769000;
    
    address T ;  // team address
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;
	address public USDT = 0x55d398326f99059fF775485246999027B3197955;
    // address public USDT = 0xCF7Fa43AE803E1453E4CD50CaC8BccbB8b9BcC24;

    address market = 0xAdb328a7caC00f338EE23EE0a36899CA362f7d31;

	// mapping (address => bool) public isDividendExempt;
	uint256 public swapThreshold; 
	IDEXRouter public router;
    address public pair;
    getu public gtu;
	
    address[] buyUser;
    mapping(address => bool) public havePush;
    uint256 public indexOfRewad = 0;

	bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }


    mapping (address => bool) public isExcludedFee;

    uint256 public buyMaxAmout = 2000;
	
	constructor ()  {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        // router = IDEXRouter(0x729f6dC25756CB31FbE84f83d6672894B81858dc);
        pair = IDEXFactory(router.factory()).createPair(USDT, address(this));
		// _allowances[address(this)][address(router)] = type(uint256).max;

        gtu = new getu();

        
        isExcludedFee[address(router)] = true;
        isExcludedFee[address(this)] = true;
        isExcludedFee[deadAddress] = true;
        isExcludedFee[market] = true;

    }
    function setBuyMax(uint256 a)public onlyOwner{
        buyMaxAmout = a;
    }

    function setFee(uint256 _buyfee,uint256 _sellfee, uint256 _reffee,uint256 _marketfee,uint256 _lpfee) public onlyOwner{
        buyFee = _buyfee;
        sellFee = _sellfee;
        reflectionFee = _reffee;
        marketFee = _marketfee;
        lpFee = _lpfee;
    }
    

    function setBot(address[] memory accounts,bool bl) public onlyOwner{
        for(uint256 i=0;i<accounts.length;i++){
		    isBot[accounts[i]] = bl;
        }
	}

    function setWhite(address[] memory accounts,bool bl) public onlyOwner{
        for(uint256 i=0;i<accounts.length;i++){
		    isExcludedFee[accounts[i]] = bl;
        }
	}
	
    function totalSupply() public view override returns (uint) {
        return _totalSupplyC;
    }

    function tokenX(uint amount) internal view returns(uint){
        return amount.mul(_totalSupplyB).div(_totalSupplyA);
    }

    function tokenD(uint amount) internal view returns(uint){
        return amount.mul(_totalSupplyA).div(_totalSupplyB);
    }

    function balanceOf(address account) public view override returns (uint) {
       
        return _balances[account].mul(_totalSupplyB).div(_totalSupplyA);
    }
    function transfer(address recipient, uint amount) public override  returns (bool) {
	//	require(_msgSender() != address(0), "BEP20: transfer from the zero address");
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address towner, address spender) public view override returns (uint) {
		require(towner != address(0), "BEP20: towner is zero address");
		require(spender != address(0), "BEP20: spender is zero address");
        return _allowances[towner][spender];
    }
    function approve(address spender, uint amount) public override returns (bool) {
		require(spender != address(0), "BEP20: spender is zero address");
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
		require(sender != address(0), "BEP20: sender is zero address");
		
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
		require(spender != address(0), "BEP20: spender is zero address");
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
		require(spender != address(0), "BEP20: spender is zero address");
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function swapamount() view internal returns(uint256) {
        if( balanceOf(pair) == 0){
            return totalSupply();
        }
        return  balanceOf(pair) / 100 ;
    }
	
	function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && tokenX(_balances[address(this)]) >= swapamount() ;
    }
	
	function swapBack() internal swapping {
		uint256 amountToSwap = tokenX(_balances[address(this)]);
        address[] memory path = new address[](2);
		path[0] = address(this);
        path[1] = USDT;

        uint256 tolpAmt = amountToSwap * lpFee / (lpFee + marketFee) / 2;
        amountToSwap = amountToSwap - tolpAmt;

		_approve(address(this),address(router),amountToSwap);
		router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(gtu),
            block.timestamp
        );

        gtu.get(USDT);

        uint256 u_balance = IBEP20(USDT).balanceOf(address(this));

        uint256 uTolp = u_balance * ( lpFee / 2 ) / (lpFee / 2 + marketFee);
        // IBEP20(USDT).transfer(T,u_balance);
        IBEP20(USDT).transfer(market,u_balance - uTolp);
        addLp(tolpAmt,uTolp);
	}

    function addLp(uint256 selfAmount,uint256 uAmount) internal {
        _approve(address(this),address(router),selfAmount);
        IBEP20(USDT).approve(address(router),uAmount);

        router.addLiquidity(
            address(this),
            USDT,
            selfAmount,
            uAmount,
            0,
            0,
            market,
            block.timestamp
        );
    }

    function getTime() public view returns(uint256){
        return block.timestamp;
    }

    function _transfer(address sender, address recipient, uint _amount) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer from the zero address");
		require(!isBot[sender],"is bot");

        // _amount = _amount * 999 / 1000 ;

		uint amount = tokenD(_amount);
        uint256 AllFee;
        if(sender == pair){AllFee = buyFee;}
        if(recipient == pair){AllFee = sellFee;}
        uint256 tax = amount.mul(AllFee).div(10000);

        if(sender == pair){
            if(!isExcludedFee[recipient]){
                require( _amount < buyMaxAmout * (10 ** 9) );
            }
        }

        if (
             isExcludedFee[sender] || isExcludedFee[recipient] || inSwap 
        ) {
            tax = 0;
        }
        uint256 netAmount = amount - tax;
		
		if(shouldSwapBack()){ swapBack(); }
   
        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(netAmount);
        emit Transfer(sender, recipient, tokenX(netAmount));
        if (tax > 0) {
            uint256 taxA = tax.mul(reflectionFee).div(AllFee);

            // uint256 taxB = tax.mul(LPfh).div(AllFee);

            uint256 taxM = tax.sub(taxA);
			
            // _balances[address(mpl)] = _balances[address(mpl)].add(taxB);
            // emit Transfer(sender, address(mpl), tokenX(taxB));

            _balances[address(this)] = _balances[address(this)].add(taxM);
            emit Transfer(sender, address(this), tokenX(taxM));


            _totalSupplyA = _totalSupplyA.sub(taxA);

        }
        
    }
 
    function _approve(address towner, address spender, uint amount) internal {
        require(towner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[towner][spender] = amount;
        emit Approval(towner, spender, amount);
    }
   

}

contract BEP20Detailed is BEP20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory tname, string memory tsymbol, uint8 tdecimals)  {
        _name = tname;
        _symbol = tsymbol;
        _decimals = tdecimals;
        
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
}

contract contractToken is BEP20Detailed {

    constructor() BEP20Detailed("Ants", "Ants", 9)  {
        deployTime = block.timestamp;
        _totalSupplyA = 14131900  * (10**9);
		_totalSupplyB = 14131900  * (10**9);
        _totalSupplyC = 14131900  * (10**9);
        T = 0xc623C084DADB2A4615C16eE9E73877cA6B296CfE;
        // T = 0x74422856af23DE770f3dB82FB4590F73d533eDfD;
        isExcludedFee[T] = true;
	    _balances[T] = _totalSupplyA;
	    emit Transfer(address(0), T, _totalSupplyA);

    }
  
    function takeOutTokenInCase(address _token, uint256 _amount, address _to) public onlyOwner {
        IBEP20(_token).transfer(_to, _amount);
    }
}