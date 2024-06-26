pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
contract CappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _cap;
    uint256 private _maxContribution;
    uint256 private _minContribution;

    /**
     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
     * @param cap Max amount of wei to be contributed
     */
    constructor (uint256 cap, uint256 minContribution, uint256 maxContribution) public {
        require(cap > 0, "CappedCrowdsale: cap is 0");
        _cap = cap;
        _maxContribution = maxContribution;
        _minContribution = minContribution;
    }

    /**
     * @return the cap of the crowdsale.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    /**
     * @dev Checks whether the cap has been reached.
     * @return Whether the cap was reached
     */
    function capReached() public view returns (bool) {
        return weiRaised() >= _cap;
    }

    /**
     * @dev Extend parent behavior requiring purchase to respect the funding cap.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);
        require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
        require(weiAmount <= _maxContribution, "max contribution exceeded");
        require(weiAmount >= _minContribution, "contribution too low");
    }
}