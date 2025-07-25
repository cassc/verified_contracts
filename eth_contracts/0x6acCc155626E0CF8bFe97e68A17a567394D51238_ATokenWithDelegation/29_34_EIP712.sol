// SPDX-License-Identifier: MIT
// Contract modified from OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol) to remove local
// fallback storage variables, so contract does not affect on existing storage layout. This works as its used on contracts
// that have name and revision < 32 bytes

pragma solidity ^0.8.10;

import {ECDSA} from 'openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol';
import {ShortStrings, ShortString} from 'openzeppelin-contracts/contracts/utils/ShortStrings.sol';
import {IERC5267} from 'openzeppelin-contracts/contracts/interfaces/IERC5267.sol';

/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 *
 * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
 * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
 * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
 *
 * _Available since v3.4._
 *
 * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
 */
abstract contract EIP712 is IERC5267 {
  using ShortStrings for *;

  bytes32 private constant _TYPE_HASH =
    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');

  // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
  // invalidate the cached domain separator if the chain id changes.
  bytes32 private immutable _cachedDomainSeparator;
  uint256 private immutable _cachedChainId;
  address private immutable _cachedThis;

  bytes32 private immutable _hashedName;
  bytes32 private immutable _hashedVersion;

  ShortString private immutable _name;
  ShortString private immutable _version;

  /**
   * @dev Initializes the domain separator and parameter caches.
   *
   * The meaning of `name` and `version` is specified in
   * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
   *
   * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
   * - `version`: the current major version of the signing domain.
   *
   * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
   * contract upgrade].
   */
  /// @dev BGD: removed usage of fallback variables to not modify previous storage layout. As we know that the length of
  ///           name and version will not be bigger than 32 bytes we use toShortString as there is no need to use the fallback system.
  constructor(string memory name, string memory version) {
    _name = name.toShortString();
    _version = version.toShortString();
    _hashedName = keccak256(bytes(name));
    _hashedVersion = keccak256(bytes(version));

    _cachedChainId = block.chainid;
    _cachedDomainSeparator = _buildDomainSeparator();
    _cachedThis = address(this);
  }

  /**
   * @dev Returns the domain separator for the current chain.
   */
  function _domainSeparatorV4() internal view returns (bytes32) {
    if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
      return _cachedDomainSeparator;
    } else {
      return _buildDomainSeparator();
    }
  }

  function _buildDomainSeparator() private view returns (bytes32) {
    return
      keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
  }

  /**
   * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
   * function returns the hash of the fully encoded EIP712 message for this domain.
   *
   * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
   *
   * ```solidity
   * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
   *     keccak256("Mail(address to,string contents)"),
   *     mailTo,
   *     keccak256(bytes(mailContents))
   * )));
   * address signer = ECDSA.recover(digest, signature);
   * ```
   */
  function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
    return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
  }

  /**
   * @dev See {EIP-5267}.
   *
   * _Available since v4.9._
   */
  function eip712Domain()
    public
    view
    virtual
    returns (
      bytes1 fields,
      string memory name,
      string memory version,
      uint256 chainId,
      address verifyingContract,
      bytes32 salt,
      uint256[] memory extensions
    )
  {
    return (
      hex'0f', // 01111
      _EIP712Name(),
      _EIP712Version(),
      block.chainid,
      address(this),
      bytes32(0),
      new uint256[](0)
    );
  }

  /**
   * @dev The name parameter for the EIP712 domain.
   *
   * NOTE: By default this function reads _name which is an immutable value.
   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
   *
   * _Available since v5.0._
   */
  /// @dev BGD: we use toString instead of toStringWithFallback as we dont have fallback, to not modify previous storage layout
  // solhint-disable-next-line func-name-mixedcase
  function _EIP712Name() internal view returns (string memory) {
    return _name.toString(); // _name.toStringWithFallback(_nameFallback);
  }

  /**
   * @dev The version parameter for the EIP712 domain.
   *
   * NOTE: By default this function reads _version which is an immutable value.
   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
   *
   * _Available since v5.0._
   */
  /// @dev BGD: we use toString instead of toStringWithFallback as we dont have fallback, to not modify previous storage layout
  // solhint-disable-next-line func-name-mixedcase
  function _EIP712Version() internal view returns (string memory) {
    return _version.toString();
  }
}