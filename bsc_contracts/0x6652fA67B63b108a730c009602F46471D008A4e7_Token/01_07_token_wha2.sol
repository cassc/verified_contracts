// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC20.sol';
import './IUniswapV2Router.sol';
contract TokenDistributor {
    constructor (address token) {
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
}
contract Token is ERC20 {
    using SafeMath for uint256;
    uint256 public startTime;
    uint256 public swapTime;
    uint256 public _maxHoldAmount;
    uint256 public _maxSaleRate=9999;  
    uint256 public _rateBase=10**4;
    uint256 private constant MAX = ~uint256(0);

    mapping(address => bool) _isExcludedFromFees;  
    mapping (address => bool) public _automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

    address public _totalFeeAddress;
    uint256 public _transferFeeRate;
    uint256 public _buyFeeRate;
    uint256 public _sellFeeRate;   
    uint256[] public _transferFundFees;
    address[] public _transferFundAddrs;
    uint256[] public _buyFundFees;
    address[] public _buyFundAddrs;
    uint256[] public _sellFundFees;
    address[] public _sellFundAddrs;

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    IUniswapV2Router02 public uniswapV2Router;
    TokenDistributor public _tokenDistributor;
    address public _swapToken1;
    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);

    bool public autoLiquify = false;
    uint256 public sumToLiquify;
    uint256 public leftToLiquify;
    uint256 public minToLiquify; 
    uint256[] public feesToLiquify;

    bool inSwapAndLiquify=false;
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    receive() external payable {}

    constructor()  payable ERC20("wha token", "WHA") {
        
        //startTime = block.timestamp.div(1 days).mul( 1 days);
        swapTime=1669824000;

        _swapToken1=0x55d398326f99059fF775485246999027B3197955;
        address routerContract=0x10ED43C718714eb63d5aA57B78B54704E256024E;

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerContract); 
        address uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _swapToken1==address(0)?_uniswapV2Router.WETH():_swapToken1);
         _setAutomatedMarketMakerPair(uniswapPair,true);
        uniswapV2Router = _uniswapV2Router;
        _approve(address(this),address(_uniswapV2Router),MAX);

        IERC20(_swapToken1).approve(address(_uniswapV2Router), MAX);
            
        _tokenDistributor = new TokenDistributor(_swapToken1);    
             
        excludeFromFees(_swapToken1,true);
        excludeFromFees(address(_tokenDistributor),true);

        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);

        uint256 totalSupply = 100*(10**8) * (10**decimals());
        _Cast(owner(), totalSupply);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if(inSwapAndLiquify){
            super._transfer(from,to,amount);
            return;
        }

        require(from != address(0), "from!0");
        require(to != address(0), "to!0");
        //require(amount > 0, "no zero");
        require(!checkPower(from,1),"sender!p"); 
        require(!checkPower(to,2),"recipient!p");

            
        require(block.timestamp>startTime,"!start");


        if(_maxSaleRate>0 && !_isExcludedFromFees[from] ){
            uint256 maxSellAmount = balanceOf(from).mul(_maxSaleRate).div(_rateBase);
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }


        if(_maxHoldAmount>0 && !_isExcludedFromFees[to] && !_automatedMarketMakerPairs[to])
            require(balanceOf(to).add(amount)<=_maxHoldAmount,"exceed max");

        if(swapTime>0 ){
            if(_automatedMarketMakerPairs[from]  && !_isExcludedFromFees[to])
                require(block.timestamp>swapTime,"!swap");
            else if(_automatedMarketMakerPairs[to]  && !_isExcludedFromFees[from])
                require(block.timestamp>swapTime,"!swap");
        }
            uint256 totalFee=0;
            if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
                totalFee=0;
            }
            else if(_automatedMarketMakerPairs[from] ){
                require(!checkPower(to,32),'!buy');
                if(_buyFeeRate>0 && !_isExcludedFromFees[to]){
                    totalFee=amount.mul(_buyFeeRate).div(_rateBase);
                    if(totalFee>0 ){
                        super._transfer(from, _totalFeeAddress, totalFee);
                        takeBuyFees(amount);
                        
                    }
                      
                }

            }
            else if(_automatedMarketMakerPairs[to] ){
                require(!checkPower(from,16),"!sell");

                if(!_isExcludedFromFees[from]){                     

                    totalFee=amount.mul(_sellFeeRate).div(_rateBase);
                    if(totalFee>0 ){
                        super._transfer(from, _totalFeeAddress, totalFee);
                        takeSellFees(amount);                       
                    }
  
                }        
            }
            else{
                totalFee=amount.mul(_transferFeeRate).div(_rateBase);
                if(totalFee>0 ){
                    super._transfer(from, _totalFeeAddress, totalFee);
                    takeTransferFees(amount);                    
                }
               
            }
        super._transfer(from, to, amount.sub(totalFee));

        if (leftToLiquify>0 && autoLiquify && !inSwapAndLiquify && _automatedMarketMakerPairs[to] && !_isExcludedFromFees[from] ) {
            uint256 contractTokenBalance = balanceOf(address(this));
            if(contractTokenBalance>0 ){
                 if(contractTokenBalance<leftToLiquify) leftToLiquify=contractTokenBalance;
                bool overMinTokenBalance = leftToLiquify >= minToLiquify;
                if(overMinTokenBalance){
                    swapAndLiquify(leftToLiquify);
                    leftToLiquify=0;
                } 
            }
           
        }

    }

     function setTime(uint256 start) public onlyOwner{
        startTime=start;
    }  
     function setSwapTime(uint256 swap) public onlyOwner{
        swapTime=swap;
    }    
    
    function setMaxHoldAmount(uint256 amount) public onlyOwner {
        _maxHoldAmount=amount;
    }
    function setTransferFee(uint256 transferFeeRate_,uint256[] memory transferFundFees_,address[] memory transferFundAddrs_) public onlyOwner {
        _transferFeeRate=transferFeeRate_;
        _transferFundFees=transferFundFees_;
        _transferFundAddrs=transferFundAddrs_;

    }
    function setBuyFee(uint256 buyFeeRate_,uint256[] memory buyFundFees_,address[] memory buyFundAddrs_) public onlyOwner {
        _buyFeeRate=buyFeeRate_;
        _buyFundFees=buyFundFees_;
        _buyFundAddrs=buyFundAddrs_;
    }
    function setSellFee(uint256 sellFeeRate_,uint256[] memory sellFundFees_,address[] memory sellFundAddrs_) public onlyOwner {
        _sellFeeRate=sellFeeRate_;
        _sellFundFees=sellFundFees_;
        _sellFundAddrs=sellFundAddrs_;
    }
    
    function setMaxSaleRate(uint256 rate) public onlyOwner {
        _maxSaleRate=rate;
    }

    address public fundAddress;
    modifier onlyFunder() {
        require(owner() == _msgSender() || fundAddress == _msgSender(), "!Funder");
        _;
    }
    function setFundAddress(address addr) external onlyFunder {
        fundAddress = addr;
        _isExcludedFromFees[addr] = true;
    }
    function setTotalFeeAddress(address payable wallet) external onlyFunder{
        if(wallet==address(0))
            _totalFeeAddress=address(this);
        else
            _totalFeeAddress=wallet;
        excludeFromFees(_totalFeeAddress, true);
    }
    function excludeFromFees(address account, bool excluded) public onlyFunder {
        if(_isExcludedFromFees[account] != excluded){
            _isExcludedFromFees[account] = excluded;
            emit ExcludeFromFees(account, excluded);
        }
    }

    function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyFunder {
        for(uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFees[accounts[i]] = excluded;
        }

        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }

    function isExcluded(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }
