// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import {EclipseAccess} from "../access/EclipseAccess.sol";
import {EclipseCollectionFactory} from "../factory/EclipseCollectionFactory.sol";
import {EclipsePaymentSplitterFactory} from "../factory/EclipsePaymentSplitterFactory.sol";
import {IEclipseERC721} from "../interface/IEclipseERC721.sol";
import {IEclipseMinter} from "../interface/IEclipseMinter.sol";

/**
 * @dev Eclipse
 * Admin of {EclipseCollectionFactory} and {EclipsePaymentSplitterFactory}
 */

struct Collection {
    uint256 id;
    address artist;
    address contractAddress;
    uint256 maxSupply;
    string script;
    address paymentSplitter;
}

struct Artist {
    address wallet;
    address[] collections;
}

contract EclipseStorage is EclipseAccess {
    mapping(address => Collection) public collections;
    mapping(address => Artist) public artists;

    event ScriptUpdated(address collection, string script);

    /**
     * @dev Helper function to get {PaymentSplitter} of artist
     */
    function getPaymentSplitterForCollection(
        address collection
    ) external view returns (address) {
        return collections[collection].paymentSplitter;
    }

    /**
     * @dev Update script of collection
     * @param collection contract address of the collection
     * @param script single html as string
     */
    function updateScript(address collection, string memory script) external {
        require(collections[collection].artist == _msgSender(), "not allowed");
        collections[collection].script = script;
        emit ScriptUpdated(collection, script);
    }

    /**
     * @dev set collection
     * @param collection contract object
     */
    function setCollection(Collection calldata collection) external onlyAdmin {
        collections[collection.contractAddress] = collection;
        artists[collection.artist].collections.push(collection.contractAddress);
    }

    /**
     * @dev set collection
     * @param artist artist object
     */
    function setArtist(Artist calldata artist) external onlyAdmin {
        artists[artist.wallet] = artist;
    }

    /**
     * @dev Get artist struct
     * @param artist adress of artist
     */
    function getArtist(address artist) external view returns (Artist memory) {
        return artists[artist];
    }

    /**
     * @dev Get collection struct
     * @param collection collection address
     */
    function getCollection(
        address collection
    ) external view returns (Collection memory) {
        return collections[collection];
    }

    /**
     * @dev Get artist of collection
     * @param collection collection address
     */
    function getArtistOfCollection(
        address collection
    ) external view returns (address) {
        return collections[collection].artist;
    }

    /**
     * @dev Update payment splitter for collection
     * @param paymentSplitter address of new payment splitter
     */
    function setPaymentSplitter(
        address collection,
        address paymentSplitter
    ) external onlyAdmin {
        collections[collection].paymentSplitter = paymentSplitter;
    }
}