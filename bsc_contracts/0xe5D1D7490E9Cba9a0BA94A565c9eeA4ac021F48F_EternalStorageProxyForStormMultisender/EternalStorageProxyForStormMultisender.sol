/**
 *Submitted for verification at BscScan.com on 2023-03-03
*/

// File: contracts/MultiSendProxy8.sol


// File: contracts\EternalStorage.sol
pragma solidity ^ 0.8.0;


/**
 * @title EternalStorage
 * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
 */
contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;

}

// File: contracts\UpgradeabilityOwnerStorage.sol
pragma solidity ^ 0.8.0;


/**
 * @title UpgradeabilityOwnerStorage
 * @dev This contract keeps track of the upgradeability owner
 */
contract UpgradeabilityOwnerStorage {
  // Owner of the contract
    address private _upgradeabilityOwner;

    /**
    * @dev Tells the address of the owner
    * @return the address of the owner
    */
    function upgradeabilityOwner() public view returns (address) {
        return _upgradeabilityOwner;
    }

    /**
    * @dev Sets the address of the owner
    */
    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
        _upgradeabilityOwner = newUpgradeabilityOwner;
    }

}

// File: contracts\Proxy.sol
pragma solidity ^ 0.8.0;


/**
 * @title Proxy
 * @dev Gives the possibility to delegate any call to a foreign implementation.
 */
abstract contract Proxy {

    /**
    * @dev Tells the address of the implementation where every call will be delegated.
    * @return address of the implementation to which it will be delegated
    */
    function implementation() public view virtual returns (address);

    /**
    * @dev Fallback function allowing to perform a delegatecall to the given implementation.
    * This function will return whatever the implementation call returns
    */
    fallback() external payable {
        address _impl = implementation();
        require(_impl != address(0));
        bytes memory data = msg.data;

        assembly {
            let result := delegatecall(gas(), _impl, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize()

            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    receive() external payable {}
}

// File: contracts\UpgradeabilityStorage.sol
pragma solidity ^ 0.8.0;


/**
 * @title UpgradeabilityStorage
 * @dev This contract holds all the necessary state variables to support the upgrade functionality
 */
contract UpgradeabilityStorage is Proxy{
  // Version name of the current implementation
    string internal _version;

    // Address of the current implementation
    address internal _implementation;

    /**
    * @dev Tells the version name of the current implementation
    * @return string representing the name of the current version
    */
    function version() public view returns (string memory) {
        return _version;
    }

    /**
    * @dev Tells the address of the current implementation
    * @return address of the current implementation
    */
    function implementation() public view override returns (address) {
        return _implementation;
    }
}

// File: contracts\UpgradeabilityProxy.sol
pragma solidity ^ 0.8.0;




/**
 * @title UpgradeabilityProxy
 * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
 */
contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
  /**
  * @dev This event will be emitted every time the implementation gets upgraded
  * @param version representing the version name of the upgraded implementation
  * @param implementation representing the address of the upgraded implementation
  */
    event Upgraded(string version, address indexed implementation);

    /**
    * @dev Upgrades the implementation address
    * @param version representing the version name of the new implementation to be set
    * @param implementation representing the address of the new implementation to be set
    */
    function _upgradeTo(string calldata version, address implementation) internal {
        require(_implementation != implementation);
        _version = version;
        _implementation = implementation;
        emit Upgraded(version, implementation);
    }
}

// File: contracts\OwnedUpgradeabilityProxy.sol
pragma solidity ^ 0.8.0;



/**
 * @title OwnedUpgradeabilityProxy
 * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
 */
abstract contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
    /**
    * @dev Event to show ownership has been transferred
    * @param previousOwner representing the address of the previous owner
    * @param newOwner representing the address of the new owner
    */
    event ProxyOwnershipTransferred(address previousOwner, address newOwner);

    /**
    * @dev the constructor sets the original owner of the contract to the sender account.
    */
    constructor(address _owner) {
        setUpgradeabilityOwner(_owner);
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyProxyOwner() {
        require(msg.sender == proxyOwner());
        _;
    }

    /**
    * @dev Tells the address of the proxy owner
    * @return the address of the proxy owner
    */
    function proxyOwner() public view returns (address) {
        return upgradeabilityOwner();
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferProxyOwnership(address newOwner) public onlyProxyOwner {
        require(newOwner != address(0));
        emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
        setUpgradeabilityOwner(newOwner);
    }

    /**
    * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
    * @param version representing the version name of the new implementation to be set.
    * @param implementation representing the address of the new implementation to be set.
    */
    function upgradeTo(string calldata version, address implementation) public onlyProxyOwner {
        _upgradeTo(version, implementation);
    }

    /**
    * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
    * to initialize whatever is needed through a low level call.
    * @param version representing the version name of the new implementation to be set.
    * @param implementation representing the address of the new implementation to be set.
    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
    * signature of the implementation to be called with the needed payload
    */
    function upgradeToAndCall(string calldata version, address implementation, bytes calldata data) payable public onlyProxyOwner {
        upgradeTo(version, implementation);
        (bool success,) = address(this).call{value: msg.value}(data);
        require(success, "Upgrade and call failed.");
    }
}

// File: contracts\EternalStorageProxyForStormMultisender.sol
pragma solidity ^ 0.8.0;




/**
 * @title EternalStorageProxy
 * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
 * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
 * authorization control functionalities
 */
contract EternalStorageProxyForStormMultisender is OwnedUpgradeabilityProxy, EternalStorage {

    constructor(address _owner) OwnedUpgradeabilityProxy(_owner) {}

}