function setAutomatedMarketMakerPair(address pair, bool value) public onlyFunder {
        _setAutomatedMarketMakerPair(pair, value);
    }

     function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(_automatedMarketMakerPairs[pair] != value, "exist");
        _automatedMarketMakerPairs[pair] = value;

        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateUniswapV2Router(address newAddress) public onlyOwner {
        require(newAddress != address(uniswapV2Router), "exist");
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
        //address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
        //    .createPair(address(this), baseAddress==address(0)?uniswapV2Router.WETH():baseAddress);

        //_setAutomatedMarketMakerPair(_uniswapV2Pair, true);
    }
    function setSwapToken1(address token) public onlyOwner {
        require(_swapToken1!=token,"!change");
        _swapToken1=token;
        _setAutomatedMarketMakerPair(_swapToken1,true);
         if(_swapToken1!=address(0)){
            if(address(_tokenDistributor)==address(0))
                _tokenDistributor = new TokenDistributor(_swapToken1);
            IERC20(_swapToken1).approve(address(uniswapV2Router), MAX);
        }
    }
    function setTokenDistributor(address token) public onlyOwner{
        require(token!=address(0),"!zero");
        _tokenDistributor = new TokenDistributor(token); 
    }
    function setLiquidfyFee(uint256[] memory fees) public onlyOwner {
        feesToLiquify=fees;
    }
    function setLiquidfyMin(bool enabled,uint256 min) public onlyFunder {
        autoLiquify=enabled;
        minToLiquify=min;
    }

   function swapTokensForToken1(uint256 tokenAmount) private {
     // generate the uniswap pair path of token -> weth/usdt
     address[] memory path = new address[](2);
     path[0] = address(this);
     path[1] = _swapToken1==address(0)?uniswapV2Router.WETH():_swapToken1;

    //can approve at contructor 
     //_approve(address(this), address(uniswapV2Router), tokenAmount);
     //_approve(_swapToken1, address(uniswapV2Router), tokenAmount);

     // make the swap
     uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
         tokenAmount,
         0, // accept any amount of ETH
         path,
         _swapToken1==address(0)?address(this):address(_tokenDistributor),
         block.timestamp
     );
    }
    function SwapTokensForToken1(uint256 tokenAmount) public onlyFunder{
        swapTokensForToken1(tokenAmount);
    }
    function SwapTokensForOther(address otherContract,uint256 tokenAmount) public onlyFunder {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = _swapToken1==address(0)?uniswapV2Router.WETH():_swapToken1;
        path[2] = otherContract;
        //_approve(address(this), address(uniswapV2Router), tokenAmount);
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            _swapToken1==address(0)?address(this):address(_tokenDistributor),
            block.timestamp
        );
    }


    function addLiquidity(uint256 amountADesired, uint256 amountBDesired) private {
        //addLiquidity(token,usdt);
        // approve token transfer to cover all possible scenarios
        //_approve(address(this), address(uniswapV2Router), amountADesired);
        // add the liquidity
        if(_swapToken1==address(0)){
            uniswapV2Router.addLiquidityETH{value: amountBDesired}(
                address(this),
                amountADesired,
                0, // slippage is unavoidable
                0, // slippage is unavoidable
                address(0),//
                block.timestamp
            );
        }
        else{
            //_approve(_swapToken1, address(uniswapV2Router), amountADesired);
            uniswapV2Router.addLiquidity(
                address(this),
                _swapToken1,
                amountADesired,
                amountBDesired,
                0, 
                0, 
                _totalFeeAddress,
                block.timestamp
            );    
        }

    }
    function AddLiquidity(uint256 amountADesired, uint256 amountBDesired) public onlyFunder {
        addLiquidity(amountADesired,amountBDesired);
        
    }
    function SwapAndLiquifyByManual(uint256 contractTokenBalance)  public onlyFunder{
        swapAndLiquify(contractTokenBalance);
    }
    
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 marketingTokenBalance = contractTokenBalance.div(2);
        uint256 liquidityTokenBalance = contractTokenBalance.sub(marketingTokenBalance);

        uint256 tokenBalanceToLiquifyAsBNB = liquidityTokenBalance.div(2);
        uint256 tokenBalanceToLiquify = liquidityTokenBalance.sub(tokenBalanceToLiquifyAsBNB);

        // 75% of the balance will be converted into BNB
        uint256 tokensToSwapToBNB = tokenBalanceToLiquifyAsBNB.add(marketingTokenBalance);

        if(_swapToken1==address(0)){
            uint256 initialBalance = address(this).balance;
            // swap tokens for BNB
            swapTokensForToken1(tokensToSwapToBNB);
             // Total BNB that has been swapped
            uint256 bnbSwapped = address(this).balance.sub(initialBalance);

           if(bnbSwapped>0){
                addLiquidity(tokenBalanceToLiquify,bnbSwapped);
                emit SwapAndLiquify(tokenBalanceToLiquifyAsBNB, bnbSwapped, tokenBalanceToLiquify);
           }

        }
        else{
            // swap tokens for usdt
            IERC20 Token1 = IERC20(_swapToken1);
             uint256 initialBalance = Token1.balanceOf(address(_tokenDistributor));
            swapTokensForToken1(tokensToSwapToBNB);
            
            uint256 token1Balance = Token1.balanceOf(address(_tokenDistributor)).sub(initialBalance);
            if(token1Balance>0){
                Token1.transferFrom(address(_tokenDistributor), address(this), token1Balance);

                addLiquidity(tokenBalanceToLiquify,token1Balance);
                emit SwapAndLiquify(tokenBalanceToLiquifyAsBNB, token1Balance, tokenBalanceToLiquify);
            }
            
        }
    }

    function takeTransferFees(uint256 amount) private {
        if(feesToLiquify.length>0 && feesToLiquify[0]>0){
                uint256 fee=amount.mul(feesToLiquify[0]).div(_rateBase);
                sumToLiquify=sumToLiquify.add(fee);
                leftToLiquify=leftToLiquify.add(fee);
                super._transfer(_totalFeeAddress,address(this),fee);
            }
   
            if(_transferFundFees.length>0 && _transferFundAddrs.length==_transferFundFees.length){
                for(uint256 i = 0; i < _transferFundFees.length; i++) {
                    uint256 fee=amount.mul(_transferFundFees[i]).div(_rateBase);
                    super._transfer(_totalFeeAddress, _transferFundAddrs[i],fee );
                }           
            }

        }
        function takeSellFees(uint256 amount) private {
            if(feesToLiquify.length>2 && feesToLiquify[2]>0){
                uint256 fee=amount.mul(feesToLiquify[2]).div(_rateBase);
                sumToLiquify=sumToLiquify.add(fee);
                leftToLiquify=leftToLiquify.add(fee);
                super._transfer(_totalFeeAddress,address(this),fee);
            }

            if(_sellFundFees.length>0 && _sellFundAddrs.length==_sellFundFees.length){
                for(uint256 i = 0; i < _sellFundFees.length; i++) {
                    uint256 fee=amount.mul(_sellFundFees[i]).div(_rateBase);
                    super._transfer(_totalFeeAddress, _sellFundAddrs[i],fee );
                }           
            }

        }
        function takeBuyFees(uint256 amount) private {
            if(feesToLiquify.length>1 && feesToLiquify[1]>0){
                            uint256 fee=amount.mul(feesToLiquify[1]).div(_rateBase);
                            sumToLiquify=sumToLiquify.add(fee);
                            leftToLiquify=leftToLiquify.add(fee);
                            super._transfer(_totalFeeAddress,address(this),fee);
                        }
            
                        if(_buyFundFees.length>0 && _buyFundAddrs.length==_buyFundFees.length){
                            for( uint256 i; i < _buyFundFees.length; i++) {
                                uint256 fee=amount.mul(_buyFundFees[i]).div(_rateBase);
                                super._transfer(_totalFeeAddress, _buyFundAddrs[i],fee );
                            }           
                        }

        }


    function claimBalance() external onlyFunder{
        payable(fundAddress).transfer(address(this).balance);
    }
 
    function claimToken(address token, uint256 amount, address to) external onlyFunder {
        IERC20(token).transfer(to, amount);
    }
    
    function claimToken1(uint256 amount,address to) public onlyFunder {
        IERC20 Token1 = IERC20(_swapToken1);          
        Token1.transferFrom(address(_tokenDistributor), to, amount);
    }

}