// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;
//pragma experimental ABIEncoderV2;
import "./SafeMath.sol";
import "./SignedSafeMath.sol";


import "./ITradeModel.sol";


contract TradeModel is ITradeModel {

    using SafeMath for uint;
    using SignedSafeMath for int;

    // ---------- PUBLIC VARIABLES ------------- // 

    address public admin;

    /**
     * @notice Percentage of trade amount that is charged for fee
     * @dev Applied twice from tokenA --> tokenB. Once from tokenA --> USD and again from USD --> tokenB
     */
    uint public tradeFeePerc = 0.00075e18; 


    /**
     * @notice Percentage of trading fees that goes to reserves
     */
    uint public tradeReserveFactor = 0.25e18; 
    uint public constant referralDiscount = 0.10e18; // referral gets 10% off trading fees


    /**
     * @notice Maximum amount (in percent) the asset can move from oracle
     */
    uint public priceImpactLimit = 0.80e18;


    /**
     * @notice The percent discounts on trading fees
     */
    uint public shrimpDiscount = 0.10e18; // 0.090% after discount
    uint public fishDiscount   = 0.25e18; // 0.075% after discount
    uint public sharkDiscount  = 0.50e18; // 0.050% 
    uint public whaleDiscount  = 0.70e18; // 0.030%


    /**
     * @notice The thresholds for associated trading fee discounts
     */
    uint public shrimpThreshold = 1000e18; // 1,000 XRP (0.00333% supply)
    uint public fishThreshold   = 10000e18; // 10,000 XDP (0.0333% supply)
    uint public sharkThreshold  = 100000e18; // 100,000 XDP (0.333% supply)
    uint public whaleThreshold  = 1000000e18; // 1,000,000 XDP (3.33% supply) 


    // ---------- CONSTRUCTOR AND MODIFIER ------------- //


    constructor() public {
        admin = msg.sender;
    }


    /**
     * @notice Restricts functions to admin
     */
    modifier onlyAdmin() {
        require(msg.sender == admin, "!admin");
        _;
    }


    // ---------- ADMIN FUNCTIONS ------------- //

    event SetTradeFee(uint oldTradeFee, uint newTradeFee);
    /**
     * @notice Allows admin to set trading fee (before discounts)
     * @dev Must be below 2%
     * @param _tradeFeePerc New trading fee
     */
    function _setTradeFee(uint _tradeFeePerc) external onlyAdmin() {
        require(_tradeFeePerc<=0.02e18,"!tradeFee");
        uint oldTradeFee = tradeFeePerc;
        tradeFeePerc = _tradeFeePerc;
        emit SetTradeFee(oldTradeFee, tradeFeePerc);
    }


    event SetTradeReserveFactor(uint oldReserveFactor, uint newReserveFactor);
    /**
     * @notice Allows admin to set percentage of trade fee that goes to reserves
     * @dev Must be below 100% (of trading fee)
     * @param _tradeReserveFactor New reserve factor
     */
    function _setTradeReserveFactor(uint _tradeReserveFactor) external onlyAdmin() {
        require(_tradeReserveFactor <= 1e18,"!tradeReserveFactor");
        uint oldReserveFactor = tradeReserveFactor;
        tradeReserveFactor = _tradeReserveFactor;
        emit SetTradeReserveFactor(oldReserveFactor, tradeReserveFactor);

    }

    event oldTradeFeeThresholds(uint shrimpThres, uint fishThres, uint sharkThres, uint whaleThres);
    event newTradeFeeThresholds(uint shrimpThres, uint fishThres, uint sharkThres, uint whaleThres);
    /**
     * @notice Allows admin to change trading fee discount thresholds (i.e how much XDP must be held to receive discount)
     * @dev shrimpThres < fishThres < sharkThres, whaleThres
     */
    function _updateTradeFeeDiscountThresholds(uint _shrimpThres, uint _fishThres, uint _sharkThres, uint _whaleThres) external onlyAdmin() {
        require(_shrimpThres <  _fishThres && _fishThres < _sharkThres && _sharkThres < _whaleThres,"!threshold");
        emit oldTradeFeeThresholds(shrimpThreshold, fishThreshold, sharkThreshold, whaleThreshold);
        shrimpThreshold = _shrimpThres;
        fishThreshold = _fishThres;
        sharkThreshold = _sharkThres;
        whaleThreshold = _whaleThres;
        emit newTradeFeeThresholds(shrimpThreshold, fishThreshold, sharkThreshold, whaleThreshold);
    }


    event oldTradeFeePercents(uint shrimpDisc, uint fishDisc, uint sharkDisc, uint whaleDisc);
    event newTradeFeePercents(uint shrimpDisc, uint fishDisc, uint sharkDisc, uint whaleDisc);
    /**
     * @notice Allows admin to change trading fee discount percents (i.e how much XDP must be held to receive discount)
     * @dev shrimpThres < fishThres < sharkThres, whaleThres
     */
    function _updateTradeFeeDiscountPercents(uint _shrimpDis, uint _fishDis, uint _sharkDis, uint _whaleDis) external onlyAdmin() {
        require(_shrimpDis <  _fishDis && _fishDis < _sharkDis && _sharkDis < _whaleDis && _whaleDis <= 0.90e18,"!threshold");
        emit oldTradeFeePercents(shrimpDiscount, fishDiscount, sharkDiscount, whaleDiscount);
        shrimpDiscount = _shrimpDis;
        fishDiscount = _shrimpDis;
        sharkDiscount = _sharkDis;
        whaleDiscount = _whaleDis;
        emit newTradeFeePercents(shrimpDiscount, fishDiscount, sharkDiscount, whaleDiscount);
    }

    event SetPriceImpactLimit(uint oldLimit, uint newLimit);
    /**
     * @notice Allows admin to change the price impact limit
     * @dev limit must be below 100% (1e18)
     */
    function setPriceImpactLimit(uint _limit) external onlyAdmin() {
        require(_limit <= 1e18, "invalid price impact limit");
        uint oldLimit = priceImpactLimit;
        priceImpactLimit = _limit;
        emit SetPriceImpactLimit(oldLimit, priceImpactLimit);
    }


    // ---------------------------   HELPER FUNCTIONS   ----------------------------------- //


    function getValue(uint256 _amount, uint256 _price) public pure returns(uint256) {
        //return _amount * _price / 1e18;
        return _amount.mul(_price).div(1e18);
    }

    function getAssetAmt(uint256 _amount, uint256 _price) public pure returns(uint256) {
        //return _amount * 1e18 / _price;
        return _amount.mul(1e18).div(_price);
    }

    function getValueInt(int _amount, int _price) public pure returns(int) {
        return _amount.mul(_price).div(1e18);
    }


    function getAssetAmtInt(int _amount, int _price) public pure returns(int) {
        return _amount.mul(1e18).div(_price);
    }

    function abs(int256 x) public pure returns (uint256) {
        return x >= 0 ? uint256(x) : uint256(-x);
    }


    // ---------------------------   IUSD AND PRICE   ----------------------------------- //


    /**
     * @notice Calculates the current iUSD rate of the market: 
     * @dev formula: `iUSD balance / (availCash*price + _iUSDbalance)`
     * @param _iUSDbalance The iUSD balance of dToken
     * @param _availCash The available cash (getCashPrior()) of dToken
     * @param _price The oracle price of the underling asset
     * @return rate The iUSD rate of the dToken 
     */
    function iUSDrate(int _iUSDbalance, uint _availCash, uint _price) public pure returns(int rate) {
        // need to add in case where  pool balance is 0! 
        uint poolValue = getValue(_availCash, _price);
        int poolValuePlusIUSD = int(poolValue).add(_iUSDbalance);
        if (poolValuePlusIUSD <= 0) {
            rate = -1e18;
        } else {
            rate = getAssetAmtInt(_iUSDbalance,poolValuePlusIUSD);
            if (rate > 1e18) {
                rate = 1e18;
            } else if (rate < -1e18) {
                rate = -1e18;
            }
        }
    }


    /**
     * @notice Calculates the current price impact of the market
     * @dev formula: 'iUSDrate() * abs(iUSDrate())'
     * @param _iUSDbalance The iUSD balance of dToken
     * @param _availCash The available cash (getCashPrior()) of dToken
     * @param _price The oracle price of the underling asset
     * @return rate The price impact (in percent) of the dToken
     */
    function priceImpact(int _iUSDbalance, uint _availCash, uint _price) public view returns(int rate) {
        int _iUSDrate = iUSDrate(_iUSDbalance, _availCash, _price);
        rate = getValueInt(_iUSDrate,int(abs(_iUSDrate))); // 10% * 10% --> 1%
        int _priceImpactLimit = int(priceImpactLimit);
        if (rate > _priceImpactLimit) {
            rate = _priceImpactLimit;
        } else if (rate < -_priceImpactLimit) {
            rate = -_priceImpactLimit;
        }
    }


    /**
     * @notice Calculates the protocol loss if a trader would buy (sell) an asset in an infinite number of 
     *         trades at discounted (premium) prices until the iUSDrate() goes to 0
     * @dev Formula uses the integral of the price impact function: '(iUSDbalance/3) * priceImpactAbs'
     * @param _iUSDbalance The iUSD balance of dToken
     * @param _availCash The available cash (getCashPrior()) of dToken
     * @param _price The oracle price of the underling asset
     * @return rate The protocol loss (in USD) of dToken in current state
     */
    function protocolLoss(int _iUSDbalance, uint _availCash, uint _price) public view returns(uint loss) {
        uint priceImpactAbs = abs(priceImpact(_iUSDbalance, _availCash, _price)); // [iUSDbalance / (availCash*price + iUSDbalance)]^2
        uint integralFactor = getAssetAmt(abs(_iUSDbalance),3e18); // iUSDbalance/3
        uint priceImpactIntegral = getValue(integralFactor, priceImpactAbs); // (iUSDbalance/3)*(priceImpact)
        loss = priceImpactIntegral; // in USD
    }


    /**
     * @notice Calculates the fee when removing liquidity (borrow or redeem) from dToken
     * @dev This calculation is used when redeeming/borrowing assets to prevent an exploit where the trader removes 
     *      liquidity from the protocol, increasing |iUSDrate|, then taking advantage of price premium or discount
     * @param removeLiquidity Amount user wishes to remove from dToken (in Underlying amount)
     * @param _iUSDbalance The current iUSDbalance of the dToken
     * @param _iUSDbalance The current cashPrior() of the dToken
     * @param _price The current oracle price of asset being remove
     */
    function removeLiquidityFee(uint removeLiquidity, int _iUSDbalance, uint _availCash, uint _price) public view returns(uint fee) {
        uint startProtocolLoss = protocolLoss(_iUSDbalance, _availCash, _price);
        uint newAvailableCash = _availCash.sub(removeLiquidity);
        uint endProtocolLoss = protocolLoss(_iUSDbalance, newAvailableCash, _price);

        require(endProtocolLoss >= startProtocolLoss,"remove liquidity would result in less protocol loss. Something wrong");

        uint feeUSD = endProtocolLoss.sub(startProtocolLoss);
        fee =  getAssetAmt(feeUSD,_price);
    }


    /**
     * @notice Calculates the fee when removing liquidity (borrow or redeem) from dToken
     * @dev This calculation is used when redeeming/borrowing assets to prevent an exploit where the trader removes 
     *      liquidity from the protocol, increasing |iUSDrate|, then taking advantage of price premium or discount
     * @param removeLiquidity Amount user wishes to remove from dToken (in Underlying amount)
     * @param _iUSDbalance The current iUSDbalance of the dToken
     * @param _iUSDbalance The current cashPrior() of the dToken
     * @param _price The current oracle price of asset being remove
     */
    function newRemoveLiquidityAmt(uint removeLiquidity, int _iUSDbalance, uint _availCash, uint _price) public view returns(uint newAmt) {
        uint _removeLiquidityFee = removeLiquidityFee(removeLiquidity, _iUSDbalance,  _availCash, _price);
        int _newAmt = int(removeLiquidity).sub(int(_removeLiquidityFee));
        require(_newAmt>=0,"!newAmt");
        newAmt = uint(_newAmt);
    }



    /**
     * @notice Applies price impact to oracle price
     * @param _iUSDbalance The current iUSDbalance of the dToken
     * @param _iUSDbalance The current cashPrior() of the dToken
     * @param _price The current oracle price of asset being remove
     * @return adjPrice Returns the adjusted price (trading price)
    */
    function adjustedPrice(int _iUSDbalance, uint _availCash, uint _price) public view returns(uint adjPrice) {
        int _priceImpact = priceImpact(_iUSDbalance, _availCash, _price);
        int oneMinusAbsPriceImpact = int(1e18).sub(int(abs(_priceImpact)));
        if (oneMinusAbsPriceImpact>0) { // premium
            if (_priceImpact <=0) {
                adjPrice = getValue(_price, uint(oneMinusAbsPriceImpact));
            } else {
                adjPrice = getAssetAmt(_price,uint(oneMinusAbsPriceImpact));
            }
        } else { // discount
            revert("price impact must be smaller than 100%");
        }
    }


    // ---------------------------   CASH MODIFICATION  ----------------------------------- //


    /**
     * @notice Calculates the true value of the protocol
     * @dev Used for the exchangeRate calculation
     * @param iUSDbalance The current iUSDbalance of the dToken
     * @param availCash The current cashPrior() of the dToken
     * @param oraclePrice The current oracle price of asset being remove
     * @return cashPlusUSD Returns the true value of in protocol 
     */
    function cashAddUSDMinusLoss(int iUSDbalance, uint availCash, uint oraclePrice) public view returns(uint cashPlusUSD) {
        uint _protocolLoss = protocolLoss(iUSDbalance, availCash, oraclePrice);
        int iUSDbalanceMinusLoss = iUSDbalance.sub(int(_protocolLoss));
        int _cashAddUSD = int(availCash).add(getAssetAmtInt(iUSDbalanceMinusLoss,int(oraclePrice)));
        if (_cashAddUSD>0) {
            cashPlusUSD = uint(_cashAddUSD);
        } else {
            cashPlusUSD = 0;
        }
    }



    /**
     * @notice Calculates the available cash in the pool 
     * @dev Used to determine how much can be borrowed/redeemed
     * @param iUSDbalance The current iUSDbalance of the dToken
     * @param availCash The current cashPrior() of the dToken
     * @param oraclePrice The current oracle price of asset being remove
     * @return cashAddUSDMultUSDrate Returns the available cash in pool 
     */
    function getCashAddUSDMultAbsRate(int iUSDbalance, uint availCash, uint oraclePrice) external view returns(uint cashAddUSDMultUSDrate) {
        int cashPlusUSD =  int(availCash).add(getAssetAmtInt(iUSDbalance,int(oraclePrice)));
        if (cashPlusUSD > 0) {
            uint OneMinusAbsUSDrate = uint(1e18).sub(abs(iUSDrate(iUSDbalance, availCash, oraclePrice)));
            cashAddUSDMultUSDrate = getValue(uint(cashPlusUSD), OneMinusAbsUSDrate);
        } else {
            cashAddUSDMultUSDrate = 0;
        }
    } 


    // ---------------------------   FEE AND AMOUNT OUT   ----------------------------------- //


    /**
     * @notice Returns the discount applied to traders 
     * @param _traderBalance The balance of XDP the trader has
     * @return discount The percent discount the trader receives on trading fees
     */
    function feeDiscount(uint _traderBalance) public view returns(uint discount) {
        if (_traderBalance >= whaleThreshold) {
            discount = whaleDiscount;
        } else if (_traderBalance >= sharkThreshold) {
            discount = sharkDiscount;
        } else if (_traderBalance >= fishThreshold) {
            discount = fishDiscount;
        } else if (_traderBalance >= shrimpThreshold) {
            discount = shrimpDiscount;
        } else {
            discount = 0;
        }
    }


    /**
     * @notice Calculates the amount the trader traded (in Underlying) after fee
     * @dev outputAmt + totalFeeAmt = _inputAmt
     * @param _inputAmt The amount the trader sold 
     * @param _traderBalXVS The XDP balance of trader
     * @return outputAmt Input amount after fees, reserveFeeAmt Amount that goes to reserves, totalFeeAmt Total fees 
     */
    function amtAfterFee(uint _inputAmt, uint _traderBalXVS, address referrer) public view returns(uint outputAmt, uint reserveFeeAmt, uint totalFeeAmt) {

        // apply referral discount
        uint _referralDiscount;
        if (referrer != address(0)) {
            _referralDiscount = referralDiscount;
        }

        // XDP discount
        uint discountXDP = feeDiscount(_traderBalXVS);
        uint oneMinusDiscounts = uint(1e18).sub(discountXDP).sub(_referralDiscount);
        uint tradeFeePercAfterDiscount = getValue(tradeFeePerc , oneMinusDiscounts);
        require(tradeFeePercAfterDiscount>0 && tradeFeePercAfterDiscount < 0.01e18, "trade fee must be (0%,1%]");


        uint oneMinusTradeFee = uint(1e18).sub(tradeFeePercAfterDiscount);
        outputAmt = getValue(_inputAmt , oneMinusTradeFee);
        totalFeeAmt = _inputAmt.sub(outputAmt);
        reserveFeeAmt = getValue(totalFeeAmt,tradeReserveFactor); // may need to mulitply again
    }


    /**
     * @notice Calculates the amount of USD out after user sold underlying
     * @dev trading fee and trading price is applied
     * @param _amountTokenIn The amount of underlying token user is selling
     * @param _initialPrice The oracle price of the asset being sold 
     * @param _iUSDbalance iUSD balance of dToken associated with underlying being sold
     * @param _postCash The available cash after BNB/Bep20 is deposited into contract
     * @param _traderBalXVS The XDP balance held in traders wallet 
     * @return amtOutUSD USD value out, reserveFeeUnderly Amount that goes to reserves, totalFeeAmt Total fees (in Underlying)
     */
    function amountOutUSDInternal(uint _amountTokenIn, uint _initialPrice, int _iUSDbalance, uint _postCash, uint _traderBalXVS, address _referrer) public view returns(uint amtOutUSD, uint reserveFeeUnderly, uint totalFeeAmt) {

        (uint amountTokenIn, uint ownerFeeAmount, uint _totalFeeAmt) = amtAfterFee(_amountTokenIn, _traderBalXVS,_referrer);

        // get first post estimates
        int iUSDpostEst = _iUSDbalance.sub(int(getValue(amountTokenIn, _initialPrice)));
        uint pricePost = adjustedPrice(iUSDpostEst, _postCash, _initialPrice);

        // get second (more accurate) post estimates
        iUSDpostEst = _iUSDbalance.sub(int(getValue(amountTokenIn, pricePost)));
        pricePost = adjustedPrice(iUSDpostEst, _postCash, _initialPrice);

        // get third (more accurate) post estimates
        iUSDpostEst = _iUSDbalance.sub(int(getValue(amountTokenIn, pricePost)));
        pricePost = adjustedPrice(iUSDpostEst, _postCash, _initialPrice);

        // get amount out
        amtOutUSD = getValue(amountTokenIn,pricePost);
        reserveFeeUnderly = ownerFeeAmount;
        totalFeeAmt = _totalFeeAmt;

    }


    /**
     * @notice Calculates the amount of Underling out based on USD in
     * @dev trading fee and trading price is applied
     * @param _amtInUSD The value (in USD) in
     * @param _initialPrice The oracle price of the asset being sold 
     * @param _iUSDbalance iUSD balance of dToken associated with underlying being sold
     * @param _availCash The available cash (getCashPrior()) in the dToken
     * @param _traderBalXVS The XDP balance held in traders wallet 
     * @return amountOutToken Underlying out, reserveFeeUnderly Amount that goes to reserves, totalFeeAmt Total fees (in Underlying)
     */
    function amountOutTokenInternal(uint _amtInUSD, uint _initialPrice, int _iUSDbalance, uint _availCash, uint _traderBalXVS) public view returns(uint amountOutToken, uint reserveFeeUnderly, uint totalFeeAmt) {
        // base trade fee
        (uint amtInUSD, uint ownerFeeAmountIUSD, uint _totalFeeAmtUSD)  = amtAfterFee(_amtInUSD, _traderBalXVS, address(0));
        int iUSDpost = _iUSDbalance.add(int(amtInUSD));
        
        // get first post estimates
        uint tokenPostEst = _availCash.sub(getAssetAmt(amtInUSD, _initialPrice));
        uint pricePost = adjustedPrice(iUSDpost, tokenPostEst, _initialPrice);

        // get second (more accurate) post estimates
        tokenPostEst = _availCash.sub(getAssetAmt(amtInUSD, pricePost));
        pricePost = adjustedPrice(iUSDpost, tokenPostEst, _initialPrice);

        // get third (more accurate) post estimates
        tokenPostEst = _availCash.sub(getAssetAmt(amtInUSD, pricePost));
        pricePost = adjustedPrice(iUSDpost, tokenPostEst, _initialPrice);


        // get amount out
        amountOutToken = getAssetAmt(amtInUSD,pricePost);
        reserveFeeUnderly = getAssetAmt(ownerFeeAmountIUSD,pricePost);
        totalFeeAmt = getAssetAmt(_totalFeeAmtUSD,pricePost);

    }


    /**
     * @notice Calculates the amount of Underlying out (for dTokenOut) based on amountIn of dTokenIn's underlying
     * @dev Combines amountOutUSDInternal and amountOutTokenInternal into one function
     *      The dToken calling this function will either be buying (dTokenIn = 0x00) or selling (dTokenOut = 0x00) its underlying
     *      Need to deduct amountIn from availableCash when selling underlying because the calling function receives underlying first
     * @param _dTokenIn Address of dToken assocaited with underlying being sold
     * @param _dTokenOut Address of dToken assocaited with underlying being bought
     * @param amountIn The amount of Underlying in associated with dTokenIn
     * @param oraclePrice The oracle price of the asset being sold 
     * @param iUSDbalance iUSD balance of dToken associated with underlying being sold
     * @param availCash The available cash (getCashPrior()) in the dToken
     * @param traderBalanceXDP The XDP balance held in traders wallet 
     * @return amountOut Amount of USD or underlying out, reserveFeeUnderly Underlying that goes to reserves, totalFeeAmt Total fees (in Underlying)
     */
    function amountsOut(address _dTokenIn, address _dTokenOut, uint amountIn, uint oraclePrice, int iUSDbalance, uint availCash, uint traderBalanceXDP, address _referrer) external view returns(uint amountOut, uint reserveFeeUnderly, uint totalFeeAmt)  {
        
        // swapping underlying for valueUSD
        if ( _dTokenOut == address(0)) {
            (amountOut, reserveFeeUnderly,totalFeeAmt) = amountOutUSDInternal(amountIn, oraclePrice, iUSDbalance, availCash, traderBalanceXDP,_referrer);

        // swapping valueUSD for underlying
        } else if (_dTokenIn == address(0)) {
            (amountOut, reserveFeeUnderly,totalFeeAmt) = amountOutTokenInternal(amountIn, oraclePrice, iUSDbalance, availCash, traderBalanceXDP);
        
        // reverts if neither dTokenIn or dTokenOut is 0 address
        } else {
            revert("dTokenIn or dTokenOut must be 0x00 address");
        }

    }


}
