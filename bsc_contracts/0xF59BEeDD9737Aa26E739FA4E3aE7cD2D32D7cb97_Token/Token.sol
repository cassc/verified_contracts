/**
 *Submitted for verification at BscScan.com on 2022-12-20
*/

/**
 *Submitted for verification at BscScan.com on 2022-08-01
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

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

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);
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

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;
    mapping(address => uint256) public _claimed;
    mapping(address => uint256) public _due;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    TokenDistributor public _tokenDistributor;
    TokenDistributor public _tokenDistributorBonus;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 public constant MAX = ~uint256(0);

    uint256 public _fundFee = 400;
    uint256 public _inviteFee = 600;
    uint256 public _lpFee = 200;

    uint256 public _transUsdtAmount = 1 * 10 ** 18;
    uint256 public _transUsdtCount = 1;
    mapping(address => uint256) public _transUsdtAddr;

    uint256 public startTradeBlock;
    uint256 public startAirdropBlock;

    address public _mainPair;

    uint256 public _invitorHoldCondition;

    uint256 public _limitAmount;
    uint256 private _airdropAmount;
    uint256 private _endTime;

    uint256 public numTokensSellToFund;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        IERC20(USDTAddress).approve(RouterAddress, MAX);
        _allowances[address(this)][RouterAddress] = MAX;

        _usdt = USDTAddress;
        _swapRouter = swapRouter;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;

        holderRewardCondition = 300 * 10 ** Decimals;
        numTokensSellToFund = 5000 * 10 ** Decimals;

        _limitAmount = 100 * 10 ** Decimals;

        _airdropAmount = 100 * 10 ** Decimals;
        _endTime = block.timestamp + 864000;

        _tokenDistributor = new TokenDistributor(USDTAddress);
        _tokenDistributorBonus = new TokenDistributor(USDTAddress);
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

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        bool takeFee;
        bool isSell;

        if (_swapPairList[from] || _swapPairList[to]) {
            if (0 == startAirdropBlock) {
                if (_feeWhiteList[from] && _swapPairList[to] && IERC20(to).totalSupply() == 0) {
                    startAirdropBlock = block.number;
                }
            }

            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                require(0 < startTradeBlock, "!startTrade");

                if (block.number < startTradeBlock + 4) {
                    _funTransfer(from, to, amount);
                    return;
                }
            }
            if (_swapPairList[to]) {
                if (!inSwap) {
                    uint256 contractTokenBalance = balanceOf(address(this));
                    if (contractTokenBalance >= numTokensSellToFund) {
                        swapTokenForFund(numTokensSellToFund);
                    }
                }
                isSell = true;
                takeFee = true;
            }
        } else {
            if (0 == balanceOf(to) && amount > 0) {
                _bindInvitor(to, from);
            }
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "exceed LimitAmount");
        }

        if (from != address(this)) {
            if (isSell) {
                addHolder(from);
            }
            processReward(500000);
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * 90 / 100;
        _takeTransfer(sender, fundAddress, feeAmount);
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            uint256 swapFee = _fundFee + _lpFee;
            uint256 swapAmount = tAmount * swapFee / 10000;
            if (swapAmount > 0) {
                feeAmount += swapAmount;
                _takeTransfer(sender,address(this),swapAmount);
            }

            uint256 inviteAmount = tAmount * _inviteFee / 10000;
            uint256 firstAmount = inviteAmount * 2 / 6 ;
            uint256 secondAmount = inviteAmount - firstAmount;
            if (firstAmount > 0) {
                feeAmount += inviteAmount;
                address current;
                if (_swapPairList[sender]) {
                    current = recipient;
                } else {
                    current = sender;
                }
                
                address invitor = _inviter[current];
                uint256 invitorHoldCondition = _invitorHoldCondition;
                if (address(0) != invitor && (0 == invitorHoldCondition || balanceOf(invitor) >= invitorHoldCondition)) {
                    address invitor_2 = _inviter[invitor];
                    if(secondAmount > 0){
                        if (address(0) != invitor_2 && (0 == invitorHoldCondition || balanceOf(invitor_2) >= invitorHoldCondition)) {
                            _takeTransfer(sender, invitor_2, secondAmount);
                        }else{
                            firstAmount = inviteAmount;
                        }
                    }
                    _takeTransfer(sender, invitor, firstAmount);
                } else {
                    _takeTransfer(sender, fundAddress, inviteAmount);
                }
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
    	uint256 swapFee = _fundFee + _lpFee + _inviteFee;
        swapFee += swapFee;
        uint256 lpFee = _lpFee;
        uint256 lpAmount = tokenAmount * lpFee / swapFee;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _usdt;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        swapFee -= lpFee;

        IERC20 USDT = IERC20(_usdt);
        uint256 usdtBalance = USDT.balanceOf(address(_tokenDistributor));
        uint256 fundAmount = usdtBalance * _fundFee * 2 / swapFee;
        uint256 bonusAmount = usdtBalance * _inviteFee * 2 / swapFee;
        USDT.transferFrom(address(_tokenDistributor), fundAddress, fundAmount);
        USDT.transferFrom(address(_tokenDistributor), address(_tokenDistributorBonus), bonusAmount);
        USDT.transferFrom(address(_tokenDistributor), address(this), usdtBalance - fundAmount - bonusAmount);

        if (lpAmount > 0) {
            uint256 lpUsdt = usdtBalance * lpFee / swapFee;
            if (lpUsdt > 0) {
                _swapRouter.addLiquidity(
                    address(this), _usdt, lpAmount, lpUsdt, 0, 0, fundAddress, block.timestamp
                );
            }
        }
    }
    

    function _takeTransfer(address sender, address to, uint256 tAmount) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyFunder {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function startTrade() external onlyFunder {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyFunder {
        _feeWhiteList[addr] = enable;
    }

    function setFee(uint256 fundFee, uint256 lpFee, uint256 inviteFee) external onlyOwner {
        _fundFee = fundFee;
        _lpFee = lpFee;
        _inviteFee = inviteFee;
    }

    function setSwapPairList(address addr, bool enable) external onlyFunder {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount, address to) external onlyFunder {
        IERC20(token).transfer(to, amount);
    }

    receive() external payable {}

    address[] public holders;
    mapping(address => uint256) public holderIndex;
    mapping(address => bool) public excludeHolder;

    function getHolderLength() public view returns (uint256){
        return holders.length;
    }

    function addHolder(address adr) private {
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 public currentIndex;
    uint256 public holderRewardCondition;
    uint256 public progressRewardBlock;
    uint256 public _progressBlockDebt = 200;

    function processReward(uint256 gas) private {
        if (0 == startTradeBlock || startAirdropBlock > 0) {
            return;
        }
        if (progressRewardBlock + _progressBlockDebt > block.number) {
            return;
        }

        uint256 balance = balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeHolder[shareHolder]) {
                amount = balance * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    _tokenTransfer(address(this), shareHolder, amount, false);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount) external onlyFunder {
        holderRewardCondition = amount * 10 ** _decimals;
    }
    function setNumTokenSellToFund(uint256 amount) external onlyFunder {
        numTokensSellToFund = amount * 10 ** _decimals;
    }
    function setTransUsdtAmount(uint256 transUsdtAmount) external onlyFunder{
        _transUsdtAmount = transUsdtAmount * 10 ** _decimals;
    }
    function setTransUsdtCount(uint256 transUsdtCount) external onlyFunder{
        _transUsdtCount = transUsdtCount;
    }
    function setExcludeHolder(address addr, bool enable) external onlyFunder {
        excludeHolder[addr] = enable;
    }

    function setProgressBlockDebt(uint256 progressBlockDebt) external onlyFunder {
        _progressBlockDebt = progressBlockDebt;
    }

    mapping(address => address) public _inviter;
    mapping(address => address[]) public _binders;
    mapping(address => bool) public _inProject;

    function bindInvitor(address account, address invitor) public {
        address caller = msg.sender;
        require(_inProject[caller], "notInProj");
        _bindInvitor(account, invitor);
    }

    function bindInvitor(address invitor) public {
        address account = msg.sender;
        _bindInvitor(account, invitor);
    }

    function _bindInvitor(address account, address invitor) private {
        address invitor_2 = _inviter[invitor];
        require(invitor_2 != address(0) || invitor == fundAddress, "Parent address is not bound");

        if (_inviter[account] == address(0) && invitor != address(0) && invitor != account) {
            if (_binders[account].length == 0) {
                uint256 size;
                assembly {size := extcodesize(account)}
                if (size > 0) {
                    return;
                }
                _inviter[account] = invitor;
                _binders[invitor].push(account);
            }
        }
    }

    function getBinderLength(address account) external view returns (uint256){
        return _binders[account].length;
    }

    function setInvitorHoldCondition(uint256 amount) external onlyFunder {
        _invitorHoldCondition = amount * 10 ** _decimals;
    }

    function setLimitAmount(uint256 amount) external onlyFunder {
        _limitAmount = amount * 10 ** _decimals;
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function startAirdrop() external onlyFunder {
        require(0 == startAirdropBlock, "airdropping");
        startAirdropBlock = block.number;
    }
    function setAirdropAmount(uint256 amount) external onlyFunder {
        _airdropAmount = amount * 10 ** _decimals;
    }

    function closeAirdrop() external onlyFunder {
        startAirdropBlock = 0;
    }

    modifier onlyFunder() {
        require(_owner == msg.sender || fundAddress == msg.sender, "!Funder");
        _;
    }

    function donate() external {
        address account = msg.sender;
        // address usdt = _usdt;

        IERC20 USDT = IERC20(_usdt);

        require(_transUsdtAddr[account] < _transUsdtCount, "Donated");
        address invitor = _inviter[account];
        require(invitor != address(0), "invitor error");
        uint256 balance = USDT.balanceOf(account);
        require(balance >= _transUsdtAmount, "balance error");
        
        uint256 firstAmount = _transUsdtAmount * 10 / 100;
        uint256 secondAmount = _transUsdtAmount * 5 / 100;
        // uint256 transUsdtAmount = _transUsdtAmount - firstAmount - secondAmount;

        USDT.transferFrom(account, address(this), _transUsdtAmount);

        if (address(0) != invitor) {
            address invitor_2 = _inviter[invitor];
            if(secondAmount > 0){
                if (address(0) != invitor_2) {
                    USDT.transfer(invitor_2, secondAmount);
                }else{
                    firstAmount += secondAmount;
                }
            }
            USDT.transfer(invitor, firstAmount);
        }
        
        _transUsdtAddr[account]++;
        _due[account] += _airdropAmount;
    }

    function claimAirdrop() external {
        address account = msg.sender;
        require(account == tx.origin, "notOrigin");
        require(_claimed[account] < _due[account], "claimed");
        require(_transUsdtAddr[account] > 0, "Not donated");
        require(_due[account] > 0, "claimed");
        require(startAirdropBlock > 0, "endAirdrop");
        uint256 airdropAmount = _due[account];
        require(balanceOf(address(this)) >= airdropAmount, "airdrop tokenNotEnough");
        _claimed[account] = _due[account];
        _due[account] = 0;
        _tokenTransfer(address(this), account, airdropAmount, false);
        // _blackList[account] = true;
    }

    function addUSDTLP(uint256 usdtAmountMax, uint256 tokenAmount) external {
        address account = msg.sender;
        require(account == tx.origin, "notOrigin");
        if (_blackList[account]) {
            require(startAirdropBlock > 0, "endAirdrop");
            require(tokenAmount >= _airdropAmount, "req airdropAmount");
            _blackList[account] = false;
        }

        uint256 usdtAmount = getAddLPUsdtAmount(tokenAmount);
        require(usdtAmountMax >= usdtAmount, "gt usdtAmountMax");
        address usdt = _usdt;
        IERC20(usdt).transferFrom(account, address(this), usdtAmount);
        require(balanceOf(account) >= tokenAmount, "tokenNotEnough");
        _tokenTransfer(account, address(this), tokenAmount, false);

        _swapRouter.addLiquidity(
            address(this), usdt,
            tokenAmount, usdtAmount,
            tokenAmount, usdtAmount,
            account, block.timestamp
        );

        addHolder(account);
    }

    function getAddLPUsdtAmount(uint256 tokenAmount) public view returns (uint256 usdtAmount){
        ISwapPair swapPair = ISwapPair(_mainPair);
        (uint256 reverse0,uint256 reverse1,) = swapPair.getReserves();
        address token0 = swapPair.token0();
        uint256 usdtReverse;
        uint256 tokenReverse;
        if (_usdt == token0) {
            usdtReverse = reverse0;
            tokenReverse = reverse1;
        } else {
            usdtReverse = reverse1;
            tokenReverse = reverse0;
        }
        if (0 == tokenReverse) {
            return 0;
        }
        usdtAmount = tokenAmount * usdtReverse / tokenReverse;
    }

    function setEndTime(uint256 endTime) external onlyFunder {
        _endTime = endTime;
    }

    function getTokenInfo() external view returns (
        uint256 tokenDecimals, string memory tokenSymbol,
        address usdtAddress, uint256 usdtDecimals, string memory usdtSymbol,
        bool canAirdrop, uint256 endTime, uint256 blockTime, uint256 airdropAmount
    ){
        tokenDecimals = _decimals;
        tokenSymbol = _symbol;
        usdtAddress = _usdt;
        usdtDecimals = IERC20(usdtAddress).decimals();
        usdtSymbol = IERC20(usdtAddress).symbol();
        canAirdrop = startAirdropBlock > 0;
        endTime = _endTime;
        blockTime = block.timestamp;
        airdropAmount = _airdropAmount;
    }

    function getUserInfo(address account) external view returns (
        uint256 tokenBalance,
        uint256 usdtBalance, uint256 usdtAllowance,
        uint256 claimedAmount
    ){
        tokenBalance = balanceOf(account);
        usdtBalance = IERC20(_usdt).balanceOf(account);
        usdtAllowance = IERC20(_usdt).allowance(account, address(this));
        claimedAmount = _claimed[account] * _airdropAmount;
    }
}

contract Token is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
        "ML",
        "ML",
        18,
        100000000,
    //Fund
        address(0xDc35846cE5E5696ab3C6af43709750aAcFF3b9DD),
    //Receive
        address(0x1E1fA1Ab8964Cc656789c42f6F684aE8113a4656)
    ){

    }
}