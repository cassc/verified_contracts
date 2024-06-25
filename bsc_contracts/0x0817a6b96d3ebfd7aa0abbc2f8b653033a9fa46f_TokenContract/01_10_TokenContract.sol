// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
/*
   💰💳💰💳✅Token smart contract with payment of fees in any tokens
   💰💳💰💳✅All market transactions retain fee to token maintenance 
   💰💳💰💳✅All market transactions retain fee for token repurchase
   💰💳💰💳✅Option repurchase with or without automated burning
   💰💳💰💳✅Anti dump control
   💰💳💰💳✅Audited contract
*/


import "./ERC20.sol";
import "./Strings.sol";
import "./Authorized.sol";
import "./IPancake.sol";
import "./SwapHelper.sol";
contract TokenContract is Authorized, ERC20 {

  uint8     constant             decimal                   = 18;
  uint8     constant             decimalBUSD               = 18;  
  string    public              _name;                    
  string    public              _symbol;                  
  uint256   public              _maxSupply;               
  uint256   public              _maxTxAmount;             
  uint256   public              _initMax;                 
  uint256   public              feeAdministrationWallet;  
  uint256   public              feePool;                  
  uint256   public              totalBurned;

  // White list mapping to special wallet permissions
  mapping (address => bool) public exemptFee;
  mapping (address => bool) public exemptFeeReceiver;
  mapping (address => bool) public exemptStaker;
  mapping (address => bool) public exemptTxLimit;
  address  []   public    liquidityPool;
  address       public    administrationWallet;
  address       constant  DEAD = 0x000000000000000000000000000000000000dEaD;
  address       constant  ZERO = 0x0000000000000000000000000000000000000000;
  address       public  WBNB;
  address       public  BUSD;
  address       WBNB_BUSD_PAIR;
  address       SMARTTOKEN_POOL;

  SwapHelper private swapHelper;
  bool private _noReentrancy = false;

  function getOwner() external view returns (address) { return owner(); }
  function getFeeTotal() public view returns(uint256) { return feePool + feeAdministrationWallet; }

  function getSwapHelperAddress() external view returns (address) { return address(swapHelper); }

  function activeTxLimit() public isAuthorized(0) { 
    _maxTxAmount = _initMax;
  }
  
  function desactiveTxLimit() public isAuthorized(0) { 
    _maxTxAmount = _maxSupply;
  }
  
  function setExemptFee(address account, bool operation) public isAuthorized(2) { exemptFee[account] = operation; }
  function setExemptFeeReceiver(address account, bool operation) public isAuthorized(2) { exemptFeeReceiver[account] = operation; }  
  function setExemptTxLimit(address account, bool operation) public isAuthorized(2) { exemptTxLimit[account] = operation; }
  
  function setExemptStaker(address account, bool operation) public isAuthorized(2) { exemptStaker[account] = operation; }
  function setAdministrationWallet(address account) public isAuthorized(0) { administrationWallet = account; }
  receive() external payable { }
  constructor(string memory name_, string memory symbol_, uint256 maxSupply_, uint256 feeAdm_, uint256 feePool_, uint256 initMax_, address[] memory propWallet_
  )ERC20(name_, symbol_) {
    _name = name_;
    _symbol = symbol_;
    _maxSupply = maxSupply_ * (10 ** decimal);
    feeAdministrationWallet = feeAdm_;
    feePool = feePool_;
    _initMax = initMax_ * (10 ** decimal);
    _maxTxAmount = _initMax;
    administrationWallet = propWallet_[0]; //owner

    PancakeRouter router = PancakeRouter(propWallet_[1]); // router

    WBNB = propWallet_[2];
    BUSD = propWallet_[3];
    WBNB_BUSD_PAIR = propWallet_[4];
    
    SMARTTOKEN_POOL = address(PancakeFactory(router.factory()).createPair(WBNB, address(this)));
    liquidityPool.push(SMARTTOKEN_POOL);
    address ownerWallet = administrationWallet;
    
    exemptStaker[SMARTTOKEN_POOL]             = true;
    exemptStaker[address(this)]               = true;
    exemptStaker[DEAD]                        = true;
    exemptStaker[ZERO]                        = true;
    exemptStaker[ownerWallet]                 = true;
    exemptFee[address(this)]                  = true;
    exemptFee[DEAD]                           = true;
    exemptFee[ownerWallet]                    = true;
    exemptTxLimit[SMARTTOKEN_POOL]            = true;
    exemptTxLimit[address(this)]              = true;
    exemptTxLimit[DEAD]                       = true;
    exemptTxLimit[ZERO]                       = true;
    exemptTxLimit[ownerWallet]                = true;
    
    swapHelper = new SwapHelper();
    swapHelper.safeApprove(WBNB, address(this), type(uint256).max);
    _mint(ownerWallet, _maxSupply);
    grantAllPermissions(ownerWallet);
    _owner = ownerWallet;

  }

  function decimals() public pure override returns (uint8) { 
    return decimal;
  }
  function _mint(address account, uint256 amount) internal override {
    require(_maxSupply >= ERC20.totalSupply() + amount && _maxSupply >= amount, "Maximum supply already minted");
    super._mint(account, amount);
  }
  function _beforeTokenTransfer( address from, address, uint256 amount ) internal view override {
    require(amount <= _maxTxAmount || exemptTxLimit[from], "Excedded the maximum transaction limit");
  }

  function _transfer( address sender, address recipient,uint256 amount ) internal override {
    require(!_noReentrancy, "ReentrancyGuard: reentrant call happens");
    _noReentrancy = true;
    
    require(sender != address(0) && recipient != address(0), "transfer from the zero address");
    
    if (!exemptFeeReceiver[recipient]){
      _beforeTokenTransfer(sender, recipient, amount);
    }
    
    uint256 senderBalance = _balances[sender];
    require(senderBalance >= amount, "transfer amount exceeds your balance");
    uint256 newSenderBalance = senderBalance - amount;
    _balances[sender] = newSenderBalance;

    uint256 feeAmount = 0;
    if (!exemptFee[sender] && !exemptFeeReceiver[recipient]) feeAmount = (getFeeTotal() * amount) / 10000;

    exchangeFeeParts(feeAmount);
    uint256 newRecipentAmount = _balances[recipient] + (amount - feeAmount);
    _balances[recipient] = newRecipentAmount;

    _noReentrancy = false;
    emit Transfer(sender, recipient, amount);
    
  }

  function exchangeFeeParts(uint256 incomingFeeTokenAmount) private returns (bool){
    if (incomingFeeTokenAmount == 0) return false;
    _balances[address(this)] += incomingFeeTokenAmount;
    
    address pairBnbSmartToken = SMARTTOKEN_POOL;
    if (_msgSender() == pairBnbSmartToken) return false;
    
    uint256 feeTokenAmount = _balances[address(this)];
    _balances[address(this)] = 0;

    address wbnbAddress = WBNB;
    (uint112 reserve0, uint112 reserve1) = getTokenReserves(pairBnbSmartToken);
    bool reversed = isReversed(pairBnbSmartToken, wbnbAddress);
    if (reversed) { uint112 temp = reserve0; reserve0 = reserve1; reserve1 = temp; }
    _balances[pairBnbSmartToken] += feeTokenAmount;
    address swapHelperAddress = address(swapHelper);
    uint256 wbnbBalanceBefore = getTokenBalanceOf(wbnbAddress, swapHelperAddress);
    
    uint256 wbnbAmount = getAmountOut(feeTokenAmount, reserve1, reserve0);
    swapToken(pairBnbSmartToken, reversed ? 0 : wbnbAmount, reversed ? wbnbAmount : 0, swapHelperAddress);
    uint256 wbnbBalanceNew = getTokenBalanceOf(wbnbAddress, swapHelperAddress);  
    require(wbnbBalanceNew == wbnbBalanceBefore + wbnbAmount, "Wrong amount of swapped on WBNB");
    {

      address busdAddress = BUSD;
      address pairWbnbBusd = WBNB_BUSD_PAIR;
      (reserve0, reserve1) = getTokenReserves(pairWbnbBusd);
      reversed = isReversed(pairWbnbBusd, wbnbAddress);
      if (reversed) { uint112 temp = reserve0; reserve0 = reserve1; reserve1 = temp; }

      uint256 busdBalanceBefore = getTokenBalanceOf(busdAddress, address(this));
      tokenTransferFrom(wbnbAddress, swapHelperAddress, pairWbnbBusd, wbnbAmount);
      uint256 busdAmount = getAmountOut(wbnbAmount, reserve0, reserve1);
      swapToken(pairWbnbBusd, reversed ? busdAmount : 0, reversed ? 0 : busdAmount, address(this));
      uint256 busdBalanceNew = getTokenBalanceOf(busdAddress, address(this));
      require(busdBalanceNew == busdBalanceBefore + busdAmount, "Wrong amount swapped on BUSD");
      if (feeAdministrationWallet > 0) tokenTransfer(busdAddress, administrationWallet, (busdAmount * feeAdministrationWallet) / getFeeTotal());
    }
    return true;
  }

  function buyBackAndHold(uint256 amount, address receiver) external isAuthorized(3) { buyBackAndHoldWithDecimals(amount * (10 ** decimalBUSD), receiver); }
  function buyBackAndHoldWithDecimals(uint256 decimalAmount, address receiver) public isAuthorized(3) { buyBackWithDecimals(decimalAmount, receiver); }
  function buyBackAndBurn(uint256 amount) external isAuthorized(3) { buyBackAndBurnWithDecimals(amount * (10 ** decimalBUSD)); }
  function buyBackAndBurnWithDecimals(uint256 decimalAmount) public isAuthorized(3) { buyBackWithDecimals(decimalAmount, address(0)); }
  function buyBackWithDecimals(uint256 decimalAmount, address destAddress) private {
    uint256 maxBalance = getTokenBalanceOf(BUSD, address(this));
    if (maxBalance < decimalAmount) revert(string(abi.encodePacked("insufficient BUSD amount[", Strings.toString(decimalAmount), "] on contract[", Strings.toString(maxBalance), "]")));

    (uint112 reserve0,uint112 reserve1) = getTokenReserves(WBNB_BUSD_PAIR);
    bool reversed = isReversed(WBNB_BUSD_PAIR, BUSD);
    if (reversed) { uint112 temp = reserve0; reserve0 = reserve1; reserve1 = temp; }

    tokenTransfer(BUSD, WBNB_BUSD_PAIR, decimalAmount);
    uint256 wbnbAmount = getAmountOut(decimalAmount, reserve0, reserve1);
    swapToken(WBNB_BUSD_PAIR, reversed ? wbnbAmount : 0, reversed ? 0 : wbnbAmount, address(this));

    bool previousExemptFeeState = exemptFee[SMARTTOKEN_POOL];
    exemptFee[SMARTTOKEN_POOL] = true;
    
    address pairBnbSmartToken = SMARTTOKEN_POOL;
    address swapHelperAddress = address(swapHelper);
    (reserve0, reserve1) = getTokenReserves(pairBnbSmartToken);
    reversed = isReversed(pairBnbSmartToken, WBNB);
    if (reversed) { uint112 temp = reserve0; reserve0 = reserve1; reserve1 = temp; }

    tokenTransfer(WBNB, pairBnbSmartToken, wbnbAmount);
    
    uint256 igtAmount = getAmountOut(wbnbAmount, reserve0, reserve1);
    if (destAddress == address(0)) {
      swapToken(pairBnbSmartToken, reversed ? igtAmount : 0, reversed ? 0 : igtAmount, swapHelperAddress);
      _burn(swapHelperAddress, igtAmount);
      totalBurned += igtAmount;
    } else {
      swapToken(pairBnbSmartToken, reversed ? igtAmount : 0, reversed ? 0 : igtAmount, destAddress);
    }
    exemptFee[SMARTTOKEN_POOL] = previousExemptFeeState;
  }

  function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256 amountOut) {
    require(amountIn > 0, 'Insufficient amount in');
    require(reserveIn > 0 && reserveOut > 0, 'Insufficient liquidity');
    uint256 amountInWithFee = amountIn * 9975;
    uint256 numerator = amountInWithFee  * reserveOut;
    uint256 denominator = (reserveIn * 10000) + amountInWithFee;
    amountOut = numerator / denominator;
  }

  function isReversed(address pair, address tokenA) internal view returns (bool) {
    address token0;
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0x0dfe168100000000000000000000000000000000000000000000000000000000)
      failed := iszero(staticcall(gas(), pair, emptyPointer, 0x04, emptyPointer, 0x20))
      token0 := mload(emptyPointer)
    }
    if (failed) revert(string(abi.encodePacked("Unable to check direction of token ", Strings.toHexString(uint160(tokenA), 20) ," from pair ", Strings.toHexString(uint160(pair), 20))));
    return token0 != tokenA;
  }

  function tokenTransfer(address token, address recipient, uint256 amount) internal {
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
      mstore(add(emptyPointer, 0x04), recipient)
      mstore(add(emptyPointer, 0x24), amount)
      failed := iszero(call(gas(), token, 0, emptyPointer, 0x44, 0, 0))
    }
    if (failed) revert(string(abi.encodePacked("Unable to transfer ", Strings.toString(amount), " of token [", Strings.toHexString(uint160(token), 20) ,"] to address ", Strings.toHexString(uint160(recipient), 20))));
  }

  function tokenTransferFrom(address token, address from, address recipient, uint256 amount) internal {
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
      mstore(add(emptyPointer, 0x04), from)
      mstore(add(emptyPointer, 0x24), recipient)
      mstore(add(emptyPointer, 0x44), amount)
      failed := iszero(call(gas(), token, 0, emptyPointer, 0x64, 0, 0)) 
    }
    if (failed) revert(string(abi.encodePacked("Unable to transfer from [", Strings.toHexString(uint160(from), 20)  ,"] ", Strings.toString(amount), " of token [", Strings.toHexString(uint160(token), 20) ,"] to address ", Strings.toHexString(uint160(recipient), 20))));
  }

  function swapToken(address pair, uint amount0Out, uint amount1Out, address receiver) internal {
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0x022c0d9f00000000000000000000000000000000000000000000000000000000)
      mstore(add(emptyPointer, 0x04), amount0Out)
      mstore(add(emptyPointer, 0x24), amount1Out)
      mstore(add(emptyPointer, 0x44), receiver)
      mstore(add(emptyPointer, 0x64), 0x80)
      mstore(add(emptyPointer, 0x84), 0)
      failed := iszero(call(gas(), pair, 0, emptyPointer, 0xa4, 0, 0))
    }
    if (failed) revert(string(abi.encodePacked("Unable to swap ", Strings.toString(amount0Out == 0 ? amount1Out : amount0Out), " on Pain [", Strings.toHexString(uint160(pair), 20)  ,"] to receiver ", Strings.toHexString(uint160(receiver), 20) )));
  }

  function getTokenBalanceOf(address token, address holder) internal view returns (uint112 tokenBalance) {
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0x70a0823100000000000000000000000000000000000000000000000000000000)
      mstore(add(emptyPointer, 0x04), holder)
      failed := iszero(staticcall(gas(), token, emptyPointer, 0x24, emptyPointer, 0x40))
      tokenBalance := mload(emptyPointer)
    }
    if (failed) revert(string(abi.encodePacked("Unable to get balance from wallet [", Strings.toHexString(uint160(holder), 20) ,"] of token [", Strings.toHexString(uint160(token), 20) ,"] ")));
  }

  function getTokenReserves(address pairAddress) internal view returns (uint112 reserve0, uint112 reserve1) {
    bool failed = false;
    assembly {
      let emptyPointer := mload(0x40)
      mstore(emptyPointer, 0x0902f1ac00000000000000000000000000000000000000000000000000000000)
      failed := iszero(staticcall(gas(), pairAddress, emptyPointer, 0x4, emptyPointer, 0x40))
      reserve0 := mload(emptyPointer)
      reserve1 := mload(add(emptyPointer, 0x20))
    }
    if (failed) revert(string(abi.encodePacked("Unable to get reserves from pair [", Strings.toHexString(uint160(pairAddress), 20), "]")));
  }
  function walletHolder(address account) private view returns (address holder) {
    return exemptStaker[account] ? address(0x00) : account;
  }
  function safeOtherTokens(address token, address payable receiv, uint amount) external isAuthorized(0) {
    if(token == address(0)) { receiv.transfer(amount); } else { IERC20(token).transfer(receiv, amount); }
  }

  function getSMARTTOKEN_POOL() external view returns(address) { return SMARTTOKEN_POOL; }
  function getWBNB_BUSD_Pair() external view returns(address) { return WBNB_BUSD_PAIR; }

}