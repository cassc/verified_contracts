// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./InitializableERC721.sol";
import "./IWrapperERC721.sol";
import "../WithdrawETH.sol";
import "../../initializable/IWrapperERC721Initializer.sol";

error AlreadyInitializedWrapperERC721();
error AmountMustBeGreaterThanZero();
error CallerNotOwnerOfWrappingToken();
error CallerNotOwnerOfWrappedToken();
error DefaultImplementationOfStakeDoesNotAcceptPayment();
error DefaultImplementationOfUnstakeDoesNotAcceptPayment();
error InvalidERC721Collection();
error InsufficientBalance();
error QuantityMustBeGreaterThanZero();
error RecipientMustBeNonZeroAddress();
error WithdrawalUnsuccessful();

abstract contract WrapperERC721 is InitializableERC721, WithdrawETH, IWrapperERC721, IWrapperERC721Initializer  {

    /// @dev Points to an external ERC721 contract that will be wrapped via staking.
    IERC721 private wrappedCollection;

    /// @dev Emitted when a user stakes their token to receive a creator token.
    event Staked(uint256 indexed tokenId, address indexed account);

    /// @dev Emitted when a user unstakes their creator token to receive the original token.
    event Unstaked(uint256 indexed tokenId, address indexed account);

    /// @dev Initializes parameters of AdventureERC721 tokens.
    /// These cannot be set in the constructor because this contract is optionally compatible with EIP-1167.
    function initializeWrapperERC721(address wrappedCollection_) public override onlyOwner {
        if(address(wrappedCollection) != address(0)) {
            revert AlreadyInitializedWrapperERC721();
        }

        bool isValidERC721Collection = false;

        if(wrappedCollection_.code.length > 0) {
            try IERC165(wrappedCollection_).supportsInterface(type(IERC721).interfaceId) returns (bool supportsERC721Interface) {
                isValidERC721Collection = supportsERC721Interface;
            } catch {}
        }

        if(!isValidERC721Collection) {
            revert InvalidERC721Collection();
        }

        wrappedCollection = IERC721(wrappedCollection_);
    }

    /// @dev ERC-165 interface support
    function supportsInterface(bytes4 interfaceId) public view virtual override(InitializableERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IWrapperERC721).interfaceId ||
            interfaceId == type(IWrapperERC721Initializer).interfaceId ||
           super.supportsInterface(interfaceId);
    }

    /// @notice Allows holders of the wrapped ERC721 token to stake into this enhanced ERC721 token.
    /// The out of the box enhancement is the capability enabled by the whitelisted transfer system.
    /// Developers can extend the functionality of this contract with additional powered up features.
    ///
    /// Throws when caller does not own the token id on the wrapped collection.
    /// Throws when inheriting contract reverts in the _onStake function (for example, in a pay to stake scenario).
    /// Throws when _mint function reverts (for example, when additional mint validation logic reverts).
    /// Throws when transferFrom function reverts (for example, if this contract does not have approval to transfer token).
    /// 
    /// Postconditions:
    /// ---------------
    /// The staker's token is now owned by this contract.
    /// The staker has received a wrapper token on this contract with the same token id.
    /// A `Staked` event has been emitted.
    function stake(uint256 tokenId) public virtual payable {
        address tokenOwner = wrappedCollection.ownerOf(tokenId);
        if(tokenOwner != _msgSender()) {
            revert CallerNotOwnerOfWrappedToken();
        }
        
        _onStake(tokenId, msg.value);
        _mint(tokenOwner, tokenId);
        emit Staked(tokenId, tokenOwner);
        wrappedCollection.transferFrom(tokenOwner, address(this), tokenId);
    }

    /// @notice Allows holders of this wrapper ERC721 token to unstake and receive the original wrapped token.
    /// 
    /// Throws when caller does not own the token id of this wrapper collection.
    /// Throws when inheriting contract reverts in the _onUnstake function (for example, in a pay to unstake scenario).
    /// Throws when _burn function reverts (for example, when additional burn validation logic reverts).
    /// Throws when transferFrom function reverts (should not be the case, unless wrapped token has additional transfer validation logic).
    ///
    /// Postconditions:
    /// ---------------
    /// The wrapper token has been burned.
    /// The wrapped token with the same token id has been transferred to the address that owned the wrapper token.
    /// An `Unstaked` event has been emitted.
    function unstake(uint256 tokenId) external payable {
        address tokenOwner = ownerOf(tokenId);
        if(tokenOwner != _msgSender()) {
            revert CallerNotOwnerOfWrappingToken();
        }

        _onUnstake(tokenId, msg.value);
        _burn(tokenId);
        emit Unstaked(tokenId, tokenOwner);
        wrappedCollection.transferFrom(address(this), tokenOwner, tokenId);
    }

    /// @notice Returns the address of the wrapped ERC721 contract.
    function getWrappedCollectionAddress() public view returns (address) {
        return address(wrappedCollection);
    }

    /// @notice Returns true if the specified token id is available to be unstaked, false otherwise.
    /// @dev This should be overridden in most cases by inheriting contracts to implement the proper constraints.
    /// In the base implementation, a token is available to be unstaked if the wrapped token is owned by this contract
    /// and the wrapper token exists.
    function canUnstake(uint256 tokenId) public virtual view returns (bool) {
        return _exists(tokenId) && wrappedCollection.ownerOf(tokenId) == address(this);
    }

    /// @dev Optional logic hook that fires during stake transaction.
    function _onStake(uint256 /*tokenId*/, uint256 value) internal virtual {
        if(value > 0) {
            revert DefaultImplementationOfStakeDoesNotAcceptPayment();
        }
    }

    /// @dev Optional logic hook that fires during unstake transaction.
    function _onUnstake(uint256 /*tokenId*/, uint256 value) internal virtual {
        if(value > 0) {
            revert DefaultImplementationOfUnstakeDoesNotAcceptPayment();
        }
    }
}