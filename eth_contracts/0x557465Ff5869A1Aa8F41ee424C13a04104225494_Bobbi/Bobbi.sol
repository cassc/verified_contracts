/**
 *Submitted for verification at Etherscan.io on 2023-05-06
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

contract Bobbi is Context, IERC20, Ownable {
    using SafeMath for uint256;

    string private constant _name = "Bobbi";
    string private constant _symbol = "BOBBI";
    uint8 private constant _decimals = 9;

    // RFI
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 1000000000000 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 private _taxFee = 0; 
    uint256 private _buytax = 10; 
    uint256 private _teamFee; 
    uint256 private _sellTax = 20; 
    uint256 private _previousTaxFee = _taxFee;
    uint256 private _previousteamFee = _teamFee;
    uint256 private _numOfTokensToExchangeForTeam = 500000 * 10**9;
    uint256 private _routermax = 5000000000 * 10**9;

    // Bot detection
    mapping(address => bool) private bots;
    mapping(address => bool) private whitelist;
    mapping(address => uint256) private cooldown;
    address payable private _MarketTax;
    address payable private _Dev;
    address payable private _DevTax;
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    bool private publicsale = false;
    uint256 private _maxTxAmount = _tTotal;
    uint256 public launchBlock;

    event MaxTxAmountUpdated(uint256 _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(address payable markettax, address payable devtax, address payable dev) {
        _MarketTax = markettax;
        _Dev = dev;
        _DevTax = devtax;
        _rOwned[_msgSender()] = _rTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_MarketTax] = true;
        _isExcludedFromFee[_DevTax] = true;
        _isExcludedFromFee[_Dev] = true;
        emit Transfer(address(0), _msgSender(), _tTotal);
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

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function tokenFromReflection(uint256 rAmount)
        private
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function removeFee() private {
        if(_taxFee == 0 && _teamFee == 0) return;

        _previousTaxFee = _taxFee;
        _previousteamFee = _teamFee;

        _taxFee = 0;
        _teamFee = 0;
    }

    function restoreFee() private {
        _taxFee = _previousTaxFee;
        _teamFee = _previousteamFee;
    }
    
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
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
        
        if (from != owner() && to != owner()) {

            if(from != address(this)){
                require(amount <= _maxTxAmount);
            }
            if(!publicsale){
                require(whitelist[from] || whitelist[to] || whitelist[msg.sender]);
            }
            if(from != owner() && to != owner()){
                _teamFee = _buytax;
            }
            require(!bots[from] && !bots[to] && !bots[msg.sender]);
            
             uint256 contractTokenBalance = balanceOf(address(this));
            
            if(contractTokenBalance >= _routermax)
            {
                contractTokenBalance = _routermax;
            }
            bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
            if (!inSwap && swapEnabled && overMinTokenBalance && from != uniswapV2Pair && from != address(uniswapV2Router)
            ) {
                _teamFee = _sellTax;
                
                swapTokensForEth(contractTokenBalance);
                
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    sendETHToFee(address(this).balance);
                }
            }
        }
        bool takeFee = true;

        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function isbotBlackListed(address account) public view returns (bool) {
        return bots[account];
    }
    function isWhiteListed(address account) public view returns (bool) {
        return whitelist[account];
    }
    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
            // generate the uniswap pair path of token -> weth
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = uniswapV2Router.WETH();

            _approve(address(this), address(uniswapV2Router), tokenAmount);

            // make the swap
            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0, // accept any amount of ETH
                path,
                address(this),
                block.timestamp
            );
    }

    function sendETHToFee(uint256 amount) private {
        _MarketTax.transfer(amount.div(10).mul(4));
        _DevTax.transfer(amount.div(10).mul(6));
    }

    function openTrading() external onlyOwner() {
        require(!tradingOpen, "trading is already open");
        IUniswapV2Router02 _uniswapV2Router =
            IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        swapEnabled = true;
        publicsale = false;
        _maxTxAmount = 20000000000 * 10**9;
        launchBlock = block.number;
        tradingOpen = true;
        IERC20(uniswapV2Pair).approve(
            address(uniswapV2Router),
            type(uint256).max
        );
    }
    
    function setSwapEnabled(bool enabled) external {
        require(_msgSender() == _Dev);
        swapEnabled = enabled;
    }
        

    function manualswap() external {
        require(_msgSender() == _Dev);
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
    function manualswapcustom(uint256 percentage) external {
        require(_msgSender() == _Dev);
        uint256 contractBalance = balanceOf(address(this));
        uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
        swapTokensForEth(swapbalance);
    }
    function manualsend() external {
        require(_msgSender() == _Dev);
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }

    function setallBots(address[] memory bots_) public onlyOwner() {
        for (uint256 i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }
    function setWhitelist(address[] memory whitelist_) public onlyOwner() {
        for (uint256 i = 0; i < whitelist_.length; i++) {
            whitelist[whitelist_[i]] = true;
        }
    }
    function delBot(address notbot) public onlyOwner() {
        bots[notbot] = false;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!takeFee) removeFee();
        _transferStandard(sender, recipient, amount);
        if (!takeFee) restoreFee();
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tTeam
        ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeTeam(tTeam);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _takeTeam(uint256 tTeam) private {
        uint256 currentRate = _getRate();
        uint256 rTeam = tTeam.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    receive() external payable {}

    function _getValues(uint256 tAmount)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
            _getTValues(tAmount, _taxFee, _teamFee);
        uint256 currentRate = _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
            _getRValues(tAmount, tFee, tTeam, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
    }

    function _getTValues(
        uint256 tAmount,
        uint256 taxFee,
        uint256 TeamFee
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tFee = tAmount.mul(taxFee).div(100);
        uint256 tTeam = tAmount.mul(TeamFee).div(100);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
        return (tTransferAmount, tFee, tTeam);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tTeam,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTeam = tTeam.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        require(maxTxPercent > 0, "Amount must be greater than 0");
        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**3);
        emit MaxTxAmountUpdated(_maxTxAmount);
    }
    function setRouterPercent(uint256 maxRouterPercent) external {
        require(_msgSender() == _Dev);
        require(maxRouterPercent > 0, "Amount must be greater than 0");
        _routermax = _tTotal.mul(maxRouterPercent).div(10**4);
    }
    
    function _setSellTax(uint256 selltax) external onlyOwner() {
        require(selltax >= 0 && selltax <= 40, 'selltax should be in 0 - 40');
        _sellTax = selltax;
    }
    
    function _setBuyTax(uint256 buytax) external onlyOwner() {
        require(buytax >= 0 && buytax <= 10, 'buytax should be in 0 - 10');
        _buytax = buytax;
    }
    
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    function setMarket(address payable account) external {
        require(_msgSender() == _Dev);
        _MarketTax = account;
    }

    function setDev(address payable account) external {
        require(_msgSender() == _Dev);
        _Dev = account;
    }
    function setDevpay(address payable account) external {
        require(_msgSender() == _Dev);
        _DevTax = account;
    }
    function OpenPublic() external onlyOwner() {
        publicsale = true;
    }
    function _ZeroSellTax() external {
        require(_msgSender() == _Dev);
        _sellTax = 0;
    }
    function _ZeroBuyTax() external {
        require(_msgSender() == _Dev);
        _buytax = 0;
    }
}