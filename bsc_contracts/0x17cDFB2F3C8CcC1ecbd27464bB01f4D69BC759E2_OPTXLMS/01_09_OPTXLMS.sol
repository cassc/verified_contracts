// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import './interfaces/IDEXRouter.sol';
import './interfaces/IDEXFactory.sol';
import './interfaces/IDEXPair.sol';

contract OPTXLMS is OwnableUpgradeable {

    IERC20Upgradeable OPTX;
    IERC20Upgradeable BUSD;
    IDEXRouter public commandSwapRouter;
    IDEXRouter public pancakeSwapRouter;
    IDEXPair public commandBNBPair;
    IDEXPair public commandBUSDPair;
    IDEXPair public pancakeBNBPair;
    IDEXPair public pancakeBUSDPair;

    address public optxAddress;
    address public busdAddress;
    address public commandBNBPairAddress;
    address public commandBUSDPairAddress;
    address public pancakeBNBPairAddress;
    address public pancakeBUSDPairAddress;
    bool public lmsEnabled;

    uint256 public priceUpThreshold;
    uint256 public priceDownThreshold;
    uint256 public priceBNBDecision;
    uint256 public priceDecision;

    function initialize() external initializer {
        __Ownable_init();
        
        // OPTX = IERC20Upgradeable(0x4Ef0F0f98326830d823F28174579C39592cDB367);
        // BUSD = IERC20Upgradeable(0x4Ef0F0f98326830d823F28174579C39592cDB367);
        // commandSwapRouter = IDEXRouter(0x39255DA12f96Bb587c7ea7F22Eead8087b0a59ae);

        // lmsEnabled = false;
    }

    function executeCommandBNBPairLMS(uint256 bnbPrice) external view returns(string memory) {
        
        if(!lmsEnabled) return "LMS is disabled";
        (uint256 optxRes, uint256 bnbRes) = getPairReserves(commandBNBPairAddress);
        if(optxRes == 0 || bnbRes == 0) return "Pair does not exist";
        
        uint256 currentPrice = bnbRes * bnbPrice / optxRes;
        if(currentPrice >= priceDownThreshold && currentPrice <= priceUpThreshold) return "Price is in our range";
        if(currentPrice > priceUpThreshold) {
            return "Price is out of Up Threshold";
        }
        if(currentPrice < priceDownThreshold) {
            return "Price is down of Down Threshold";
        }
    }

    function executeCommandBUSDPairLMS() external view returns(string memory) {
        
        if(!lmsEnabled) return "LMS is disabled";
        (uint256 optxRes, uint256 busdRes) = getPairReserves(commandBUSDPairAddress);
        if(optxRes == 0 || busdRes == 0) return "Pair does not exist";
        
        uint256 currentPrice = busdRes * priceDecision / optxRes;
        if(currentPrice >= priceDownThreshold && currentPrice <= priceUpThreshold) return "Price is in our range";
        if(currentPrice > priceUpThreshold) {
            return "Price is out of Up Threshold";
        }
        if(currentPrice < priceDownThreshold) {
            return "Price is down of Down Threshold";
        }
    }

    function executePancakeBNBPairLMS() external returns(string memory) {

    }

    function executePancakeBUSDPairLMS() external returns(string memory) {

    }

    function getPairReserves(address _pairAddr) public view returns(uint256, uint256) {
        
        IDEXPair optxPair = IDEXPair(_pairAddr);
        (uint256 res0, uint256 res1, ) = optxPair.getReserves();
        
        uint256 optxReserve = res1;
        uint256 nativeReserve  = res0;

        address token0 = commandBNBPair.token0();
        if(token0 == optxAddress) {
            optxReserve = res0;
            nativeReserve  = res1;
        }

        return (optxReserve, nativeReserve);
    }

    function setLMSEnabled(bool _enable) external {
        lmsEnabled = _enable;
    }

    function setCommandPairs(address _bnbPairAddr, address _busdPairAddr) external {
        commandBNBPair  = IDEXPair(_bnbPairAddr);
        commandBUSDPair = IDEXPair(_busdPairAddr);
        commandBNBPairAddress  = _bnbPairAddr;
        commandBUSDPairAddress = _busdPairAddr;
    }

    function setPancakePairs(address _bnbPairAddr, address _busdPairAddr) external {
        pancakeBNBPair  = IDEXPair(_bnbPairAddr);
        pancakeBUSDPair = IDEXPair(_busdPairAddr);
        pancakeBNBPairAddress  = _bnbPairAddr;
        pancakeBUSDPairAddress = _busdPairAddr;
    }

    function setIntialValues(uint256 _up, uint256 _down, uint256 _bnbNum, uint256 _num) external {
        priceUpThreshold   = _up;
        priceDownThreshold = _down;
        priceBNBDecision = _bnbNum;
        priceDecision = _num;
    }
}