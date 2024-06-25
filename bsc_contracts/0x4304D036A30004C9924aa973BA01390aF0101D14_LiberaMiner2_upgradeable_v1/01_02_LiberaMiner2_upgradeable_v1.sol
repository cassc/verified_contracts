// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
pragma solidity 0.8.4;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b!=0,"division by zero");
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly {
            r.slot := slot
        }
    }
}

abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
     */
    modifier initializer() {
        bool isTopLevelCall = _setInitializedVersion(1);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
     * initialization step. This is essential to configure modules that are added through upgrades and that require
     * initialization.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     */
    modifier reinitializer(uint8 version) {
        bool isTopLevelCall = _setInitializedVersion(version);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(version);
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     */
    function _disableInitializers() internal virtual {
        _setInitializedVersion(type(uint8).max);
    }

    function _setInitializedVersion(uint8 version) private returns (bool) {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
        // of initializers, because in other contexts the contract may have been reentered.
        if (_initializing) {
            require(
                version == 1 && !AddressUpgradeable.isContract(address(this)),
                "Initializable: contract is already initialized"
            );
            return false;
        } else {
            require(_initialized < version, "Initializable: contract is already initialized");
            _initialized = version;
            return true;
        }
    }
}

abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    uint256[50] private __gap;
}

interface IERC1822ProxiableUpgradeable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}



