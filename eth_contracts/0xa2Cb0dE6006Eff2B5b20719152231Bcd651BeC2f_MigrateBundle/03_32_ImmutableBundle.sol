// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./NftfiBundler.sol";
import "./utils/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title ImmutableBundle
 * @author NFTfi
 * @notice Bundle wrapper that allows users to lock bundles so they can be used for loans.
 * @dev This contract prevents owners of the bundles to remove any child, but they can still receive new children.
 *      Solves the problem of bundles being emptied by their owner between they are listed and the loan begins.
 */
contract ImmutableBundle is ERC721Enumerable, IERC721Receiver, Ownable, Pausable {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    // Incremental token id
    uint256 public tokenCount = 0;

    // Address of the bundler contract
    NftfiBundler public immutable bundler;

    string public baseURI;

    // flag to toggle airdrop flashloan functionality
    bool public pullAirdropEnabled; //false by default

    // immutable tokenId => bundleId
    mapping(uint256 => uint256) public bundleOfImmutable;
    // bundleId => immutable tokenId
    mapping(uint256 => uint256) public immutableOfBundle;

    event ImmutableMinted(uint256 indexed immutableId, uint256 indexed bundleId);

    /**
     * @dev Stores the bundler, name and symbol
     *
     * @param _bundler Address of the bundler contract
     * @param _name name of the token contract
     * @param _symbol symbol of the token contract
     */
    constructor(
        address _admin,
        address _bundler,
        string memory _name,
        string memory _symbol,
        string memory _customBaseURI
    ) ERC721(_name, _symbol) Ownable(_admin) {
        bundler = NftfiBundler(_bundler);
        _setBaseURI(_customBaseURI);
        _pause();
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
        return _interfaceId == type(IERC721Receiver).interfaceId || super.supportsInterface(_interfaceId);
    }

    /**
     * @notice Mints a new bundle storing it as immutable bundle.
     *         The bundle can receive children but there is no way to remove a child, unless withdrawing the bundle.
     * @param _to The address that owns the new immutable bundle
     * @return The id of the new created immutable bundle
     */
    function mintBundle(address _to) external whenNotPaused returns (uint256) {
        uint256 bundleId = bundler.safeMint(address(this));
        return _mintImmutableBundle(_to, bundleId);
    }

    /**
     * @notice Method invoked when a bundle is received
     * param The address that caused the transfer
     * @param _from The previous owner of the token
     * @param _bundleId The bundle that is being transferred
     * param _data Arbitrary data
     * @return the selector of this method
     */
    function onERC721Received(
        address,
        address _from,
        uint256 _bundleId,
        bytes memory
    ) external virtual override whenNotPaused returns (bytes4) {
        require(msg.sender == address(bundler), "asset not allowed");

        // Special check for when onERC721Received is invoked from `mintBundle` call
        if (_from != address(0)) {
            _mintImmutableBundle(_from, _bundleId);
        }

        return this.onERC721Received.selector;
    }

    /**
     * @notice Withdraw a bundle
     * @param _immutableId the id of the immutable bundle
     * @param _to the address of the receiver of the bundle
     */
    function withdraw(uint256 _immutableId, address _to) external {
        _validateWithdraw(_immutableId, _to);

        uint256 bundleId = bundleOfImmutable[_immutableId];

        _burnImmutableBundle(_immutableId);

        bundler.safeTransferFrom(address(this), _to, bundleId);
    }

    /**
     * @notice Withdraw a bundle and remove all the children from the bundle
     * @param _immutableId the id of the immutable bundle
     * @param _to the address of the receiver of the bundle
     */
    function withdrawAndDecompose(uint256 _immutableId, address _to) external {
        _validateWithdraw(_immutableId, _to);

        uint256 bundleId = bundleOfImmutable[_immutableId];

        _burnImmutableBundle(_immutableId);

        bundler.decomposeBundle(bundleId, _to);
        bundler.safeTransferFrom(address(this), _to, bundleId);
    }

    /**
     * @notice this function initiates a flashloan to pull an airdrop from a tartget contract
     *
     * @param _immutableId - the id of the immutable bundle
     * @param _nftContract - contract address of the target nft of the drop
     * @param _nftId - id of the target nft of the drop
     * @param _target - address of the airdropping contract
     * @param _data - function selector to be called on the airdropping contract
     * @param _nftAirdrop - address of the used claiming nft in the drop
     * @param _nftAirdropId - id of the used claiming nft in the drop
     * @param _is1155 -
     * @param _nftAirdropAmount - amount in case of 1155
     */
    function pullAirdrop(
        uint256 _immutableId,
        address _nftContract,
        uint256 _nftId,
        address _target,
        bytes calldata _data,
        address _nftAirdrop,
        uint256 _nftAirdropId,
        bool _is1155,
        uint256 _nftAirdropAmount
    ) external {
        require(pullAirdropEnabled, "pullAirdrop feature disabled");

        require(ownerOf(_immutableId) == msg.sender, "pullAirdrop msg.sender not eligible");

        (, uint256 bundleId) = bundler.ownerOfChild(_nftContract, _nftId);
        require(bundleOfImmutable[_immutableId] == bundleId, "immutable-nft mismatch");
        bundler.pullAirdrop(
            _nftContract,
            _nftId,
            _target,
            _data,
            _nftAirdrop,
            _nftAirdropId,
            _is1155,
            _nftAirdropAmount,
            msg.sender
        );
    }

    /**
     * @notice Validates the withdraw params
     * @param _immutableId the id of the immutable bundle
     * @param _to the address of the receiver of the bundle
     */
    function _validateWithdraw(uint256 _immutableId, address _to) internal view {
        require(ownerOf(_immutableId) == msg.sender, "caller is not owner");
        require(_to != address(0), "transfer to zero address");
    }

    /**
     * @notice Mints a new immutable bundle.
     * @param _to The address that owns the new immutable bundle
     * @param _bundleId The associated bundle id
     * @return The id of the new created immutable bundle
     */
    function _mintImmutableBundle(address _to, uint256 _bundleId) internal returns (uint256) {
        uint256 immutableId = ++tokenCount;
        _safeMint(_to, immutableId);
        bundleOfImmutable[immutableId] = _bundleId;
        immutableOfBundle[_bundleId] = immutableId;
        emit ImmutableMinted(immutableId, _bundleId);
        return immutableId;
    }

    /**
     * @notice Burns an immutable bundle
     * @param _immutableId the id of the immutable bundle
     */
    function _burnImmutableBundle(uint256 _immutableId) internal {
        _burn(_immutableId);

        uint256 bundleId = bundleOfImmutable[_immutableId];
        delete bundleOfImmutable[_immutableId];
        delete immutableOfBundle[bundleId];
    }

    /**
     * @notice used by the owner account to be able to drain ERC721 tokens received as airdrops
     * for the locked  collateral NFT-s
     * @param _tokenAddress - address of the token contract for the token to be sent out
     * @param _tokenId - id token to be sent out
     * @param _receiver - receiver of the token
     */
    function rescueERC721(
        address _tokenAddress,
        uint256 _tokenId,
        address _receiver
    ) external onlyOwner {
        IERC721 tokenContract = IERC721(_tokenAddress);
        if (_tokenAddress == address(bundler)) {
            require(immutableOfBundle[_tokenId] == 0, "token is in immutable");
        }
        require(tokenContract.ownerOf(_tokenId) == address(this), "nft not owned");
        tokenContract.safeTransferFrom(address(this), _receiver, _tokenId);
    }

    /**
     * @notice used by the owner account to be able to drain ERC20 tokens received as airdrops
     * for the locked  collateral NFT-s
     * @param _tokenAddress - address of the token contract for the token to be sent out
     * @param _receiver - receiver of the token
     */
    function rescueERC20(address _tokenAddress, address _receiver) external onlyOwner {
        IERC20 tokenContract = IERC20(_tokenAddress);
        uint256 amount = tokenContract.balanceOf(address(this));
        require(amount > 0, "no tokens owned");
        tokenContract.safeTransfer(_receiver, amount);
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - Only the owner can call this method.
     * - The contract must not be paused.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - Only the owner can call this method.
     * - The contract must be paused.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Toggles airdrop flashloan feature
     * @param _pullAirdropEnabled - bool flag
     */
    function setPullAirdropEnabled(bool _pullAirdropEnabled) external onlyOwner {
        pullAirdropEnabled = _pullAirdropEnabled;
    }

    /**
     * @dev Sets baseURI.
     * @param _customBaseURI - Base URI
     */
    function setBaseURI(string memory _customBaseURI) external onlyOwner {
        _setBaseURI(_customBaseURI);
    }

    /**
     * @dev Sets baseURI.
     */
    function _setBaseURI(string memory _customBaseURI) internal virtual {
        baseURI = bytes(_customBaseURI).length > 0
            ? string(abi.encodePacked(_customBaseURI, _getChainID().toString(), "/"))
            : "";
    }

    /** @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
     * @dev This function gets the current chain ID.
     */
    function _getChainID() internal view returns (uint256) {
        uint256 id;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            id := chainid()
        }
        return id;
    }
}