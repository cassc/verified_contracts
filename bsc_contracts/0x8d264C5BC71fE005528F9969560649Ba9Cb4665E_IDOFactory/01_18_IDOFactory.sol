//SPDX-License-Identifier: no license
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import "./IDOPool.sol";

contract IDOFactory is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20Burnable;
    using SafeERC20 for ERC20;

    address payable public feeWallet;
    uint256 public feeAmount;
    uint256 public burnPercent; // use this state only if your token is ERC20Burnable and has burnFrom method
    uint256 public divider;

    event IDOCreated(
        address indexed owner,
        address idoPool,
        address indexed rewardToken,
        string tokenURI
    );

    event FeeAmountUpdated(uint256 newFeeAmount);
    event BurnPercentUpdated(uint256 newBurnPercent, uint256 divider);
    event FeeWalletUpdated(address newFeeWallet);

    constructor(
        address payable _feeWallet,
        uint256 _feeAmount,
        uint256 _burnPercent
    ){
        feeWallet = _feeWallet;
        feeAmount = _feeAmount;
        burnPercent = _burnPercent;
        divider = 100;
    }

    function setFeeAmount(uint256 _newFeeAmount) external onlyOwner {
        feeAmount = _newFeeAmount;

        emit FeeAmountUpdated(_newFeeAmount);
    }

    function setFeeWallet(address payable _newFeeWallet) external onlyOwner {
        feeWallet = _newFeeWallet;

        emit FeeWalletUpdated(_newFeeWallet);
    }

    function setBurnPercent(uint256 _newBurnPercent, uint256 _newDivider)
        external
        onlyOwner
    {
        require(_newBurnPercent <= _newDivider, "Burn percent must be less than divider");
        burnPercent = _newBurnPercent;
        divider = _newDivider;

        emit BurnPercentUpdated(_newBurnPercent, _newDivider);
    }

    function createIDO(
        ERC20 _rewardToken,
        IDOPool.FinInfo memory _finInfo,
        IDOPool.Timestamps memory _timestamps,
        IDOPool.DEXInfo memory _dexInfo,
        address _lockerFactoryAddress,
        string memory _metadataURL
    ) external payable {
        IDOPool idoPool =
            new IDOPool(
                _rewardToken,
                _finInfo,
                _timestamps,
                _dexInfo,
                _lockerFactoryAddress,
                _metadataURL
            );

        uint256 transferAmount = getTokenAmount(_finInfo.hardCap, _finInfo.tokenPrice) + getTokenAmount(_finInfo.hardCap * _finInfo.lpInterestRate / 100, _finInfo.listingPrice);

        idoPool.transferOwnership(msg.sender);

        require(msg.value >= feeAmount, "Insufficient BNB");

        (bool success,) = feeWallet.call{value: feeAmount}("");
        require(success, "Failed to transfer BNB to fee wallet");

        if (burnPercent > 0){
            uint256 burnAmount = feeAmount.mul(burnPercent).div(divider);

            (success,) = msg.sender.call{value: burnAmount}("");
            require(success, "Failed to burn BNB from sender");
        }

        _rewardToken.safeTransferFrom(
            msg.sender,
            address(idoPool),
            transferAmount
        );

        emit IDOCreated(
            msg.sender,
address(idoPool),
address(_rewardToken),
_metadataURL
);
}
function getTokenAmount(uint256 _ethAmount, uint256 _rate)
    internal
    view
    returns (uint256)
{
    return _ethAmount.mul(_rate).div(10 ** 18);
}

function getTokenAmount(uint256 ethAmount, uint8 decimals, uint256 price)
    internal
    view
    returns (uint256)
{
    return ethAmount.mul(10**decimals).div(price);
}
}