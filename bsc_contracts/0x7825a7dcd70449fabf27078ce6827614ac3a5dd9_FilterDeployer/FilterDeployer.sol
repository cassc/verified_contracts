/**
 *Submitted for verification at BscScan.com on 2023-01-07
*/

//FilterSwap (V1): filterswap.exchange

pragma solidity ^0.8;

interface IFilterManager { 
    function treasuryAddress() external view returns (address);
    function distributorAddress() external view returns (address);
    function routerAddress() external view returns (address);
    function deployerMintFee() external view returns (uint);
    function deployerMaxOwnerShare() external view returns (uint);
    function tokenTemplateAddresses(uint) external view returns (address);
    function isTokenVerified(address) external view returns (bool);
    function verifyToken(address) external;
}

interface IERC20 {
    function balanceOf(address) external view returns (uint);
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function approve(address, uint) external returns (bool);
}

interface IFilterRouter {
    function addLiquidity(address, address, uint, uint, uint, uint, address, uint, uint) external returns (uint, uint, uint);
    function addLiquidityETH(address, uint, uint, uint, address, uint, uint) external payable returns (uint, uint, uint);
}

interface IDeployedToken {
    function initializeToken(string memory, string memory, address, address, bytes32[] memory) external;
}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        require(IERC20(token).approve(to, value), "FilterDeployer: APPROVE_FAILED");
    }

    function safeTransfer(address token, address to, uint value) internal {
        require(IERC20(token).transfer(to, value), "FilterDeployer: TRANSFER_FAILED");
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        require(IERC20(token).transferFrom(from, to, value), "FilterDeployer: TRANSFER_FROM_FAILED");
    }
}

contract FilterDeployer {
    address public managerAddress;
    IFilterManager filterManager;

    constructor(address _managerAddress) {
        managerAddress = _managerAddress;
        filterManager = IFilterManager(managerAddress);
    }

    function cloneContract(address _addressToClone) private returns (address) {
        address deployedAddress;

        assembly {
            mstore(0x0, or (0x5880730000000000000000000000000000000000000000803b80938091923cF3, mul(_addressToClone, 0x1000000000000000000)))
            deployedAddress := create(0, 0, 32)
        }

        return deployedAddress;
    }

    function createToken(uint _tokenType, string memory _tokenName, string memory _tokenSymbol, bytes32[] memory _tokenArgs, address _baseTokenAddress, uint _baseTokenAmount, uint _ownerShare, uint _liquidityLockTime) external returns (address deployedTokenAddress) {
        require(_ownerShare <= filterManager.deployerMaxOwnerShare(), "FilterDeployer: OWNER_SHARE_TOO_HIGH");
        require(filterManager.tokenTemplateAddresses(_tokenType) != address(0), "FilterDeployer: INVALID_TOKEN_TYPE");
        require(IERC20(_baseTokenAddress).balanceOf(msg.sender) >= _baseTokenAmount, "FilterDeployer: INSUFFICIENT_BASE_TOKEN_AMOUNT");
        require(filterManager.isTokenVerified(_baseTokenAddress), "FilterDeployer: BASE_TOKEN_NOT_VERIFIED");

        TransferHelper.safeTransferFrom(_baseTokenAddress, msg.sender, address(this), _baseTokenAmount);
        TransferHelper.safeTransfer(_baseTokenAddress, filterManager.treasuryAddress(), (filterManager.deployerMintFee() * IERC20(_baseTokenAddress).balanceOf(address(this))) / 10000);

        deployedTokenAddress = cloneContract(filterManager.tokenTemplateAddresses(_tokenType));

        IDeployedToken(deployedTokenAddress).initializeToken(_tokenName, _tokenSymbol, msg.sender, address(this), _tokenArgs);
        TransferHelper.safeTransfer(deployedTokenAddress, msg.sender, (IERC20(deployedTokenAddress).balanceOf(address(this)) * _ownerShare) / 10000);
        filterManager.verifyToken(deployedTokenAddress);

        TransferHelper.safeApprove(_baseTokenAddress, filterManager.routerAddress(), type(uint).max);
        TransferHelper.safeApprove(deployedTokenAddress, filterManager.routerAddress(), type(uint).max);

        IFilterRouter(filterManager.routerAddress()).addLiquidity(
            _baseTokenAddress,
            deployedTokenAddress,
            IERC20(_baseTokenAddress).balanceOf(address(this)),
            IERC20(deployedTokenAddress).balanceOf(address(this)),
            0,
            0,
            msg.sender,
            block.timestamp,
            _liquidityLockTime
        ); 
    }

    function createTokenETH(uint _tokenType, string memory _tokenName, string memory _tokenSymbol, bytes32[] memory _tokenArgs, uint _ownerShare, uint _liquidityLockTime) external payable returns (address deployedTokenAddress) {
        require(_ownerShare <= filterManager.deployerMaxOwnerShare(), "FilterDeployer: OWNER_SHARE_TOO_HIGH");
        require(filterManager.tokenTemplateAddresses(_tokenType) != address(0), "FilterDeployer: INVALID_TOKEN_TYPE");
        require(msg.value > 0, "FilterDeployer: NO_ETH_SUPPLIED");

        payable(filterManager.treasuryAddress()).transfer((filterManager.deployerMintFee() * address(this).balance) / 10000);

        deployedTokenAddress = cloneContract(filterManager.tokenTemplateAddresses(_tokenType));
        IDeployedToken(deployedTokenAddress).initializeToken(_tokenName, _tokenSymbol, msg.sender, address(this), _tokenArgs);

        TransferHelper.safeTransfer(deployedTokenAddress, msg.sender, (IERC20(deployedTokenAddress).balanceOf(address(this)) * _ownerShare) / 10000);
        filterManager.verifyToken(deployedTokenAddress);
        TransferHelper.safeApprove(deployedTokenAddress, filterManager.routerAddress(), type(uint).max);

        IFilterRouter(filterManager.routerAddress()).addLiquidityETH{value: address(this).balance}(
            deployedTokenAddress,
            IERC20(deployedTokenAddress).balanceOf(address(this)),
            0,
            0,
            msg.sender,
            block.timestamp,
            _liquidityLockTime
        );        
    }

    function createPresaleToken(uint _tokenType, string memory _tokenName, string memory _tokenSymbol, bytes32[] memory _tokenArgs, address _ownerAddress) external returns (address deployedTokenAddress) {
        require(msg.sender == filterManager.distributorAddress());

        deployedTokenAddress = cloneContract(filterManager.tokenTemplateAddresses(_tokenType));
        IDeployedToken(deployedTokenAddress).initializeToken(_tokenName, _tokenSymbol, _ownerAddress, msg.sender, _tokenArgs);
    }
}