abstract contract ERC1967UpgradeUpgradeable is Initializable {
    function __ERC1967Upgrade_init() internal onlyInitializing {
    }

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
    }
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallUUPS(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        // Upgrades from old implementations will perform a rollback test. This test requires the new
        // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
        // this special case will break upgrade paths from old UUPS implementation to new ones.
        if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
            _setImplementation(newImplementation);
        } else {
            try IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot) {
                require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
            } catch {
                revert("ERC1967Upgrade: new implementation is not UUPS");
            }
            _upgradeToAndCall(newImplementation, data, forceCall);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Emitted when the beacon is upgraded.
     */
    event BeaconUpgraded(address indexed beacon);

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(
        address newBeacon,
        bytes memory data,
        bool forceCall
    ) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
        }
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function _functionDelegateCall(address target, bytes memory data) private returns (bytes memory) {
        require(AddressUpgradeable.isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return AddressUpgradeable.verifyCallResult(success, returndata, "Address: low-level delegate call failed");
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

abstract contract UUPSUpgradeable is Initializable, IERC1822ProxiableUpgradeable, ERC1967UpgradeUpgradeable {
    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(address(this) != __self, "Function must be called through delegatecall");
        require(_getImplementation() == __self, "Function must be called through active proxy");
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        require(address(this) == __self, "UUPSUpgradeable: must not be called through delegatecall");
        _;
    }

    /**
     * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate that the this implementation remains valid after an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeTo(address newImplementation) external virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

abstract contract AuthUpgradeable is Initializable, UUPSUpgradeable, ContextUpgradeable {
    address owner;
    mapping (address => bool) private authorizations;

    function __AuthUpgradeable_init() internal onlyInitializing {
        __AuthUpgradeable_init_unchained();
    }

    function __AuthUpgradeable_init_unchained() internal onlyInitializing {
        owner = _msgSender();
        authorizations[_msgSender()] = true;
        __UUPSUpgradeable_init();
    }

    modifier onlyOwner() {
        require(isOwner(_msgSender())); _;
    }

    modifier authorized() {
        require(isAuthorized(_msgSender())); _;
    }

    function authorize(address _address) public onlyOwner {
        authorizations[_address] = true;
        emit Authorized(_address);
    }

    function unauthorize(address _address) public onlyOwner {
        authorizations[_address] = false;
        emit Unauthorized(_address);
    }

    function isOwner(address _address) public view returns (bool) {
        return _address == owner;
    }

    function isAuthorized(address _address) public view returns (bool) {
        return authorizations[_address];
    }

    function transferOwnership(address newOwner) public onlyOwner {
        address oldOwner = owner;
        owner = newOwner;
        authorizations[oldOwner] = false;
        authorizations[newOwner] = true;
        emit Unauthorized(oldOwner);
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    event OwnershipTransferred(address oldOwner, address newOwner);
    event Authorized(address _address);
    event Unauthorized(address _address);

    uint256[49] private __gap;
}

abstract contract ReentrancyGuardUpgradeable {
    uint256 private constant _NOT_ENTERED = 0;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

interface IAutoMiner {
}

contract LiberaMiner2_upgradeable_v1 is Initializable, UUPSUpgradeable, AuthUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMath for uint256;

    IAutoMiner public AUTO_CONTRACT;
    IERC20Upgradeable public token_MAIN;

    uint256 public EGGS_TO_HIRE_1MINERS;// 18% 479520; 3% 2592000; 8% 1080000;
    uint256 public marketEggs; //baked beans 86400000000

    uint256 public PERCENTS_DIVIDER;
    uint256 public MAX_TAX;
    uint256 public REFERRAL;
    bool public DEFAULT_REFERRAL;

    uint256 public MARKET_EGGS_DIVISOR; // 20%
    uint256 public MARKET_EGGS_DIVISOR_COMPOUND; // 20%
    uint256 public MARKET_EGGS_DIVISOR_SELL; // 100%

    uint256 public MIN_INVEST_LIMIT; /** change to 10 * 1e18 = 10 BUSD  **/
    uint256 public WALLET_DEPOSIT_LIMIT; /** 50000 BUSD  **/

    uint256 public MAX_EARNINGS; /** 300%  **/

    uint256 public COMPOUND_TAX; // 10%  per compound
    uint256 public COMPOUND_BONUS; // 0.1%  per compound
    uint256 public COMPOUND_BONUS_MAX_TIMES; // 10
    uint256 public COMPOUND_STEP; // 24 * 60 *60 so every 24 hours. **/
    uint256 public WITHDRAW_STEP ; // 7 * 24 * 60 *60 so every 7 days **/
    uint256 public CUTOFF_STEP; /** 24 * 60 * 60 = 24 hours  **/
    uint256 public ZERO_STEP; /** 26 * 60 * 60 = 26 hours  **/

    uint256 public WITHDRAW_TAX; // 20%
    uint256 public WITHDRAW_LIMIT;

    uint256 public TAX_ACCELERATOR ;

    uint256 PSN;
    uint256 PSNH;

    uint256 public allFee; // 7% to treasury
    uint256 public AUTO_TAX;
    bool public AUTO_ENABLED;
    uint256 public AUTO_MIN_DEPOSIT;
    uint256 public WHALE_TAX_MULTIPLIER;


    uint256 public BIGGEST_BUYER_PERCENTAGE ; // 1%
    uint256 public BUYING_POWER_STEP_PERDAY; // 0.1%

    bool public paused;

    uint256 public totalStaked;
    uint256 public totalUsers;
    uint256 public totalCompound;
    uint256 public totalRefBonus;
    uint256 public totalWithdrawn;
    uint256 public totalTaxWithDrawn;
    uint256 public totalMinersAdjusted;
    uint256 public totalAutoPaid;

    bool public contractStarted;

    address public treasury;
    address public bankWallet;


    struct User {
        uint256 initialDeposit;
        uint256 userDeposit;
        uint256 miners;
        uint256 claimedEggs;
        uint256 lastHatch;
        address referrer;
        uint256 referralsCount;
        uint256 referralRewards;
        uint256 totalWithdrawn;
        uint256 dailyCompoundBonus;
        uint256 lastWithdrawTime;
    }

    mapping(address => User) public users;
    mapping(address => uint256) public rewarded;

    /** Reward Biggest Buyer **/
    bool public isRewardBiggestBuyer;
    uint256 public biggestBuyerPeriod; // to do: change this to 24*3600;
    uint256 public launchTime;
    uint256 public totalBiggestBuyerPaid;
    mapping(uint256 => address) public biggestBuyer;
    mapping(uint256 => uint256) public biggestBuyerAmount;
    mapping(uint256 => uint256) public biggestBuyerPaid;
    mapping(address => bool) public LockMagic;


    function initialize() public initializer {
        __UUPSUpgradeable_init();
        __AuthUpgradeable_init();

        treasury = 0x4Dfa03c64ABd96359B77E7cCa8219B451C19f27E;
        bankWallet = 0x17Eca3A2aFDff586e5D66c992554ea29fF9Cb11D;

        AUTO_CONTRACT = IAutoMiner(0xBac82EB24616DB1dbf691407132147cf5E598CbE); // to do: build contract auto then address here

        authorize(address(AUTO_CONTRACT));

        token_MAIN = IERC20Upgradeable(0x22D954CA5540caB869AdA9bd9d339CDE3a9313b3);
        EGGS_TO_HIRE_1MINERS = 2592000;// 18% 479520; 3% 2592000; 8% 1080000;

        PERCENTS_DIVIDER = 1000;
        MAX_TAX = PERCENTS_DIVIDER*99/100;
        REFERRAL = 30;
        DEFAULT_REFERRAL = true;

        MARKET_EGGS_DIVISOR = 5; // 20%
        MARKET_EGGS_DIVISOR_COMPOUND = 2; // 33%
        MARKET_EGGS_DIVISOR_SELL = 1; // 100%

        MIN_INVEST_LIMIT = 5 * 1e18; // 5 LP ~ 6 usd
        WALLET_DEPOSIT_LIMIT = 50000000000000000000000 * 1e18; /** 50000 LP ~ 50000 usd **/

        MAX_EARNINGS = 3000; /** 300%  **/

        COMPOUND_TAX = 100; // 10%  per compound
        COMPOUND_BONUS = 5; // 0.5%  per compound
        COMPOUND_BONUS_MAX_TIMES = 5;
        COMPOUND_STEP = 24 * 60 * 60;
        WITHDRAW_STEP = 7 * COMPOUND_STEP;
        CUTOFF_STEP = 1 * COMPOUND_STEP;
        ZERO_STEP = COMPOUND_STEP + 48 * 3600; //48 hours later, to do: change to 1 hour later

        WITHDRAW_TAX = 200; // 20%
        WITHDRAW_LIMIT = 2000 * 1e18; // 2000 LP ~ 2000 usd

        TAX_ACCELERATOR = 2000;

        allFee = 80; // 8% to treasury
        AUTO_TAX = 50; // 5%
        AUTO_ENABLED = true; //remember to authorize auto_contract to miner address
        AUTO_MIN_DEPOSIT = 1000 * 10**18; // 1000 LP ~ 1200 usd
        WHALE_TAX_MULTIPLIER=5;

        BIGGEST_BUYER_PERCENTAGE = 3; // 0.5%
        BUYING_POWER_STEP_PERDAY = 2; // 0.2%
        isRewardBiggestBuyer = true;
        biggestBuyerPeriod = COMPOUND_STEP;

        paused = false;

        PSN = 10000;
        PSNH = 5000;

        //to do: every thing
        marketEggs = 1423275283448924;
        totalStaked = 1536525960832386566979513;
        totalUsers = 4219;
        totalCompound = 3748703494594925662189309;
        totalRefBonus = 121394774526704694158532;
        totalWithdrawn = 409209492010989079135336;
        totalTaxWithDrawn = 138357531710707097886417;
        totalMinersAdjusted = 10468486;
        totalAutoPaid = 113633540673482962361176;
        totalBiggestBuyerPaid = 604763841530432006822413;

        contractStarted = true;
        launchTime = 1654178620;

    }

    ///@dev required by the OZ UUPS module
    function _authorizeUpgrade(address) internal override onlyOwner {}

    function compoundEggs() whenNotPaused nonReentrant public {
    }

    event HatchEggsFor(address adr, bool isAuto);

    function hatchEggsForAuto(address adr) external authorized {
    }

    function sellEggsForAuto(address adr) external authorized {
    }

    event SellEggsFor(address adr, bool isAuto);

    function sellEggs() whenNotPaused nonReentrant public{
    }

    function buyEggsForMe(address ref, uint256 amount) public {
    }

    function buyEggs(address buyer, address ref, uint256 amount) whenNotPaused nonReentrant public {
    }

    event BuyEggsFor(address buyer, address ref, uint256 amount, bool realBuy);

    function canCompound(address _adr) public view returns(bool) {
    }

    function canWithdraw(address _adr) public view returns(bool) {
    }

    function startPool(uint256 amount) public onlyOwner {
    }

    function getBalance() public view returns (uint256) {
        return totalStaked.sub(totalWithdrawn).sub(totalTaxWithDrawn);
    }

    function getTimeStamp() public view returns (uint256) {
        return block.timestamp;
    }

    function getNextCompoundBonus(address _adr) public view returns(uint256 totalBonus) {
    }

    function getNormalWithdrawalTax(address _adr) public view returns(uint256 withdrawTax) {
    }

    function getNextWithdrawalTax(address _adr) public view returns(uint256 withdrawTax) {
    }

    function getNextCompoundTax(address _adr) public view returns(uint256 compoundTax) {
    }

    function getAvailableEarnings(address _adr) public view returns(uint256) {
    }

    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
    }

    function calculateEggSell(uint256 eggs) public view returns(uint256){
    }

    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
    }

    function calculateEggBuySimple(uint256 eth) public view returns(uint256){
    }

    function getEggsYield(uint256 amount) public view returns(uint256 _miners,uint256 _earningsPerDay) {
    }

    function recalculateMiner(uint256 userDeposit) public view returns(uint256 miners){
    }

    function getUserEarningsPerDay(address adr) public view returns(uint256 _miners,uint256 _earningsPerDay,uint256 _aprDay, uint256 _aprDayOnDeposit) {
    }

    function calculateEggSellForYield(uint256 eggs,uint256 amount) public view returns(uint256){
    }

    function getMaxPayOutLeft(address adr) public view returns(uint256) {
    }

    function getEggs(address adr) public view returns(uint256){
    }

    function getEggsSinceLastHatch(address adr) public view returns(uint256){
    }

    function SET_WALLETS(address _treasury, address _bankWallet) external onlyOwner {
    }

    function SET_AUTO(address autoMiner, bool _AUTO_ENABLED, uint256 _AUTO_TAX, uint256 _AUTO_MIN_DEPOSIT) external onlyOwner {
    }

    function SET_REFERRAL(uint256 value, bool _DEFAULT_REFERRAL) external onlyOwner{
    }

    function SET_MARKET_EGGS_DIVISOR(uint256 _MARKET_EGGS_DIVISOR,uint256 _MARKET_EGGS_DIVISOR_COMPOUND,uint256 _MARKET_EGGS_DIVISOR_SELL) external onlyOwner{
    }

    /** withdrawal tax **/
    function SET_WITHDRAWAL(uint256 _WITHDRAW_STEP, uint256 _WITHDRAW_TAX, uint256 _WITHDRAW_LIMIT) external onlyOwner {
    }

    function SET_COMPOUND(uint256 _COMPOUND_BONUS_MAX_TIMES, uint256 _COMPOUND_STEP, uint256 _COMPOUND_BONUS, uint256 _COMPOUND_TAX) external onlyOwner {
    }

    function SET_WALLET_DEPOSIT_LIMIT(uint256 _MIN_INVEST_LIMIT,uint256 _WALLET_DEPOSIT_LIMIT) external onlyOwner{
    }

    function SET_WHALE_TAX_MULTIPLIER(uint256 value) external onlyOwner {
    }

    function SET_BIGGEST_BUYER(bool _status, uint256 _biggestBuyerPeriod, uint256 _BIGGEST_BUYER_PERCENTAGE) external onlyOwner {
    }

    function SET_BUYING_POWER_STEP_PERDAY(uint256 _BUYING_POWER_STEP_PERDAY) external onlyOwner {
    }

    function SET_ZERO_CUTOFF_STEP(uint256 _ZERO_STEP, uint256 _CUTOFF_STEP) external onlyOwner { // set to 0 to disable
    }

    function getPeriod() public view returns (uint256) {
    }

    function payBiggestBuyer(uint256 _hour) external authorized {
    }

    function getUserPercentage(address _adr) public view returns(uint256) {
    }

    function getWhaleTax(address _adr) public view returns(uint256 _whaleTax) {
    }

    modifier whenNotPaused() {
        require(contractStarted, "not Started");
        require(!paused, "paused");
        _;
    }
    function SET_PAUSED(bool _PAUSED) external onlyOwner{
    }

    function getPartnershipCount() external view returns(uint256) {
    }
    function getBonusPartnership(address adr) external view returns(uint256) {
    }
    function getBonusxThoreum(address adr) external view returns(uint256) {
    }
    function getAutomateCounts() external view returns(uint256) {
    }
    function automations(address adr) public view returns(bool) {
    }
    function ADD_AUTOMATE() whenNotPaused external {
    }
    function REMOVE_AUTOMATE()  whenNotPaused external {
    }
    function syncBalance() external onlyOwner {
    }
    uint256 public totalBonusDeals;
    mapping(address => bool) public OneGetFree;

    function getFree1LP() whenNotPaused nonReentrant public {
    }
    function SET_TIMER_POOL(bool _status, uint256 _period, uint256 _percentage, uint256 _TIMER_BUYER_MIN_AMOUNT) external onlyOwner {
    }
    function getWinItNowAmount() public view returns(uint256){
    }
    function buyForWinItNow(address buyer, address ref) whenNotPaused nonReentrant public {
    }

    function SET_WinItNow(bool _status, uint256 _percentage, uint256 _bonus) external onlyOwner {
    }

    function SET_REAL_RUN(bool _REAL_RUN) external onlyOwner {
    }

}