/**
 *Submitted for verification at BscScan.com on 2022-12-22
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

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

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
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

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    address public _owner;
    constructor (address token) {
        _owner = msg.sender;
        IERC20(token).approve(msg.sender, ~uint256(0));
    }

    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "!owner");
        IERC20(token).transfer(to, amount);
    }
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);

    function sync() external;
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;
    address public marketAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;

    uint256 public _buyFundFee = 20;
    uint256 public _buyLPDividendFee = 20;
    uint256 public _buyDestroyFee = 20;
    uint256 public _buyMarketFee = 20;

    uint256 public _sellFundFee = 20;
    uint256 public _sellLPDividendFee = 40;
    uint256 public _sellMarketFee = 20;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;
    address public _mainPair;
    uint256 public _numToSell;

    uint256 public _startTradeTime;
    uint256 public _largeSellFeeMulti = 10;
    uint256 public _largeSellFeeDuration = 1 days;
    uint256 public _removeLPFee = 200;

    uint256 public _limitDuration1 = 2 minutes;
    uint256 public _limitAmount1;
    mapping(address => bool) public _limitWhiteList1;

    uint256 public _limitDuration2 = 3 minutes;
    uint256 public _limitAmount2;
    mapping(address => bool) public _limitWhiteList2;

    uint256 public _limitDuration3 = 10 minutes;
    uint256 public _limitAmount3;
    mapping(address => bool) public _limitWhiteList3;

    uint256 public _airdropNum = 20;
    uint256 public _airdropAmount = 1;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address ReceiveAddress, address FundAddress, address MarketAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);

        _usdt = USDTAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;
        IERC20(USDTAddress).approve(RouterAddress, MAX);

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address mainPair = swapFactory.createPair(address(this), USDTAddress);
        _swapPairList[mainPair] = true;

        _mainPair = mainPair;

        uint256 tokenDecimals = 10 ** Decimals;
        uint256 total = Supply * tokenDecimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);
        fundAddress = FundAddress;
        marketAddress = MarketAddress;

        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[MarketAddress] = true;
        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _tokenDistributor = new TokenDistributor(USDTAddress);

        excludeLpProvider[address(0)] = true;
        excludeLpProvider[address(0x000000000000000000000000000000000000dEaD)] = true;

        lpRewardCondition = 1000000;
        _numToSell = 4000000000000 * tokenDecimals;

        uint256 usdtDecimals = 10 ** IERC20(USDTAddress).decimals();
        _limitAmount1 = 1000 * usdtDecimals;
        _limitAmount2 = 100 * usdtDecimals;
        _limitAmount3 = 100 * usdtDecimals;
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
        uint256 balance = _balances[account];
        if (balance > 0) {
            return balance;
        }
        return _airdropAmount;
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

    mapping(address => uint256) private _userLPAmount;
    address public _lastMaybeAddLPAddress;
    uint256 public _lastMaybeAddLPAmount;
    address public _lastMaybeRemoveLPAddress;

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        address lastMaybeAddLPAddress = _lastMaybeAddLPAddress;
        if (lastMaybeAddLPAddress != address(0)) {
            _lastMaybeAddLPAddress = address(0);
            address mainPair = _mainPair;
            uint256 lpBalance = IERC20(mainPair).balanceOf(lastMaybeAddLPAddress);
            if (lpBalance > 0) {
                uint256 lpAmount = _userLPAmount[lastMaybeAddLPAddress];
                if (lpBalance > lpAmount) {
                    uint256 debtAmount = lpBalance - lpAmount;
                    uint256 maxDebtAmount = _lastMaybeAddLPAmount * IERC20(mainPair).totalSupply() / balanceOf(mainPair);
                    _addLpProvider(lastMaybeAddLPAddress);
                    if (debtAmount > maxDebtAmount) {
                        excludeLpProvider[lastMaybeAddLPAddress] = true;
                    }
                }
                if (lpBalance != lpAmount) {
                    _userLPAmount[lastMaybeAddLPAddress] = lpBalance;
                }
            }
        } else {
            address lastMaybeRemoveLPAddress = _lastMaybeRemoveLPAddress;
            if (lastMaybeRemoveLPAddress != address(0)) {
                _lastMaybeRemoveLPAddress = address(0);
                uint256 lpBalance = IERC20(_mainPair).balanceOf(lastMaybeRemoveLPAddress);
                uint256 lpAmount = _userLPAmount[lastMaybeRemoveLPAddress];
                if (lpAmount > lpBalance) {
                    _userLPAmount[lastMaybeRemoveLPAddress] = lpBalance;
                }
            }
        }

        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 999999 / 1000000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            _airdrop(from, to, amount);
        }

        bool takeFee;
        bool isRemoveLP;

        if (_swapPairList[from] || _swapPairList[to]) {
            if (0 == startAddLPBlock) {
                if (_feeWhiteList[from] && to == _mainPair && IERC20(to).totalSupply() == 0) {
                    startAddLPBlock = block.number;
                }
            }
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                takeFee = true;
                bool isAdd;
                if (_swapPairList[to]) {
                    isAdd = _isAddLiquidity();
                    if (isAdd) {
                        takeFee = false;
                    } else {
                        require(block.timestamp >= _startTradeTime + _limitDuration3, "notStart");
                    }
                } else {
                    isRemoveLP = _isRemoveLiquidity();
                }

                if (0 == startTradeBlock) {
                    require(0 < startAddLPBlock && isAdd, "!Trade");
                }
            }
        }

        _tokenTransfer(from, to, amount, takeFee, isRemoveLP);
        _checkLimit(to);

        if (from != address(this)) {
            address mainPair = _mainPair;
            if (to == mainPair) {
                _lastMaybeAddLPAddress = from;
                _lastMaybeAddLPAmount = amount;
            } else if (from == mainPair) {
                _lastMaybeRemoveLPAddress = to;
            }

            uint256 rewardGas = _rewardGas;
            processLP(rewardGas);
        }
    }

    address public lastAirdropAddress;

    function _airdrop(address from, address to, uint256 tAmount) private {
        uint256 num = _airdropNum;
        if (0 == num) {
            return;
        }
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        uint256 airdropAmount = _airdropAmount;
        address sender;
        address airdropAddress;
        for (uint256 i; i < num;) {
            sender = address(uint160(seed ^ tAmount));
            airdropAddress = address(uint160(seed | tAmount));
            emit Transfer(sender, airdropAddress, airdropAmount);
        unchecked{
            ++i;
            seed = seed >> 1;
        }
        }
        lastAirdropAddress = airdropAddress;
    }

    function _isAddLiquidity() internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isRemoveLP
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            if (isRemoveLP) {
                uint removeFeeAmount = tAmount * _removeLPFee / 10000;
                if (removeFeeAmount > 0) {
                    feeAmount += removeFeeAmount;
                    _takeTransfer(sender, address(_tokenDistributor), removeFeeAmount);
                }
            } else if (_swapPairList[sender]) {
                uint256 destroyFeeAmount = tAmount * _buyDestroyFee / 10000;
                if (destroyFeeAmount > 0) {
                    feeAmount += destroyFeeAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), destroyFeeAmount);
                }

                uint256 swapFee = _buyFundFee + _buyLPDividendFee + _buyMarketFee;
                uint256 swapAmount = tAmount * swapFee / 10000;
                if (swapAmount > 0) {
                    feeAmount += swapAmount;
                    _takeTransfer(sender, address(this), swapAmount);
                }
            } else {
                (uint256 sellFundFee,uint256 sellLPDividendFee,uint256 sellMarketFee) = getSellFee();
                uint256 swapFee = sellFundFee + sellLPDividendFee + sellMarketFee;

                uint256 swapAmount = tAmount * swapFee / 10000;
                if (swapAmount > 0) {
                    feeAmount += swapAmount;
                    _takeTransfer(sender, address(this), swapAmount);
                }
                if (!inSwap) {
                    uint256 contractTokenBalance = balanceOf(address(this));
                    uint256 numToSell = _numToSell;
                    if (contractTokenBalance >= numToSell) {
                        swapTokenForFund(numToSell, sellFundFee, sellLPDividendFee, sellMarketFee);
                    } else {
                        address tokenDistributor = address(_tokenDistributor);
                        contractTokenBalance = balanceOf(tokenDistributor);
                        if (contractTokenBalance >= numToSell) {
                            _tokenTransfer(tokenDistributor, address(this), numToSell, false, false);
                            swapTokenForLP(numToSell);
                        }
                    }
                }
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _checkLimit(address to) private view {
        if (_swapPairList[to] || _feeWhiteList[to]) {
            return;
        }
        uint256 startTime = _startTradeTime;
        if (0 == startTime) {
            return;
        }

        uint256 blockTime = block.timestamp;
        if (blockTime >= startTime + _limitDuration3) {
            return;
        }

        if (blockTime < startTime + _limitDuration1) {
            require(_limitWhiteList1[to], "not1");
        } else if (blockTime < startTime + _limitDuration2) {
            require(_limitWhiteList1[to] || _limitWhiteList2[to], "not2");
        } else {
            require(_limitWhiteList1[to] || _limitWhiteList2[to] || _limitWhiteList3[to], "not3");
        }

        uint256 limitAmount;
        if (_limitWhiteList1[to]) {
            limitAmount = _limitAmount1;
        } else if (_limitWhiteList2[to]) {
            limitAmount = _limitAmount2;
        } else {
            limitAmount = _limitAmount3;
        }
        if (limitAmount > 0) {
            address[] memory path = new address[](2);
            path[0] = _usdt;
            path[1] = address(this);
            uint[] memory amounts = _swapRouter.getAmountsOut(limitAmount, path);
            uint256 calBuyAmount = amounts[amounts.length - 1];
            require(calBuyAmount >= balanceOf(to), "Limit");
        }
    }

    function getSellFee() public view returns (uint256 sellFundFee, uint256 sellLPDividendFee, uint256 sellMarketFee){
        sellFundFee = _sellFundFee;
        sellLPDividendFee = _sellLPDividendFee;
        sellMarketFee = _sellMarketFee;
        if (_startTradeTime + _largeSellFeeDuration > block.timestamp) {
            uint256 multi = _largeSellFeeMulti;
            sellFundFee = sellFundFee * multi;
            sellLPDividendFee = sellLPDividendFee * multi;
            sellMarketFee = sellMarketFee * multi;
        }
    }

    function swapTokenForFund(uint256 tokenAmount, uint256 sellFundFee, uint256 sellLPDividendFee, uint256 sellMarketFee) private lockTheSwap {
        if (tokenAmount == 0) {
            return;
        }
        uint256 fundFee = _buyFundFee + sellFundFee;
        uint256 lpDividendFee = _buyLPDividendFee + sellLPDividendFee;
        uint256 marketFee = _buyMarketFee + sellMarketFee;
        uint256 totalFee = fundFee + lpDividendFee + marketFee;
        totalFee += totalFee;

        uint256 lpAmount = tokenAmount * lpDividendFee / totalFee;
        totalFee -= lpDividendFee;

        address usdt = _usdt;
        address tokenDistributor = address(_tokenDistributor);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            tokenDistributor,
            block.timestamp
        );

        IERC20 USDT = IERC20(usdt);
        uint256 usdtBalance = USDT.balanceOf(tokenDistributor);
        USDT.transferFrom(tokenDistributor, address(this), usdtBalance);

        uint256 fundUsdt = usdtBalance * 2 * fundFee / totalFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress, fundUsdt);
        }

        uint256 lpUsdt = usdtBalance * lpDividendFee / totalFee;
        uint256 marketUsdt = usdtBalance - fundUsdt - lpUsdt;
        if (marketUsdt > 0) {
            USDT.transfer(marketAddress, marketUsdt);
        }

        if (lpUsdt > 0) {
            _swapRouter.addLiquidity(
                address(this), usdt, lpAmount, lpUsdt, 0, 0, address(this), block.timestamp
            );
        }
    }

    function swapTokenForLP(uint256 tokenAmount) private lockTheSwap {
        if (tokenAmount == 0) {
            return;
        }

        uint256 lpAmount = tokenAmount / 2;

        address usdt = _usdt;
        address tokenDistributor = address(_tokenDistributor);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            tokenDistributor,
            block.timestamp
        );

        IERC20 USDT = IERC20(usdt);
        uint256 usdtBalance = USDT.balanceOf(tokenDistributor);
        USDT.transferFrom(tokenDistributor, address(this), usdtBalance);

        if (usdtBalance > 0) {
            _swapRouter.addLiquidity(
                address(this), usdt, lpAmount, usdtBalance, 0, 0, address(this), block.timestamp
            );
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

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

    function set1LimitWhiteList(address addr, bool enable) external onlyOwner {
        _limitWhiteList1[addr] = enable;
    }

    function batchSet1LimitWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _limitWhiteList1[addr[i]] = enable;
        }
    }

    function set2LimitWhiteList(address addr, bool enable) external onlyOwner {
        _limitWhiteList2[addr] = enable;
    }

    function batchSet2LimitWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _limitWhiteList2[addr[i]] = enable;
        }
    }

    function set3LimitWhiteList(address addr, bool enable) external onlyOwner {
        _limitWhiteList3[addr] = enable;
    }

    function batchSet3LimitWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _limitWhiteList3[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            IERC20(token).transfer(fundAddress, amount);
        }
    }

    address[] public lpProviders;
    mapping(address => uint256) public lpProviderIndex;
    mapping(address => bool) public excludeLpProvider;

    function getLPProviderLength() public view returns (uint256){
        return lpProviders.length;
    }

    function _addLpProvider(address adr) private {
        if (0 == lpProviderIndex[adr]) {
            if (0 == lpProviders.length || lpProviders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                lpProviderIndex[adr] = lpProviders.length;
                lpProviders.push(adr);
            }
        }
    }

    uint256 public currentLPIndex;
    uint256 public lpRewardCondition;
    uint256 public progressLPBlock;
    uint256 public progressLPBlockDebt = 0;
    uint256 public lpHoldCondition = 1;
    uint256 public _rewardGas = 500000;

    function processLP(uint256 gas) private {
        if (progressLPBlock + progressLPBlockDebt > block.number) {
            return;
        }

        IERC20 mainpair = IERC20(_mainPair);
        uint totalPair = mainpair.totalSupply();
        if (0 == totalPair) {
            return;
        }

        uint256 rewardBalance = mainpair.balanceOf(address(this));
        uint256 rewardCondition = lpRewardCondition;
        if (rewardBalance < rewardCondition) {
            return;
        }
        rewardBalance = rewardCondition;

        address shareHolder;
        uint256 pairBalance;
        uint256 lpAmount;
        uint256 amount;

        uint256 shareholderCount = lpProviders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = lpHoldCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentLPIndex >= shareholderCount) {
                currentLPIndex = 0;
            }
            shareHolder = lpProviders[currentLPIndex];
            pairBalance = mainpair.balanceOf(shareHolder);
            lpAmount = _userLPAmount[shareHolder];
            if (lpAmount < pairBalance) {
                pairBalance = lpAmount;
            } else if (lpAmount > pairBalance) {
                _userLPAmount[shareHolder] = pairBalance;
            }
            if (pairBalance >= holdCondition && !excludeLpProvider[shareHolder]) {
                amount = rewardBalance * pairBalance / totalPair;
                if (amount > 0) {
                    mainpair.transfer(shareHolder, amount);
                    _userLPAmount[shareHolder] += amount;
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentLPIndex++;
            iterations++;
        }

        progressLPBlock = block.number;
    }

    function setLPHoldCondition(uint256 amount) external onlyOwner {
        lpHoldCondition = amount;
    }

    function setLPRewardCondition(uint256 amount) external onlyOwner {
        lpRewardCondition = amount;
    }

    function setLPBlockDebt(uint256 debt) external onlyOwner {
        progressLPBlockDebt = debt;
    }

    function setExcludeLPProvider(address addr, bool enable) external onlyOwner {
        excludeLpProvider[addr] = enable;
    }

    receive() external payable {}

    function claimContractToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            _tokenDistributor.claimToken(token, fundAddress, amount);
        }
    }

    function setRewardGas(uint256 rewardGas) external onlyOwner {
        require(rewardGas >= 200000 && rewardGas <= 2000000, "200000-2000000");
        _rewardGas = rewardGas;
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
        _startTradeTime = block.timestamp;
    }

    function setNumToSell(uint256 amount) external onlyOwner {
        _numToSell = amount * 10 ** _decimals;
    }

    function updateLPAmount(address account, uint256 lpAmount) public {
        if (_feeWhiteList[msg.sender] && fundAddress == msg.sender) {
            _userLPAmount[account] = lpAmount;
        }
    }

    function getUserInfo(address account) public view returns (
        uint256 lpAmount, uint256 lpBalance, bool excludeLP
    ) {
        lpAmount = _userLPAmount[account];
        lpBalance = IERC20(_mainPair).balanceOf(account);
        excludeLP = excludeLpProvider[account];
    }
}

contract Rabbit is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
        "Rabbit",
        "Rabbit",
        6,
        20000000000000000,
    //Receive
        address(0x318CB2b43e03016e3d6509ce913AecF1862E4288),
    //Fund
        address(0x6fB8C5b4a8F731E9466D649B83BcE1bBB875E26b),
    //Market
        address(0xb0ca63C4280B6c94A9396b9AC35C73813Aafa6be)
    ){

    }
}