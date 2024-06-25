//SPDX-License-Identifier: Unlicensed

/*
 .d888888                    dP       oo   dP       
d8'    88                    88            88      
88aaaaa88a 88d888b. dP    dP 88d888b. dP d8888P   
88     88  88'  `88 88    88 88'  `88 88   88      
88     88  88    88 88.  .88 88.  .88 88   88     
88     88  dP    dP `88888P' 88Y8888' dP   dP      


        Name = Anubit
        Symbol = ANB
        Total Supply = 100_000_000
        Decimal = 18

                      ..::ToKenomIcS:..
                **** 0% Buy Fee - 1% Sell Fee ****
    ___________ sell fees taken from the 1% total TX Fee _____________

                         20% Development
                         5%  Bounty distributed in ANB tokens
                         10% Charity
                         20% Liquidity
                         10% Marketing
                         20% Owners
                         15% Holders Reward
    ___________________________________________________________________
*/

pragma solidity ^0.8.17;

// Open Zeppelin libraries for controlling upgradability and access.
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

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

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Anubit is Initializable, UUPSUpgradeable, OwnableUpgradeable, IERC20 {
    
    using SafeMath for uint;

    address internal _lola;
    address internal _pos;
    address internal _service;
    mapping (address => bool) internal authorizations;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 internal constant DAY = 86400; //seconds in a day
    address public constant _dEaD = 0x000000000000000000000000000000000000dEaD;

    //Magnifier
    uint256 private constant MAX = 1e58;

    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _totalFees;

    // Limits
    uint256 public _maxTxAmount;
    uint256 public _maxWallet;
    uint256 internal constant _maxSupply = 100_000_000 * (10**18);

    string private constant _name = "Anubit";
    string private constant _symbol = "ANB";
    uint8 private constant _decimals = 18;
    					

    uint8 private constant _charity = 10;
    uint8 private constant _developer = 20;
    uint8 private constant _marketing = 10;
    uint8 private constant _owners = 20;
    uint8 private constant _liquidity = 20;

    

    //fee tracking
    uint8 private _previousReflectionFee;
    uint8 private _previousBountyFee;
    uint8 private _previousLiquidityFee;
  
    // for custom rates
    struct FeeStructure {
        uint8 refl;
        uint8 liq;
        uint8 bounty;
    }

    FeeStructure private customFees;
    FeeStructure public sellFees;
    FeeStructure private currentFees;


    // Pancakeswap router
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    
    // Swap And Liquify
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled;
    uint256 public minSalTokens;
    
    // Fee recieving wallets
    address payable _marketingAddress;
    address payable _developerAddress;
    address payable _ownersAddress;
    address payable _charityAddress;



    //POS address for merchants
    address payable _posAddress;

    //L.O.L.A. address
    address payable _lolaAddress;

    // Bounty
    address _bountyAddress; // Bounty wallet address
    uint256 public _bountyDrawCount;
    mapping(address => bool) private _bountyAddressExists;
    address[] private _bountyAddressList;
    event DrawBounty(uint256 amount, uint256 _bountyDrawCount);

    // Launch tracking 
    uint256 public _launchedAt;
    bool public _tradingEnabled;

    //Anti Whale & limits
    bool public _antiWhaleProtection;
    bool private dynamicWhaleDiv;
    uint256 private _sellTimeLimit;
    uint256 public _maxWhaleTxAmount;
    mapping(address => uint256) private dailySpent;
    mapping(address => uint256) private _allowedTxAmount;
    mapping(address => uint256) private _sellIntervalStart;
    mapping(address => bool) private _isExcludedFromAntiWhale;

    //LOLA is watching and will black list bad actors
    mapping(address => bool) public _isBlacklisted;

    //KYC Features
    bool public isKycEnabled;
    mapping(address => uint256) private _kycID;
    mapping(uint256 => uint256) private allowedKycTxAmount;
    mapping(uint256 => uint256) private sellKycIntervalStart;

    //Merchant
    mapping(address => bool) public _isMerchant;
    mapping(address => bool) public _merchantSellFee;
    mapping(address => uint256) private _merchantPoolAmount;

    //Private messages
    bool public isMessagingEnabled;
    mapping(address => uint256) private _msgID;

    // Time locked accounts
    bool public _lockableAccountsProtection;
    mapping(address => bool) private _isLocked;
    mapping(address => uint256) private _lockTime;

    
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    event MintDrop(address adr, uint256 amount);
    event MessageSet(address _address, uint256 msgID);
    event GetAnubits(address recipient, uint256 amount);
    event PosTx(address merchantAddress, address customerAddress, address gratAddress, uint256 txAmount, bool hasGratuity, uint256 gratAmount, uint256 gasFee, uint256 transactionID, bool takeFees);

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    modifier onlyLola() {
        require(isLola(msg.sender), "!LOLA"); _;
    }
    modifier onlyPos() {
        require(isPos(msg.sender), "!POS"); _;
    }
    modifier onlyService() {
        require(isService(msg.sender), "!SVC"); _;
    }

    mapping(address => uint8) private customDiv;
    uint8 public _div;


    function initialize() public initializer {

        __Ownable_init();
        __UUPSUpgradeable_init();

        _tTotal = 1 * 10**18;
        _rTotal = (MAX - (MAX % _tTotal));
        

        _lola = _msgSender();
        _pos = _msgSender();
        _service = _msgSender();
        authorizations[_msgSender()] = true;
		

        //General fee addresses
        _marketingAddress = payable(0xD753D7c2C29b665103b012785c74eD9b4a99d6ba);
        _developerAddress = payable(0xb8Cc20B8E2093560b24b7D765B1808D801AfBf04);
        _ownersAddress = payable(0x54b0a24582C6678566b8443BaD66bDf2631d40C2);
        _charityAddress = payable(0x2a08205a63f634d12865FDAc12457400cD23B351);

        // Bounty address
        _bountyAddress = address(0x8780BB2BFaaC57d1E87a6f65B14927e670da3162);

        //POS address
        _posAddress = payable(0x280fb306b668d0f352E8aaE346DdbCF0aBaD1d68);

        //L.O.L.A. address
        _lolaAddress = payable(0xCC59F4a97A57Cc09B72c623229be6331ed7c2aB2);

        // Setup Pancakeswap router
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
         // Create the pair 
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;
        

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_marketingAddress] = true;
        _isExcludedFromFee[_developerAddress] = true;
        _isExcludedFromFee[_charityAddress] = true;
        _isExcludedFromFee[_ownersAddress] = true;
        _isExcludedFromFee[_bountyAddress] = true;
        _isExcludedFromFee[_posAddress] = true;
        _isExcludedFromFee[_lolaAddress] = true;
        _isExcludedFromFee[uniswapV2Pair] = true;
        _isExcludedFromFee[address(uniswapV2Router)] = true;

        //exclude from reflections
        excludeFromReward(address(this));
        excludeFromReward(uniswapV2Pair);
        excludeFromReward(address(uniswapV2Router));
        excludeFromReward(_bountyAddress);
        excludeFromReward(_marketingAddress);
        excludeFromReward(_ownersAddress);
        excludeFromReward(_charityAddress);
        excludeFromReward(_developerAddress);
        excludeFromReward(_lolaAddress);
        excludeFromReward(_posAddress);

        // Ignored by anti whale code
        _isExcludedFromAntiWhale[address(this)] = true;
        _isExcludedFromAntiWhale[owner()] = true;
        _isExcludedFromAntiWhale[_marketingAddress] = true;
        _isExcludedFromAntiWhale[_charityAddress] = true;
        _isExcludedFromAntiWhale[_developerAddress] = true;
        _isExcludedFromAntiWhale[_ownersAddress] = true;
        _isExcludedFromAntiWhale[_bountyAddress] = true;
        _isExcludedFromAntiWhale[uniswapV2Pair] = true;
        _isExcludedFromAntiWhale[_lolaAddress] = true;
        _isExcludedFromAntiWhale[_posAddress] = true;
        _isExcludedFromAntiWhale[address(uniswapV2Router)] = true;

        // -----Init variables-------
        _maxTxAmount = 100_000_000 * 10**18;
        _maxWallet = 100_000_000 * 10**18;
        
        _div = 4;

        //Some merchants have custom fees
        customFees =
            FeeStructure({
                refl: 15,
                liq: 80,  
                bounty: 5
            });

        // default total fees of 1% over 10000
        sellFees =
            FeeStructure({
                refl: 15, // reflection fee
                liq: 80,  
                bounty: 5  
            });

        currentFees = sellFees;

        _previousReflectionFee = currentFees.refl;
        _previousBountyFee = currentFees.bounty;
        _previousLiquidityFee = currentFees.liq;


        //Swap and Liquify (SAL) set by lola
        minSalTokens = 50 * 10**18;

        _lockableAccountsProtection=true;

        //Anti Whale & limits
		_antiWhaleProtection = true;
		dynamicWhaleDiv = true;
		_maxWhaleTxAmount = _maxTxAmount;
		_sellTimeLimit = DAY;

        isKycEnabled = false;
		

        //Contract will create 1 anubit 
        _rOwned[owner()] = _rTotal;
        emit Transfer(address(0),owner(), _tTotal);
    }

    function lola() public view virtual returns (address) {
        return _lola;
    }

    function pos() public view virtual returns (address) {
        return _pos;
    }

    function service() public view virtual returns (address) {
        return _service;
    }

    /**
     * Remove address authorization. Owner only
     */
    function unauthorize(address account) public onlyOwner {
        authorizations[account] = false;
    }

    /**
     * Return address authorization status
     */
    function isAuthorized(address account) public view returns (bool) {
        return authorizations[account];
    }

   /**
     * Check if address is Lola
     */
    function isLola(address account) public view returns (bool) {
        return account == _lola;
    }

    /**
     * Check if address is POS
     */
    function isPos(address account) public view returns (bool) {
        return account == _pos;
    }

    /**
     * Check if address is Service
     */
    function isService(address account) public view returns (bool) {
        return account == _service;
    }


    /**
     * Authorize Lola address. Owner only
     */
    function authorizeLola(address account) public onlyOwner {
        authorizations[account] = true;
        _lola = account;
    }

    /**
     * Authorize POS address. Owner only
     */
    function authorizePos(address account) public onlyOwner {
        authorizations[account] = true;
        _pos = account;
    }

    /**
     * Authorize Bounty Service address. Owner only
     */
    function authorizeService(address account) public onlyOwner {
        authorizations[account] = true;
        _service = account;
    }

   function version() public pure virtual returns (string memory) {
        return "V2.4";
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "M280"));//transfer amount exceeds allowance
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "MC281"));//decreased allowance below zero
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _totalFees;
    }


    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "M66");//Amount must be less than supply
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "M67");//Amount must be less than total reflections
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }


    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        _takeLiquidity(sender,tLiquidity);
        _takeBounty(tBounty);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    


    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    


    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(
            10**2
        );
    }

    
     //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _totalFees = _totalFees.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tBounty, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBounty);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 tBounty = calculateBountyFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBounty);
        return (tTransferAmount, tFee, tLiquidity, tBounty);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rBounty = tBounty.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBounty);
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
    
    function _takeLiquidity(address sender, uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);

        if(_isExcluded[address(this)]){
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
        }

        if(tLiquidity != 0){
           emit Transfer(sender, address(this), tLiquidity); 
        }
        
    }
    
    function _takeBounty(uint256 tBounty) private {
        uint256 currentRate =  _getRate();
        uint256 rBounty = tBounty.mul(currentRate);
        _rOwned[_bountyAddress] = _rOwned[_bountyAddress].add(rBounty);
        if(_isExcluded[_bountyAddress]){
            _tOwned[_bountyAddress] = _tOwned[_bountyAddress].add(tBounty);
        }

        if(tBounty != 0){
         emit Transfer(address(this), _bountyAddress, tBounty);   
        }
        
    }
    


    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(currentFees.refl).div(
            (10**4)
        );
    }

    function calculateBountyFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(currentFees.bounty).div(
            (10**4)
        );
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(currentFees.liq).div(
            (10**4)
        );
    }
    


    function removeAllFee() private {

        if(currentFees.refl == 0 && currentFees.liq == 0) return;
        
        _previousReflectionFee = currentFees.refl;
        _previousBountyFee = currentFees.bounty;
        _previousLiquidityFee = currentFees.liq;
        
        currentFees.refl = 0;
        currentFees.bounty = 0;
        currentFees.liq = 0;
    }
    
    function restoreAllFee() private {
        currentFees.refl = _previousReflectionFee;
        currentFees.bounty = _previousBountyFee;
        currentFees.liq = _previousLiquidityFee;
    }
    
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "M333");//ERC20: approve from the zero address
        require(spender != address(0), "M334");//ERC20: approve to the zero address

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "M335");//ERC20: transfer from the zero address
        require(to != address(0), "M336");//ERC20: transfer to the zero address
        require(amount > 0, "M337");//Transfer amount must be greater than zero
        if(from != owner() && to != owner()){require(amount <= _maxTxAmount, "M338");}//Transfer amount exceeds the maxTxAmount.
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "M339");//blacklisted

        //if(_merchantSellFee[from] == true){
        //    revert("M77 Contact anubit.com");
        //}

        if ((_isExcludedFromFee[from] != true) || (_isExcludedFromFee[to] != true)) {
            require(_tradingEnabled, "Paused");
        }

        // Time locked accounts handler
        if (_lockableAccountsProtection && _isLocked[from]) {
            // lets check if this wallet is locked
            if (block.timestamp > _lockTime[from]) {
                _isLocked[msg.sender] = false;
                _lockTime[msg.sender] = 0;
            }
			
            require(!_isLocked[from], "M116"); //token transfer from locked account
            require(!_isLocked[to], "M117"); //token transfer to locked account
            require(!_isLocked[msg.sender], "M118"); //token transfer called from locked account
        }

        //Anti whale protection
        if (_antiWhaleProtection) {


            if (to != uniswapV2Pair) {
                //buy
                require(balanceOf(to).add(amount) <= _maxWallet, "E200"); //Transfer exceeds max
            } else {
                if(_isExcludedFromAntiWhale[from] == false){

                    //sell
                    if(_sellIntervalStart[from] != 0){
                        if(_sellIntervalStart[from].add(_sellTimeLimit) < block.timestamp){
                            _allowedTxAmount[from] = _maxWhaleTxAmount;
                            _sellIntervalStart[from] = block.timestamp;
                        }
                    }
                    if(_allowedTxAmount[from] == 0 && _sellIntervalStart[from] == 0){
                        _allowedTxAmount[from] = _maxWhaleTxAmount;
                        _sellIntervalStart[from] = block.timestamp;
                    }
                    if(amount > _allowedTxAmount[from]){
                        revert("M43");
                    }else{
                        if(_allowedTxAmount[from].sub(amount) <= 0){
                            _allowedTxAmount[from] = 0;
                        }else{
                            _allowedTxAmount[from] = _allowedTxAmount[from].sub(amount); 
                        }
                    }
                }
            }


        }
       
       //SAL management
        uint256 contractTokenBalance = balanceOf(address(this));
        if(contractTokenBalance >= _maxTxAmount)
        {
            contractTokenBalance = _maxTxAmount;
        }

        bool overMinTokenBalance = contractTokenBalance >= minSalTokens;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }
        
        //should be deducted from transfer?
        bool takeFee = true;


        //if any account belongs to _isExcludedFromFee account then remove the fee
        //if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
        //    takeFee = false;
        //}

        //is this a buy or sell    
        if (to == uniswapV2Pair) {
            //sell
            takeFee = true;
        } else if (from == uniswapV2Pair) {
            //buy
            takeFee = false;
        } else {
            //standard transfer
            takeFee = true;
        }    
        

        
        addBountyAddress(from);
        addBountyAddress(to);

        //transfer tokens with fees if any
        _tokenTransfer(from,to,amount,takeFee);
    }

    function addBountyAddress(address adr) private {
        if (_bountyAddressExists[adr]) return;
        _bountyAddressExists[adr] = true;
        _bountyAddressList.push(adr);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {

        uint256 tokensToAddLiquidityWith = contractTokenBalance.mul(_liquidity).div(80);

        uint256 toSwap = contractTokenBalance.sub(tokensToAddLiquidityWith);

        uint256 initialBalance = address(this).balance;

        // swap tokens for BNB
        swapTokensForBnb(toSwap,address(this));

        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 BNBToAddLiquidityWith = deltaBalance.mul(_liquidity).div(80);

        // add liquidity and burn LP tokens permanantly lock liquidity
        addLiquidity(tokensToAddLiquidityWith, BNBToAddLiquidityWith,_dEaD);

        // we give the remaining tax to dev, owners, marketing & charity wallets
        uint256 remainingBalance = address(this).balance;

        uint256 developerFee = remainingBalance.mul(_developer).div(80);
        uint256 ownersFee = remainingBalance.mul(_owners).div(80);
        uint256 marketingFee = remainingBalance.mul(_marketing).div(80);
        uint256 charityFee = remainingBalance.mul(_charity).div(80);

        transferToAddressBnb(_developerAddress, developerFee);
        transferToAddressBnb(_ownersAddress, ownersFee);
        transferToAddressBnb(_marketingAddress, marketingFee);
        transferToAddressBnb(_charityAddress, charityFee);
        
        emit SwapAndLiquify(toSwap, tokensToAddLiquidityWith, BNBToAddLiquidityWith);
    }

    function transferToAddressBnb(address payable recipient, uint256 amount) private {
        recipient.transfer(amount);
    }

    function swapTokensForBnb(uint256 tokenAmount, address recipient) private {
  
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            recipient,
            block.timestamp + 20 seconds
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount, address recipient) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, 
            0,
            recipient,
            block.timestamp
        );
    }


    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if(!takeFee){
            removeAllFee();
        }

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
        
        if(!takeFee){
            restoreAllFee();
        }
            
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeLiquidity(sender,tLiquidity);
        _takeBounty(tBounty);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
        _takeLiquidity(sender,tLiquidity);
        _takeBounty(tBounty);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBounty) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
        _takeLiquidity(sender,tLiquidity);
        _takeBounty(tBounty);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function excludeFromReward(address account) public onlyOwner() {
        require(!_isExcluded[account], "M450");//Account is already excluded
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) public onlyOwner() {
        require(_isExcluded[account], "M451");//Account is already included
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



    // Blacklist/unblacklist an address
    function blacklistAddress(address _address, bool _value) public onlyOwner {
        _isBlacklisted[_address] = _value;
    }



    function setSalMin(uint256 _minSalTokens) external onlyOwner {
        minSalTokens = _minSalTokens;
    }


    //Minting
    function mint(uint256 amount) public onlyOwner {
        _mint( amount);
    }

    function _mint( uint256 amount) private  {
        require((_tTotal + amount) <= _maxSupply, "CE");//cap exceeded

        uint256 rate = _getRate();

        _tTotal += amount;
        _rTotal += amount * rate;

        rate = _getRate();
        
        _tOwned[owner()] = _tOwned[owner()].add(amount);
        rate = _getRate();
        uint256 rAmount = amount.mul(rate);
        _rOwned[owner()] += rAmount;
        emit Transfer(address(0), owner(), amount);
    }

    function multiLock(
        address[] memory wallets,
        bool lockWallet
    ) external onlyOwner {
        require(wallets.length < 600, "E310"); 

        uint256 defaultLockTime = block.timestamp + 365 days;

        for (uint256 i = 0; i < wallets.length; i++) {
            
			address wallet = wallets[i];
            
            _lockTime[wallet] = lockWallet ? defaultLockTime : 0;
            _isLocked[wallet] = lockWallet;
            
        }
       
    }

    function mintDrop(
        address[] memory wallets,
        uint256[] memory amountsInTokens
    ) external onlyOwner {
        require(wallets.length == amountsInTokens.length, "E309"); //arrays must be the same length
        require(wallets.length < 600, "E310"); //Can only airdrop 600 wallets per txn due to gas limits

        
        uint256 mintAmount;
        for (uint256 i = 0; i < amountsInTokens.length; i++) {
            mintAmount += amountsInTokens[i];
        }
        
        _mint(mintAmount);

       removeAllFee();
        for (uint256 i = 0; i < wallets.length; i++) {
            address wallet = wallets[i];
            uint256 amount = amountsInTokens[i];
            
            _tokenTransfer(owner(),wallet,amount,false);

            emit MintDrop(wallet, amount);
        }
        restoreAllFee();

    }


    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(newAddress != address(uniswapV2Router),"ER551");

        uniswapV2Router = IUniswapV2Router02(newAddress);
        address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Pair = _uniswapV2Pair;
    }


    //SAL 
    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    function manualSwap(uint256 amount) external onlyOwner {
        swapAndLiquify(amount);
    }

    // Helper functions
    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountBNB = address(this).balance;
        payable(msg.sender).transfer((amountBNB * amountPercentage) / 100);
    }

    function setKycStatus(bool _enabled) external onlyOwner {
        isKycEnabled = _enabled;
    }

    function setLockableAccountsProtection(bool _enabled) external onlyOwner {
        _lockableAccountsProtection = _enabled;
    }

    function setTrading(bool enabled) external onlyOwner {
        _tradingEnabled = enabled;
        swapAndLiquifyEnabled = enabled;
        restoreAllFee();
    }

    function setMaxTx(uint256 maxTxAmount) external onlyOwner {
        require(maxTxAmount > 0, "E308"); //max tx too low
        _maxTxAmount = maxTxAmount;
    }

    // Whale protection
    function setAntiWhaleProtection(bool _enabled) external onlyOwner {
        _antiWhaleProtection = _enabled;
    }
    function whaleSellTimeLimit( uint256 time) public onlyOwner {
        _sellTimeLimit = time;
    }
    function setIsWhaleExempt(address adr, bool exempt) external onlyOwner {
        _isExcludedFromAntiWhale[adr] = exempt;
    }

    function setMaxWhaleTxAmount(uint256 amount) external onlyOwner  {
        require(amount > 0, "E304");
        _maxWhaleTxAmount = amount;
    }  

    function setMaxWalletAmount(uint256 amount) external onlyOwner {
        require(amount > 0, "E304");
        _maxWallet = amount;
    }  

    //Timelocks
    function timelock(address _lockAccount, uint256 time) public onlyOwner {
        return _timelock(_lockAccount, time);
    }
    function unlock(address _lockAccount) public onlyOwner {
        _isLocked[_lockAccount] = false;
        _lockTime[_lockAccount] = 0;
    }
    function _timelock(address _lockAccount, uint256 time) private onlyOwner {
        _isLocked[_lockAccount] = true;
        _lockTime[_lockAccount] = block.timestamp + time;
    }
    function increaseLockTime(address _lockAccount, uint256 _secondsToIncrease) public onlyOwner {
        _lockTime[_lockAccount] = _lockTime[_lockAccount].add(_secondsToIncrease);
    }

    function lockedAccountDetails(address account) public view returns (uint256, uint256,bool) {
        uint256 currentTime = block.timestamp;
        uint256 unlockTime = _lockTime[account];
        bool locked = _isLocked[account];
        return (unlockTime, currentTime, locked);
    }


    // Messaging
    function enableMessaging(bool _enabled) external onlyOwner {
        isMessagingEnabled = _enabled;
    }

    function setMessageId(address _address, uint256 msgID) public onlyPos {
        _msgID[_address] = msgID;
        emit MessageSet(_address, msgID);
    }


    //LOLA
    function lolaAddressChange(address payable lolaAddress) external onlyLola {
        require(lolaAddress != address(0), "M49");//cant set LOLA to address 0
        _lolaAddress = lolaAddress;
    }
    function lolaMintSwap(uint256 amount, address bnbRecipient) external onlyLola lockTheSwap {
        //LOLA mints then swaps for bnb
        _mint(amount);
        swapTokensForBnb(amount,bnbRecipient);
    }


    //Anubit merchants
    function posAddressChange(address payable posAddress) external onlyOwner {
        require(posAddress != address(0), "M30");//cant set POS to address 0
        _posAddress = posAddress;
    }

	function merchantDetails(address account) public view returns (bool, bool,uint8) {
        bool isMerchant = _isMerchant[account];
        bool hasFee = _merchantSellFee[account];
        uint8 div = _div;
        return (isMerchant, hasFee, div);
    }

    function merchantDisable(address account) public onlyOwner {
        _isMerchant[account] = false;
        _merchantSellFee[account] = false;
        customDiv[account] = _div;
    }

    function posTransaction(
        address merchantAddress,
        address customerAddress,
        address gratAddress,
        uint256 txAmount,
        bool hasGratuity,
        uint256 gratAmount,
        uint256 gasFee,
        uint256 transactionID,
        bool takeFees
    ) external onlyPos {
  
        _tokenTransfer(customerAddress, merchantAddress, txAmount, takeFees);
        
        if(gasFee != 0){
            _tokenTransfer(merchantAddress, _posAddress, gasFee, false);
        }

        if (hasGratuity) {
            _tokenTransfer(merchantAddress, gratAddress, gratAmount, false);
        }

        emit PosTx(merchantAddress, customerAddress, gratAddress, txAmount, hasGratuity, gratAmount, gasFee, transactionID, takeFees);
    }

    function posGetAnubits(address recipient, uint256 amount) external onlyPos {
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(this);

        _approve(address(this), address(uniswapV2Router), amount);

        uniswapV2Router.swapExactETHForTokens{value: amount}(0, path, recipient, block.timestamp.add(300));
        emit GetAnubits(recipient, amount);
    }

    function posMerchantDistribute(
        address merchantAddress,
        address[] memory wallets,
        uint256[] memory amountsInTokens,
        bool[] memory takeFees,
        uint256 gasFee
    ) external onlyPos {
        require(wallets.length == amountsInTokens.length, "E500"); //arrays must be the same length
        require(wallets.length < 600, "E501"); //600 wallets per txn due to gas limits

        for (uint256 i = 0; i < wallets.length; i++) {
            address wallet = wallets[i];
            uint256 amount = amountsInTokens[i];
            bool fees = takeFees[i];
            require(_merchantPoolAmount[merchantAddress] > 0, "E503"); //Balance less than zero
            _tokenTransfer(merchantAddress, wallet, amount, fees);
        }

        if (gasFee > 0) {
            _tokenTransfer(merchantAddress, _posAddress, gasFee, false);
        }
    }

    function circulatingSupply() public view returns (uint256) {
        uint256 excluded = balanceOf(address(this)).add(balanceOf(owner()));
        return _tTotal.sub(excluded);
    }


    function maxSupply() public pure returns (uint256) {
        return _maxSupply;
    }


 function multiBlacklist(
        address[] memory wallets,
        bool status
    ) external onlyOwner {
        for (uint256 i = 0; i < wallets.length; i++) {
			address wallet = wallets[i];
            _isBlacklisted[wallet] = status;
  
        }
       
    }

	function isBlackListed(address account) public view returns (bool) {
        return (_isBlacklisted[account]);
    }

    function setMerchant(
        address[] memory wallets
    ) external onlyOwner {

        for (uint256 i = 0; i < wallets.length; i++) {
            _merchantSellFee[wallets[i]] = true;
        }
       
    }

}